import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';
import 'package:stream_transform/stream_transform.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import '../../../core/widgets/mony_settings_action.dart';
import '../../../core/widgets/mony_states.dart';
import '../../../core/theme/sumi_visuals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../domain/transaction.dart';
import '../domain/transaction_history_filter.dart';
import '../domain/transaction_repository.dart';
import '../../budgets/domain/budget.dart';
import '../../budgets/presentation/budgets_providers.dart';
import 'transactions_providers.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  static const _pageSize = 20;
  final _search = TextEditingController();
  final _minimumAmount = TextEditingController();
  final _maximumAmount = TextEditingController();
  final _queryChanges = StreamController<String>();
  StreamSubscription<String>? _querySubscription;
  String _appliedQuery = '';
  TransactionType? _type;
  Set<int> _categoryIds = {};
  Set<int> _paymentMethodIds = {};
  int? _minimumAmountInCents;
  int? _maximumAmountInCents;
  DateTime? _startDate;
  DateTime? _endDate;
  DateRange? _cycleRange;
  String _cycleFilterId = 'all';
  String _cycleFilterLabel = 'Todos los ciclos';
  TransactionSortOrder _sortOrder = TransactionSortOrder.newest;
  int _visibleCount = _pageSize;

  @override
  void initState() {
    super.initState();
    _querySubscription = _queryChanges.stream
        .debounce(const Duration(milliseconds: 300))
        .listen((value) {
          if (!mounted) return;
          setState(() {
            _appliedQuery = value;
            _visibleCount = _pageSize;
          });
        });
  }

  @override
  void dispose() {
    _querySubscription?.cancel();
    _queryChanges.close();
    _search.dispose();
    _minimumAmount.dispose();
    _maximumAmount.dispose();
    super.dispose();
  }

  void _updateFilter(VoidCallback update) => setState(() {
    update();
    _visibleCount = _pageSize;
  });

  DateTime? get _effectiveStartDate =>
      _cycleRange == null ||
          (_startDate != null && !_startDate!.isBefore(_cycleRange!.start))
      ? _startDate
      : _cycleRange!.start;

  DateTime? get _effectiveEndDate =>
      _cycleRange == null ||
          (_endDate != null && !_endDate!.isAfter(_cycleRange!.endInclusive))
      ? _endDate
      : _cycleRange!.endInclusive;

  TransactionHistoryFilter get _filter => TransactionHistoryFilter(
    query: _appliedQuery,
    type: _type,
    categoryIds: _categoryIds,
    paymentMethodIds: _paymentMethodIds,
    minimumAmountInCents: _minimumAmountInCents,
    maximumAmountInCents: _maximumAmountInCents,
    startDate: _effectiveStartDate,
    endDate: _effectiveEndDate,
    sortOrder: _sortOrder,
  );

  int get _activeFilterCount =>
      (_appliedQuery.trim().isNotEmpty ? 1 : 0) +
      (_type != null ? 1 : 0) +
      (_categoryIds.isNotEmpty ? 1 : 0) +
      (_paymentMethodIds.isNotEmpty ? 1 : 0) +
      (_minimumAmountInCents != null || _maximumAmountInCents != null ? 1 : 0) +
      (_startDate != null || _endDate != null ? 1 : 0) +
      (_cycleRange != null ? 1 : 0);

  void _clearFilters() {
    _search.clear();
    _queryChanges.add('');
    _minimumAmount.clear();
    _maximumAmount.clear();
    _appliedQuery = '';
    _updateFilter(() {
      _type = null;
      _categoryIds = {};
      _paymentMethodIds = {};
      _minimumAmountInCents = null;
      _maximumAmountInCents = null;
      _startDate = null;
      _endDate = null;
      _cycleRange = null;
      _cycleFilterId = 'all';
      _cycleFilterLabel = 'Todos los ciclos';
      _sortOrder = TransactionSortOrder.newest;
    });
  }

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

  Future<void> _openActivityCalendar() async {
    final initialDate = _startDate ?? DateTime.now();
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.78,
        child: _TransactionActivityCalendar(initialDate: initialDate),
      ),
    );
    if (selected != null && mounted) {
      _updateFilter(() {
        _startDate = DateTime(selected.year, selected.month, selected.day);
        _endDate = _startDate;
      });
    }
  }

  Future<Set<int>?> _selectIds({
    required String title,
    required List<(int, String)> values,
    required Set<int> selected,
  }) => showDialog<Set<int>>(
    context: context,
    builder: (context) {
      final draft = {...selected};
      var query = '';
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 360,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: TextField(
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: 'Buscar opciones',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (value) => setDialogState(() => query = value),
                  ),
                ),
                for (final (id, name) in values.where(
                  (value) => value.$2.toLowerCase().contains(
                    query.trim().toLowerCase(),
                  ),
                ))
                  CheckboxListTile(
                    value: draft.contains(id),
                    title: Text(name),
                    onChanged: (checked) => setDialogState(() {
                      if (checked == true) {
                        draft.add(id);
                      } else {
                        draft.remove(id);
                      }
                    }),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, <int>{}),
              child: const Text('Quitar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, draft),
              child: const Text('Aplicar'),
            ),
          ],
        ),
      );
    },
  );

  void _applyAmountRange() {
    final minimumText = _minimumAmount.text.trim();
    final maximumText = _maximumAmount.text.trim();
    final minimum = minimumText.isEmpty
        ? null
        : MoneyFormatter.parseDopMinorUnits(minimumText);
    final maximum = maximumText.isEmpty
        ? null
        : MoneyFormatter.parseDopMinorUnits(maximumText);
    if ((minimumText.isNotEmpty && (minimum == null || minimum < 0)) ||
        (maximumText.isNotEmpty && (maximum == null || maximum < 0))) {
      MonyFeedback.error(context, 'Indica importes válidos y no negativos.');
      return;
    }
    if (minimum != null && maximum != null && minimum > maximum) {
      MonyFeedback.error(
        context,
        'El importe mínimo no puede superar el máximo.',
      );
      return;
    }
    _updateFilter(() {
      _minimumAmountInCents = minimum;
      _maximumAmountInCents = maximum;
    });
  }

  Future<void> _openAdvancedFilters(
    List<Category> categories,
    List<PaymentMethod> methods,
  ) async {
    final budget = ref.read(budgetConfigProvider).value;
    final cycles =
        ref.read(budgetHistoryProvider).value ?? const <BudgetCycle>[];
    final cycleOptions = <(String, String)>[
      ('all', 'Todos los ciclos'),
      ('current', 'Ciclo actual'),
      ('previous', 'Ciclo anterior'),
      for (final cycle in cycles)
        (
          'history-${cycle.id}',
          '${_dateLabel(cycle.startDate)} – ${_dateLabel(cycle.endDate)}',
        ),
    ];
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.94,
        builder: (context, scrollController) => _AdvancedTransactionFilters(
          scrollController: scrollController,
          categoryLabel: _categoryIds.isEmpty
              ? 'Categorías'
              : 'Categorías (${_categoryIds.length})',
          methodLabel: _paymentMethodIds.isEmpty
              ? 'Métodos de pago'
              : 'Métodos (${_paymentMethodIds.length})',
          dateLabel: _rangeLabel,
          cycleSelection: _cycleFilterId,
          cycleOptions: cycleOptions,
          onCycleChanged: (selection) =>
              _selectCycle(selection, budget, cycles),
          hasFilters:
              _filter.hasCriteria || _sortOrder != TransactionSortOrder.newest,
          minimumAmount: _minimumAmount,
          maximumAmount: _maximumAmount,
          sortOrder: _sortOrder,
          onCategories: () async {
            final selected = await _selectIds(
              title: 'Categorías',
              values: categories.map((item) => (item.id, item.name)).toList(),
              selected: _categoryIds,
            );
            if (selected != null && mounted) {
              _updateFilter(() => _categoryIds = selected);
            }
          },
          onMethods: () async {
            final selected = await _selectIds(
              title: 'Métodos de pago',
              values: methods.map((item) => (item.id, item.name)).toList(),
              selected: _paymentMethodIds,
            );
            if (selected != null && mounted) {
              _updateFilter(() => _paymentMethodIds = selected);
            }
          },
          onDatePreset: _applyDatePreset,
          onApplyAmount: _applyAmountRange,
          onSort: (value) => _updateFilter(() => _sortOrder = value),
          onClear: _clearFilters,
        ),
      ),
    );
  }

  void _applyDatePreset(_DateRangePreset preset) {
    if (preset == _DateRangePreset.custom) {
      _chooseRange();
      return;
    }
    final today = DateTime.now();
    final end = DateTime(today.year, today.month, today.day);
    final start = switch (preset) {
      _DateRangePreset.today => end,
      _DateRangePreset.week => _startOfLocaleWeek(end),
      _DateRangePreset.month => DateTime(end.year, end.month),
      _DateRangePreset.year => DateTime(end.year),
      _DateRangePreset.custom => end,
    };
    _updateFilter(() {
      _startDate = start;
      _endDate = end;
    });
  }

  void _selectCycle(
    String selection,
    BudgetConfig? budget,
    List<BudgetCycle> cycles,
  ) {
    if (selection == 'all') {
      _updateFilter(() {
        _cycleFilterId = selection;
        _cycleFilterLabel = 'Todos los ciclos';
        _cycleRange = null;
      });
      return;
    }
    final now = DateTime.now();
    final current = activeBudgetPeriod(budget, now);
    DateRange? range;
    String label;
    if (selection == 'current') {
      range = current;
      label =
          'Ciclo actual · ${_dateLabel(range.start)}–${_dateLabel(range.endInclusive)}';
    } else if (selection == 'previous') {
      if (cycles.isNotEmpty) {
        final previous = cycles.first;
        range = DateRange(
          start: previous.startDate,
          endInclusive: previous.endDate,
        );
      } else {
        range = activeBudgetPeriod(
          budget,
          current.start.subtract(const Duration(days: 1)),
        );
      }
      label =
          'Ciclo anterior · ${_dateLabel(range.start)}–${_dateLabel(range.endInclusive)}';
    } else {
      final id = int.tryParse(selection.replaceFirst('history-', ''));
      final cycle = cycles.where((item) => item.id == id).firstOrNull;
      if (cycle == null) return;
      range = DateRange(start: cycle.startDate, endInclusive: cycle.endDate);
      label = '${_dateLabel(range.start)}–${_dateLabel(range.endInclusive)}';
    }
    _updateFilter(() {
      _cycleFilterId = selection;
      _cycleRange = range;
      _cycleFilterLabel = label;
    });
  }

  DateTime _startOfLocaleWeek(DateTime date) {
    final sundayBasedIndex = MaterialLocalizations.of(
      context,
    ).firstDayOfWeekIndex;
    final firstWeekday = sundayBasedIndex == 0
        ? DateTime.sunday
        : sundayBasedIndex;
    final offset =
        (date.weekday - firstWeekday + DateTime.daysPerWeek) %
        DateTime.daysPerWeek;
    return DateTime(date.year, date.month, date.day - offset);
  }

  Future<void> _delete(
    BuildContext context,
    FinanceTransaction transaction,
  ) async {
    final description = transaction.description?.trim();
    final confirmed = await MonyConfirmDialog.show(
      context,
      title: 'Eliminar movimiento',
      message:
          '“${description == null || description.isEmpty ? 'Movimiento' : description}” se eliminará definitivamente. Esta acción no se puede deshacer.',
      confirmLabel: 'Eliminar',
      destructive: true,
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(transactionRepositoryProvider).delete(transaction.id);
      if (context.mounted) _notify(context, 'Movimiento eliminado.');
    } on InvalidTransactionException catch (error) {
      if (context.mounted) MonyFeedback.error(context, error.message);
    } catch (_) {
      if (context.mounted) {
        MonyFeedback.error(context, 'No se pudo eliminar el movimiento.');
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
    } on InvalidTransactionException catch (error) {
      if (context.mounted) MonyFeedback.error(context, error.message);
    } catch (_) {
      if (context.mounted) {
        MonyFeedback.error(context, 'No se pudo duplicar el movimiento.');
      }
    }
  }

  void _notify(BuildContext context, String message) {
    MonyFeedback.info(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(filteredTransactionsProvider(_filter));
    final categories = ref.watch(categoriesProvider);
    final methods = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          IconButton(
            tooltip: 'Calendario de actividad',
            onPressed: _openActivityCalendar,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          const MonySettingsAction(),
        ],
      ),
      floatingActionButton:
          (transactions.hasValue && transactions.requireValue.isNotEmpty)
          ? FloatingActionButton.extended(
              onPressed: () => context.pushNamed('transactionNew'),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo movimiento'),
            )
          : null,
      body: transactions.when(
        loading: () =>
            const LoadingPlaceholder(message: 'Cargando movimientos'),
        error: (error, stack) => _TransactionsError(
          onRetry: () => ref.invalidate(filteredTransactionsProvider(_filter)),
        ),
        data: (items) => categories.when(
          loading: () =>
              const LoadingPlaceholder(message: 'Cargando categorías'),
          error: (error, stack) => _TransactionsError(
            onRetry: () => ref.invalidate(categoriesProvider),
          ),
          data: (categoryItems) => methods.when(
            loading: () =>
                const LoadingPlaceholder(message: 'Cargando métodos de pago'),
            error: (error, stack) => _TransactionsError(
              onRetry: () => ref.invalidate(paymentMethodsProvider),
            ),
            data: (methodItems) => MonyEntrance(
              child: _history(items, categoryItems, methodItems),
            ),
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
    final filtered = items;
    final shown = filtered.take(_visibleCount).toList(growable: false);
    final groupByDate =
        _sortOrder == TransactionSortOrder.newest ||
        _sortOrder == TransactionSortOrder.oldest;
    final entries = <_HistoryEntry>[];
    DateTime? previousDate;
    for (final item in shown) {
      final date = DateTime(item.date.year, item.date.month, item.date.day);
      if (groupByDate && !DateUtils.isSameDay(previousDate, date)) {
        entries.add(_HistoryDateHeader(date));
      }
      previousDate = date;
      final category = _firstWhereOrNull(
        categories,
        (entry) => entry.id == item.categoryId,
      );
      final method = _firstWhereOrNull(
        methods,
        (entry) => entry.id == item.paymentMethodId,
      );
      entries.add(
        _HistoryMovement(
          transaction: item,
          categoryName: category?.name ?? 'Categoría archivada',
          paymentMethodName: method?.name ?? 'Método archivado',
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            children: [
              TextField(
                controller: _search,
                onChanged: (value) => _queryChanges.add(value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Buscar movimientos',
                  hintText: 'Descripción, categoría o método',
                  filled: SumiThemeColors.maybeOf(context) == null
                      ? null
                      : false,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Limpiar búsqueda',
                          onPressed: () {
                            _search.clear();
                            _queryChanges.add('');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 900;
                  final typeFilter = _TypeFilter(
                    value: _type,
                    onChanged: (value) => _updateFilter(() => _type = value),
                  );
                  final filterButton = OutlinedButton.icon(
                    onPressed: () => _openAdvancedFilters(categories, methods),
                    icon: const Icon(Icons.tune),
                    label: Text(
                      _activeFilterCount == 0
                          ? 'Filtros'
                          : 'Filtros ($_activeFilterCount)',
                    ),
                  );
                  final sorting = DropdownButtonFormField<TransactionSortOrder>(
                    initialValue: _sortOrder,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Ordenar',
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
                      DropdownMenuItem(
                        value: TransactionSortOrder.categoryAscending,
                        child: Text('Categoría A–Z'),
                      ),
                      DropdownMenuItem(
                        value: TransactionSortOrder.categoryDescending,
                        child: Text('Categoría Z–A'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _updateFilter(() => _sortOrder = value);
                      }
                    },
                  );
                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(width: double.infinity, child: typeFilter),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            filterButton,
                            const SizedBox(width: 8),
                            Expanded(child: sorting),
                          ],
                        ),
                        if (_filter.hasCriteria ||
                            _search.text.isNotEmpty ||
                            _sortOrder != TransactionSortOrder.newest)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _clearFilters,
                              icon: const Icon(Icons.filter_alt_off),
                              label: const Text('Limpiar filtros'),
                            ),
                          ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      typeFilter,
                      const SizedBox(width: 12),
                      filterButton,
                      const SizedBox(width: 12),
                      SizedBox(width: 190, child: sorting),
                      const Spacer(),
                      if (_filter.hasCriteria ||
                          _search.text.isNotEmpty ||
                          _sortOrder != TransactionSortOrder.newest)
                        TextButton.icon(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.filter_alt_off),
                          label: const Text('Limpiar'),
                        ),
                    ],
                  );
                },
              ),
              if (_filter.hasCriteria)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 6,
                    children: [
                      if (_appliedQuery.isNotEmpty)
                        InputChip(
                          label: Text('Texto: $_appliedQuery'),
                          onDeleted: () {
                            _search.clear();
                            _appliedQuery = '';
                            _updateFilter(() {});
                          },
                        ),
                      if (_type != null)
                        InputChip(
                          label: Text(
                            _type == TransactionType.income
                                ? 'Ingresos'
                                : 'Gastos',
                          ),
                          onDeleted: () => _updateFilter(() => _type = null),
                        ),
                      if (_categoryIds.isNotEmpty)
                        InputChip(
                          label: Text('Categorías: ${_categoryIds.length}'),
                          onDeleted: () =>
                              _updateFilter(() => _categoryIds = {}),
                        ),
                      if (_paymentMethodIds.isNotEmpty)
                        InputChip(
                          label: Text('Métodos: ${_paymentMethodIds.length}'),
                          onDeleted: () =>
                              _updateFilter(() => _paymentMethodIds = {}),
                        ),
                      if (_minimumAmountInCents != null ||
                          _maximumAmountInCents != null)
                        InputChip(
                          label: Text(
                            'Importe: ${_minimumAmountInCents == null ? '0' : MoneyFormatter.toDopInput(_minimumAmountInCents!)}–${_maximumAmountInCents == null ? '∞' : MoneyFormatter.toDopInput(_maximumAmountInCents!)}',
                          ),
                          onDeleted: () {
                            _minimumAmount.clear();
                            _maximumAmount.clear();
                            _updateFilter(() {
                              _minimumAmountInCents = null;
                              _maximumAmountInCents = null;
                            });
                          },
                        ),
                      if (_startDate != null || _endDate != null)
                        InputChip(
                          label: Text(_rangeLabel),
                          onDeleted: () => _updateFilter(() {
                            _startDate = null;
                            _endDate = null;
                          }),
                        ),
                      if (_cycleRange != null)
                        InputChip(
                          label: Text(_cycleFilterLabel),
                          onDeleted: () => _selectCycle(
                            'all',
                            ref.read(budgetConfigProvider).value,
                            ref.read(budgetHistoryProvider).value ?? const [],
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 14,
                  runSpacing: 4,
                  children: [
                    Text(
                      '${filtered.length} ${filtered.length == 1 ? 'movimiento' : 'movimientos'}',
                    ),
                    Text(
                      'Ingresos ${MoneyFormatter.formatDopMinorUnits(filtered.where((item) => item.type == TransactionType.income).fold<int>(0, (total, item) => total + item.amountInCents))}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Gastos ${MoneyFormatter.formatDopMinorUnits(filtered.where((item) => item.type == TransactionType.expense).fold<int>(0, (total, item) => total + item.amountInCents))}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? _TransactionsEmpty(
                  filtered: _filter.hasCriteria,
                  onClear: _filter.hasCriteria ? _clearFilters : null,
                )
              : SlidableAutoCloseBehavior(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 104),
                    itemCount:
                        entries.length +
                        (shown.length < filtered.length ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == entries.length) {
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
                      return switch (entries[index]) {
                        _HistoryDateHeader(:final date) => _DateHeading(
                          key: ValueKey(
                            'date-${date.year}-${date.month}-${date.day}',
                          ),
                          date: date,
                        ),
                        _HistoryMovement(
                          :final transaction,
                          :final categoryName,
                          :final paymentMethodName,
                        ) =>
                          _TransactionCard(
                            key: ValueKey('transaction-${transaction.id}'),
                            transaction: transaction,
                            categoryName: categoryName,
                            paymentMethodName: paymentMethodName,
                            onTap: () => context.pushNamed(
                              'transactionDetail',
                              pathParameters: {'id': transaction.id.toString()},
                            ),
                            onEdit: () => context.pushNamed(
                              'transactionEdit',
                              pathParameters: {'id': transaction.id.toString()},
                            ),
                            onDuplicate: () => _duplicate(context, transaction),
                            onDelete: () => _delete(context, transaction),
                            onManageSeries: () =>
                                context.goNamed('recurringEntries'),
                          ),
                      };
                    },
                  ),
                ),
        ),
      ],
    );
  }

  String get _rangeLabel {
    if (_startDate == null && _endDate == null) return 'Todas las fechas';
    if (_startDate == null) return 'Hasta ${_dateLabel(_endDate!)}';
    if (_endDate == null) return 'Desde ${_dateLabel(_startDate!)}';
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

String _sortLabel(TransactionSortOrder value) => switch (value) {
  TransactionSortOrder.newest => 'Más recientes',
  TransactionSortOrder.oldest => 'Más antiguos',
  TransactionSortOrder.amountHighToLow => 'Mayor importe',
  TransactionSortOrder.amountLowToHigh => 'Menor importe',
  TransactionSortOrder.categoryAscending => 'Categoría (A–Z)',
  TransactionSortOrder.categoryDescending => 'Categoría (Z–A)',
};

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({required this.value, required this.onChanged});
  final TransactionSortOrder value;
  final ValueChanged<TransactionSortOrder> onChanged;

  @override
  Widget build(BuildContext context) =>
      DropdownButtonFormField<TransactionSortOrder>(
        initialValue: value,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Ordenar por',
          isDense: true,
        ),
        items: TransactionSortOrder.values
            .map(
              (item) =>
                  DropdownMenuItem(value: item, child: Text(_sortLabel(item))),
            )
            .toList(),
        onChanged: (item) {
          if (item != null) onChanged(item);
        },
      );
}

class _AdvancedTransactionFilters extends StatelessWidget {
  const _AdvancedTransactionFilters({
    required this.scrollController,
    required this.categoryLabel,
    required this.methodLabel,
    required this.dateLabel,
    required this.cycleSelection,
    required this.cycleOptions,
    required this.onCycleChanged,
    required this.hasFilters,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.sortOrder,
    required this.onCategories,
    required this.onMethods,
    required this.onDatePreset,
    required this.onApplyAmount,
    required this.onSort,
    required this.onClear,
  });
  final ScrollController scrollController;
  final String categoryLabel, methodLabel, dateLabel;
  final String cycleSelection;
  final List<(String, String)> cycleOptions;
  final bool hasFilters;
  final TextEditingController minimumAmount, maximumAmount;
  final TransactionSortOrder sortOrder;
  final VoidCallback onCategories, onMethods, onApplyAmount, onClear;
  final ValueChanged<String> onCycleChanged;
  final ValueChanged<_DateRangePreset> onDatePreset;
  final ValueChanged<TransactionSortOrder> onSort;

  @override
  Widget build(BuildContext context) => ListView(
    controller: scrollController,
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
    children: [
      Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      const SizedBox(height: 18),
      Text('Filtros avanzados', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton.icon(
            onPressed: onCategories,
            icon: const Icon(Icons.category_outlined),
            label: Text(categoryLabel),
          ),
          OutlinedButton.icon(
            onPressed: onMethods,
            icon: const Icon(Icons.payments_outlined),
            label: Text(methodLabel),
          ),
        ],
      ),
      const SizedBox(height: 18),
      Text('Rango de importe', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: minimumAmount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Mínimo RD\$',
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: maximumAmount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Máximo RD\$',
                isDense: true,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: FilledButton.tonal(
          onPressed: onApplyAmount,
          child: const Text('Aplicar importe'),
        ),
      ),
      const SizedBox(height: 14),
      Text('Período', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        initialValue: cycleSelection,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Ciclo financiero',
          isDense: true,
        ),
        items: [
          for (final (value, label) in cycleOptions)
            DropdownMenuItem(value: value, child: Text(label)),
        ],
        onChanged: (value) {
          if (value != null) onCycleChanged(value);
        },
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: [
          for (final entry in const [
            (_DateRangePreset.today, 'Hoy'),
            (_DateRangePreset.week, 'Esta semana'),
            (_DateRangePreset.month, 'Este mes'),
            (_DateRangePreset.year, 'Este año'),
            (_DateRangePreset.custom, 'Personalizado'),
          ])
            ActionChip(
              label: Text(entry.$2),
              onPressed: () => onDatePreset(entry.$1),
            ),
        ],
      ),
      Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 14),
      _SortDropdown(value: sortOrder, onChanged: onSort),
      if (hasFilters) ...[
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.filter_alt_off),
            label: const Text('Limpiar filtros'),
          ),
        ),
      ],
    ],
  );
}

