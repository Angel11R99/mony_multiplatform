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
    endInclusive: DateTime(today.year, today.month, today.day),
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
    final duration = current.dayCount ?? 1;
    final end = current.start!.subtract(const Duration(days: 1));
    return StatisticsPeriod(
      start: end.subtract(Duration(days: duration - 1)),
      endInclusive: end,
    );
  }
  if (range == StatisticsRange.currentMonth) {
    final previousMonth = DateTime(today.year, today.month - 1);
    final previousEnd = DateTime(
      previousMonth.year,
      previousMonth.month + 1,
      0,
    );
    return StatisticsPeriod(
      start: previousMonth,
      endInclusive: DateTime(
        previousEnd.year,
        previousEnd.month,
        today.day < previousEnd.day ? today.day : previousEnd.day,
      ),
    );
  }
  final previousYear = today.year - 1;
  return StatisticsPeriod(
    start: DateTime(previousYear),
    endInclusive: DateTime(previousYear, today.month, today.day),
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
}) => calculateFinancialStatisticsForPeriods(
  transactions: transactions,
  categories: categories,
  currentPeriod: period,
).$1;

/// Calculates two comparable periods in one pass over the transaction source.
(FinancialStatistics current, FinancialStatistics? previous)
calculateFinancialStatisticsForPeriods({
  required Iterable<FinanceTransaction> transactions,
  required Map<int, Category> categories,
  required StatisticsPeriod currentPeriod,
  StatisticsPeriod? previousPeriod,
}) {
  final current = _FinancialStatisticsAccumulator();
  final previous = previousPeriod == null
      ? null
      : _FinancialStatisticsAccumulator();
  for (final transaction in transactions) {
    if (currentPeriod.contains(transaction.date)) current.add(transaction);
    if (previousPeriod?.contains(transaction.date) ?? false) {
      previous!.add(transaction);
    }
  }
  return (current.build(categories), previous?.build(categories));
}

class _FinancialStatisticsAccumulator {
  var income = 0;
  var expense = 0;
  var expenseCount = 0;
  var count = 0;
  final expenseByCategory = <int, int>{};

  void add(FinanceTransaction transaction) {
    count++;
    if (transaction.type == TransactionType.income) {
      income += transaction.amountInCents;
      return;
    }
    expense += transaction.amountInCents;
    expenseCount++;
    expenseByCategory.update(
      transaction.categoryId,
      (amount) => amount + transaction.amountInCents,
      ifAbsent: () => transaction.amountInCents,
    );
  }

  FinancialStatistics build(Map<int, Category> categories) {
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
}

class FinancialStatisticsOverview {
  const FinancialStatisticsOverview({
    required this.current,
    required this.previous,
    required this.limitInsights,
    required this.evolution,
  });

