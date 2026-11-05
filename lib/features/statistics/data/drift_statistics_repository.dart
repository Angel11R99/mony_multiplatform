import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../categories/domain/category.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/financial_statistics.dart';
import '../domain/statistics_aggregate_snapshot.dart';
import '../domain/statistics_repository.dart';

class DriftStatisticsRepository implements StatisticsRepository {
  const DriftStatisticsRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<StatisticsAggregateSnapshot> watchPeriods({
    required Map<int, Category> categories,
    required Iterable<Category> limitCategories,
    required StatisticsPeriod currentPeriod,
    required StatisticsPeriod? previousPeriod,
    required StatisticsPeriod budgetPeriod,
    required DateTime through,
    int? categoryId,
  }) {
    final baseVariables = <Variable>[];
    final selectedWindows = <String>[];
    for (final window in [currentPeriod, ?previousPeriod, budgetPeriod]) {
      selectedWindows.add(_windowPredicate(window, baseVariables));
    }
    final categoryClause = categoryId == null ? '' : 'AND category_id = ?';
    if (categoryId != null) baseVariables.add(Variable.withInt(categoryId));

    final variables = <Variable>[...baseVariables];
    final currentClause = _windowPredicate(currentPeriod, variables);
    final categoryCurrentClause = _windowPredicate(currentPeriod, variables);
    final budgetClause = _windowPredicate(budgetPeriod, variables);

    final effectiveEnd =
        currentPeriod.endInclusive != null &&
            currentPeriod.endInclusive!.isBefore(through)
        ? currentPeriod.endInclusive!
        : through;
    final selectedStart = currentPeriod.start;
    final totalMonths = selectedStart == null
        ? 6
        : (effectiveEnd.year - selectedStart.year) * 12 +
              effectiveEnd.month -
              selectedStart.month +
              1;
    final monthCount = totalMonths.clamp(1, 12);
    final firstMonth = DateTime(
      effectiveEnd.year,
      effectiveEnd.month - monthCount + 1,
    );
    final monthlyVariables = <Variable>[];
    final monthlyCurrentClause = _windowPredicate(
      currentPeriod,
      monthlyVariables,
    );
    monthlyVariables.add(
      Variable.withInt(
        dateToEpochDay(DateTime(firstMonth.year, firstMonth.month)),
      ),
    );
    monthlyVariables.add(Variable.withInt(dateToEpochDay(effectiveEnd)));
    variables.addAll(monthlyVariables);

    final previousVariables = <Variable>[];
    final previousClause = previousPeriod == null
        ? null
        : _windowPredicate(previousPeriod, previousVariables);
    final previousSelect = previousClause == null
        ? ''
        : '''UNION ALL
          SELECT 'previous_total', type, SUM(amount_in_cents), COUNT(*)
          FROM selected WHERE $previousClause GROUP BY type''';
    variables.addAll(previousVariables);

    return _database
        .customSelect(
          '''WITH selected AS (
            SELECT category_id, type, amount_in_cents, date_epoch_day
            FROM transactions WHERE (${selectedWindows.join(') OR (')})
              $categoryClause
          )
          SELECT 'current_total' AS kind, type AS label,
            SUM(amount_in_cents) AS value, COUNT(*) AS auxiliary
          FROM selected WHERE $currentClause GROUP BY type
          UNION ALL
          SELECT 'current_category', CAST(category_id AS TEXT),
            SUM(amount_in_cents), 0 FROM selected
          WHERE $categoryCurrentClause AND type = 'expense' GROUP BY category_id
          UNION ALL
          SELECT 'limit', CAST(category_id AS TEXT), SUM(amount_in_cents), 0
          FROM selected WHERE $budgetClause AND type = 'expense' GROUP BY category_id
          UNION ALL
          SELECT 'month', strftime('%Y-%m', date_epoch_day * 86400, 'unixepoch'),
            SUM(CASE WHEN type = 'income' THEN amount_in_cents ELSE 0 END),
            SUM(CASE WHEN type = 'expense' THEN amount_in_cents ELSE 0 END)
          FROM selected WHERE $monthlyCurrentClause
            AND date_epoch_day BETWEEN ? AND ?
          GROUP BY strftime('%Y-%m', date_epoch_day * 86400, 'unixepoch')
          $previousSelect''',
          variables: variables,
          readsFrom: {_database.transactions},
        )
        .watch()
        .map((rows) {
          final current = _StatisticsAccumulator();
          final previous = _StatisticsAccumulator();
          final expenseByCategory = <int, int>{};
          final spentByCategory = <int, int>{};
          final monthly = <String, (int, int)>{};
          for (final row in rows) {
            final kind = row.read<String>('kind');
            final label = row.read<String>('label');
            final value = row.read<int>('value');
            final auxiliary = row.read<int>('auxiliary');
            switch (kind) {
              case 'current_total':
                current.add(label, value, auxiliary);
              case 'previous_total':
                previous.add(label, value, auxiliary);
              case 'current_category':
                expenseByCategory[int.parse(label)] = value;
              case 'limit':
                spentByCategory[int.parse(label)] = value;
              case 'month':
                monthly[label] = (value, auxiliary);
            }
          }
          return _buildSnapshot(
            current: current.build(categories, expenseByCategory),
            previous: previousPeriod == null
                ? null
                : previous.build(categories, const {}),
            spentByCategory: spentByCategory,
            monthly: monthly,
            firstMonth: firstMonth,
            monthCount: monthCount,
            limitCategories: limitCategories,
          );
        });
  }

