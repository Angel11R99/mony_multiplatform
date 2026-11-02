import '../../transactions/domain/transaction.dart';

class FinancialDashboardSummary {
  const FinancialDashboardSummary({
    required this.month,
    required this.incomeInCents,
    required this.expenseInCents,
    required this.balanceInCents,
    required this.transactionCount,
    required this.recentTransactions,
  });

  final DateTime month;
  final int incomeInCents;
  final int expenseInCents;
  final int balanceInCents;
  final int transactionCount;
  final List<FinanceTransaction> recentTransactions;

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
    for (final transaction in sorted) {
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
    );
  }
}
