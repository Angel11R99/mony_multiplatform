import '../../budgets/domain/budget.dart';
import '../../categories/domain/category.dart';
import '../../transactions/domain/transaction.dart';

enum StatisticsRange {
  currentBudget,
  currentMonth,
  currentYear,
  allTime,
  custom,
}

class StatisticsPeriod {
  const StatisticsPeriod({this.start, this.endInclusive});

  final DateTime? start;
  final DateTime? endInclusive;

  bool contains(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return (start == null || !day.isBefore(start!)) &&
        (endInclusive == null || !day.isAfter(endInclusive!));
  }

  int? get dayCount => start == null || endInclusive == null
      ? null
      : endInclusive!.difference(start!).inDays + 1;
}

StatisticsPeriod statisticsPeriod({
  required StatisticsRange range,
  required DateTime today,
  BudgetConfig? budget,
  DateTime? customStart,
  DateTime? customEnd,
}) => switch (range) {
  StatisticsRange.currentBudget => _period(activeBudgetPeriod(budget, today)),
  StatisticsRange.currentMonth => StatisticsPeriod(
    start: DateTime(today.year, today.month),
    endInclusive: DateTime(today.year, today.month + 1, 0),
  ),
  StatisticsRange.currentYear => StatisticsPeriod(
    start: DateTime(today.year),
    endInclusive: DateTime(today.year, today.month, today.day),
  ),
  StatisticsRange.allTime => const StatisticsPeriod(),
  StatisticsRange.custom => StatisticsPeriod(
    start: _dateOnly(customStart),
    endInclusive: _dateOnly(customEnd),
  ),
};

StatisticsPeriod previousStatisticsPeriod({
  required StatisticsRange range,
  required StatisticsPeriod current,
  required DateTime today,
  BudgetConfig? budget,
}) {
  if (range == StatisticsRange.allTime || range == StatisticsRange.custom) {
    return const StatisticsPeriod();
  }
  if (range == StatisticsRange.currentBudget) {
    final priorDay = current.start!.subtract(const Duration(days: 1));
    return _period(activeBudgetPeriod(budget, priorDay));
  }
  if (range == StatisticsRange.currentMonth) {
    final previousMonth = DateTime(today.year, today.month - 1);
    return StatisticsPeriod(
      start: previousMonth,
      endInclusive: DateTime(previousMonth.year, previousMonth.month + 1, 0),
    );
  }
  final previousYear = today.year - 1;
  return StatisticsPeriod(
    start: DateTime(previousYear),
    endInclusive: DateTime(previousYear, 12, 31),
  );
}

class CategoryStatistics {
  const CategoryStatistics({
    required this.category,
    required this.amountInCents,
  });
  final Category category;
  final int amountInCents;
}

class FinancialStatistics {
  const FinancialStatistics({
    required this.incomeInCents,
    required this.expenseInCents,
    required this.transactionCount,
    required this.averageExpenseInCents,
    required this.expenseByCategory,
  });

  final int incomeInCents;
  final int expenseInCents;
  final int transactionCount;
  final int averageExpenseInCents;
  final List<CategoryStatistics> expenseByCategory;
  int get balanceInCents => incomeInCents - expenseInCents;
}

FinancialStatistics calculateFinancialStatistics({
  required Iterable<FinanceTransaction> transactions,
  required Map<int, Category> categories,
  required StatisticsPeriod period,
}) {
  var income = 0;
  var expense = 0;
  var expenseCount = 0;
  var count = 0;
  final expenseByCategory = <int, int>{};
  for (final transaction in transactions) {
    if (!period.contains(transaction.date)) continue;
    count++;
    if (transaction.type == TransactionType.income) {
      income += transaction.amountInCents;
    } else {
      expense += transaction.amountInCents;
      expenseCount++;
      expenseByCategory.update(
        transaction.categoryId,
        (amount) => amount + transaction.amountInCents,
        ifAbsent: () => transaction.amountInCents,
      );
    }
  }
  final breakdown =
      expenseByCategory.entries
          .map(
            (entry) => categories[entry.key] == null
                ? null
                : CategoryStatistics(
                    category: categories[entry.key]!,
                    amountInCents: entry.value,
                  ),
          )
          .whereType<CategoryStatistics>()
          .toList()
        ..sort((a, b) => b.amountInCents.compareTo(a.amountInCents));
  return FinancialStatistics(
    incomeInCents: income,
    expenseInCents: expense,
    transactionCount: count,
    averageExpenseInCents: expenseCount == 0 ? 0 : expense ~/ expenseCount,
    expenseByCategory: breakdown,
  );
}

class MonthlyStatistics {
  const MonthlyStatistics({
    required this.month,
    required this.incomeInCents,
    required this.expenseInCents,
  });
  final DateTime month;
  final int incomeInCents;
  final int expenseInCents;
}

List<MonthlyStatistics> monthlyStatistics(
  Iterable<FinanceTransaction> transactions, {
  required DateTime through,
  int months = 6,
}) {
  final first = DateTime(through.year, through.month - months + 1);
  final totals = <DateTime, List<int>>{
    for (var i = 0; i < months; i++)
      DateTime(first.year, first.month + i): [0, 0],
  };
  for (final transaction in transactions) {
    final month = DateTime(transaction.date.year, transaction.date.month);
    final totalsForMonth = totals[month];
    if (totalsForMonth == null) continue;
    totalsForMonth[transaction.type == TransactionType.income ? 0 : 1] +=
        transaction.amountInCents;
  }
  return totals.entries
      .map(
        (entry) => MonthlyStatistics(
          month: entry.key,
          incomeInCents: entry.value[0],
          expenseInCents: entry.value[1],
        ),
      )
      .toList(growable: false);
}

class BudgetLimitInsight {
  const BudgetLimitInsight({
    required this.category,
    required this.limitInCents,
    required this.spentInCents,
  });
  final Category category;
  final int limitInCents;
  final int spentInCents;
  int get usagePercent => (spentInCents * 100) ~/ limitInCents;
}

List<BudgetLimitInsight> budgetLimitInsights({
  required Iterable<FinanceTransaction> transactions,
  required Iterable<Category> categories,
  required StatisticsPeriod period,
}) {
  final limits = categories.where(
    (category) =>
        category.type == CategoryType.expense &&
        category.budgetLimitInCents != null &&
        category.budgetLimitInCents! > 0,
  );
  final spent = <int, int>{};
  for (final transaction in transactions) {
    if (transaction.type == TransactionType.expense &&
        period.contains(transaction.date)) {
      spent.update(
        transaction.categoryId,
        (value) => value + transaction.amountInCents,
        ifAbsent: () => transaction.amountInCents,
      );
    }
  }
  return limits
      .map(
        (category) => BudgetLimitInsight(
          category: category,
          limitInCents: category.budgetLimitInCents!,
          spentInCents: spent[category.id] ?? 0,
        ),
      )
      .toList(growable: false)
    ..sort((a, b) => b.usagePercent.compareTo(a.usagePercent));
}

int? percentageChange(int current, int previous) =>
    previous <= 0 ? null : ((current - previous) * 100) ~/ previous;

StatisticsPeriod _period(DateRange range) =>
    StatisticsPeriod(start: range.start, endInclusive: range.endInclusive);

DateTime? _dateOnly(DateTime? value) =>
    value == null ? null : DateTime(value.year, value.month, value.day);
