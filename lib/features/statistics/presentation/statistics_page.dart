import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/money/money_formatter.dart';
import '../../../core/widgets/mony_settings_action.dart';
import '../../budgets/domain/budget.dart';
import '../../budgets/presentation/budgets_providers.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../categories/presentation/category_icons.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../../transactions/presentation/transactions_providers.dart';
import '../domain/financial_statistics.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  StatisticsRange _range = StatisticsRange.currentBudget;
  int? _cycleIndex;
  int? _historyCycleId;
  int? _categoryId;
  DateTime? _customStart;
  DateTime? _customEnd;

  Future<void> _chooseCustomRange() async {
    final today = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year + 1, 12, 31),
      initialDateRange: _customStart != null && _customEnd != null
          ? DateTimeRange(start: _customStart!, end: _customEnd!)
          : null,
      helpText: 'Selecciona el período',
      saveText: 'Aplicar período',
    );
    if (range != null) {
      setState(() {
        _range = StatisticsRange.custom;
        _cycleIndex = null;
        _historyCycleId = null;
        _customStart = range.start;
        _customEnd = range.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionsProvider);
    final categoryState = ref.watch(categoriesProvider);
    final budgetState = ref.watch(budgetConfigProvider);
    final cycleHistoryState = ref.watch(budgetHistoryProvider);
    final preferences =
        ref.watch(appPreferencesProvider).value ?? AppPreferences.defaults;

    if (transactionState.hasError ||
        categoryState.hasError ||
        budgetState.hasError ||
        cycleHistoryState.hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Estadísticas'),
          actions: const [MonySettingsAction()],
        ),
        body: _StatisticsError(
          onRetry: () {
            ref.invalidate(transactionsProvider);
            ref.invalidate(categoriesProvider);
            ref.invalidate(budgetConfigProvider);
            ref.invalidate(budgetHistoryProvider);
          },
        ),
      );
    }
    if (!transactionState.hasValue || !categoryState.hasValue) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Estadísticas'),
          actions: const [MonySettingsAction()],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final transactions = transactionState.requireValue;
    final categories = categoryState.requireValue;
    final budget = budgetState.value;
    final cycleHistory = cycleHistoryState.value ?? const <BudgetCycle>[];
    final selectedHistoryCycle = cycleHistory
        .where((item) => item.id == _historyCycleId)
        .firstOrNull;
    if (_historyCycleId != null && selectedHistoryCycle == null) {
      _historyCycleId = null;
    }
    final now = DateTime.now();
    final schedules =
        budget?.cycleSchedules ??
        defaultBudgetCycleSchedules(budget?.period ?? BudgetPeriod.fortnightly);
    if (_cycleIndex != null && _cycleIndex! >= schedules.length) {
      _cycleIndex = null;
    }
    final cycle = _cycleIndex == null ? null : schedules[_cycleIndex!];
    final period = selectedHistoryCycle != null
        ? StatisticsPeriod(
            start: selectedHistoryCycle.startDate,
            endInclusive: selectedHistoryCycle.endDate,
          )
        : cycle == null
        ? statisticsPeriod(
            range: _range,
            today: now,
            budget: budget,
            customStart: _customStart,
            customEnd: _customEnd,
          )
        : _periodForCycle(cycle, now);
    final scopedTransactions = _categoryId == null
        ? transactions
        : transactions.where((item) => item.categoryId == _categoryId);
    final current = calculateFinancialStatistics(
      transactions: scopedTransactions,
      categories: {for (final category in categories) category.id: category},
      period: period,
    );
    final isComparable =
        _historyCycleId == null &&
        _range != StatisticsRange.allTime &&
        _range != StatisticsRange.custom;
    final previous = isComparable
        ? calculateFinancialStatistics(
            transactions: scopedTransactions,
            categories: {
              for (final category in categories) category.id: category,
            },
            period: previousStatisticsPeriod(
              range: _cycleIndex == null
                  ? _range
                  : StatisticsRange.currentBudget,
              current: period,
              today: now,
              budget: budget,
            ),
          )
        : null;
    final focusedCategory = categories
        .where((item) => item.id == _categoryId)
        .firstOrNull;
    final focusedStats = current.expenseByCategory
        .where((item) => item.category.id == _categoryId)
        .firstOrNull;
    final currentBudgetPeriod = activeBudgetPeriod(budget, now);
    final limitInsights = budgetLimitInsights(
      transactions: scopedTransactions,
      categories: _categoryId == null
          ? categories
          : categories.where((item) => item.id == _categoryId),
      period: _periodForRange(currentBudgetPeriod),
    );
    final evolution = monthlyStatistics(
      scopedTransactions,
      through: now,
      period: period,
      categoryId: _categoryId,
    );
    final expenseCategories =
        categories.where((item) => item.type == CategoryType.expense).toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        actions: const [MonySettingsAction()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 900
              ? 900.0
              : constraints.maxWidth;
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: maxWidth,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Text(
                    'Entiende cómo se mueven tus finanzas',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _rangeSelector(schedules, now),
                  if (cycleHistory.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int?>(
                      initialValue: _historyCycleId,
                      decoration: const InputDecoration(
                        labelText: 'Mis ciclos',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Sin ciclo histórico'),
                        ),
                        for (final savedCycle in cycleHistory)
                          DropdownMenuItem<int?>(
                            value: savedCycle.id,
                            child: Text(
                              '${_dateLabel(savedCycle.startDate)} – ${_dateLabel(savedCycle.endDate)}',
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() {
                        _historyCycleId = value;
                        _cycleIndex = null;
                      }),
                    ),
                  ],
                  if (_range == StatisticsRange.custom)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _chooseCustomRange,
                        icon: const Icon(Icons.date_range_outlined),
                        label: Text(_customRangeLabel),
                      ),
                    ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    key: ValueKey(_categoryId),
                    initialValue: _categoryId,
                    decoration: const InputDecoration(
                      labelText: 'Enfoque por categoría',
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Todas las categorías'),
                      ),
                      for (final category in expenseCategories)
                        DropdownMenuItem<int?>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                    ],
                    onChanged: (value) => setState(() => _categoryId = value),
                  ),
                  const SizedBox(height: 14),
                  _SummaryCard(
                    report: current,
                    currencyStyle: preferences.currencyFormatStyle,
                  ),
                  const SizedBox(height: 12),
                  _IncomeExpenseCard(
                    report: current,
                    currencyStyle: preferences.currencyFormatStyle,
                  ),
                  const SizedBox(height: 12),
                  if (previous != null) ...[
                    _ComparisonCard(
                      current: current,
                      previous: previous,
                      currencyStyle: preferences.currencyFormatStyle,
                    ),
                    const SizedBox(height: 12),
                  ],
                  _EvolutionCard(
                    data: evolution,
                    currencyStyle: preferences.currencyFormatStyle,
                    periodLabel: _evolutionLabel(period, _range, cycle),
                  ),
                  const SizedBox(height: 22),
                  _SectionTitle(
                    title: focusedCategory == null
                        ? 'Gastos por categoría'
                        : 'Detalle de ${focusedCategory.name}',
                    subtitle: _periodLabel(period, _range, cycle),
                  ),
                  const SizedBox(height: 8),
                  if (current.expenseByCategory.isEmpty)
                    const _EmptyPanel(
                      message: 'No hay gastos registrados en este período.',
                    )
                  else
                    ...current.expenseByCategory
                        .where(
                          (item) =>
                              _categoryId == null ||
                              item.category.id == _categoryId,
                        )
                        .map(
                          (item) => _CategoryBar(
                            statistic: item,
                            totalExpenses: current.expenseInCents,
                            currencyStyle: preferences.currencyFormatStyle,
                          ),
                        ),
                  if (focusedCategory != null) ...[
                    const SizedBox(height: 12),
                    _CategoryFocusCard(
                      category: focusedCategory,
                      spent: focusedStats?.amountInCents ?? 0,
                      currencyStyle: preferences.currencyFormatStyle,
                    ),
                  ],
                  const SizedBox(height: 22),
                  const _SectionTitle(
                    title: 'Límites del ciclo actual',
                    subtitle:
                        'Alertas al acercarte o superar el límite de cada categoría.',
                  ),
                  const SizedBox(height: 8),
                  if (limitInsights.isEmpty)
                    const _EmptyPanel(
                      message:
                          'Asigna límites a tus categorías desde Plan de ciclo para ver alertas aquí.',
                    )
                  else
                    ...limitInsights.map(
                      (insight) => _LimitInsightTile(
                        insight: insight,
                        currencyStyle: preferences.currencyFormatStyle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _rangeSelector(
    List<BudgetCycleSchedule> schedules,
    DateTime now,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          _filterChip(StatisticsRange.currentBudget, 'Ciclo actual'),
          _filterChip(StatisticsRange.currentMonth, 'Este mes'),
          _filterChip(StatisticsRange.currentYear, 'Este año'),
          _filterChip(StatisticsRange.allTime, 'Todo'),
          _filterChip(StatisticsRange.custom, 'Personalizado'),
        ],
      ),
      if (schedules.length > 1)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 8,
            children: [
              for (var index = 0; index < schedules.length; index++)
                ChoiceChip(
                  label: Text(
                    'Ciclo ${index + 1} · ${schedules[index].openingDay}–${schedules[index].closingDay}',
                  ),
                  selected: _cycleIndex == index,
                  onSelected: (_) => setState(() {
                    _cycleIndex = index;
                    _historyCycleId = null;
                    _range = StatisticsRange.currentBudget;
                  }),
                ),
            ],
          ),
        ),
    ],
  );

  Widget _filterChip(StatisticsRange range, String label) => ChoiceChip(
    label: Text(label),
    selected: _cycleIndex == null && _range == range,
    onSelected: (_) {
      if (range == StatisticsRange.custom &&
          (_customStart == null || _customEnd == null)) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _chooseCustomRange(),
        );
        return;
      }
      setState(() {
        _cycleIndex = null;
        _historyCycleId = null;
        _range = range;
      });
    },
  );

  String get _customRangeLabel => _customStart == null || _customEnd == null
      ? 'Selecciona las fechas'
      : '${_dateLabel(_customStart!)} – ${_dateLabel(_customEnd!)}';
}

