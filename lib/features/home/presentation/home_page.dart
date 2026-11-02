import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../../core/theme/mony_tokens.dart';
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
            loading: () =>
                const LoadingPlaceholder(message: 'Cargando categorías'),
            error: (error, stack) => ErrorState(
              message: 'No pudimos cargar las categorías.',
              retryLabel: 'Reintentar',
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
          const SizedBox(height: 18),
          _MonthSelector(
            month: summary.month,
            onPrevious: onPreviousMonth,
            onNext: onNextMonth,
          ),
          const SizedBox(height: 12),
          BalanceCard(
            label: 'Balance del mes',
            amount: MoneyFormatter.formatDopMinorUnits(
              summary.balanceInCents,
              style: currencyStyle,
            ),
            supportingText: summary.balanceInCents < 0
                ? 'Gastos por encima de los ingresos'
                : 'Ingresos menos gastos',
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 22),
          const SectionHeader(title: 'Accesos rápidos'),
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
                onPressed: () => context.pushNamed('barcodeScan'),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Escanear producto'),
              ),
              TextButton.icon(
                onPressed: () => context.pushNamed('receiptScan'),
                icon: const Icon(Icons.document_scanner_outlined),
                label: const Text('Escanear ticket'),
              ),
              TextButton.icon(
                onPressed: () => context.pushNamed('widgets'),
                icon: const Icon(Icons.widgets_outlined),
                label: const Text('Widgets de inicio'),
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
          SectionHeader(
            title: 'Movimientos recientes',
            action: TextButton(
              onPressed: () => context.goNamed('transactions'),
              child: const Text('Ver todos'),
            ),
          ),
          if (summary.recentTransactions.isEmpty)
            const EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Todavía no hay movimientos',
              message:
                  'Registra tu primer ingreso o gasto para ver el balance aquí.',
            )
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
