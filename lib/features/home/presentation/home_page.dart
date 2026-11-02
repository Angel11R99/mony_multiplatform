import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../../core/theme/mony_tokens.dart';
import '../../../core/theme/mony_finance_colors.dart';
import '../../../core/widgets/mony_finance_widgets.dart';
import '../../../core/widgets/mony_layout.dart';
import '../../../core/widgets/mony_states.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/presentation/transactions_providers.dart';
import '../../dashboard/domain/financial_dashboard_summary.dart';
import '../../dashboard/presentation/dashboard_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _changeMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(dashboardSummaryProvider(_month));
    final categories = ref.watch(categoriesProvider);
    final preferences =
        ref.watch(appPreferencesProvider).value ?? AppPreferences.defaults;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mony'),
        actions: [
          PopupMenuButton<_HomeAction>(
            tooltip: 'Más opciones',
            onSelected: (action) {
              switch (action) {
                case _HomeAction.paymentMethods:
                  context.goNamed('paymentMethods');
                  break;
                case _HomeAction.categories:
                  context.goNamed('categories');
                  break;
                case _HomeAction.settings:
                  context.pushNamed('settings');
                  break;
                case _HomeAction.exports:
                  context.pushNamed('exports');
                  break;
                case _HomeAction.barcode:
                  context.pushNamed('barcodeScan');
                  break;
                case _HomeAction.receipt:
                  context.pushNamed('receiptScan');
                  break;
                case _HomeAction.widgets:
                  context.pushNamed('widgets');
                  break;
                case _HomeAction.about:
                  context.pushNamed('about');
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _HomeAction.paymentMethods,
                child: Text('Métodos de pago'),
              ),
              PopupMenuItem(
                value: _HomeAction.categories,
                child: Text('Administrar categorías'),
              ),
              PopupMenuItem(
                value: _HomeAction.settings,
                child: Text('Apariencia y preferencias'),
              ),
              PopupMenuItem(
                value: _HomeAction.exports,
                child: Text('Exportar datos'),
              ),
              PopupMenuItem(
                value: _HomeAction.barcode,
                child: Text('Escanear producto'),
              ),
              PopupMenuItem(
                value: _HomeAction.receipt,
                child: Text('Escanear ticket'),
              ),
              PopupMenuItem(
                value: _HomeAction.widgets,
                child: Text('Widgets de Mony'),
              ),
              PopupMenuItem(
                value: _HomeAction.about,
                child: Text('Acerca de Mony'),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: MonySpace.x2),
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: summary.when(
          loading: () => const LoadingPlaceholder(message: 'Cargando resumen'),
          error: (error, stack) => ErrorState(
            message: 'No pudimos cargar el resumen financiero.',
            retryLabel: 'Reintentar',
            onRetry: () => ref.invalidate(transactionsProvider),
          ),
          data: (value) => categories.when(
            loading: () => _DashboardContent(
              summary: value,
              categories: const [],
              categoryNotice: 'Cargando categorías…',
              currencyStyle: preferences.currencyFormatStyle,
              onPreviousMonth: () => _changeMonth(-1),
              onNextMonth: DateUtils.isSameMonth(_month, DateTime.now())
                  ? null
                  : () => _changeMonth(1),
            ),
            error: (error, stack) => _DashboardContent(
              summary: value,
              categories: const [],
              categoryNotice:
                  'No se pudieron cargar los nombres de categorías.',
              onRetryCategories: () => ref.invalidate(categoriesProvider),
              currencyStyle: preferences.currencyFormatStyle,
              onPreviousMonth: () => _changeMonth(-1),
              onNextMonth: DateUtils.isSameMonth(_month, DateTime.now())
                  ? null
                  : () => _changeMonth(1),
            ),
            data: (categoryItems) => _DashboardContent(
              summary: value,
              categories: categoryItems,
              currencyStyle: preferences.currencyFormatStyle,
              onPreviousMonth: () => _changeMonth(-1),
              onNextMonth: DateUtils.isSameMonth(_month, DateTime.now())
                  ? null
                  : () => _changeMonth(1),
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
    this.categoryNotice,
    this.onRetryCategories,
    required this.currencyStyle,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final FinancialDashboardSummary summary;
  final List<Category> categories;
  final String? categoryNotice;
  final VoidCallback? onRetryCategories;
  final CurrencyFormatStyle currencyStyle;
  final VoidCallback onPreviousMonth;
  final VoidCallback? onNextMonth;

  @override
  Widget build(BuildContext context) {
    final categoryNames = {for (final item in categories) item.id: item.name};
    final theme = Theme.of(context);
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
            const SizedBox(height: MonySpace.x8),
            const EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Empieza con tu primer movimiento',
              message:
                  'Registra un ingreso o un gasto para ver tu balance y la evolución de tus finanzas.',
            ),
            const SizedBox(height: MonySpace.x4),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: MonySpace.x3,
              runSpacing: MonySpace.x2,
              children: [
                FilledButton.icon(
                  onPressed: () => context.pushNamed(
                    'transactionNew',
                    queryParameters: const {'type': 'income'},
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir ingreso'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed(
                    'transactionNew',
                    queryParameters: const {'type': 'expense'},
                  ),
                  icon: const Icon(Icons.remove),
                  label: const Text('Añadir gasto'),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: MonySpace.x4),
            _MonthSelector(
              month: summary.month,
              onPrevious: onPreviousMonth,
              onNext: onNextMonth,
            ),
            const SizedBox(height: MonySpace.x2),
            BalanceCard(
              label: 'Balance neto del mes',
              amount: MoneyFormatter.formatDopMinorUnits(
                summary.balanceInCents,
                style: currencyStyle,
              ),
              supportingText:
                  'Ingresos menos gastos · ${_monthName(summary.month)}',
            ),
            const SizedBox(height: MonySpace.x3),
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
            _MonthlyTrendChart(
              totals: summary.monthlyTotals,
              currencyStyle: currencyStyle,
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

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: 'Mes anterior',
        onPressed: onPrevious,
        icon: const Icon(Icons.chevron_left),
      ),
      Expanded(
        child: Text(
          _monthName(month),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      IconButton(
        tooltip: 'Mes siguiente',
        onPressed: onNext,
        icon: const Icon(Icons.chevron_right),
      ),
    ],
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

String _monthName(DateTime date) {
  const months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  return '${months[date.month - 1]} ${date.year}';
}

String _dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

enum _HomeAction {
  paymentMethods,
  categories,
  settings,
  exports,
  barcode,
  receipt,
  widgets,
  about,
}
