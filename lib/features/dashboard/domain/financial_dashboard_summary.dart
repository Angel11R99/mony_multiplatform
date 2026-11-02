import '../../transactions/domain/transaction.dart';

class FinancialDashboardSummary {
  const FinancialDashboardSummary({
    required this.month,
    required this.incomeInCents,
    required this.expenseInCents,
    required this.balanceInCents,
    required this.transactionCount,
    required this.recentTransactions,
    required this.monthlyTotals,
  });

  final DateTime month;
  final int incomeInCents;
  final int expenseInCents;
  final int balanceInCents;
  final int transactionCount;
  final List<FinanceTransaction> recentTransactions;
  final List<DashboardMonthTotals> monthlyTotals;

  factory FinancialDashboardSummary.fromTransactions(
    Iterable<FinanceTransaction> transactions, {
    required DateTime month,
    int recentLimit = 5,
  }) {
    final period = DateTime(month.year, month.month);
    var income = 0;
    var expense = 0;
    var periodCount = 0;
    final sorted = transactions.toList()
      ..sort((a, b) {
        final byDay = dateToEpochDay(b.date).compareTo(dateToEpochDay(a.date));
        if (byDay != 0) return byDay;
        final byCreated = b.createdAt.compareTo(a.createdAt);
        return byCreated != 0 ? byCreated : b.id.compareTo(a.id);
      });
    final monthTotalsByKey = <int, List<int>>{};
    for (var index = 0; index < 6; index++) {
      final trendMonth = DateTime(period.year, period.month - (5 - index));
      monthTotalsByKey[_monthKey(trendMonth)] = [0, 0];
    }
    for (final transaction in sorted) {
      final amounts = monthTotalsByKey[_monthKey(transaction.date)];
      if (amounts != null) {
        if (transaction.type == TransactionType.income) {
          amounts[0] += transaction.amountInCents;
        } else {
          amounts[1] += transaction.amountInCents;
        }
      }
      if (transaction.date.year != period.year ||
          transaction.date.month != period.month) {
        continue;
      }
      periodCount++;
      switch (transaction.type) {
        case TransactionType.income:
          income += transaction.amountInCents;
        case TransactionType.expense:
          expense += transaction.amountInCents;
      }
    }
    return FinancialDashboardSummary(
      month: period,
      incomeInCents: income,
      expenseInCents: expense,
      balanceInCents: income - expense,
      transactionCount: periodCount,
      recentTransactions: List.unmodifiable(sorted.take(recentLimit)),
      monthlyTotals: List.unmodifiable(
        List.generate(6, (index) {
          final trendMonth = DateTime(period.year, period.month - (5 - index));
          final totals = monthTotalsByKey[_monthKey(trendMonth)]!;
          return DashboardMonthTotals(
            month: trendMonth,
            incomeInCents: totals[0],
            expenseInCents: totals[1],
          );
        }),
      ),
    );
  }

  static int _monthKey(DateTime date) => date.year * 12 + date.month;
}

class DashboardMonthTotals {
  const DashboardMonthTotals({
    required this.month,
    required this.incomeInCents,
    required this.expenseInCents,
  });

  final DateTime month;
  final int incomeInCents;
  final int expenseInCents;
}
