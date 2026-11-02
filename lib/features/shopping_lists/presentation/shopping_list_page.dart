import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dialog_helpers.dart';
import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../domain/shopping_list.dart';
import '../domain/shopping_list_repository.dart';
import '../domain/shopping_list_validator.dart';
import 'shopping_lists_providers.dart';

class ShoppingListPage extends ConsumerWidget {
  const ShoppingListPage({required this.listId, super.key});
  final int listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingListDetailsProvider(listId));
    final style =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        AppPreferences.defaults.currencyFormatStyle;
    return state.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: const Text('Lista')),
        body: const Center(child: Text('No pudimos cargar esta lista.')),
      ),
      data: (details) {
        if (details == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lista')),
            body: const Center(child: Text('Esta lista ya no existe.')),
          );
        }
        return _ShoppingListContent(details: details, currencyStyle: style);
      },
    );
  }
}

class _ShoppingListContent extends ConsumerWidget {
  const _ShoppingListContent({
    required this.details,
    required this.currencyStyle,
  });
  final ShoppingListDetails details;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = details.list;
    final completed = list.status == ShoppingListStatus.completed;
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final category = categories
        .where((item) => item.id == list.expenseCategoryId)
        .firstOrNull;
    final methods =
        ref.watch(activePaymentMethodsProvider).value ??
        const <PaymentMethod>[];
    final method = methods
        .where((item) => item.id == list.paymentMethodId)
        .firstOrNull;
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width > 860 ? 860.0 : width;
    return Scaffold(
      appBar: AppBar(
        title: Text(list.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (!completed)
            IconButton(
              tooltip: 'Escanear producto',
              onPressed: () => context.pushNamed(
                'barcodeScan',
                queryParameters: {'listId': list.id.toString()},
              ),
              icon: const Icon(Icons.qr_code_scanner),
            ),
          if (!completed)
            IconButton(
              tooltip: 'Editar lista',
              onPressed: () => _editList(context, ref, details),
              icon: const Icon(Icons.edit_outlined),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'duplicate') _duplicate(context, ref, list.id);
              if (value == 'reopen') _reopen(context, ref, list.id);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Text('Duplicar lista'),
              ),
              if (completed)
                const PopupMenuItem(
                  value: 'reopen',
                  child: Text('Reabrir compra'),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: completed
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _editItem(context, ref, list.id, currencyStyle),
              icon: const Icon(Icons.add),
              label: const Text('Producto'),
            ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: maxWidth,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
            children: [
              _ListStatusHeader(details: details, currencyStyle: currencyStyle),
              if (completed) ...[
                const SizedBox(height: 10),
                Card.filled(
                  child: ListTile(
                    leading: Icon(
                      method?.icon == 'credit_card'
                          ? Icons.credit_card
                          : Icons.check_circle_outline,
                    ),
                    title: Text(
                      method == null
                          ? 'Compra finalizada'
                          : 'Pagado con ${method.name}',
                    ),
                    subtitle: Text(
                      category == null
                          ? _dateLabel(list.purchaseDate)
                          : '${category.name} · ${_dateLabel(list.purchaseDate)}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Reabrir compra',
                      icon: const Icon(Icons.lock_open_outlined),
                      onPressed: () => _reopen(context, ref, list.id),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Productos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (!completed)
                    TextButton.icon(
                      onPressed: () =>
                          _editItem(context, ref, list.id, currencyStyle),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              if (details.items.isEmpty)
                _EmptyShoppingContent(
                  icon: Icons.shopping_basket_outlined,
                  title: 'La lista está vacía',
                  message: 'Agrega los productos que quieres comprar.',
                )
              else
                for (final item in details.items)
                  _ShoppingItemTile(
                    item: item,
                    currencyStyle: currencyStyle,
                    readOnly: completed,
                    onPurchased: () => _saveItem(
                      context,
                      ref,
                      item.copyWith(
                        isPurchased: !item.isPurchased,
                        updatedAt: DateTime.now(),
                      ),
                    ),
                    onQuantity: (delta) => _saveItem(
                      context,
                      ref,
                      item.copyWith(
                        quantity: (item.quantity + delta).clamp(1, 1000000),
                        updatedAt: DateTime.now(),
                      ),
                    ),
                    onEdit: () => _editItem(
                      context,
                      ref,
                      list.id,
                      currencyStyle,
                      existing: item,
                    ),
                    onDelete: () => _deleteItem(context, ref, list.id, item.id),
                  ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Descuentos y recargos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (!completed)
                    IconButton(
                      tooltip: 'Agregar descuento o recargo',
                      onPressed: () =>
                          _editAdjustment(context, ref, list.id, currencyStyle),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                ],
              ),
              if (details.adjustments.isEmpty)
                Text(
                  'Agrega cupones, descuentos, impuestos o recargos.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              else
                for (final adjustment in details.adjustments)
                  _AdjustmentTile(
                    adjustment: adjustment,
                    currencyStyle: currencyStyle,
                    readOnly: completed,
                    onEdit: () => _editAdjustment(
                      context,
                      ref,
                      list.id,
                      currencyStyle,
                      existing: adjustment,
                    ),
                    onDelete: () =>
                        _deleteAdjustment(context, ref, adjustment.id),
                  ),
              const SizedBox(height: 18),
              _TotalsCard(details: details, currencyStyle: currencyStyle),
              const SizedBox(height: 16),
              if (!completed && list.status == ShoppingListStatus.pending)
                OutlinedButton.icon(
                  onPressed: () => _startShopping(context, ref, list),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Empezar a comprar'),
                ),
              if (!completed)
                FilledButton.icon(
                  onPressed: details.items.isEmpty
                      ? null
                      : () => _finalize(
                          context,
                          ref,
                          details,
                          categories,
                          methods,
                        ),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Finalizar compra'),
                ),
              if (completed && list.payableId != null)
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: ListTile(
                    leading: Icon(Icons.schedule),
                    title: const Text('Compra a crédito pendiente'),
                    subtitle: const Text(
                      'Consulta el saldo y registra abonos en pagos pendientes.',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.pushNamed(
                      'obligationDetail',
                      pathParameters: {'id': '${list.payableId}'},
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListStatusHeader extends StatelessWidget {
  const _ListStatusHeader({required this.details, required this.currencyStyle});
  final ShoppingListDetails details;
  final CurrencyFormatStyle currencyStyle;
  @override
  Widget build(BuildContext context) {
    final list = details.list;
    final colors = Theme.of(context).colorScheme;
    final color = switch (list.status) {
      ShoppingListStatus.pending => colors.secondary,
      ShoppingListStatus.shopping => colors.primary,
      ShoppingListStatus.completed => colors.tertiary,
    };
    final label = switch (list.status) {
      ShoppingListStatus.pending => 'Pendiente',
      ShoppingListStatus.shopping => 'En compra',
      ShoppingListStatus.completed => 'Completada',
    };
    final remaining = details.remainingBudgetInCents;
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                Chip(
                  avatar: Icon(Icons.circle, size: 10, color: color),
                  label: Text(label),
                ),
                Chip(
                  avatar: const Icon(Icons.checklist_outlined, size: 17),
                  label: Text(
                    '${details.purchasedItemCount}/${details.items.length} comprados',
                  ),
                ),
              ],
            ),
            if (list.budgetInCents != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Presupuesto ${_money(list.budgetInCents!, currencyStyle)}',
                    ),
                  ),
                  Text(
                    remaining! < 0
                        ? 'Excedido ${_money(-remaining, currencyStyle)}'
                        : 'Disponible ${_money(remaining, currencyStyle)}',
                    style: TextStyle(
                      color: remaining < 0 ? colors.error : colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: list.budgetInCents == 0
                    ? 0
                    : (details.actualTotalInCents / list.budgetInCents!).clamp(
                        0,
                        1,
                      ),
                color: details.actualTotalInCents > list.budgetInCents!
                    ? colors.error
                    : colors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShoppingItemTile extends StatelessWidget {
  const _ShoppingItemTile({
    required this.item,
    required this.currencyStyle,
    required this.readOnly,
    required this.onPurchased,
    required this.onQuantity,
    required this.onEdit,
    required this.onDelete,
  });
  final ShoppingListItem item;
  final CurrencyFormatStyle currencyStyle;
  final bool readOnly;
  final VoidCallback onPurchased;
  final ValueChanged<int> onQuantity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    final line = item.actualUnitPriceInCents ?? item.estimatedUnitPriceInCents;
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7, 4, 4, 7),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: item.isPurchased,
                  onChanged: readOnly ? null : (_) => onPurchased(),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onEdit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  decoration: item.isPurchased
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                          ),
                          Text(
                            item.actualUnitPriceInCents == null
                                ? 'Estimado ${_money(item.estimatedUnitPriceInCents ?? 0, currencyStyle)} c/u'
                                : '${_money(item.actualUnitPriceInCents!, currencyStyle)} c/u · real',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (item.barcode != null)
                            Text(
                              'Código ${item.barcode}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!readOnly)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                    ],
                  ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 18),
                if (!readOnly)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Disminuir cantidad',
                    onPressed: item.quantity <= 1 ? null : () => onQuantity(-1),
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                  ),
                Text(
                  '${item.quantity} ${item.quantity == 1 ? 'unidad' : 'unidades'}',
                ),
                if (!readOnly)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Aumentar cantidad',
                    onPressed: () => onQuantity(1),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                  ),
                const Spacer(),
                Text(
                  _money((line ?? 0) * item.quantity, currencyStyle),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdjustmentTile extends StatelessWidget {
  const _AdjustmentTile({
    required this.adjustment,
    required this.currencyStyle,
    required this.readOnly,
    required this.onEdit,
    required this.onDelete,
  });
  final ShoppingAdjustment adjustment;
  final CurrencyFormatStyle currencyStyle;
  final bool readOnly;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    leading: Icon(
      adjustment.isPositive
          ? Icons.add_circle_outline
          : Icons.remove_circle_outline,
      color: adjustment.isPositive
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
    ),
    title: Text(adjustment.name),
    subtitle: Text(adjustment.isPositive ? 'Recargo' : 'Descuento'),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${adjustment.isPositive ? '+' : '−'}${_money(adjustment.amountInCents, currencyStyle)}',
        ),
        if (!readOnly)
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
          ),
      ],
    ),
  );
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.details, required this.currencyStyle});
  final ShoppingListDetails details;
  final CurrencyFormatStyle currencyStyle;
  @override
  Widget build(BuildContext context) {
    final adjustments = details.adjustmentTotalInCents;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _TotalRow(
              label: 'Subtotal estimado',
              value: details.estimatedSubtotalInCents,
              style: currencyStyle,
            ),
            const SizedBox(height: 7),
            _TotalRow(
              label: 'Subtotal comprado',
              value: details.purchasedSubtotalInCents,
              style: currencyStyle,
            ),
            if (adjustments != 0) ...[
              const Divider(height: 19),
              _TotalRow(
                label: adjustments > 0 ? 'Recargos e impuestos' : 'Descuentos',
                value: adjustments,
                style: currencyStyle,
              ),
            ],
            const Divider(height: 22),
            _TotalRow(
              label: 'Total actual',
              value: details.actualTotalInCents,
              style: currencyStyle,
              emphasized: true,
            ),
            if (details.missingActualPriceItems.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Faltan precios reales en ${details.missingActualPriceItems.length} producto(s) para finalizar.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    required this.style,
    this.emphasized = false,
  });
  final String label;
  final int value;
  final CurrencyFormatStyle style;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: emphasized
              ? Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
              : null,
        ),
      ),
      Text(
        _money(value, style),
        style: emphasized
            ? Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)
            : Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
}

class _EmptyShoppingContent extends StatelessWidget {
  const _EmptyShoppingContent({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Card.outlined(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Icon(icon, size: 38, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

Future<void> _editList(
  BuildContext context,
  WidgetRef ref,
  ShoppingListDetails details,
) async {
  final name = TextEditingController(text: details.list.name);
  final budget = TextEditingController(
    text: details.list.budgetInCents == null
        ? ''
        : MoneyFormatter.toDopInput(details.list.budgetInCents!),
  );
  await showDialogAndWaitForDismissal<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Editar lista'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: budget,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Presupuesto (opcional)',
              prefixText: 'RD\$ ',
            ),
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
            final parsed = budget.text.trim().isEmpty
                ? null
                : MoneyFormatter.parseDopMinorUnits(budget.text);
            if (ShoppingListValidator.validateName(name.text) != null ||
                (budget.text.trim().isNotEmpty && parsed == null) ||
                ShoppingListValidator.validateBudget(parsed) != null) {
              return;
            }
            try {
              await ref
                  .read(shoppingListRepositoryProvider)
                  .update(
                    details.list.copyWith(
                      name: name.text,
                      budgetInCents: parsed,
                      clearBudget: budget.text.trim().isEmpty,
                      updatedAt: DateTime.now(),
                    ),
                  );
              if (dialogContext.mounted) Navigator.pop(dialogContext, true);
            } on ShoppingListException catch (error) {
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(SnackBar(content: Text(error.message)));
              }
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
  name.dispose();
  budget.dispose();
}

Future<void> _editItem(
  BuildContext context,
  WidgetRef ref,
  int listId,
  CurrencyFormatStyle style, {
  ShoppingListItem? existing,
}) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final quantity = TextEditingController(text: '${existing?.quantity ?? 1}');
  final estimated = TextEditingController(
    text: existing?.estimatedUnitPriceInCents == null
        ? ''
        : MoneyFormatter.toDopInput(existing!.estimatedUnitPriceInCents!),
  );
  final actual = TextEditingController(
    text: existing?.actualUnitPriceInCents == null
        ? ''
        : MoneyFormatter.toDopInput(existing!.actualUnitPriceInCents!),
  );
  var purchased = existing?.isPurchased ?? false;
  String? error;
  await showDialogAndWaitForDismissal<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null ? 'Agregar producto' : 'Editar producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                maxLength: 100,
                decoration: const InputDecoration(labelText: 'Producto'),
              ),
              TextField(
                controller: quantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: estimated,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio unitario estimado',
                  prefixText: 'RD\$ ',
                ),
              ),
              TextField(
                controller: actual,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio unitario real',
                  prefixText: 'RD\$ ',
                ),
              ),
              if (existing != null)
                CheckboxListTile(
                  value: purchased,
                  onChanged: (value) =>
                      setState(() => purchased = value ?? false),
                  title: const Text('Ya lo compré'),
                  contentPadding: EdgeInsets.zero,
                ),
              if (error != null)
                Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
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
              final count = int.tryParse(quantity.text) ?? 0;
              final estimate = estimated.text.trim().isEmpty
                  ? null
                  : MoneyFormatter.parseDopMinorUnits(estimated.text);
              final real = actual.text.trim().isEmpty
                  ? null
                  : MoneyFormatter.parseDopMinorUnits(actual.text);
              final validation = ShoppingListValidator.validateItem(
                name: name.text,
                quantity: count,
                estimatedUnitPriceInCents: estimate,
                actualUnitPriceInCents: real,
              );
              if (validation != null ||
                  (estimated.text.trim().isNotEmpty && estimate == null) ||
                  (actual.text.trim().isNotEmpty && real == null)) {
                setState(
                  () => error =
                      validation ?? 'El precio debe tener un formato válido.',
                );
                return;
              }
              final now = DateTime.now();
              try {
                await ref
                    .read(shoppingListRepositoryProvider)
                    .saveItem(
                      ShoppingListItem(
                        id: existing?.id ?? 0,
                        shoppingListId: listId,
                        name: name.text,
                        quantity: count,
                        estimatedUnitPriceInCents: estimate,
                        actualUnitPriceInCents: real,
                        isPurchased: purchased,
                        notes: existing?.notes,
                        barcode: existing?.barcode,
                        createdAt: existing?.createdAt ?? now,
                        updatedAt: now,
                      ),
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } on ShoppingListException catch (exception) {
                if (dialogContext.mounted) {
                  setState(() => error = exception.message);
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
  quantity.dispose();
  estimated.dispose();
  actual.dispose();
}

Future<void> _editAdjustment(
  BuildContext context,
  WidgetRef ref,
  int listId,
  CurrencyFormatStyle style, {
  ShoppingAdjustment? existing,
}) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final amount = TextEditingController(
    text: existing == null
        ? ''
        : MoneyFormatter.toDopInput(existing.amountInCents),
  );
  var isPositive = existing?.isPositive ?? false;
  String? error;
  await showDialogAndWaitForDismissal<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null ? 'Descuento o recargo' : 'Editar ajuste'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              autofocus: true,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Concepto',
                hintText: 'Cupón, ITBIS, envío',
              ),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Descuento')),
                ButtonSegment(value: true, label: Text('Recargo')),
              ],
              selected: {isPositive},
              onSelectionChanged: (selected) =>
                  setState(() => isPositive = selected.first),
            ),
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: 'RD\$ ',
              ),
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
              final parsed = MoneyFormatter.parseDopMinorUnits(amount.text);
              final validation = parsed == null
                  ? 'Escribe un monto válido.'
                  : ShoppingListValidator.validateAdjustment(name.text, parsed);
              if (validation != null) {
                setState(() => error = validation);
                return;
              }
              try {
                await ref
                    .read(shoppingListRepositoryProvider)
                    .saveAdjustment(
                      ShoppingAdjustment(
                        id: existing?.id ?? 0,
                        shoppingListId: listId,
                        name: name.text,
                        isPositive: isPositive,
                        amountInCents: parsed!,
                        createdAt: existing?.createdAt ?? DateTime.now(),
                      ),
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } on ShoppingListException catch (exception) {
                if (dialogContext.mounted) {
                  setState(() => error = exception.message);
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
  amount.dispose();
}

Future<void> _finalize(
  BuildContext context,
  WidgetRef ref,
  ShoppingListDetails details,
  List<Category> allCategories,
  List<PaymentMethod> methods,
) async {
  final categories = allCategories
      .where(
        (category) =>
            category.type == CategoryType.expense && category.isActive,
      )
      .toList();
  if (categories.isEmpty || methods.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activa una categoría de gasto y un método de pago.'),
      ),
    );
    return;
  }
  var categoryId = categories
      .firstWhere(
        (item) => item.name.toLowerCase() == 'compras',
        orElse: () => categories.first,
      )
      .id;
  var methodId = methods
      .firstWhere((item) => item.isDefault, orElse: () => methods.first)
      .id;
  var date = DateTime.now();
  final saved = await showDialogAndWaitForDismissal<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Finalizar compra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total ${_money(details.finalizableTotalInCents, CurrencyFormatStyle.symbol)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: categoryId,
              decoration: const InputDecoration(
                labelText: 'Categoría de gasto',
              ),
              items: [
                for (final category in categories)
                  DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => categoryId = value);
              },
            ),
            DropdownButtonFormField<int>(
              initialValue: methodId,
              decoration: const InputDecoration(labelText: 'Método de pago'),
              items: [
                for (final method in methods)
                  DropdownMenuItem(value: method.id, child: Text(method.name)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => methodId = value);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Fecha de compra'),
              subtitle: Text(_dateLabel(date)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => date = picked);
              },
            ),
            if (details.missingActualPriceItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Falta el precio real en ${details.missingActualPriceItems.length} producto(s).',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: details.missingActualPriceItems.isNotEmpty
                ? null
                : () => Navigator.pop(dialogContext, true),
            child: const Text('Confirmar compra'),
          ),
        ],
      ),
    ),
  );
  if (saved != true) return;
  try {
    final payable =
        methods
            .firstWhere((item) => item.id == methodId)
            .name
            .toLowerCase()
            .contains('crédito') ||
        methods
            .firstWhere((item) => item.id == methodId)
            .name
            .toLowerCase()
            .contains('credit');
    final financialId = await ref
        .read(shoppingListRepositoryProvider)
        .finalizePurchase(
          listId: details.list.id,
          categoryId: categoryId,
          purchaseDate: date,
          paymentMethodId: methodId,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            payable
                ? 'Compra registrada como pago pendiente · #$financialId'
                : 'Compra finalizada y agregada a gastos.',
          ),
        ),
      );
    }
  } on ShoppingListException catch (exception) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(exception.message)));
    }
  }
}