StatisticsPeriod _periodForCycle(
  BudgetCycleSchedule cycle,
  DateTime reference,
) {
  final range = cycle.toDateRange(DateTime(reference.year, reference.month));
  return StatisticsPeriod(start: range.start, endInclusive: range.endInclusive);
}

StatisticsPeriod _periodForRange(DateRange range) =>
    StatisticsPeriod(start: range.start, endInclusive: range.endInclusive);

String _periodLabel(
  StatisticsPeriod period,
  StatisticsRange range,
  BudgetCycleSchedule? cycle,
) {
  if (range == StatisticsRange.allTime) return 'Todo el historial';
  if (period.start == null || period.endInclusive == null) {
    return 'Período seleccionado';
  }
  return '${_dateLabel(period.start!)} – ${_dateLabel(period.endInclusive!)}';
}

String _evolutionLabel(
  StatisticsPeriod period,
  StatisticsRange range,
  BudgetCycleSchedule? cycle,
) {
  if (range == StatisticsRange.allTime) return 'Últimos 6 meses';
  final months = period.start == null || period.endInclusive == null
      ? 0
      : (period.endInclusive!.year - period.start!.year) * 12 +
            period.endInclusive!.month -
            period.start!.month +
            1;
  if (months > 12) {
    return 'Últimos 12 meses · ${_periodLabel(period, range, cycle)}';
  }
  return _periodLabel(period, range, cycle);
}

