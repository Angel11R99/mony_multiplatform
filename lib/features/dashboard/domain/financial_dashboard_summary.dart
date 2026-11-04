import '../../transactions/domain/transaction.dart';
import '../../budgets/domain/budget.dart';

class FinancialDashboardSummary {
  const FinancialDashboardSummary({
    required this.month,
    required this.incomeInCents,
    required this.expenseInCents,
    required this.balanceInCents,
    required this.transactionCount,
    required this.recentTransactions,
    required this.monthlyTotals,
    this.period,
  });

  final DateTime month;
  final int incomeInCents;
  final int expenseInCents;
  final int balanceInCents;
  final int transactionCount;
  final List<FinanceTransaction> recentTransactions;
  final List<DashboardMonthTotals> monthlyTotals;
  final DateRange? period;

  factory FinancialDashboardSummary.fromTransactions(
    Iterable<FinanceTransaction> transactions, {
    required DateTime month,
    DateRange? selectedPeriod,
    int recentLimit = 5,
  }) {
    final monthStart = DateTime(month.year, month.month);
    var income = 0;
    var expense = 0;
    var periodCount = 0;
    final recentTransactions = <FinanceTransaction>[];
    final monthTotalsByKey = <int, List<int>>{};
    for (var index = 0; index < 6; index++) {
      final trendMonth = DateTime(
        monthStart.year,
        monthStart.month - (5 - index),
      );
      monthTotalsByKey[_monthKey(trendMonth)] = [0, 0];
    }
    for (final transaction in transactions) {
      _insertRecent(recentTransactions, transaction, recentLimit);
      final amounts = monthTotalsByKey[_monthKey(transaction.date)];
      if (amounts != null) {
        if (transaction.type == TransactionType.income) {
          amounts[0] += transaction.amountInCents;
        } else {
          amounts[1] += transaction.amountInCents;
        }
      }
      final inPeriod = selectedPeriod == null
          ? transaction.date.year == monthStart.year &&
                transaction.date.month == monthStart.month
          : selectedPeriod.contains(transaction.date);
      if (!inPeriod) continue;
      periodCount++;
      switch (transaction.type) {
        case TransactionType.income:
          income += transaction.amountInCents;
        case TransactionType.expense:
          expense += transaction.amountInCents;
      }
    }
    return FinancialDashboardSummary(
      month: monthStart,
      incomeInCents: income,
      expenseInCents: expense,
      balanceInCents: income - expense,
      transactionCount: periodCount,
      recentTransactions: List.unmodifiable(recentTransactions),
      monthlyTotals: List.unmodifiable(
        List.generate(6, (index) {
          final trendMonth = DateTime(
            monthStart.year,
            monthStart.month - (5 - index),
          );
          final totals = monthTotalsByKey[_monthKey(trendMonth)]!;
          return DashboardMonthTotals(
            month: trendMonth,
            incomeInCents: totals[0],
            expenseInCents: totals[1],
          );
        }),
      ),
      period: selectedPeriod,
    );
  }

  static int _monthKey(DateTime date) => date.year * 12 + date.month;

  static void _insertRecent(
    List<FinanceTransaction> recent,
    FinanceTransaction transaction,
    int limit,
  ) {
    if (limit <= 0) return;
    var index = 0;
    while (index < recent.length &&
        _compareRecent(recent[index], transaction) <= 0) {
      index++;
    }
    if (index >= limit) return;
    recent.insert(index, transaction);
    if (recent.length > limit) recent.removeLast();
  }

  static int _compareRecent(FinanceTransaction a, FinanceTransaction b) {
    final byYear = b.date.year.compareTo(a.date.year);
    if (byYear != 0) return byYear;
    final byMonth = b.date.month.compareTo(a.date.month);
    if (byMonth != 0) return byMonth;
    final byDay = b.date.day.compareTo(a.date.day);
    if (byDay != 0) return byDay;
    final byCreated = b.createdAt.compareTo(a.createdAt);
    return byCreated != 0 ? byCreated : b.id.compareTo(a.id);
  }
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