Future<void> _startShopping(
  BuildContext context,
  WidgetRef ref,
  ShoppingList list,
) async {
  try {
    await ref
        .read(shoppingListRepositoryProvider)
        .update(
          list.copyWith(
            status: ShoppingListStatus.shopping,
            updatedAt: DateTime.now(),
          ),
        );
  } on ShoppingListException catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

Future<void> _saveItem(
  BuildContext context,
  WidgetRef ref,
  ShoppingListItem item,
) async {
  try {
    await ref.read(shoppingListRepositoryProvider).saveItem(item);
  } on ShoppingListException catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

Future<void> _deleteItem(
  BuildContext context,
  WidgetRef ref,
  int listId,
  int id,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Eliminar producto'),
      content: const Text('¿Quieres quitar este producto de la lista?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await ref.read(shoppingListRepositoryProvider).deleteItem(id);
  } on ShoppingListException catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

Future<void> _deleteAdjustment(
  BuildContext context,
  WidgetRef ref,
  int id,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Eliminar ajuste'),
      content: const Text('¿Quieres quitar este descuento o recargo?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await ref.read(shoppingListRepositoryProvider).deleteAdjustment(id);
  } on ShoppingListException catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

Future<void> _reopen(BuildContext context, WidgetRef ref, int id) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Reabrir compra'),
      content: const Text(
        'Se quitará el gasto o pago pendiente asociado. Los productos seguirán guardados.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Reabrir'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await ref.read(shoppingListRepositoryProvider).reopen(id);
  } on ShoppingListException catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

Future<void> _duplicate(BuildContext context, WidgetRef ref, int id) async {
  try {
    final newId = await ref.read(shoppingListRepositoryProvider).duplicate(id);
    if (newId != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lista duplicada.')));
    }
  } on ShoppingListException catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

String _money(int amount, CurrencyFormatStyle style) =>
    MoneyFormatter.formatDopMinorUnits(amount, style: style);
String _dateLabel(DateTime? date) => date == null
    ? 'Sin fecha'
    : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
