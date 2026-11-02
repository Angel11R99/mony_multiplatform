import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../domain/transaction.dart';
import '../domain/transaction_history_filter.dart';
import 'transactions_providers.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  static const _pageSize = 20;
  final _search = TextEditingController();
  TransactionType? _type;
  int? _categoryId;
  DateTime? _startDate;
  DateTime? _endDate;
  TransactionSortOrder _sortOrder = TransactionSortOrder.newest;
  int _visibleCount = _pageSize;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _updateFilter(VoidCallback update) => setState(() {
    update();
    _visibleCount = _pageSize;
  });

  TransactionHistoryFilter get _filter => TransactionHistoryFilter(
    query: _search.text,
    type: _type,
    categoryId: _categoryId,
    startDate: _startDate,
    endDate: _endDate,
    sortOrder: _sortOrder,
  );

  Future<void> _chooseRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange: _startDate == null || _endDate == null
          ? null
          : DateTimeRange(start: _startDate!, end: _endDate!),
      helpText: 'Filtrar por período',
      saveText: 'Aplicar',
    );
    if (range != null && mounted) {
      _updateFilter(() {
        _startDate = DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
        );
        _endDate = DateTime(range.end.year, range.end.month, range.end.day);
      });
    }
  }

  Future<void> _delete(
    BuildContext context,
    FinanceTransaction transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar movimiento'),
        content: const Text(
          'El movimiento se eliminará definitivamente. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(transactionRepositoryProvider).delete(transaction.id);
      if (context.mounted) _notify(context, 'Movimiento eliminado.');
    } catch (_) {
      if (context.mounted) {
        _notify(context, 'No se pudo eliminar el movimiento.');
      }
    }
  }

  Future<void> _duplicate(
    BuildContext context,
    FinanceTransaction transaction,
  ) async {
    try {
      final id = await ref
          .read(transactionRepositoryProvider)
          .duplicate(transaction.id);
      if (context.mounted) {
        _notify(
          context,
          id == null
              ? 'No encontramos el movimiento.'
              : 'Movimiento duplicado con la fecha de hoy.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _notify(context, 'No se pudo duplicar el movimiento.');
      }
    }
  }

  void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);
    final methods = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('transactionNew'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo movimiento'),
      ),
      body: transactions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _TransactionsError(
          onRetry: () => ref.invalidate(transactionsProvider),
        ),
        data: (items) => categories.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _TransactionsError(
            onRetry: () => ref.invalidate(categoriesProvider),
          ),
          data: (categoryItems) => methods.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _TransactionsError(
              onRetry: () => ref.invalidate(paymentMethodsProvider),
            ),
            data: (methodItems) => _history(items, categoryItems, methodItems),
          ),
        ),
      ),
    );
  }

  Widget _history(
    List<FinanceTransaction> items,
    List<Category> categories,
    List<PaymentMethod> methods,
  ) {
    final names = {
      for (final category in categories) category.id: category.name,
    };
    final filtered = _filter.apply(items, categoryNames: names);
    final shown = filtered.take(_visibleCount).toList(growable: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            children: [
              TextField(
                controller: _search,
                onChanged: (_) => _updateFilter(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Buscar movimientos',
                  hintText: 'Nota o categoría',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Limpiar búsqueda',
                          onPressed: () {
                            _search.clear();
                            _updateFilter(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _TypeFilter(
                    value: _type,
                    onChanged: (value) => _updateFilter(() => _type = value),
                  ),
                  SizedBox(
                    width: 190,
                    child: DropdownButtonFormField<int?>(
                      key: ValueKey(_categoryId),
                      initialValue: _categoryId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Todas las categorías'),
                        ),
                        ...categories.map(
                          (category) => DropdownMenuItem<int?>(
                            value: category.id,
                            child: Text(
                              category.isActive
                                  ? category.name
                                  : '${category.name} (archivada)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          _updateFilter(() => _categoryId = value),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _chooseRange,
                    icon: const Icon(Icons.date_range),
                    label: Text(_rangeLabel),
                  ),
                  SizedBox(
                    width: 190,
                    child: DropdownButtonFormField<TransactionSortOrder>(
                      initialValue: _sortOrder,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Ordenar por',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: TransactionSortOrder.newest,
                          child: Text('Más recientes'),
                        ),
                        DropdownMenuItem(
                          value: TransactionSortOrder.oldest,
                          child: Text('Más antiguos'),
                        ),
                        DropdownMenuItem(
                          value: TransactionSortOrder.amountHighToLow,
                          child: Text('Mayor importe'),
                        ),
                        DropdownMenuItem(
                          value: TransactionSortOrder.amountLowToHigh,
                          child: Text('Menor importe'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateFilter(() => _sortOrder = value);
                        }
                      },
                    ),
                  ),
                  if (_filter.hasCriteria)
                    TextButton.icon(
                      onPressed: () {
                        _search.clear();
                        _updateFilter(() {
                          _type = null;
                          _categoryId = null;
                          _startDate = null;
                          _endDate = null;
                        });
                      },
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('Limpiar filtros'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  filtered.isEmpty
                      ? 'Sin resultados'
                      : '${filtered.length} ${filtered.length == 1 ? 'resultado' : 'resultados'}',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const _TransactionsEmpty(filtered: true)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 104),
                  itemCount:
                      shown.length + (shown.length < filtered.length ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == shown.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                setState(() => _visibleCount += _pageSize),
                            icon: const Icon(Icons.expand_more),
                            label: Text(
                              'Cargar más (${filtered.length - shown.length})',
                            ),
                          ),
                        ),
                      );
                    }
                    final item = shown[index];
                    final category = _firstWhereOrNull(
                      categories,
                      (entry) => entry.id == item.categoryId,
                    );
                    final method = _firstWhereOrNull(
                      methods,
                      (entry) => entry.id == item.paymentMethodId,
                    );
                    return _TransactionCard(
                      transaction: item,
                      categoryName: category?.name ?? 'Categoría archivada',
                      paymentMethodName: method?.name ?? 'Método archivado',
                      onTap: () => context.pushNamed(
                        'transactionDetail',
                        pathParameters: {'id': item.id.toString()},
                      ),
                      onEdit: () => context.pushNamed(
                        'transactionEdit',
                        pathParameters: {'id': item.id.toString()},
                      ),
                      onDuplicate: () => _duplicate(context, item),
                      onDelete: () => _delete(context, item),
                      onManageSeries: () => context.goNamed('recurringEntries'),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String get _rangeLabel {
    if (_startDate == null || _endDate == null) return 'Todas las fechas';
    return '${_dateLabel(_startDate!)} – ${_dateLabel(_endDate!)}';
  }
}

class _TypeFilter extends StatelessWidget {
  const _TypeFilter({required this.value, required this.onChanged});
  final TransactionType? value;
  final ValueChanged<TransactionType?> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<TransactionType?>(
    segments: const [
      ButtonSegment<TransactionType?>(value: null, label: Text('Todos')),
      ButtonSegment(value: TransactionType.expense, label: Text('Gastos')),
      ButtonSegment(value: TransactionType.income, label: Text('Ingresos')),
    ],
    selected: {value},
    showSelectedIcon: false,
    onSelectionChanged: (values) => onChanged(values.first),
  );
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.transaction,
    required this.categoryName,
    required this.paymentMethodName,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onManageSeries,
  });

  final FinanceTransaction transaction;
  final String categoryName;
  final String paymentMethodName;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onManageSeries;

  @override
  Widget build(BuildContext context) {
    final income = transaction.type == TransactionType.income;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: (income ? colorScheme.primary : colorScheme.error)
              .withValues(alpha: 0.12),
          child: Icon(
            income ? Icons.south_west : Icons.north_east,
            color: income ? colorScheme.primary : colorScheme.error,
          ),
        ),
        title: Text(
          transaction.description?.isNotEmpty == true
              ? transaction.description ?? categoryName
              : categoryName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '$categoryName · $paymentMethodName · ${_dateLabel(transaction.date)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${income ? '+' : '−'}${MoneyFormatter.formatDopMinorUnits(transaction.amountInCents)}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: income ? colorScheme.primary : colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            PopupMenuButton<String>(
              tooltip:
                  'Acciones para ${transaction.description ?? categoryName}',
              onSelected: (action) {
                switch (action) {
                  case 'series':
                    onManageSeries();
                  case 'edit':
                    onEdit();
                  case 'duplicate':
                    onDuplicate();
                  case 'delete':
                    onDelete();
                }
              },
              itemBuilder: (context) => transaction.fixedEntryId != null
                  ? const [
                      PopupMenuItem(
                        value: 'series',
                        child: ListTile(
                          leading: Icon(Icons.repeat),
                          title: Text('Administrar series'),
                        ),
                      ),
                    ]
                  : const [
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Editar'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        child: ListTile(
                          leading: Icon(Icons.copy_outlined),
                          title: Text('Duplicar'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Eliminar'),
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

class _TransactionsEmpty extends StatelessWidget {
  const _TransactionsEmpty({this.filtered = false});
  final bool filtered;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            filtered ? Icons.search_off : Icons.receipt_long_outlined,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            filtered
                ? 'No hay movimientos con estos filtros.'
                : 'Todavía no hay movimientos.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            filtered
                ? 'Prueba con otras palabras, fechas o categorías.'
                : 'Registra un ingreso o un gasto para comenzar tu historial.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _TransactionsError extends StatelessWidget {
  const _TransactionsError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar los movimientos.'),
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

String _dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T) test) {
  for (final value in values) {
    if (test(value)) return value;
  }
  return null;
}
