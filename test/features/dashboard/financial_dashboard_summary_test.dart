import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/budgets/domain/budget.dart';
import 'package:mony_multiplatform/features/dashboard/domain/financial_dashboard_summary.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  test('sums current month in integer centavos and keeps five recent rows', () {
    final month = DateTime(2026, 11, 15);
    final transactions = [
      _movement(1, TransactionType.income, 200005, DateTime(2026, 11, 3)),
      _movement(2, TransactionType.expense, 3450, DateTime(2026, 11, 4)),
      _movement(3, TransactionType.income, 1, DateTime(2026, 10, 31)),
      _movement(4, TransactionType.expense, 400, DateTime(2026, 11, 6)),
      _movement(5, TransactionType.expense, 500, DateTime(2026, 11, 7)),
      _movement(6, TransactionType.income, 100, DateTime(2026, 11, 8)),
      _movement(7, TransactionType.expense, 200, DateTime(2026, 11, 9)),
      _movement(8, TransactionType.income, 300, DateTime(2026, 11, 10)),
    ];

    final summary = FinancialDashboardSummary.fromTransactions(
      transactions,
      month: month,
    );

    expect(summary.month, DateTime(2026, 11));
    expect(summary.incomeInCents, 200405);
    expect(summary.expenseInCents, 4550);
    expect(summary.balanceInCents, 195855);
    expect(summary.transactionCount, 7);
    expect(summary.recentTransactions.map((item) => item.id), [8, 7, 6, 5, 4]);
  });

  test('supports a negative monthly balance and empty months', () {
    final month = DateTime(2026, 11);
    final summary = FinancialDashboardSummary.fromTransactions([
      _movement(1, TransactionType.expense, 9900, month),
    ], month: month);
    final empty = FinancialDashboardSummary.fromTransactions(
      const [],
      month: DateTime(2026, 12),
    );

    expect(summary.balanceInCents, -9900);
    expect(empty.incomeInCents, 0);
    expect(empty.expenseInCents, 0);
    expect(empty.balanceInCents, 0);
    expect(empty.recentTransactions, isEmpty);
  });

  test('summarizes a configured cycle across month boundaries', () {
    final range = DateRange(
      start: DateTime(2026, 10, 30),
      endInclusive: DateTime(2026, 11, 5),
    );
    final summary = FinancialDashboardSummary.fromTransactions(
      [
        _movement(1, TransactionType.expense, 500, DateTime(2026, 10, 31)),
        _movement(2, TransactionType.income, 2000, DateTime(2026, 11, 1)),
        _movement(3, TransactionType.income, 9000, DateTime(2026, 11, 8)),
      ],
      month: range.start,
      selectedPeriod: range,
    );

    expect(summary.period, range);
    expect(summary.transactionCount, 2);
    expect(summary.incomeInCents, 2000);
    expect(summary.expenseInCents, 500);
  });
}

FinanceTransaction _movement(
  int id,
  TransactionType type,
  int amount,
  DateTime date,
) => FinanceTransaction(
  id: id,
  amountInCents: amount,
  type: type,
  categoryId: type == TransactionType.income ? 1 : 6,
  paymentMethodId: 1,
  description: 'Movimiento $id',
  date: date,
  createdAt: DateTime(date.year, date.month, date.day, 10),
  updatedAt: DateTime(date.year, date.month, date.day, 10),
);
