import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_settings_action.dart';
import '../../../core/widgets/mony_layout.dart';
import '../../../core/widgets/mony_states.dart';
import '../../../core/theme/mony_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/recurring_entry.dart';
import 'recurring_providers.dart';

class RecurringEntriesPage extends ConsumerStatefulWidget {
  const RecurringEntriesPage({super.key});

  @override
  ConsumerState<RecurringEntriesPage> createState() =>
      _RecurringEntriesPageState();
}

class _ScheduleMetric extends StatelessWidget {
  const _ScheduleMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(MonyRadius.medium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: colors.primary),
          const SizedBox(width: 7),
          Text('$value $label', style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _RecurringEntriesPageState extends ConsumerState<RecurringEntriesPage> {
  TransactionType? _type;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final entries = ref.watch(recurringEntriesProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fijos'),
        actions: [
          IconButton(
            tooltip: 'Nueva serie',
            onPressed: () => _edit(context, ref),
            icon: const Icon(Icons.add),
          ),
          const MonySettingsAction(),
        ],
      ),
      floatingActionButton: entries.hasValue && entries.requireValue.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _edit(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Nueva serie'),
            ),
      body: entries.when(
        loading: () =>
            const LoadingPlaceholder(message: 'Cargando movimientos fijos'),
        error: (error, stack) => ErrorState(
          message: 'No se pudieron cargar los movimientos fijos.',
          retryLabel: 'Reintentar',
          onRetry: () => ref.invalidate(recurringEntriesProvider),
        ),
        data: (items) {
          final visible = _type == null
              ? items
              : items.where((item) => item.type == _type).toList();
          final expenses = items
              .where((item) => item.type == TransactionType.expense)
              .length;
          final incomes = items
              .where((item) => item.type == TransactionType.income)
              .length;
          final activeCount = items.where((item) => item.isActive).length;
          return LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth > 820
                  ? 820.0
                  : constraints.maxWidth;
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: maxWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: MonyCard(
                          padding: const EdgeInsets.all(MonySpace.x4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pagos que se repiten',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: MonySpace.x1),
                              Text(
                                'Ten a la vista tus ingresos fijos y los próximos cargos.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: MonySpace.x3),
                              Wrap(
                                spacing: MonySpace.x2,
                                runSpacing: MonySpace.x2,
                                children: [
                                  _ScheduleMetric(
                                    label: 'Activas',
                                    value: '$activeCount',
                                    icon: Icons.autorenew,
                                  ),
                                  _ScheduleMetric(
                                    label: 'Ingresos',
                                    value: '$incomes',
                                    icon: Icons.south_west,
                                  ),
                                  _ScheduleMetric(
                                    label: 'Gastos',
                                    value: '$expenses',
                                    icon: Icons.north_east,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            ChoiceChip(
                              label: Text('Todos (${items.length})'),
                              selected: _type == null,
                              onSelected: (_) => setState(() => _type = null),
                            ),
                            ChoiceChip(
                              label: Text('Gastos ($expenses)'),
                              selected: _type == TransactionType.expense,
                              onSelected: (_) => setState(
                                () => _type = TransactionType.expense,
                              ),
                            ),
                            ChoiceChip(
                              label: Text('Ingresos ($incomes)'),
                              selected: _type == TransactionType.income,
                              onSelected: (_) => setState(
                                () => _type = TransactionType.income,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: visible.isEmpty
                            ? ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                children: [
                                  const SizedBox(height: 20),
                                  EmptyState(
                                    icon: items.isEmpty
                                        ? Icons.event_repeat_outlined
                                        : Icons.filter_alt_off_outlined,
                                    title: items.isEmpty
                                        ? 'Ordena tus cargos recurrentes'
                                        : _type == TransactionType.income
                                        ? 'No hay ingresos fijos'
                                        : 'No hay gastos fijos',
                                    message: items.isEmpty
                                        ? 'Programa servicios, suscripciones o ingresos para tener presente cuándo se repiten.'
                                        : 'Prueba otra categoría o crea una nueva serie para este tipo.',
                                  ),
                                  if (items.isEmpty)
                                    Center(
                                      child: FilledButton.icon(
                                        onPressed: () => _edit(context, ref),
                                        icon: const Icon(Icons.add),
                                        label: const Text(
                                          'Crear primera serie',
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  104,
                                ),
                                itemCount: visible.length,
                                itemBuilder: (context, index) {
                                  final item = visible[index];
                                  final category = categories
                                      .where((c) => c.id == item.categoryId)
                                      .firstOrNull;
                                  return MonyEntrance(
                                    delay: Duration(milliseconds: 30 * index),
                                    child: Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: Icon(
                                            item.type == TransactionType.income
                                                ? Icons.south_west
                                                : Icons.north_east,
                                          ),
                                        ),
                                        title: Text(item.title),
                                        subtitle: Text(
                                          '${MoneyFormatter.formatDopMinorUnits(item.amountInCents)} · ${category?.name ?? 'Categoría'}\n${_frequencyLabel(item)}${item.isActive ? ' · Próximo: ${_date(item.nextDate)}' : ' · En pausa'}',
                                        ),
                                        isThreeLine: true,
                                        onTap: () => _edit(context, ref, item),
                                        trailing: PopupMenuButton<String>(
                                          onSelected: (action) async {
                                            if (action == 'edit') {
                                              _edit(context, ref, item);
                                            }
                                            if (action == 'register') {
                                              await _registerOccurrence(
                                                context,
                                                ref,
                                                item,
                                              );
                                            }
                                            if (action == 'pause' ||
                                                action == 'resume') {
                                              await ref
                                                  .read(
                                                    recurringRepositoryProvider,
                                                  )
                                                  .setActive(
                                                    item.id,
                                                    action == 'resume',
                                                  );
                                            }
                                          },
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(
                                              value: 'register',
                                              child: Text(
                                                'Registrar movimiento',
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Editar serie'),
                                            ),
                                            PopupMenuItem(
                                              value: item.isActive
                                                  ? 'pause'
                                                  : 'resume',
                                              child: Text(
                                                item.isActive
                                                    ? 'Pausar'
                                                    : 'Reanudar',
                                              ),
                                            ),
                                          ],
                                        ),
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

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    RecurringEntry? existing,
  ]) async {
    final categories =
        (ref.read(categoriesProvider).value ?? const <Category>[])
            .where((category) => category.isActive)
            .toList(growable: false);
    final methods = ref.read(activePaymentMethodsProvider).value ?? const [];
    if (categories.isEmpty || methods.isEmpty) {
      MonyFeedback.info(
        context,
        'Agrega una categoría y un método de pago primero.',
      );
      return;
    }
    final result = await showDialog<RecurringEntry>(
      context: context,
      builder: (_) => _RecurringForm(
        entry: existing,
        categories: categories,
        methods: methods,
      ),
    );
    if (result == null) return;
    final repo = ref.read(recurringRepositoryProvider);
    try {
      if (existing == null) {
        await repo.create(result);
      } else {
        await repo.update(result);
      }
    } catch (_) {
      if (context.mounted) {
        MonyFeedback.info(
          context,
          existing == null
              ? 'No se pudo guardar la serie.'
              : 'No se pudo actualizar la serie.',
        );
      }
    }
  }

  Future<void> _registerOccurrence(
    BuildContext context,
    WidgetRef ref,
    RecurringEntry entry,
  ) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstDate = DateUtils.dateOnly(entry.startDate);
    final lastDate =
        entry.endDate != null &&
            entry.endDate!.isBefore(today) &&
            !entry.endDate!.isBefore(firstDate)
        ? DateUtils.dateOnly(entry.endDate!)
        : (today.isBefore(firstDate) ? firstDate : today);
    final suggestedDate = DateUtils.dateOnly(entry.nextDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: suggestedDate.isBefore(firstDate)
          ? firstDate
          : (suggestedDate.isAfter(lastDate) ? lastDate : suggestedDate),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Fecha del movimiento',
    );
    if (picked == null || !context.mounted) return;
    try {
      final created = await ref
          .read(recurringRepositoryProvider)
          .registerOccurrence(entry.id, picked);
      if (context.mounted) {
        MonyFeedback.info(
          context,
          created
              ? 'Movimiento fijo registrado.'
              : 'Ya existe un movimiento de esta serie para esa fecha.',
        );
      }
    } catch (error) {
      if (context.mounted) MonyFeedback.error(context, error.toString());
    }
  }
}

class _RecurringForm extends StatefulWidget {
  const _RecurringForm({
    this.entry,
    required this.categories,
    required this.methods,
  });
  final RecurringEntry? entry;
  final List<Category> categories;
  final List<PaymentMethod> methods;
  @override
  State<_RecurringForm> createState() => _RecurringFormState();
}

class _RecurringFormState extends State<_RecurringForm> {
  final form = GlobalKey<FormState>();
  late final title = TextEditingController(text: widget.entry?.title ?? '');
  late final amount = TextEditingController(
    text: widget.entry == null
        ? ''
        : MoneyFormatter.toDopInput(widget.entry!.amountInCents),
  );
  late TransactionType type = widget.entry?.type ?? TransactionType.expense;
  late RecurrenceFrequency frequency =
      widget.entry?.frequency ?? RecurrenceFrequency.monthly;
  late DateTime start = widget.entry?.startDate ?? DateTime.now();
  late DateTime? end = widget.entry?.endDate;
  late int? category = widget.entry?.categoryId ?? widget.categories.first.id;
  late int? method = widget.entry?.paymentMethodId ?? widget.methods.first.id;
  late int interval = widget.entry?.interval ?? 1;

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.entry == null ? 'Nueva serie recurrente' : 'Editar serie',
    ),
    content: SizedBox(
      width: 420,
      child: Form(
        key: form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Escribe una descripción.'
                    : null,
              ),
              TextFormField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Monto (RD\$)'),
                validator: (v) =>
                    (MoneyFormatter.parseDopMinorUnits(v ?? '') ?? 0) <= 0
                    ? 'Escribe un monto válido.'
                    : null,
              ),
              DropdownButtonFormField<TransactionType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: TransactionType.values
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(
                          v == TransactionType.income ? 'Ingreso' : 'Gasto',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  type = v!;
                  category = null;
                }),
              ),
              DropdownButtonFormField<int>(
                initialValue:
                    widget.categories.any(
                      (c) => c.id == category && c.type.name == type.name,
                    )
                    ? category
                    : null,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: widget.categories
                    .where((c) => c.type.name == type.name)
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => category = v),
              ),
              DropdownButtonFormField<int>(
                initialValue: method,
                decoration: const InputDecoration(labelText: 'Método de pago'),
                items: widget.methods
                    .map(
                      (m) => DropdownMenuItem<int>(
                        value: m.id,
                        child: Text(m.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => method = v),
              ),
              DropdownButtonFormField<RecurrenceFrequency>(
                initialValue: frequency,
                decoration: const InputDecoration(labelText: 'Repetición'),
                items: RecurrenceFrequency.values
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(_frequency(v)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => frequency = v!),
              ),
              TextFormField(
                initialValue: '$interval',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cada cuántos periodos',
                ),
                onChanged: (v) => interval = int.tryParse(v) ?? 0,
                validator: (v) => (int.tryParse(v ?? '') ?? 0) < 1
                    ? 'Debe ser al menos 1.'
                    : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha de inicio'),
                subtitle: Text(_date(start)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: start,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) setState(() => start = d);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tiene fecha final'),
                value: end != null,
                onChanged: (v) async {
                  if (!v) {
                    setState(() => end = null);
                  } else {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: end ?? start,
                      firstDate: start,
                      lastDate: DateTime(2100),
                    );
                    if (d != null) setState(() => end = d);
                  }
                },
              ),
              if (end != null) Text('Finaliza: ${_date(end!)}'),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (!(form.currentState?.validate() ?? false) ||
              category == null ||
              method == null) {
            return;
          }
          final next = widget.entry == null || start != widget.entry!.startDate
              ? start
              : widget.entry!.nextDate;
          Navigator.pop(
            context,
            RecurringEntry(
              id: widget.entry?.id ?? 0,
              title: title.text.trim(),
              amountInCents: MoneyFormatter.parseDopMinorUnits(amount.text)!,
              type: type,
              categoryId: category!,
              paymentMethodId: method!,
              frequency: frequency,
              interval: interval,
              startDate: start,
              nextDate: next,
              endDate: end,
              isActive: widget.entry?.isActive ?? true,
            ),
          );
        },
        child: const Text('Guardar'),
      ),
    ],
  );
}

String _date(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
String _frequency(RecurrenceFrequency f) => switch (f) {
  RecurrenceFrequency.daily => 'Diaria',
  RecurrenceFrequency.weekly => 'Semanal',
  RecurrenceFrequency.monthly => 'Mensual',
  RecurrenceFrequency.yearly => 'Anual',
};

String _frequencyLabel(RecurringEntry entry) =>
    'Cada ${entry.interval} ${switch (entry.frequency) {
      RecurrenceFrequency.daily => entry.interval == 1 ? 'día' : 'días',
      RecurrenceFrequency.weekly => entry.interval == 1 ? 'semana' : 'semanas',
      RecurrenceFrequency.monthly => entry.interval == 1 ? 'mes' : 'meses',
      RecurrenceFrequency.yearly => entry.interval == 1 ? 'año' : 'años',
    }}';
