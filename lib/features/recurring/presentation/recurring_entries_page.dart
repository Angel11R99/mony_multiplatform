import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/recurring_entry.dart';
import 'recurring_providers.dart';

class RecurringEntriesPage extends ConsumerWidget {
  const RecurringEntriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(recurringEntriesProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos recurrentes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nueva serie'),
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('No se pudieron cargar las series.')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('Aún no hay movimientos recurrentes.'))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final category = categories
                      .where((c) => c.id == item.categoryId)
                      .firstOrNull;
                  return Card(
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
                          if (action == 'edit') _edit(context, ref, item);
                          if (action == 'pause' || action == 'resume') {
                            await ref
                                .read(recurringRepositoryProvider)
                                .setActive(item.id, action == 'resume');
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Editar serie'),
                          ),
                          PopupMenuItem(
                            value: item.isActive ? 'pause' : 'resume',
                            child: Text(item.isActive ? 'Pausar' : 'Reanudar'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
