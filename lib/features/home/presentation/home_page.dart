import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/money/money_formatter.dart';
import '../../../core/theme/mony_tokens.dart';
import '../../../core/theme/mony_finance_colors.dart';
import '../../../core/theme/sumi_visuals.dart';
import '../../../core/theme/coquette_visuals.dart';
import '../../../core/widgets/mony_finance_widgets.dart';
import '../../../core/widgets/mony_layout.dart';
import '../../../core/widgets/mony_settings_action.dart';
import '../../../core/widgets/mony_states.dart';
import '../../budgets/domain/budget.dart';
import '../../budgets/presentation/budgets_providers.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/presentation/transactions_providers.dart';
import '../../dashboard/domain/financial_dashboard_summary.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  BudgetPeriodView _periodView = BudgetPeriodView.current;

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final budget = ref.watch(budgetConfigProvider);
    final range = budgetPeriodForView(
      budget.value,
      _periodView,
      DateTime.now(),
    );
    final summary = transactions.whenData(
      (items) => FinancialDashboardSummary.fromTransactions(
        items,
        month: range.start,
        selectedPeriod: range,
      ),
    );
    final categories = ref.watch(categoriesProvider);
    final preferences =
        ref.watch(appPreferencesProvider).value ?? AppPreferences.defaults;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: const [MonySettingsAction()],
      ),
      body: SelectionContainer.disabled(
        child: SafeArea(
          child: budget.hasError
              ? ErrorState(
                  message: 'No pudimos cargar la configuración del ciclo.',
                  retryLabel: 'Reintentar',
                  onRetry: () => ref.invalidate(budgetConfigProvider),
                )
              : summary.when(
                  loading: () =>
                      const LoadingPlaceholder(message: 'Cargando resumen'),
                  error: (error, stack) => ErrorState(
                    message: 'No pudimos cargar el resumen financiero.',
                    retryLabel: 'Reintentar',
                    onRetry: () => ref.invalidate(transactionsProvider),
                  ),
                  data: (value) => categories.when(
                    loading: () => _DashboardContent(
                      summary: value,
                      categories: const [],
                      budgetAmountInCents: budget.value?.amountInCents,
                      categoryNotice: 'Cargando categorías…',
                      currencyStyle: preferences.currencyFormatStyle,
                      periodView: _periodView,
                      onPeriodViewChanged: (view) =>
                          setState(() => _periodView = view),
                    ),
                    error: (error, stack) => _DashboardContent(
                      summary: value,
                      categories: const [],
                      budgetAmountInCents: budget.value?.amountInCents,
                      categoryNotice:
                          'No se pudieron cargar los nombres de categorías.',
                      onRetryCategories: () =>
                          ref.invalidate(categoriesProvider),
                      currencyStyle: preferences.currencyFormatStyle,
                      periodView: _periodView,
                      onPeriodViewChanged: (view) =>
                          setState(() => _periodView = view),
                    ),
                    data: (categoryItems) => _DashboardContent(
                      summary: value,
                      categories: categoryItems,
                      budgetAmountInCents: budget.value?.amountInCents,
                      currencyStyle: preferences.currencyFormatStyle,
                      periodView: _periodView,
                      onPeriodViewChanged: (view) =>
                          setState(() => _periodView = view),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.summary,
    required this.categories,
    this.budgetAmountInCents,
    this.categoryNotice,
    this.onRetryCategories,
    required this.currencyStyle,
    required this.periodView,
    required this.onPeriodViewChanged,
  });

  final FinancialDashboardSummary summary;
  final List<Category> categories;
  final int? budgetAmountInCents;
  final String? categoryNotice;
  final VoidCallback? onRetryCategories;
  final CurrencyFormatStyle currencyStyle;
  final BudgetPeriodView periodView;
  final ValueChanged<BudgetPeriodView> onPeriodViewChanged;

  @override
  Widget build(BuildContext context) {
    final categoryNames = {for (final item in categories) item.id: item.name};
    final theme = Theme.of(context);
    final sumi = SumiThemeColors.maybeOf(context);
    return ResponsiveContainer(
      maxWidth: 760,
      padding: EdgeInsets.zero,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          MonySpace.x4,
          MonySpace.x4,
          MonySpace.x4,
          MonySpace.x8,
        ),
        children: [
          Text(
            'Tus finanzas, en un solo lugar',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Resumen de tus movimientos y balance.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (categoryNotice != null) ...[
            const SizedBox(height: MonySpace.x2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    categoryNotice!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (onRetryCategories != null)
                  TextButton(
                    onPressed: onRetryCategories,
                    child: const Text('Reintentar'),
                  ),
              ],
            ),
          ],
          if (summary.recentTransactions.isEmpty) ...[
            const SizedBox(height: MonySpace.x4),
            _CycleSelector(
              selected: periodView,
              onChanged: onPeriodViewChanged,
            ),
            const SizedBox(height: MonySpace.x3),
            MonyEntrance(
              child: BalanceCard(
                label: 'Balance disponible',
                amount: MoneyFormatter.formatDopMinorUnits(
                  summary.balanceInCents,
                  style: currencyStyle,
                ),
                supportingText: 'Tu balance del ciclo actual',
              ),
            ),
            const SizedBox(height: MonySpace.x3),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - MonySpace.x3) / 2;
                return Wrap(
                  spacing: MonySpace.x3,
                  children: [
                    SizedBox(
                      width: width,
                      child: StatTile(
                        title: 'Ingresos',
                        value: MoneyFormatter.formatDopMinorUnits(
                          summary.incomeInCents,
                          style: currencyStyle,
                        ),
                        icon: Icons.south_west_rounded,
                        emphasis: AmountEmphasis.income,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: StatTile(
                        title: 'Gastos',
                        value: MoneyFormatter.formatDopMinorUnits(
                          summary.expenseInCents,
                          style: currencyStyle,
                        ),
                        icon: Icons.north_east_rounded,
                        emphasis: AmountEmphasis.expense,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: MonySpace.x3),
            const _EmptyTrendCard(),
            const SizedBox(height: MonySpace.x3),
            MonyCard(
              padding: const EdgeInsets.all(MonySpace.x4),
              sumiVariant: SumiSurfaceVariant.inkWash,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Empieza con un movimiento',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: sumi?.ink,
                          ),
                        ),
                        const SizedBox(height: MonySpace.x1),
                        Text(
                          'Registra un ingreso o un gasto para activar tu resumen.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                sumi?.inkGray ??
                                theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: MonySpace.x2),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('transactionNew'),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Añadir'),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: MonySpace.x4),
            _CycleSelector(
              selected: periodView,
              onChanged: onPeriodViewChanged,
            ),
            const SizedBox(height: MonySpace.x2),
            MonyEntrance(
              child: BalanceCard(
                label: 'Balance neto del ciclo',
                amount: MoneyFormatter.formatDopMinorUnits(
                  summary.balanceInCents,
                  style: currencyStyle,
                ),
                supportingText: summary.period == null
                    ? 'Ingresos menos gastos · ${_monthName(summary.month)}'
                    : 'Ingresos menos gastos · ${MonyDateFormatter.formatDate(summary.period!.start)} – ${MonyDateFormatter.formatDate(summary.period!.endInclusive)}',
              ),
            ),
            const SizedBox(height: MonySpace.x3),
            if (budgetAmountInCents != null && budgetAmountInCents! > 0) ...[
              _CycleBudgetProgress(
                spentInCents: summary.expenseInCents,
                budgetInCents: budgetAmountInCents!,
                currencyStyle: currencyStyle,
              ),
              const SizedBox(height: MonySpace.x3),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - MonySpace.x3) / 2;
                return Wrap(
                  spacing: MonySpace.x3,
                  runSpacing: MonySpace.x3,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: StatTile(
                        title: 'Ingresos',
                        value: MoneyFormatter.formatDopMinorUnits(
                          summary.incomeInCents,
                          style: currencyStyle,
                        ),
                        icon: Icons.south_west,
                        emphasis: AmountEmphasis.income,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatTile(
                        title: 'Gastos',
                        value: MoneyFormatter.formatDopMinorUnits(
                          summary.expenseInCents,
                          style: currencyStyle,
                        ),
                        icon: Icons.north_east,
                        emphasis: AmountEmphasis.expense,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: MonySpace.x3),
            Wrap(
              spacing: MonySpace.x2,
              runSpacing: MonySpace.x2,
              children: [
                FilledButton.icon(
                  onPressed: () => context.pushNamed(
                    'transactionNew',
                    queryParameters: const {'type': 'income'},
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo ingreso'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed(
                    'transactionNew',
                    queryParameters: const {'type': 'expense'},
                  ),
                  icon: const Icon(Icons.remove),
                  label: const Text('Nuevo gasto'),
                ),
              ],
            ),
            const SizedBox(height: MonySpace.x6),
            MonyEntrance(
              delay: const Duration(milliseconds: 80),
              child: _MonthlyTrendChart(
                totals: summary.monthlyTotals,
                currencyStyle: currencyStyle,
              ),
            ),
            const SizedBox(height: MonySpace.x6),
            SectionHeader(
              title: 'Movimientos recientes',
              action: TextButton(
                onPressed: () => context.goNamed('transactions'),
                child: const Text('Ver todos'),
              ),
            ),
            ...summary.recentTransactions.map((transaction) {
              final category = categoryNames[transaction.categoryId];
              return _RecentTransactionTile(
                transaction: transaction,
                categoryName:
                    category ??
                    (categoryNotice == null
                        ? 'Categoría archivada'
                        : 'Categoría no disponible'),
                currencyStyle: currencyStyle,
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _EmptyTrendCard extends StatelessWidget {
  const _EmptyTrendCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sumi = SumiThemeColors.maybeOf(context);
    return MonyCard(
      padding: const EdgeInsets.fromLTRB(
        MonySpace.x4,
        MonySpace.x4,
        MonySpace.x4,
        MonySpace.x2,
      ),
      sumiVariant: SumiSurfaceVariant.inkWash,
      coquetteVariant: CoquetteSurfaceVariant.editorial,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIconsRegular.chartLineUp,
                size: 19,
                color: sumi?.vermilion ?? theme.colorScheme.primary,
              ),
              const SizedBox(width: MonySpace.x2),
              Text(
                'Tu evolución',
                style: theme.textTheme.titleMedium?.copyWith(color: sumi?.ink),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Los datos del ciclo aparecerán aquí',
            style: theme.textTheme.bodySmall?.copyWith(
              color: sumi?.inkGray ?? theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: MonySpace.x2),
          SizedBox(
            height: 112,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _TrendGridPainter(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: sumi == null ? .4 : .25,
                    ),
                  ),
                ),
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          sumi?.deepInk ?? theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(
                        sumi == null ? MonyRadius.medium : 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        'Sin movimientos todavía',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color:
                              sumi?.paper ?? theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendGridPainter extends CustomPainter {
  const _TrendGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var row = 1; row <= 3; row++) {
      final y = size.height * row / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (var column = 1; column <= 5; column++) {
      final x = size.width * column / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendGridPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _MonthlyTrendChart extends StatelessWidget {
  const _MonthlyTrendChart({required this.totals, required this.currencyStyle});

  final List<DashboardMonthTotals> totals;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = Theme.of(context).extension<MonyFinanceColors>()!;
    final maximum = totals.fold<int>(
      0,
      (value, month) =>
          math.max(value, math.max(month.incomeInCents, month.expenseInCents)),
    );
    final chartDescription = totals
        .map((month) {
          final label = _shortMonth(month.month);
          final income = MoneyFormatter.formatDopMinorUnits(
            month.incomeInCents,
            style: currencyStyle,
          );
          final expense = MoneyFormatter.formatDopMinorUnits(
            month.expenseInCents,
            style: currencyStyle,
          );
          return '$label: ingresos $income, gastos $expense';
        })
        .join('. ');

    return MonyCard(
      padding: const EdgeInsets.all(MonySpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ingresos y gastos', style: theme.textTheme.titleMedium),
          const SizedBox(height: MonySpace.x1),
          Text(
            'Últimos seis meses',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: MonySpace.x4),
          Semantics(
            label: 'Gráfico de ingresos y gastos. $chartDescription.',
            child: ExcludeSemantics(
              child: SizedBox(
                height: 184,
                child: BarChart(
                  BarChartData(
                    maxY: maximum == 0 ? 1 : maximum / 100,
                    minY: 0,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: maximum == 0
                          ? 1
                          : (maximum / 100 / 3).clamp(1, double.infinity),
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.45,
                        ),
                        strokeWidth: 1,
                      ),
                    ),
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
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= totals.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                _shortMonth(totals[index].month),
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var index = 0; index < totals.length; index++)
                        BarChartGroupData(
                          x: index,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: totals[index].incomeInCents / 100,
                              width: 7,
                              color: finance.income,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            BarChartRodData(
                              toY: totals[index].expenseInCents / 100,
                              width: 7,
                              color: finance.expense,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ],
                        ),
                    ],
                  ),
                  duration: MonyMotion.durationFor(context, MonyMotion.quick),
                ),
              ),
            ),
          ),
          const SizedBox(height: MonySpace.x3),
          Wrap(
            spacing: MonySpace.x4,
            runSpacing: MonySpace.x2,
            children: [
              _TrendLegend(color: finance.income, label: 'Ingresos'),
              _TrendLegend(color: finance.expense, label: 'Gastos'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendLegend extends StatelessWidget {
  const _TrendLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const SizedBox(width: 10, height: 10),
        ),
      ),
      const SizedBox(width: MonySpace.x1),
      Text(label, style: Theme.of(context).textTheme.labelMedium),
    ],
  );
}

String _shortMonth(DateTime date) {
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  return months[date.month - 1];
}

class _CycleBudgetProgress extends StatelessWidget {
  const _CycleBudgetProgress({
    required this.spentInCents,
    required this.budgetInCents,
    required this.currencyStyle,
  });

  final int spentInCents;
  final int budgetInCents;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context) {
    final remaining = budgetInCents - spentInCents;
    final overBudget = remaining < 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MonySpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Progreso del presupuesto',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  MoneyFormatter.formatDopMinorUnits(
                    spentInCents,
                    style: currencyStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: MonySpace.x2),
            LinearProgressIndicator(
              value: (spentInCents / budgetInCents).clamp(0.0, 1.0),
              color: overBudget ? Theme.of(context).colorScheme.error : null,
              minHeight: 8,
            ),
            const SizedBox(height: MonySpace.x2),
            Text(
              '${overBudget ? 'Exceso' : 'Disponible'} ${MoneyFormatter.formatDopMinorUnits(remaining.abs(), style: currencyStyle)} de ${MoneyFormatter.formatDopMinorUnits(budgetInCents, style: currencyStyle)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: overBudget
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleSelector extends StatelessWidget {
  const _CycleSelector({required this.selected, required this.onChanged});

  final BudgetPeriodView selected;
  final ValueChanged<BudgetPeriodView> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<BudgetPeriodView>(
    segments: const [
      ButtonSegment(
        value: BudgetPeriodView.current,
        label: Text('Ciclo actual'),
      ),
      ButtonSegment(value: BudgetPeriodView.next, label: Text('Próximo ciclo')),
    ],
    selected: {selected},
    showSelectedIcon: false,
    onSelectionChanged: (value) => onChanged(value.first),
  );
}

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({
    required this.transaction,
    required this.categoryName,
    required this.currencyStyle,
  });
  final FinanceTransaction transaction;
  final String categoryName;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context) {
    final income = transaction.type == TransactionType.income;
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => context.pushNamed(
        'transactionDetail',
        pathParameters: {'id': transaction.id.toString()},
      ),
      leading: CircleAvatar(
        backgroundColor: (income ? colors.primary : colors.error).withValues(
          alpha: 0.12,
        ),
        child: Icon(
          income ? Icons.south_west : Icons.north_east,
          color: income ? colors.primary : colors.error,
        ),
      ),
      title: Text(
        transaction.description?.isNotEmpty == true
            ? transaction.description ?? categoryName
            : categoryName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('$categoryName · ${_dateLabel(transaction.date)}'),
      trailing: Text(
        '${income ? '+' : '−'}${MoneyFormatter.formatDopMinorUnits(transaction.amountInCents, style: currencyStyle)}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: income ? colors.primary : colors.error,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _monthName(DateTime date) => MonyDateFormatter.formatMonthYear(date);

String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);