String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);

String _monthLabel(DateTime date) => MonyDateFormatter.formatMonthYear(date);

String _money(int amount, CurrencyFormatStyle style) =>
    MoneyFormatter.formatDopMinorUnits(amount, style: style);

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.report, required this.currencyStyle});
  final FinancialStatistics report;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BALANCE DEL PERÍODO',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 5),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _money(report.balanceInCents, currencyStyle),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: report.balanceInCents < 0
                      ? colors.error
                      : colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AmountLabel(
                    label: 'Ingresos',
                    amount: report.incomeInCents,
                    style: currencyStyle,
                  ),
                ),
                Expanded(
                  child: _AmountLabel(
                    label: 'Gastos',
                    amount: report.expenseInCents,
                    style: currencyStyle,
                    expense: true,
                  ),
                ),
                Expanded(
                  child: _AmountLabel(
                    label: 'Movimientos',
                    amount: report.transactionCount,
                    style: currencyStyle,
                    count: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountLabel extends StatelessWidget {
  const _AmountLabel({
    required this.label,
    required this.amount,
    required this.style,
    this.expense = false,
    this.count = false,
  });
  final String label;
  final int amount;
  final CurrencyFormatStyle style;
  final bool expense;
  final bool count;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelSmall),
      const SizedBox(height: 3),
      Text(
        count ? '$amount' : _money(amount, style),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: expense ? Theme.of(context).colorScheme.error : null,
        ),
      ),
    ],
  );
}