enum _DateRangePreset { today, week, month, year, custom }

class _TransactionActivityCalendar extends ConsumerStatefulWidget {
  const _TransactionActivityCalendar({required this.initialDate});

  final DateTime initialDate;

  @override
  ConsumerState<_TransactionActivityCalendar> createState() =>
      _TransactionActivityCalendarState();
}

class _TransactionActivityCalendarState
    extends ConsumerState<_TransactionActivityCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    return transactions.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No pudimos cargar la actividad.'),
            TextButton(
              onPressed: () => ref.invalidate(transactionsProvider),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      data: _buildCalendar,
    );
  }

  Widget _buildCalendar(List<FinanceTransaction> transactions) {
    final eventsByDay = <int, List<FinanceTransaction>>{};
    for (final transaction in transactions) {
      eventsByDay
          .putIfAbsent(dateToEpochDay(transaction.date), () => [])
          .add(transaction);
    }
    final dayTransactions =
        eventsByDay[dateToEpochDay(_selectedDay)] ?? const [];
    final firstDayOfWeekIndex = MaterialLocalizations.of(
      context,
    ).firstDayOfWeekIndex;
    final startingDay = StartingDayOfWeek
        .values[(firstDayOfWeekIndex + 6) % StartingDayOfWeek.values.length];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        children: [
          Text(
            'Actividad financiera',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TableCalendar<FinanceTransaction>(
              locale: Localizations.localeOf(context).toString(),
              firstDay: DateTime(1900),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              startingDayOfWeek: startingDay,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: {
                CalendarFormat.month:
                    Localizations.localeOf(context).languageCode == 'en'
                    ? 'Month'
                    : 'Mes',
              },
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              selectedDayPredicate: (day) =>
                  DateUtils.isSameDay(day, _selectedDay),
              eventLoader: (day) =>
                  eventsByDay[dateToEpochDay(day)] ?? const [],
              onDaySelected: (selectedDay, focusedDay) => setState(() {
                _selectedDay = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                );
                _focusedDay = DateTime(
                  focusedDay.year,
                  focusedDay.month,
                  focusedDay.day,
                );
              }),
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                markersMaxCount: 3,
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              dayTransactions.isEmpty
                  ? 'Sin movimientos para ${_dateLabel(_selectedDay)}'
                  : '${dayTransactions.length} ${dayTransactions.length == 1 ? 'movimiento' : 'movimientos'} para ${_dateLabel(_selectedDay)}',
              semanticsLabel: dayTransactions.isEmpty
                  ? 'Sin movimientos para ${_dateLabel(_selectedDay)}'
                  : '${dayTransactions.length} ${dayTransactions.length == 1 ? 'movimiento' : 'movimientos'} para ${_dateLabel(_selectedDay)}',
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(_selectedDay),
              icon: const Icon(Icons.filter_alt),
              label: const Text('Ver este día'),
            ),
          ),
        ],
      ),
    );
  }
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
    super.key,
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
    return Slidable(
      key: ValueKey('slidable-${transaction.id}'),
      endActionPane: transaction.fixedEntryId == null
          ? ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.78,
              children: [
                SlidableAction(
                  onPressed: (_) => onEdit(),
                  icon: Icons.edit_outlined,
                  label: 'Editar',
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                SlidableAction(
                  onPressed: (_) => onDuplicate(),
                  icon: Icons.copy_outlined,
                  label: 'Duplicar',
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                ),
                SlidableAction(
                  onPressed: (_) => onDelete(),
                  icon: Icons.delete_outline,
                  label: 'Eliminar',
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
              ],
            )
          : null,
      child: Card(
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
      ),
    );
  }
}

