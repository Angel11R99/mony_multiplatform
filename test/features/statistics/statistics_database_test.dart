import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/categories/data/drift_categories_repository.dart';
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
}
