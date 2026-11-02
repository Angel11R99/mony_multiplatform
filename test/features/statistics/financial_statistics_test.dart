import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/statistics/domain/financial_statistics.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  final food = Category(
    id: 1,
    name: 'Alimentación',
    type: CategoryType.expense,
    icon: 'restaurant',
    colorArgb: 0xFF008577,
    isActive: true,
    createdAt: DateTime(2026),
    budgetLimitInCents: 5000,
  );

  test('calculates inclusive totals, average and category ordering', () {
    final transactions = [
      _transaction(10000, TransactionType.income, 3, DateTime(2026, 6, 1)),
      _transaction(
        2000,
        TransactionType.expense,
        food.id,
        DateTime(2026, 6, 2),
      ),
      _transaction(
        3000,
        TransactionType.expense,
        food.id,
        DateTime(2026, 6, 30),
      ),
      _transaction(
        9000,
        TransactionType.expense,
        food.id,
        DateTime(2026, 7, 1),
      ),
    ];
    final report = calculateFinancialStatistics(
      transactions: transactions,
      categories: {food.id: food},
      period: StatisticsPeriod(
        start: DateTime(2026, 6, 1),
        endInclusive: DateTime(2026, 6, 30),
      ),
    );
    expect(report.incomeInCents, 10000);
    expect(report.expenseInCents, 5000);
    expect(report.balanceInCents, 5000);
    expect(report.averageExpenseInCents, 2500);
    expect(report.transactionCount, 3);
    expect(report.expenseByCategory.single.amountInCents, 5000);
  });

  test(
    'calculates selected periods and the prior month at month boundaries',
    () {
      final now = DateTime(2026, 3, 31, 22);
      final month = statisticsPeriod(
        range: StatisticsRange.currentMonth,
        today: now,
      );
      expect(month.start, DateTime(2026, 3, 1));
      expect(month.endInclusive, DateTime(2026, 3, 31));
      final prior = previousStatisticsPeriod(
        range: StatisticsRange.currentMonth,
        current: month,
        today: now,
      );
      expect(prior.start, DateTime(2026, 2, 1));
      expect(prior.endInclusive, DateTime(2026, 2, 28));
    },
  );

  test('supports custom and all time periods without implicit boundaries', () {
    final all = statisticsPeriod(
      range: StatisticsRange.allTime,
      today: DateTime(2026, 6, 10),
    );
    expect(all.contains(DateTime(1999)), isTrue);
    final custom = statisticsPeriod(
      range: StatisticsRange.custom,
      today: DateTime(2026, 6, 10),
      customStart: DateTime(2026, 5, 20, 17),
      customEnd: DateTime(2026, 6, 3, 8),
    );
    expect(custom.start, DateTime(2026, 5, 20));
    expect(custom.endInclusive, DateTime(2026, 6, 3));
    expect(custom.contains(DateTime(2026, 6, 3, 23)), isTrue);
  });

  test('aggregates monthly evolution and budget limit warnings', () {
    final transactions = [
      _transaction(500, TransactionType.income, 3, DateTime(2026, 1, 2)),
      _transaction(900, TransactionType.expense, food.id, DateTime(2026, 1, 5)),
      _transaction(100, TransactionType.income, 3, DateTime(2026, 2, 2)),
      _transaction(
        4000,
        TransactionType.expense,
        food.id,
        DateTime(2026, 2, 6),
      ),
      _transaction(
        2000,
        TransactionType.expense,
        food.id,
        DateTime(2026, 3, 1),
      ),
    ];
    final evolution = monthlyStatistics(
      transactions,
      through: DateTime(2026, 3, 15),
      months: 3,
    );
    expect(evolution.map((month) => month.incomeInCents), [500, 100, 0]);
    expect(evolution.map((month) => month.expenseInCents), [900, 4000, 2000]);

    final insights = budgetLimitInsights(
      transactions: transactions,
      categories: [food],
      period: StatisticsPeriod(
        start: DateTime(2026, 2),
        endInclusive: DateTime(2026, 2, 28),
      ),
    );
    expect(insights.single.usagePercent, 80);
  });

  test('comparison percent handles new, decrease and zero values', () {
    expect(percentageChange(150, 100), 50);
    expect(percentageChange(75, 100), -25);
    expect(percentageChange(100, 0), isNull);
  });
}

FinanceTransaction _transaction(
  int amount,
  TransactionType type,
  int categoryId,
  DateTime date,
) => FinanceTransaction(
  amountInCents: amount,
  type: type,
  categoryId: categoryId,
  paymentMethodId: 1,
  description: null,
  date: date,
  createdAt: date,
  updatedAt: date,
);
