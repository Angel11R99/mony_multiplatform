import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/money/money_formatter.dart';
import '../../../core/widgets/mony_settings_action.dart';
import '../../../core/widgets/mony_states.dart';
import '../../../core/widgets/dialog_helpers.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../domain/obligation.dart';
import '../domain/obligation_repository.dart';
import '../domain/obligation_validator.dart';
import 'obligations_providers.dart';

class ObligationsPage extends ConsumerStatefulWidget {
  const ObligationsPage({super.key});

  @override
  ConsumerState<ObligationsPage> createState() => _ObligationsPageState();
}

class _ObligationsPageState extends ConsumerState<ObligationsPage> {
  var _filter = 0;
  _DueDateFilter _dueDateFilter = _DueDateFilter.all;
  DateTimeRange? _customDueRange;

  Future<void> _chooseDueRange() async {
    final today = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year + 5),
      initialDateRange: _customDueRange,
      helpText: 'Filtrar vencimientos',
      saveText: 'Aplicar',
    );
    if (range != null && mounted) {
      setState(() {
        _dueDateFilter = _DueDateFilter.custom;
        _customDueRange = range;
      });
    }
  }

  bool _matchesDueDate(DateTime date) {
    final today = DateTime.now();
    final day = DateTime(date.year, date.month, date.day);
    return switch (_dueDateFilter) {
      _DueDateFilter.all => true,
      _DueDateFilter.week =>
        !day.isBefore(DateTime(today.year, today.month, today.day)) &&
            !day.isAfter(DateTime(today.year, today.month, today.day + 6)),
      _DueDateFilter.month =>
        date.year == today.year && date.month == today.month,
      _DueDateFilter.custom =>
        _customDueRange != null &&
            !day.isBefore(_customDueRange!.start) &&
            !day.isAfter(_customDueRange!.end),
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(obligationsProvider);
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final methods =
        ref.watch(activePaymentMethodsProvider).value ??
        const <PaymentMethod>[];
    final currencyStyle =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        AppPreferences.defaults.currencyFormatStyle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios'),
        actions: const [MonySettingsAction()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => editObligation(context, ref, categories, methods),
        icon: const Icon(Icons.add),
        label: const Text('Nueva obligación'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ObligationError(
          onRetry: () => ref.invalidate(obligationsProvider),
        ),
        data: (all) {
          final today = DateTime.now();
          final filtered = all
              .where((obligation) {
                final status = obligation.statusAt(today);
                final matchesStatus = switch (_filter) {
                  0 =>
                    status != ObligationStatus.settled &&
                        status != ObligationStatus.cancelled,
                  1 =>
                    obligation.direction == ObligationDirection.payable &&
                        status != ObligationStatus.settled &&
                        status != ObligationStatus.cancelled,
                  2 =>
                    obligation.direction == ObligationDirection.receivable &&
                        status != ObligationStatus.settled &&
                        status != ObligationStatus.cancelled,
                  _ =>
                    status == ObligationStatus.settled ||
                        status == ObligationStatus.cancelled,
                };
                final dueDate = obligation.dueDate;
                return matchesStatus &&
                    (dueDate == null
                        ? _dueDateFilter == _DueDateFilter.all
                        : _matchesDueDate(dueDate));
              })
              .toList(growable: false);
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth > 850
                  ? 850.0
                  : constraints.maxWidth;
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Row(
                          children: [
                            _filterChip('Activas', 0),
                            _filterChip('Por pagar', 1),
                            _filterChip('Por cobrar', 2),
                            _filterChip('Historial', 3),
                            PopupMenuButton<_DueDateFilter>(
                              tooltip: 'Filtrar por vencimiento',
                              initialValue: _dueDateFilter,
                              onSelected: (value) {
                                if (value == _DueDateFilter.custom) {
                                  _chooseDueRange();
                                } else {
                                  setState(() => _dueDateFilter = value);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: _DueDateFilter.all,
                                  child: Text('Todas las fechas'),
                                ),
                                PopupMenuItem(
                                  value: _DueDateFilter.week,
                                  child: Text('Próximos 7 días'),
                                ),
                                PopupMenuItem(
                                  value: _DueDateFilter.month,
                                  child: Text('Este mes'),
                                ),
                                PopupMenuItem(
                                  value: _DueDateFilter.custom,
                                  child: Text('Rango personalizado…'),
                                ),
                              ],
                              child: Chip(
                                avatar: const Icon(
                                  Icons.event_outlined,
                                  size: 18,
                                ),
                                label: Text(switch (_dueDateFilter) {
                                  _DueDateFilter.all => 'Todas las fechas',
                                  _DueDateFilter.week => 'Próximos 7 días',
                                  _DueDateFilter.month => 'Este mes',
                                  _DueDateFilter.custom =>
                                    _customDueRange == null
                                        ? 'Rango personalizado'
                                        : '${_formatDueDate(_customDueRange!.start)} – ${_formatDueDate(_customDueRange!.end)}',
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: filtered.isEmpty
                            ? _ObligationsEmpty(filter: _filter)
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  100,
                                ),
                                itemCount: filtered.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final obligation = filtered[index];
                                  return MonyEntrance(
                                    delay: Duration(milliseconds: 30 * index),
                                    child: _ObligationCard(
                                      obligation: obligation,
                                      currencyStyle: currencyStyle,
                                      onTap: () => context.pushNamed(
                                        'obligationDetail',
                                        pathParameters: {
                                          'id': '${obligation.id}',
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _filterChip(String label, int index) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: _filter == index,
      onSelected: (_) => setState(() => _filter = index),
    ),
  );
}

enum _DueDateFilter { all, week, month, custom }

String _formatDueDate(DateTime date) => MonyDateFormatter.formatDate(date);

class _ObligationCard extends StatelessWidget {
  const _ObligationCard({
    required this.obligation,
    required this.currencyStyle,
    required this.onTap,
  });

  final Obligation obligation;
  final CurrencyFormatStyle currencyStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = obligation.statusAt(DateTime.now());
    final overdue = status == ObligationStatus.overdue;
    final amount = MoneyFormatter.formatDopMinorUnits(
      obligation.remainingAmountInCents,
      style: currencyStyle,
    );
    final total = MoneyFormatter.formatDopMinorUnits(
      obligation.amountInCents,
      style: currencyStyle,
    );
    final due = obligation.dueDate;
    final paid = obligation.amountInCents - obligation.remainingAmountInCents;
    final progress = paid / obligation.amountInCents;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    obligation.direction == ObligationDirection.payable
                        ? Icons.south_west
                        : Icons.north_east,
                    color: obligation.direction == ObligationDirection.payable
                        ? scheme.error
                        : scheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      obligation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ObligationStatusBadge(status: status),
                ],
              ),
              if (obligation.counterparty?.isNotEmpty ?? false) ...[
                const SizedBox(height: 4),
                Text(obligation.counterparty!),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    obligation.direction == ObligationDirection.payable
                        ? 'Saldo por pagar'
                        : 'Saldo por cobrar',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    amount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: overdue ? scheme.error : null,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: progress.clamp(0, 1).toDouble()),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Text('De $total')),
                  Text(
                    due == null ? 'Sin vencimiento' : _dateLabel(due),
                    style: TextStyle(color: overdue ? scheme.error : null),
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

class ObligationStatusBadge extends StatelessWidget {
  const ObligationStatusBadge({required this.status, super.key});
  final ObligationStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = switch (status) {
      ObligationStatus.pending => colors.secondary,
      ObligationStatus.partiallyPaid => colors.primary,
      ObligationStatus.overdue => colors.error,
      ObligationStatus.settled => colors.tertiary,
      ObligationStatus.cancelled => colors.outline,
    };
    final label = switch (status) {
      ObligationStatus.pending => 'Pendiente',
      ObligationStatus.partiallyPaid => 'Parcial',
      ObligationStatus.overdue => 'Vencida',
      ObligationStatus.settled => 'Liquidada',
      ObligationStatus.cancelled => 'Cancelada',
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ObligationsEmpty extends StatelessWidget {
  const _ObligationsEmpty({required this.filter});
  final int filter;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_available_outlined, size: 52),
          const SizedBox(height: 12),
          Text(
            filter == 3 ? 'Aún no hay historial' : 'Todo al día',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          const Text(
            'Registra cuentas que debes pagar o dinero que esperas recibir.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _ObligationError extends StatelessWidget {
  const _ObligationError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar tus pendientes.'),
        const SizedBox(height: 8),
        FilledButton.tonal(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    ),
  );
}

Future<void> editObligation(
  BuildContext context,
  WidgetRef ref,
  List<Category> allCategories,
  List<PaymentMethod> methods, {
  Obligation? existing,
}) async {
  final name = TextEditingController(text: existing?.title ?? '');
  final counterparty = TextEditingController(
    text: existing?.counterparty ?? '',
  );
  final amount = TextEditingController(
    text: existing == null
        ? ''
        : MoneyFormatter.toDopInput(existing.amountInCents),
  );
  final notes = TextEditingController(text: existing?.notes ?? '');
  var direction = existing?.direction ?? ObligationDirection.payable;
  final activeCategories = allCategories
      .where((category) {
        return category.isActive &&
            category.type ==
                (direction == ObligationDirection.payable
                    ? CategoryType.expense
                    : CategoryType.income);
      })
      .toList(growable: false);
  var categoryId = existing?.categoryId ?? activeCategories.firstOrNull?.id;
  var methodId = existing?.defaultPaymentMethodId;
  var dueDate = existing?.dueDate;
  String? error;
  int? createdId;
  final saved = await showDialogAndWaitForDismissal<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(
          existing == null ? 'Nueva obligación' : 'Editar obligación',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (existing == null)
                SegmentedButton<ObligationDirection>(
                  segments: const [
                    ButtonSegment(
                      value: ObligationDirection.payable,
                      label: Text('Por pagar'),
                    ),
                    ButtonSegment(
                      value: ObligationDirection.receivable,
                      label: Text('Por cobrar'),
                    ),
                  ],
                  selected: {direction},
                  onSelectionChanged: (selection) {
                    setDialogState(() {
                      direction = selection.first;
                      final nextCategories = allCategories.where((category) {
                        return category.isActive &&
                            category.type ==
                                (direction == ObligationDirection.payable
                                    ? CategoryType.expense
                                    : CategoryType.income);
                      });
                      categoryId = nextCategories.firstOrNull?.id;
                    });
                  },
                ),
              TextField(
                controller: name,
                maxLength: 120,
                readOnly: existing?.sourceShoppingListId != null,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: counterparty,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Persona o entidad',
                ),
              ),
              TextField(
                controller: amount,
                readOnly: existing?.sourceShoppingListId != null,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Monto total',
                  prefixText: 'RD\$ ',
                ),
              ),
              DropdownButtonFormField<int>(
                key: ValueKey(direction),
                initialValue: categoryId,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: [
                  for (final category in allCategories.where(
                    (item) =>
                        item.isActive &&
                        item.type ==
                            (direction == ObligationDirection.payable
                                ? CategoryType.expense
                                : CategoryType.income),
                  ))
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                ],
                onChanged: (value) => categoryId = value,
              ),
              DropdownButtonFormField<int>(
                initialValue: methodId,
                decoration: const InputDecoration(
                  labelText: 'Método habitual (opcional)',
                ),
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('Elegir al registrar cada abono'),
                  ),
                  for (final method in methods)
                    DropdownMenuItem(
                      value: method.id,
                      child: Text(method.name),
                    ),
                ],
                onChanged: (value) => methodId = value,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Vencimiento'),
                subtitle: Text(
                  dueDate == null ? 'Sin fecha' : _dateLabel(dueDate!),
                ),
                trailing: IconButton(
                  tooltip: 'Elegir fecha de vencimiento',
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) {
                      setDialogState(() => dueDate = picked);
                    }
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              TextField(
                controller: notes,
                maxLength: 500,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
              if (error != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final parsedAmount = MoneyFormatter.parseDopMinorUnits(
                amount.text,
              );
              final titleError = ObligationValidator.validateTitle(name.text);
              final amountError = parsedAmount == null
                  ? 'Escribe un monto válido.'
                  : ObligationValidator.validateAmount(parsedAmount);
              if (titleError != null ||
                  amountError != null ||
                  categoryId == null) {
                setDialogState(
                  () => error =
                      titleError ??
                      amountError ??
                      'Selecciona una categoría activa.',
                );
                return;
              }
              final now = DateTime.now();
              final obligation = existing == null
                  ? Obligation(
                      direction: direction,
                      title: name.text,
                      counterparty: counterparty.text,
                      amountInCents: parsedAmount!,
                      dueDate: dueDate,
                      categoryId: categoryId!,
                      defaultPaymentMethodId: methodId,
                      notes: notes.text,
                      createdAt: now,
                      updatedAt: now,
                    )
                  : existing.copyWith(
                      title: name.text,
                      counterparty: counterparty.text,
                      clearCounterparty: counterparty.text.trim().isEmpty,
                      amountInCents: parsedAmount!,
                      dueDate: dueDate,
                      clearDueDate: dueDate == null,
                      categoryId: categoryId!,
                      defaultPaymentMethodId: methodId,
                      clearDefaultPaymentMethod: methodId == null,
                      notes: notes.text,
                      clearNotes: notes.text.trim().isEmpty,
                      updatedAt: now,
                    );
              try {
                final repo = ref.read(obligationRepositoryProvider);
                if (existing == null) {
                  createdId = await repo.create(obligation);
                } else {
                  await repo.update(obligation);
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } on ObligationException catch (exception) {
                if (dialogContext.mounted) {
                  setDialogState(() => error = exception.message);
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    ),
  );
  name.dispose();
  counterparty.dispose();
  amount.dispose();
  notes.dispose();
  if (saved == true && createdId != null && context.mounted) {
    context.pushNamed('obligationDetail', pathParameters: {'id': '$createdId'});
  }
}

String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);