  @override
  Stream<StatisticsAggregateSnapshot> watchAllTime({
    required Map<int, Category> categories,
    required Iterable<Category> limitCategories,
    required StatisticsPeriod budgetPeriod,
    required DateTime through,
    int? categoryId,
  }) {
    final categoryClause = categoryId == null ? '' : 'AND category_id = ?';
    final variables = <Variable>[];
    if (categoryId != null) variables.add(Variable.withInt(categoryId));
    variables.addAll([
      Variable.withInt(dateToEpochDay(budgetPeriod.start!)),
      Variable.withInt(dateToEpochDay(budgetPeriod.endInclusive!)),
      Variable.withInt(
        dateToEpochDay(DateTime(through.year, through.month - 5, 1)),
      ),
      Variable.withInt(dateToEpochDay(through)),
    ]);

    return _database
        .customSelect(
          '''WITH selected AS (
            SELECT category_id, type, amount_in_cents, date_epoch_day
            FROM transactions
            WHERE 1 = 1 $categoryClause
          )
          SELECT 'total' AS kind, type AS label,
            SUM(amount_in_cents) AS value, COUNT(*) AS auxiliary
          FROM selected GROUP BY type
          UNION ALL
          SELECT 'category', CAST(category_id AS TEXT), SUM(amount_in_cents), 0
          FROM selected WHERE type = 'expense' GROUP BY category_id
          UNION ALL
          SELECT 'limit', CAST(category_id AS TEXT), SUM(amount_in_cents), 0
          FROM selected WHERE type = 'expense'
            AND date_epoch_day BETWEEN ? AND ? GROUP BY category_id
          UNION ALL
          SELECT 'month', strftime('%Y-%m', date_epoch_day * 86400, 'unixepoch'),
            SUM(CASE WHEN type = 'income' THEN amount_in_cents ELSE 0 END),
            SUM(CASE WHEN type = 'expense' THEN amount_in_cents ELSE 0 END)
          FROM selected WHERE date_epoch_day BETWEEN ? AND ?
          GROUP BY strftime('%Y-%m', date_epoch_day * 86400, 'unixepoch')''',
          variables: variables,
          readsFrom: {_database.transactions},
        )
        .watch()
        .map((rows) {
          var income = 0;
          var expense = 0;
          var transactionCount = 0;
          var expenseCount = 0;
          final expenseByCategory = <int, int>{};
          final spentByCategory = <int, int>{};
          final monthly = <String, (int, int)>{};

          for (final row in rows) {
            final kind = row.read<String>('kind');
            final label = row.read<String>('label');
            final value = row.read<int>('value');
            final auxiliary = row.read<int>('auxiliary');
            switch (kind) {
              case 'total':
                transactionCount += auxiliary;
                if (label == TransactionType.income.name) {
                  income = value;
                } else {
                  expense = value;
                  expenseCount = auxiliary;
                }
              case 'category':
                expenseByCategory[int.parse(label)] = value;
              case 'limit':
                spentByCategory[int.parse(label)] = value;
              case 'month':
                monthly[label] = (value, auxiliary);
            }
          }

          final breakdown =
              expenseByCategory.entries
                  .map((entry) {
                    final category = categories[entry.key];
                    return category == null
                        ? null
                        : CategoryStatistics(
                            category: category,
                            amountInCents: entry.value,
                          );
                  })
                  .whereType<CategoryStatistics>()
                  .toList()
                ..sort((a, b) => b.amountInCents.compareTo(a.amountInCents));
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
          final firstMonth = DateTime(through.year, through.month - 5);
          final evolution = List<MonthlyStatistics>.generate(6, (index) {
            final month = DateTime(firstMonth.year, firstMonth.month + index);
            final totals = monthly[_monthLabel(month)] ?? (0, 0);
            return MonthlyStatistics(
              month: month,
              incomeInCents: totals.$1,
              expenseInCents: totals.$2,
            );
          }, growable: false);

          return StatisticsAggregateSnapshot(
            statistics: FinancialStatistics(
              incomeInCents: income,
              expenseInCents: expense,
              transactionCount: transactionCount,
              averageExpenseInCents: expenseCount == 0
                  ? 0
                  : expense ~/ expenseCount,
              expenseByCategory: breakdown,
            ),
            previous: null,
            limitInsights: List.unmodifiable(limits),
            evolution: evolution,
          );
        });
  }

