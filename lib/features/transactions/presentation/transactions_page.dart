import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../domain/transaction.dart';
import 'transactions_providers.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
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
    WidgetRef ref,
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

  static void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            data: (methodItems) => items.isEmpty
                ? const _TransactionsEmpty()
                : _TransactionList(
                    transactions: items,
                    categories: categoryItems,
                    methods: methodItems,
                    onEdit: (item) => context.pushNamed(
                      'transactionEdit',
                      pathParameters: {'id': item.id.toString()},
                    ),
                    onDuplicate: (item) => _duplicate(context, ref, item),
                    onDelete: (item) => _delete(context, ref, item),
                  ),
          ),
        ),
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList({
    required this.transactions,
    required this.categories,
    required this.methods,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  final List<FinanceTransaction> transactions;
  final List<Category> categories;
  final List<PaymentMethod> methods;
  final ValueChanged<FinanceTransaction> onEdit;
  final ValueChanged<FinanceTransaction> onDuplicate;
  final ValueChanged<FinanceTransaction> onDelete;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 104),
    itemCount: transactions.length,
    separatorBuilder: (context, index) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final transaction = transactions[index];
      final category = _firstWhereOrNull(
        categories,
        (item) => item.id == transaction.categoryId,
      );
      final method = _firstWhereOrNull(
        methods,
        (item) => item.id == transaction.paymentMethodId,
      );
      return _TransactionCard(
        transaction: transaction,
        categoryName: category?.name ?? 'Categoría archivada',
        paymentMethodName: method?.name ?? 'Método archivado',
        onEdit: () => onEdit(transaction),
        onDuplicate: () => onDuplicate(transaction),
        onDelete: () => onDelete(transaction),
      );
    },
  );
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.transaction,
    required this.categoryName,
    required this.paymentMethodName,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  final FinanceTransaction transaction;
  final String categoryName;
  final String paymentMethodName;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final income = transaction.type == TransactionType.income;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onEdit,
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
                  case 'edit':
                    onEdit();
                  case 'duplicate':
                    onDuplicate();
                  case 'delete':
                    onDelete();
                }
              },
              itemBuilder: (context) => const [
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
  const _TransactionsEmpty();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Todavía no hay movimientos.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Registra un ingreso o un gasto para comenzar tu historial.',
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
