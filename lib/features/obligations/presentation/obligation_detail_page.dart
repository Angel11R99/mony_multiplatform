import 'package:flutter/material.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
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
import 'obligations_page.dart';
import 'obligations_providers.dart';

class ObligationDetailPage extends ConsumerWidget {
  const ObligationDetailPage({required this.obligationId, super.key});
  final int obligationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(obligationDetailsProvider(obligationId));
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final methods =
        ref.watch(activePaymentMethodsProvider).value ??
        const <PaymentMethod>[];
    final currencyStyle =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        AppPreferences.defaults.currencyFormatStyle;
    return state.when(
      loading: () => const Scaffold(
        appBar: _ObligationAppBar(),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const Scaffold(
        appBar: _ObligationAppBar(),
        body: Center(child: Text('No pudimos cargar esta obligación.')),
      ),
      data: (details) {
        if (details == null) {
          return const Scaffold(
            appBar: _ObligationAppBar(),
            body: Center(child: Text('Esta obligación ya no existe.')),
          );
        }
        return _ObligationDetailsContent(
          details: details,
          categories: categories,
          methods: methods,
          currencyStyle: currencyStyle,
        );
      },
    );
  }
}

class _ObligationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ObligationAppBar();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) => AppBar(title: const Text('Obligación'));
}

class _ObligationDetailsContent extends ConsumerWidget {
  const _ObligationDetailsContent({
    required this.details,
    required this.categories,
    required this.methods,
    required this.currencyStyle,
  });