  String _monthLabel(DateTime month) =>
      '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';
}

String _windowPredicate(StatisticsPeriod period, List<Variable> variables) {
  final predicates = <String>[];
  if (period.start != null) {
    predicates.add('date_epoch_day >= ?');
    variables.add(Variable.withInt(dateToEpochDay(period.start!)));
  }
  if (period.endInclusive != null) {
    predicates.add('date_epoch_day <= ?');
    variables.add(Variable.withInt(dateToEpochDay(period.endInclusive!)));
  }
  return predicates.isEmpty ? '1 = 1' : predicates.join(' AND ');
}

class _StatisticsAccumulator {
  var income = 0;
  var expense = 0;
  var transactionCount = 0;
  var expenseCount = 0;

  void add(String type, int value, int count) {
    transactionCount += count;
    if (type == TransactionType.income.name) {
      income = value;
    } else {
      expense = value;
      expenseCount = count;
    }
  }

  FinancialStatistics build(
    Map<int, Category> categories,
    Map<int, int> expenseByCategory,
  ) {
    final breakdown =
        expenseByCategory.entries
            .map((entry) {
              final category = categories[entry.key];
              return category == null
                  ? null
                  : CategoryStatistics(
                      category: category,
                      amountInCents: entry.value,
                    );
            })
            .whereType<CategoryStatistics>()
            .toList()
          ..sort((a, b) => b.amountInCents.compareTo(a.amountInCents));
    return FinancialStatistics(
      incomeInCents: income,
      expenseInCents: expense,
      transactionCount: transactionCount,
      averageExpenseInCents: expenseCount == 0 ? 0 : expense ~/ expenseCount,
      expenseByCategory: breakdown,
    );
  }
}

StatisticsAggregateSnapshot _buildSnapshot({
  required FinancialStatistics current,
  required FinancialStatistics? previous,
  required Map<int, int> spentByCategory,
  required Map<String, (int, int)> monthly,
  required DateTime firstMonth,
  required int monthCount,
  required Iterable<Category> limitCategories,
}) {
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
  final evolution = List<MonthlyStatistics>.generate(monthCount, (index) {
    final month = DateTime(firstMonth.year, firstMonth.month + index);
    final totals = monthly[_monthLabel(month)] ?? (0, 0);
    return MonthlyStatistics(
      month: month,
      incomeInCents: totals.$1,
      expenseInCents: totals.$2,
    );
  }, growable: false);
  return StatisticsAggregateSnapshot(
    statistics: current,
    previous: previous,
    limitInsights: List.unmodifiable(limits),
    evolution: evolution,
  );
}

String _monthLabel(DateTime month) =>
    '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';
