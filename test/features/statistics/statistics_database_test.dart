import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/categories/data/drift_categories_repository.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/statistics/data/drift_statistics_repository.dart';
import 'package:mony_multiplatform/features/statistics/domain/financial_statistics.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  late AppDatabase database;
  late DriftTransactionRepository transactions;
  late DriftCategoriesRepository categories;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    transactions = DriftTransactionRepository(database);
    categories = DriftCategoriesRepository(database);
  });

  tearDown(() => database.close());

  test(
    'report totals match independent SQLite aggregates for the date range',
    () async {
      final food = (await categories.watchAll().first).singleWhere(
        (category) => category.name == 'Alimentación',
      );
      final start = DateTime(2026, 5, 1);
      final end = DateTime(2026, 5, 31);
      for (final entry in [
        (
          amount: 200000,
          type: TransactionType.income,
          category: 1,
          date: DateTime(2026, 5, 1),
        ),
        (
          amount: 32500,
          type: TransactionType.expense,
          category: food.id,
          date: DateTime(2026, 5, 31),
        ),
        (
          amount: 90000,
          type: TransactionType.expense,
          category: food.id,
          date: DateTime(2026, 6, 1),
        ),
      ]) {
        await transactions.create(
          FinanceTransaction(
            amountInCents: entry.amount,
            type: entry.type,
            categoryId: entry.category,
            paymentMethodId: 1,
            description: 'Estadística DB',
            date: entry.date,
            createdAt: entry.date,
            updatedAt: entry.date,
          ),
        );
      }

      final allTransactions = await transactions.watchAll().first;
      final report = calculateFinancialStatistics(
        transactions: allTransactions,
        categories: {
          for (final item in await categories.watchAll().first) item.id: item,
        },
        period: StatisticsPeriod(start: start, endInclusive: end),
      );
      final rows = await database
          .customSelect(
            'SELECT type, SUM(amount_in_cents) AS total FROM transactions '
            'WHERE date_epoch_day >= ? AND date_epoch_day <= ? GROUP BY type',
            variables: [
              Variable<int>(dateToEpochDay(start)),
              Variable<int>(dateToEpochDay(end)),
            ],
            readsFrom: {database.transactions},
          )
          .get();
      final byType = {
        for (final row in rows)
          row.read<String>('type'): row.read<int>('total'),
      };
      expect(report.incomeInCents, byType['income']);
      expect(report.expenseInCents, byType['expense']);
      expect(report.incomeInCents, 200000);
      expect(report.expenseInCents, 32500);
    },
  );

  test('aggregate queries preserve period and all-time breakdowns', () async {
    final categoryItems = await categories.watchAll().first;
    final food = categoryItems.singleWhere((category) => category.id == 6);
    final transport = categoryItems.singleWhere((category) => category.id == 7);
    final categoriesById = {for (final item in categoryItems) item.id: item};
    final limitedFood = Category(
      id: food.id,
      name: food.name,
      type: food.type,
      icon: food.icon,
      colorArgb: food.colorArgb,
      isActive: food.isActive,
      createdAt: food.createdAt,
      budgetLimitInCents: 50000,
    );
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final currentStart = day.subtract(const Duration(days: 29));
    final previousStart = day.subtract(const Duration(days: 59));
    final previousEnd = day.subtract(const Duration(days: 30));

    Future<void> add(
      int amount,
      TransactionType type,
      int categoryId,
      DateTime date,
    ) => transactions.create(
      FinanceTransaction(
        amountInCents: amount,
        type: type,
        categoryId: categoryId,
        paymentMethodId: 1,
        description: 'Aggregate regression',
        date: date,
        createdAt: date,
        updatedAt: date,
      ),
    );

    await add(200000, TransactionType.income, 1, day);
    await add(10000, TransactionType.expense, food.id, day);
    await add(5000, TransactionType.expense, transport.id, day);
    await add(2000, TransactionType.expense, food.id, previousEnd);
    await add(
      3000,
      TransactionType.expense,
      food.id,
      previousStart.subtract(const Duration(days: 1)),
    );

    final repository = DriftStatisticsRepository(database);
    final periodSnapshot = await repository
        .watchPeriods(
          categories: categoriesById,
          limitCategories: [limitedFood],
          currentPeriod: StatisticsPeriod(
            start: currentStart,
            endInclusive: day,
          ),
          previousPeriod: StatisticsPeriod(
            start: previousStart,
            endInclusive: previousEnd,
          ),
          budgetPeriod: StatisticsPeriod(
            start: day.subtract(const Duration(days: 13)),
            endInclusive: day,
          ),
          through: day,
        )
        .first;

    expect(periodSnapshot.statistics.incomeInCents, 200000);
    expect(periodSnapshot.statistics.expenseInCents, 15000);
    expect(periodSnapshot.statistics.transactionCount, 3);
    expect(periodSnapshot.statistics.averageExpenseInCents, 7500);
    expect(periodSnapshot.previous?.expenseInCents, 2000);
    expect(periodSnapshot.previous?.transactionCount, 1);
    expect(periodSnapshot.previous?.averageExpenseInCents, 2000);
    expect(periodSnapshot.limitInsights.single.spentInCents, 10000);

    final allTimeSnapshot = await repository
        .watchAllTime(
          categories: categoriesById,
          limitCategories: [limitedFood],
          budgetPeriod: StatisticsPeriod(
            start: day.subtract(const Duration(days: 13)),
            endInclusive: day,
          ),
          through: day,
        )
        .first;

    expect(allTimeSnapshot.statistics.incomeInCents, 200000);
    expect(allTimeSnapshot.statistics.expenseInCents, 20000);
    expect(allTimeSnapshot.statistics.transactionCount, 5);
    expect(allTimeSnapshot.statistics.averageExpenseInCents, 5000);
    expect(
      allTimeSnapshot.statistics.expenseByCategory.map(
        (item) => (item.category.id, item.amountInCents),
      ),
      containsAll([(food.id, 15000), (transport.id, 5000)]),
    );
    expect(allTimeSnapshot.limitInsights.single.spentInCents, 10000);

    final categorySnapshot = await repository
        .watchAllTime(
          categories: categoriesById,
          limitCategories: [limitedFood],
          budgetPeriod: StatisticsPeriod(
            start: currentStart,
            endInclusive: day,
          ),
          through: day,
          categoryId: food.id,
        )
        .first;
    expect(categorySnapshot.statistics.incomeInCents, 0);
    expect(categorySnapshot.statistics.expenseInCents, 15000);
    expect(categorySnapshot.statistics.transactionCount, 3);
    expect(categorySnapshot.statistics.averageExpenseInCents, 5000);
  });
}