  final ObligationDetails details;
  final List<Category> categories;
  final List<PaymentMethod> methods;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obligation = details.obligation;
    final categoriesById = {
      for (final category in categories) category.id: category,
    };
    final methodsById = {for (final method in methods) method.id: method};
    final status = obligation.statusAt(DateTime.now());
    final canPay =
        !obligation.isCancelled && obligation.remainingAmountInCents > 0;
    final categoryName =
        categoriesById[obligation.categoryId]?.name ?? 'Categoría archivada';
    final defaultMethod = methodsById[obligation.defaultPaymentMethodId];
    final colors = Theme.of(context).colorScheme;
    final paid = obligation.paidAmountInCents;
    final progress = (paid / obligation.amountInCents)
        .clamp(0.0, 1.0)
        .toDouble();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          obligation.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (!obligation.isCancelled)
            IconButton(
              tooltip: 'Editar obligación',
              onPressed: () => editObligation(
                context,
                ref,
                categories,
                methods,
                existing: obligation,
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width > 850
              ? 850
              : MediaQuery.sizeOf(context).width,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                sliver: SliverList.list(
                  children: [
                    Card.filled(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    obligation.direction ==
                                            ObligationDirection.payable
                                        ? 'Saldo por pagar'
                                        : 'Saldo por cobrar',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                ObligationStatusBadge(status: status),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _money(obligation.remainingAmountInCents),
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 14),
                            LinearProgressIndicator(value: progress),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Abonado: ${_money(paid)}'),
                                Text(
                                  'Total: ${_money(obligation.amountInCents)}',
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _InfoLine(
                              label:
                                  obligation.direction ==
                                      ObligationDirection.payable
                                  ? 'A quién debes'
                                  : 'Quién te debe',
                              value:
                                  obligation.counterparty ?? 'Sin especificar',
                            ),
                            _InfoLine(label: 'Categoría', value: categoryName),
                            _InfoLine(
                              label: 'Vencimiento',
                              value: obligation.dueDate == null
                                  ? 'Sin fecha'
                                  : _dateLabel(obligation.dueDate!),
                              valueColor: status == ObligationStatus.overdue
                                  ? colors.error
                                  : null,
                            ),
                            if (defaultMethod != null)
                              _InfoLine(
                                label: 'Método habitual',
                                value: defaultMethod.name,
                              ),
                            if (obligation.notes?.isNotEmpty ?? false)
                              _InfoLine(
                                label: 'Notas',
                                value: obligation.notes!,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (obligation.sourceShoppingListId != null) ...[
                      const SizedBox(height: 10),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.shopping_cart_outlined),
                          title: const Text(
                            'Compra registrada desde una lista',
                          ),
                          subtitle: const Text(
                            'El total y la descripción se sincronizan con la lista de compras.',
                          ),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: () => context.pushNamed(
                            'shoppingListDetail',
                            pathParameters: {
                              'id': '${obligation.sourceShoppingListId}',
                            },
                          ),
                        ),
                      ),
                    ],
                    if (canPay) ...[
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: () => _recordPayment(
                          context,
                          ref,
                          obligation,
                          methods,
                          currencyStyle,
                          settle: true,
                        ),
                        icon: const Icon(Icons.task_alt),
                        label: const Text('Liquidar saldo'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _recordPayment(
                          context,
                          ref,
                          obligation,
                          methods,
                          currencyStyle,
                        ),
                        icon: const Icon(Icons.add_card_outlined),
                        label: const Text('Registrar abono'),
                      ),
                    ],
                    if (obligation.sourceShoppingListId == null &&
                        details.payments.isEmpty &&
                        !obligation.isCancelled) ...[
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: () =>
                            _cancelObligation(context, ref, obligation),
                        icon: const Icon(Icons.block_outlined),
                        label: const Text('Cancelar obligación'),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'Abonos y movimientos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (details.payments.isEmpty)
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.receipt_long_outlined),
                          title: Text('Sin abonos todavía'),
                          subtitle: Text(
                            'Cada abono registrado aparecerá aquí y en tus movimientos.',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (details.payments.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverList.builder(
                    itemCount: details.payments.length,
                    itemBuilder: (context, index) {
                      final payment = details.payments[index];
                      return _PaymentTile(
                        payment: payment,
                        methodName:
                            methodsById[payment.paymentMethodId]?.name ??
                            'Método archivado',
                        currencyStyle: currencyStyle,
                        onDelete: () => _deletePayment(context, ref, payment),
                        onOpenMovement: payment.transactionId == null
                            ? null
                            : () => context.pushNamed(
                                'transactionDetail',
                                pathParameters: {
                                  'id': '${payment.transactionId}',
                                },
                              ),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.payment,
    required this.methodName,
    required this.currencyStyle,
    required this.onDelete,
    required this.onOpenMovement,
  });

  final ObligationPayment payment;
  final String methodName;
  final CurrencyFormatStyle currencyStyle;
  final VoidCallback onDelete;
  final VoidCallback? onOpenMovement;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.payments_outlined)),
        title: Text(_money(payment.amountInCents, currencyStyle)),
        subtitle: Text(
          '${_dateLabel(payment.date)} · $methodName${payment.note?.isNotEmpty == true ? '\n${payment.note}' : ''}',
        ),
        isThreeLine: payment.note?.isNotEmpty == true,
        onTap: onOpenMovement,
        trailing: PopupMenuButton<String>(
          tooltip: 'Opciones del abono',
          onSelected: (value) {
            if (value == 'movement') onOpenMovement?.call();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            if (onOpenMovement != null)
              const PopupMenuItem(
                value: 'movement',
                child: Text('Ver movimiento'),
              ),
            const PopupMenuItem(value: 'delete', child: Text('Eliminar abono')),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 132,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _recordPayment(
  BuildContext context,
  WidgetRef ref,
  Obligation obligation,
  List<PaymentMethod> methods,
  CurrencyFormatStyle currencyStyle, {
  bool settle = false,
}) async {
  if (methods.isEmpty) {
    MonyFeedback.info(context, 'Agrega un método de pago activo primero.');
    return;
  }
  final amount = TextEditingController(
    text: MoneyFormatter.toDopInput(
      settle ? obligation.remainingAmountInCents : 0,
    ),
  );
  final note = TextEditingController();
  var date = DateTime.now();
  var methodId =
      methods.any((method) => method.id == obligation.defaultPaymentMethodId)
      ? obligation.defaultPaymentMethodId!
      : methods.first.id;
  String? error;
  await showDialogAndWaitForDismissal<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(settle ? 'Liquidar saldo' : 'Registrar abono'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pendiente: ${_money(obligation.remainingAmountInCents, currencyStyle)}',
            ),
            TextField(
              controller: amount,
              autofocus: !settle,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monto del abono',
                prefixText: 'RD\$ ',
              ),
            ),
            DropdownButtonFormField<int>(
              initialValue: methodId,
              decoration: const InputDecoration(labelText: 'Método de pago'),
              items: [
                for (final method in methods)
                  DropdownMenuItem(value: method.id, child: Text(method.name)),
              ],
              onChanged: (value) {
                if (value != null) methodId = value;
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha del abono'),
              subtitle: Text(_dateLabel(date)),
              trailing: IconButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) setDialogState(() => date = picked);
                },
                icon: const Icon(Icons.calendar_today_outlined),
              ),
            ),
            TextField(
              controller: note,
              maxLength: 120,
              decoration: const InputDecoration(labelText: 'Nota (opcional)'),
            ),
            if (error != null)
              Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final amountInCents = MoneyFormatter.parseDopMinorUnits(
                amount.text,
              );
              if (amountInCents == null) {
                setDialogState(() => error = 'Escribe un monto válido.');
                return;
              }
              final validation = ObligationValidator.validatePayment(
                amountInCents: amountInCents,
                remainingInCents: obligation.remainingAmountInCents,
              );
              if (validation != null) {
                setDialogState(() => error = validation);
                return;
              }
              try {
                await ref
                    .read(obligationRepositoryProvider)
                    .recordPayment(
                      obligationId: obligation.id,
                      amountInCents: amountInCents,
                      date: date,
                      paymentMethodId: methodId,
                      note: note.text,
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } on ObligationException catch (exception) {
                if (dialogContext.mounted) {
                  setDialogState(() => error = exception.message);
                }
              }
            },
            child: Text(settle ? 'Confirmar liquidación' : 'Guardar abono'),
          ),
        ],
      ),
    ),
  );
  amount.dispose();
  note.dispose();
}

Future<void> _deletePayment(
  BuildContext context,
  WidgetRef ref,
  ObligationPayment payment,
) async {
  final confirmed = await MonyConfirmDialog.show(
    context,
    title: 'Eliminar abono',
    message: 'También se eliminará el movimiento que se creó para este abono.',
    confirmLabel: 'Eliminar',
    destructive: true,
  );
  if (confirmed != true) return;
  try {
    await ref.read(obligationRepositoryProvider).deletePayment(payment.id);
  } on ObligationException catch (exception) {
    if (context.mounted) {
      MonyFeedback.error(context, exception.message);
    }
  }
}

Future<void> _cancelObligation(
  BuildContext context,
  WidgetRef ref,
  Obligation obligation,
) async {
  final confirmed = await MonyConfirmDialog.show(
    context,
    title: 'Cancelar obligación',
    message: 'Se conservará en el historial y ya no aceptará abonos.',
    confirmLabel: 'Cancelar obligación',
    cancelLabel: 'Volver',
    destructive: true,
  );
  if (confirmed != true) return;
  try {
    await ref.read(obligationRepositoryProvider).cancel(obligation.id);
  } on ObligationException catch (exception) {
    if (context.mounted) {
      MonyFeedback.error(context, exception.message);
    }
  }
}

String _money(
  int amount, [
  CurrencyFormatStyle style = CurrencyFormatStyle.symbol,
]) => MoneyFormatter.formatDopMinorUnits(amount, style: style);
String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);