sealed class _HistoryEntry {
  const _HistoryEntry();
}

class _HistoryDateHeader extends _HistoryEntry {
  const _HistoryDateHeader(this.date);
  final DateTime date;
}

class _HistoryMovement extends _HistoryEntry {
  const _HistoryMovement({
    required this.transaction,
    required this.categoryName,
    required this.paymentMethodName,
  });

  final FinanceTransaction transaction;
  final String categoryName;
  final String paymentMethodName;
}

class _DateHeading extends StatelessWidget {
  const _DateHeading({required this.date, super.key});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final label = DateUtils.isSameDay(date, today)
        ? 'Hoy'
        : DateUtils.isSameDay(date, yesterday)
        ? 'Ayer'
        : _dateLabel(date);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _TransactionsEmpty extends StatelessWidget {
  const _TransactionsEmpty({this.filtered = false, this.onClear});
  final bool filtered;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    filtered ? Icons.search_off : Icons.receipt_long_outlined,
                    size: 32,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  filtered
                      ? 'No hay movimientos con estos filtros.'
                      : 'Todavía no hay movimientos.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  filtered
                      ? 'Prueba con otras palabras, fechas o categorías.'
                      : 'Registra un ingreso o un gasto para comenzar tu historial.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                if (filtered && onClear != null)
                  OutlinedButton.icon(
                    onPressed: onClear,
                    icon: const Icon(Icons.filter_alt_off),
                    label: const Text('Limpiar filtros'),
                  )
                else if (!filtered)
                  FilledButton.icon(
                    onPressed: () => context.pushNamed('transactionNew'),
                    icon: const Icon(Icons.add),
                    label: const Text('Nuevo movimiento'),
                  ),
              ],
            ),
          ),
        ),
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

String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);

T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T) test) {
  for (final value in values) {
    if (test(value)) return value;
  }
  return null;
}