class _IncomeExpenseCard extends StatelessWidget {
  const _IncomeExpenseCard({required this.report, required this.currencyStyle});
  final FinancialStatistics report;
  final CurrencyFormatStyle currencyStyle;
  @override
  Widget build(BuildContext context) {
    final maxAmount = math.max(report.incomeInCents, report.expenseInCents);
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INGRESOS Y GASTOS',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 14),
            _ComparisonBar(
              label: 'Ingresos',
              amount: report.incomeInCents,
              maxAmount: maxAmount,
              color: Theme.of(context).colorScheme.primary,
              style: currencyStyle,
            ),
            const SizedBox(height: 14),
            _ComparisonBar(
              label: 'Gastos',
              amount: report.expenseInCents,
              maxAmount: maxAmount,
              color: Theme.of(context).colorScheme.error,
              style: currencyStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonBar extends StatelessWidget {
  const _ComparisonBar({
    required this.label,
    required this.amount,
    required this.maxAmount,
    required this.color,
    required this.style,
  });
  final String label;
  final int amount;
  final int maxAmount;
  final Color color;
  final CurrencyFormatStyle style;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: Text(label)),
          Text(_money(amount, style)),
        ],
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          minHeight: 9,
          value: maxAmount == 0 ? 0 : amount / maxAmount,
          color: color,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
        ),
      ),
    ],
  );
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.current,
    required this.previous,
    required this.currencyStyle,
  });
  final FinancialStatistics current;
  final FinancialStatistics previous;
  final CurrencyFormatStyle currencyStyle;
  @override
  Widget build(BuildContext context) => Card.outlined(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMPARACIÓN CON EL PERÍODO ANTERIOR',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12),
          _TrendRow(
            label: 'Gastos',
            current: current.expenseInCents,
            previous: previous.expenseInCents,
            style: currencyStyle,
            upIsGood: false,
          ),
          const Divider(height: 18),
          _TrendRow(
            label: 'Ingresos',
            current: current.incomeInCents,
            previous: previous.incomeInCents,
            style: currencyStyle,
            upIsGood: true,
          ),
        ],
      ),
    ),
  );
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({
    required this.label,
    required this.current,
    required this.previous,
    required this.style,
    required this.upIsGood,
  });
  final String label;
  final int current;
  final int previous;
  final CurrencyFormatStyle style;
  final bool upIsGood;
  @override
  Widget build(BuildContext context) {
    final change = percentageChange(current, previous);
    final improved = change == null || change == 0
        ? null
        : (change > 0) == upIsGood;
    final color = improved == null
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : improved
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Text(
                _money(current, style),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Text(
          change == null
              ? (current == 0 ? 'Sin cambios' : 'Nuevo')
              : '${change > 0 ? '+' : ''}$change%',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Antes ${_money(previous, style)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _EvolutionCard extends StatelessWidget {
  const _EvolutionCard({
    required this.data,
    required this.currencyStyle,
    required this.periodLabel,
  });
  final List<MonthlyStatistics> data;
  final CurrencyFormatStyle currencyStyle;
  final String periodLabel;
  @override
  Widget build(BuildContext context) {
    final income = Theme.of(context).colorScheme.primary;
    final expense = Theme.of(context).colorScheme.error;
    final description = data
        .map(
          (item) =>
              '${_monthLabel(item.month)}: ingresos ${_money(item.incomeInCents, currencyStyle)}, gastos ${_money(item.expenseInCents, currencyStyle)}',
        )
        .join('. ');
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EVOLUCIÓN · $periodLabel',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 18,
              children: [
                _Legend(color: income, label: 'Ingresos'),
                _Legend(color: expense, label: 'Gastos'),
              ],
            ),
            const SizedBox(height: 10),
            Semantics(
              label: 'Ingresos y gastos por mes. $description',
              child: SizedBox(
                height: 210,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: _chartMaxY,
                    gridData: FlGridData(drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= data.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                _monthLabel(data[index].month),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (spots) => spots.map((spot) {
                          final item = data[spot.x.toInt()];
                          final amount = spot.barIndex == 0
                              ? item.incomeInCents
                              : item.expenseInCents;
                          final label = spot.barIndex == 0
                              ? 'Ingresos'
                              : 'Gastos';
                          return LineTooltipItem(
                            '$label · ${_money(amount, currencyStyle)}',
                            TextStyle(
                              color:
                                  spot.bar.color ??
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    lineBarsData: [_line(true, income), _line(false, expense)],
                  ),
                  duration: const Duration(milliseconds: 180),
                ),
              ),
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Ver datos por mes'),
              children: [
                for (final item in data)
                  ListTile(
                    dense: true,
                    title: Text(_monthLabel(item.month)),
                    subtitle: Text(
                      'Ingresos ${_money(item.incomeInCents, currencyStyle)} · Gastos ${_money(item.expenseInCents, currencyStyle)}',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double get _chartMaxY {
    final max = data.fold<int>(
      0,
      (value, item) =>
          math.max(value, math.max(item.incomeInCents, item.expenseInCents)),
    );
    return max == 0 ? 1 : max / 100 * 1.1;
  }

  LineChartBarData _line(bool income, Color color) => LineChartBarData(
    spots: [
      for (var index = 0; index < data.length; index++)
        FlSpot(
          index.toDouble(),
          (income ? data[index].incomeInCents : data[index].expenseInCents) /
              100,
        ),
    ],
    color: color,
    barWidth: 3,
    isCurved: false,
    dotData: const FlDotData(show: true),
  );
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.statistic,
    required this.totalExpenses,
    required this.currencyStyle,
  });
  final CategoryStatistics statistic;
  final int totalExpenses;
  final CurrencyFormatStyle currencyStyle;
  @override
  Widget build(BuildContext context) {
    final category = statistic.category;
    final share = totalExpenses <= 0
        ? 0.0
        : statistic.amountInCents / totalExpenses;
    final limit = category.budgetLimitInCents;
    final ratio = limit == null || limit <= 0
        ? share
        : statistic.amountInCents / limit;
    final color = Color(category.colorArgb);
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color.withValues(alpha: .15),
                  child: Icon(
                    categoryIcons[category.icon] ?? Icons.category_outlined,
                    size: 15,
                    color: color,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  _money(statistic.amountInCents, currencyStyle),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                minHeight: 7,
                value: ratio.clamp(0, 1),
                color: limit != null && ratio >= 1
                    ? Theme.of(context).colorScheme.error
                    : color,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              limit != null && limit > 0
                  ? '${(ratio * 100).round()}% del límite · ${_money(limit, currencyStyle)}'
                  : '${(share * 100).round()}% de los gastos',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFocusCard extends StatelessWidget {
  const _CategoryFocusCard({
    required this.category,
    required this.spent,
    required this.currencyStyle,
  });
  final Category category;
  final int spent;
  final CurrencyFormatStyle currencyStyle;
  @override
  Widget build(BuildContext context) {
    final limit = category.budgetLimitInCents;
    final percent = limit == null || limit <= 0 ? null : (spent * 100) ~/ limit;
    return Card(
      color: percent != null && percent >= 100
          ? Theme.of(context).colorScheme.errorContainer
          : null,
      child: ListTile(
        title: Text(category.name),
        subtitle: Text(
          percent == null
              ? 'Límite no definido'
              : '$percent% del límite de ${_money(limit ?? 0, currencyStyle)}',
        ),
        trailing: Text(
          _money(spent, currencyStyle),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class _LimitInsightTile extends StatelessWidget {
  const _LimitInsightTile({required this.insight, required this.currencyStyle});
  final BudgetLimitInsight insight;
  final CurrencyFormatStyle currencyStyle;
  @override
  Widget build(BuildContext context) {
    final percent = insight.usagePercent;
    final isOver = percent >= 100;
    final isNear = percent >= 75;
    final colors = Theme.of(context).colorScheme;
    final color = isOver
        ? colors.error
        : isNear
        ? colors.tertiary
        : colors.primary;
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    insight.category.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  '$percent%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            LinearProgressIndicator(
              value: (percent / 100).clamp(0, 1),
              color: color,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isOver
                        ? 'Límite superado'
                        : isNear
                        ? 'Cerca del límite'
                        : 'Dentro del límite',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: color),
                  ),
                ),
                Text(
                  '${_money(insight.spentInCents, currencyStyle)} de ${_money(insight.limitInCents, currencyStyle)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Card.outlined(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ),
  );
}

class _StatisticsError extends StatelessWidget {
  const _StatisticsError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar las estadísticas.'),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
        ),
      ],
    ),
  );
}
