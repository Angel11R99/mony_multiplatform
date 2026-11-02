import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/dialog_helpers.dart';
import '../../../core/money/money_formatter.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../domain/shopping_list.dart';
import '../domain/shopping_list_repository.dart';
import '../domain/shopping_list_validator.dart';
import 'shopping_lists_providers.dart';

class ShoppingListsPage extends ConsumerWidget {
  const ShoppingListsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingListOverviewsProvider);
    final style =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        AppPreferences.defaults.currencyFormatStyle;
    return Scaffold(
      appBar: AppBar(title: const Text('Listas de compras')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editList(context, ref, style),
        icon: const Icon(Icons.add),
        label: const Text('Nueva lista'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _ListError(
          onRetry: () => ref.invalidate(shoppingListOverviewsProvider),
        ),
        data: (overviews) {
          if (overviews.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 54,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Prepara tu próxima compra',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Agrega productos, cantidades y precios para controlar el total antes de pagar.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _editList(context, ref, style),
                      icon: const Icon(Icons.add),
                      label: const Text('Crear lista'),
                    ),
                  ],
                ),
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth > 850
                  ? 850.0
                  : constraints.maxWidth;
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: width,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 96),
                    children: [
                      Text(
                        'Todo lo que necesitas, con el total bajo control.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 14),
                      for (final overview in overviews)
                        _ShoppingListCard(
                          overview: overview,
                          currencyStyle: style,
                          onOpen: () => context.pushNamed(
                            'shoppingListDetail',
                            pathParameters: {'id': '${overview.list.id}'},
                          ),
                          onDuplicate: () =>
                              _duplicate(context, ref, overview.list.id),
                          onDelete:
                              overview.list.status ==
                                  ShoppingListStatus.completed
                              ? null
                              : () => _delete(context, ref, overview.list.id),
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
}

Future<void> _editList(
  BuildContext context,
  WidgetRef ref,
  CurrencyFormatStyle style,
) async {
  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  String? error;
  await showDialogAndWaitForDismissal<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Nueva lista'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Compra semanal',
              ),
            ),
            TextField(
              controller: budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Presupuesto (opcional)',
                prefixText: 'RD\$ ',
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  error!,
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
            onPressed: () async {
              final nameError = ShoppingListValidator.validateName(
                nameController.text,
              );
              final rawBudget = budgetController.text.trim();
              final budget = rawBudget.isEmpty
                  ? null
                  : MoneyFormatter.parseDopMinorUnits(rawBudget);
              final budgetError = rawBudget.isNotEmpty && budget == null
                  ? 'Escribe un presupuesto válido.'
                  : ShoppingListValidator.validateBudget(budget);
              if (nameError != null || budgetError != null) {
                setState(() => error = nameError ?? budgetError);
                return;
              }
              final now = DateTime.now();
              try {
                final id = await ref
                    .read(shoppingListRepositoryProvider)
                    .create(
                      ShoppingList(
                        name: nameController.text,
                        budgetInCents: budget,
                        createdAt: now,
                        updatedAt: now,
                      ),
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
                if (context.mounted) {
                  context.pushNamed(
                    'shoppingListDetail',
                    pathParameters: {'id': '$id'},
                  );
                }
              } on ShoppingListException catch (exception) {
                if (dialogContext.mounted) {
                  setState(() => error = exception.message);
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    ),
  );
  nameController.dispose();
  budgetController.dispose();
}

Future<void> _duplicate(BuildContext context, WidgetRef ref, int id) async {
  try {
    final newId = await ref.read(shoppingListRepositoryProvider).duplicate(id);
    if (newId != null && context.mounted) {
      context.pushNamed('shoppingListDetail', pathParameters: {'id': '$newId'});
    }
  } on ShoppingListException catch (exception) {
    if (context.mounted) _showMessage(context, exception.message);
  }
}

Future<void> _delete(BuildContext context, WidgetRef ref, int id) async {
  final confirmed = await MonyConfirmDialog.show(
    context,
    title: 'Eliminar lista',
    message: 'Se eliminarán los productos y ajustes de esta lista.',
    confirmLabel: 'Eliminar',
    destructive: true,
  );
  if (confirmed != true) return;
  try {
    await ref.read(shoppingListRepositoryProvider).delete(id);
  } on ShoppingListException catch (exception) {
    if (context.mounted) _showMessage(context, exception.message);
  }
}

void _showMessage(BuildContext context, String message) =>
    MonyFeedback.info(context, message);

class _ShoppingListCard extends StatelessWidget {
  const _ShoppingListCard({
    required this.overview,
    required this.currencyStyle,
    required this.onOpen,
    required this.onDuplicate,
    required this.onDelete,
  });
  final ShoppingListOverview overview;
  final CurrencyFormatStyle currencyStyle;
  final VoidCallback onOpen;
  final VoidCallback onDuplicate;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final list = overview.list;
    final colors = Theme.of(context).colorScheme;
    final statusColor = switch (list.status) {
      ShoppingListStatus.pending => colors.secondary,
      ShoppingListStatus.shopping => colors.primary,
      ShoppingListStatus.completed => colors.tertiary,
    };
    final statusLabel = switch (list.status) {
      ShoppingListStatus.pending => 'Pendiente',
      ShoppingListStatus.shopping => 'En compra',
      ShoppingListStatus.completed => 'Completada',
    };
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onOpen,
        contentPadding: const EdgeInsets.fromLTRB(16, 7, 8, 7),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: .13),
          child: Icon(Icons.shopping_cart_outlined, color: statusColor),
        ),
        title: Text(list.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _StatusPill(label: statusLabel, color: statusColor),
              Text(
                '${overview.itemCount} ${overview.itemCount == 1 ? 'producto' : 'productos'}',
              ),
              if (list.budgetInCents != null)
                Text(
                  'Límite ${MoneyFormatter.formatDopMinorUnits(list.budgetInCents!, style: currencyStyle)}',
                ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (overview.totalInCents > 0)
              Text(
                MoneyFormatter.formatDopMinorUnits(
                  overview.totalInCents,
                  style: currencyStyle,
                ),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'duplicate') onDuplicate();
                if (value == 'delete') onDelete?.call();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Text('Duplicar lista'),
                ),
                if (onDelete != null)
                  const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

class _ListError extends StatelessWidget {
  const _ListError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar tus listas.'),
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
