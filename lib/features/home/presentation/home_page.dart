import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
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
          IconButton(
            tooltip: 'Métodos de pago',
            onPressed: () => context.goNamed('paymentMethods'),
            icon: const Icon(Icons.payment_outlined),
          ),
          IconButton(
            tooltip: 'Administrar categorías',
            onPressed: () => context.goNamed('categories'),
            icon: const Icon(Icons.category_outlined),
          ),
          IconButton(
            tooltip: 'Apariencia y preferencias',
            onPressed: () => context.goNamed('settings'),
            icon: const Icon(Icons.tune),
          ),
          IconButton(
            tooltip: 'Exportar datos',
            onPressed: () => context.goNamed('exports'),
            icon: const Icon(Icons.file_download_outlined),
          ),
          IconButton(
            tooltip: 'Acerca de Mony',
            onPressed: () => context.goNamed('about'),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: summary.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _DashboardError(
          onRetry: () => ref.invalidate(transactionsProvider),
        ),
        data: (value) => categories.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _DashboardError(
            onRetry: () => ref.invalidate(categoriesProvider),
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
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.summary,
    required this.categories,
    required this.currencyStyle,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final FinancialDashboardSummary summary;
  final List<Category> categories;
  final CurrencyFormatStyle currencyStyle;
  final VoidCallback onPreviousMonth;
  final VoidCallback? onNextMonth;

  @override
  Widget build(BuildContext context) {
    final categoryNames = {for (final item in categories) item.id: item.name};
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 760
            ? 760.0
            : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: maxWidth,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
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
                const SizedBox(height: 18),
                _MonthSelector(
                  month: summary.month,
                  onPrevious: onPreviousMonth,
                  onNext: onNextMonth,
                ),
                const SizedBox(height: 12),
                _BalanceCard(
                  amount: summary.balanceInCents,
                  currencyStyle: currencyStyle,
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _MetricCard(
                            title: 'Ingresos',
                            amount: summary.incomeInCents,
                            icon: Icons.south_west,
                            color: theme.colorScheme.primary,
                            currencyStyle: currencyStyle,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _MetricCard(
                            title: 'Gastos',
                            amount: summary.expenseInCents,
                            icon: Icons.north_east,
                            color: theme.colorScheme.error,
                            currencyStyle: currencyStyle,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),
                Text('Accesos rápidos', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
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
                    TextButton.icon(
                      onPressed: () => context.goNamed('transactions'),
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: const Text('Ver historial'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.goNamed('savingsGoals'),
                      icon: const Icon(Icons.savings_outlined),
                      label: const Text('Metas de ahorro'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.goNamed('budgets'),
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      label: const Text('Presupuestos'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.goNamed('statistics'),
                      icon: const Icon(Icons.query_stats_outlined),
                      label: const Text('Estadísticas'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.goNamed('exports'),
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('Exportar datos'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.goNamed('shoppingLists'),
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Listas de compras'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.goNamed('obligations'),
                      icon: const Icon(Icons.event_note_outlined),
                      label: const Text('Pagos y cobros pendientes'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.goNamed('recurringEntries'),
                      icon: const Icon(Icons.repeat),
                      label: const Text('Movimientos recurrentes'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Movimientos recientes',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.goNamed('transactions'),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
                if (summary.recentTransactions.isEmpty)
                  const _DashboardEmpty()
                else
                  ...summary.recentTransactions.map((transaction) {
                    final category =
                        categoryNames[transaction.categoryId] ??
                        'Categoría archivada';
                    return _RecentTransactionTile(
                      transaction: transaction,
                      categoryName: category,
                      currencyStyle: currencyStyle,
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.amount, required this.currencyStyle});
  final int amount;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance del mes',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                MoneyFormatter.formatDopMinorUnits(
                  amount,
                  style: currencyStyle,
                ),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              amount < 0
                  ? 'Gastos por encima de los ingresos'
                  : 'Ingresos menos gastos',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.currencyStyle,
  });
  final String title;
  final int amount;
  final IconData icon;
  final Color color;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context) => Card.outlined(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              MoneyFormatter.formatDopMinorUnits(amount, style: currencyStyle),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),
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

class _DashboardEmpty extends StatelessWidget {
  const _DashboardEmpty();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: Column(
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          size: 44,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Todavía no hay movimientos',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        const Text(
          'Registra tu primer ingreso o gasto para ver el balance aquí.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar el resumen financiero.'),
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