  final FinancialStatistics current;
  final FinancialStatistics? previous;
  final List<BudgetLimitInsight> limitInsights;
  final List<MonthlyStatistics> evolution;
}

FinancialStatisticsOverview calculateFinancialStatisticsOverview({
  required Iterable<FinanceTransaction> transactions,
  required Map<int, Category> categories,
  required StatisticsPeriod currentPeriod,
  required StatisticsPeriod? previousPeriod,
  required StatisticsPeriod budgetPeriod,
  required DateTime through,
  required Iterable<Category> limitCategories,
  int? categoryId,
}) {
  final current = _FinancialStatisticsAccumulator();
  final previous = previousPeriod == null
      ? null
      : _FinancialStatisticsAccumulator();
  final spentByCategory = <int, int>{};
  final monthly = _monthlyBuckets(through: through, period: currentPeriod);

  for (final transaction in transactions) {
    if (categoryId != null && transaction.categoryId != categoryId) continue;
    final isInCurrentPeriod = currentPeriod.contains(transaction.date);
    if (isInCurrentPeriod) current.add(transaction);
    if (previousPeriod?.contains(transaction.date) ?? false) {
      previous!.add(transaction);
    }
    if (transaction.type == TransactionType.expense &&
        budgetPeriod.contains(transaction.date)) {
      spentByCategory.update(
        transaction.categoryId,
        (value) => value + transaction.amountInCents,
        ifAbsent: () => transaction.amountInCents,
      );
    }
    if (isInCurrentPeriod && !transaction.date.isAfter(monthly.effectiveEnd)) {
      final monthTotal = monthly.totals[_statisticsMonthKey(transaction.date)];
      if (monthTotal != null) {
        monthTotal[transaction.type == TransactionType.income ? 0 : 1] +=
            transaction.amountInCents;
      }
    }
  }

  final limits =
      limitCategories
          .where(
            (category) =>
                category.type == CategoryType.expense &&
                category.budgetLimitInCents != null &&
                category.budgetLimitInCents! > 0,
          )
          .map(
            (category) => BudgetLimitInsight(
              category: category,
              limitInCents: category.budgetLimitInCents!,
              spentInCents: spentByCategory[category.id] ?? 0,
            ),
          )
          .toList()
        ..sort((a, b) => b.usagePercent.compareTo(a.usagePercent));

  final evolution = List<MonthlyStatistics>.generate(monthly.count, (index) {
    final month = DateTime(monthly.first.year, monthly.first.month + index);
    final totals = monthly.totals[_statisticsMonthKey(month)]!;
    return MonthlyStatistics(
      month: month,
      incomeInCents: totals[0],
      expenseInCents: totals[1],
    );
  }, growable: false);

  return FinancialStatisticsOverview(
    current: current.build(categories),
    previous: previous?.build(categories),
    limitInsights: List.unmodifiable(limits),
    evolution: evolution,
  );
}

({DateTime effectiveEnd, DateTime first, int count, Map<int, List<int>> totals})
_monthlyBuckets({required DateTime through, required StatisticsPeriod period}) {
  final effectiveEnd =
      period.endInclusive != null && period.endInclusive!.isBefore(through)
      ? period.endInclusive!
      : through;
  final selectedStart = period.start;
  final totalMonths = selectedStart == null
      ? 6
      : (effectiveEnd.year - selectedStart.year) * 12 +
            effectiveEnd.month -
            selectedStart.month +
            1;
  final count = totalMonths.clamp(1, 12);
  final first = DateTime(effectiveEnd.year, effectiveEnd.month - count + 1);
  final totals = <int, List<int>>{
    for (var index = 0; index < count; index++)
      _statisticsMonthKey(DateTime(first.year, first.month + index)): [0, 0],
  };
  return (
    effectiveEnd: effectiveEnd,
    first: first,
    count: count,
    totals: totals,
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
  StatisticsPeriod? period,
  int? months,
  int maxMonths = 12,
  int? categoryId,
}) {
  final effectiveEnd =
      period?.endInclusive != null && period!.endInclusive!.isBefore(through)
      ? period.endInclusive!
      : through;
  final selectedStart = period?.start;
  final totalMonths = selectedStart == null
      ? 6
      : (effectiveEnd.year - selectedStart.year) * 12 +
            effectiveEnd.month -
            selectedStart.month +
            1;
  final monthCount = (months ?? totalMonths).clamp(1, maxMonths);
  final first = DateTime(
    effectiveEnd.year,
    effectiveEnd.month - monthCount + 1,
  );
  final totals = <DateTime, List<int>>{
    for (var i = 0; i < monthCount; i++)
      DateTime(first.year, first.month + i): [0, 0],
  };
  for (final transaction in transactions) {
    if (categoryId != null && transaction.categoryId != categoryId) continue;
    if (period != null && !period.contains(transaction.date)) continue;
    if (transaction.date.isAfter(effectiveEnd)) continue;
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

int _statisticsMonthKey(DateTime date) => date.year * 12 + date.month;

StatisticsPeriod _period(DateRange range) =>
    StatisticsPeriod(start: range.start, endInclusive: range.endInclusive);

DateTime? _dateOnly(DateTime? value) =>
    value == null ? null : DateTime(value.year, value.month, value.day);
