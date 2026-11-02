import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../domain/transaction.dart';
import 'transactions_providers.dart';

class TransactionDetailPage extends ConsumerWidget {
  const TransactionDetailPage({required this.transactionId, super.key});
  final int transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movement = ref.watch(transactionByIdProvider(transactionId));
    final categories = ref.watch(categoriesProvider);
    final methods = ref.watch(paymentMethodsProvider);
    return movement.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text('Detalle del movimiento')),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _missing(context),
      data: (transaction) {
        if (transaction == null) return _missing(context);
        return categories.when(
          loading: () => Scaffold(
            appBar: AppBar(title: Text('Detalle del movimiento')),
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => _missing(context),
          data: (categoryItems) => methods.when(
            loading: () => Scaffold(
              appBar: AppBar(title: Text('Detalle del movimiento')),
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => _missing(context),
            data: (methodItems) => _detail(
              context,
              ref,
              transaction,
              categoryItems
                      .where(
                        (category) => category.id == transaction.categoryId,
                      )
                      .firstOrNull
                      ?.name ??
                  'Categoría archivada',
              methodItems
                      .where(
                        (method) => method.id == transaction.paymentMethodId,
                      )
                      .firstOrNull
                      ?.name ??
                  'Método archivado',
            ),
          ),
        );
      },
    );
  }

  Widget _detail(
    BuildContext context,
    WidgetRef ref,
    FinanceTransaction transaction,
    String categoryName,
    String methodName,
  ) {
    final isIncome = transaction.type == TransactionType.income;
    final note = transaction.description?.trim();
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del movimiento'),
        actions: [
          IconButton(
            tooltip: 'Editar movimiento',
            onPressed: () => context.pushNamed(
              'transactionEdit',
              pathParameters: {'id': transaction.id.toString()},
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    isIncome ? Icons.north_east : Icons.south_west,
                    size: 36,
                    color: isIncome ? scheme.primary : scheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${isIncome ? '+' : '−'}${MoneyFormatter.formatDopMinorUnits(transaction.amountInCents)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isIncome ? scheme.primary : scheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(isIncome ? 'Ingreso' : 'Gasto'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Categoría', value: categoryName),
          _DetailRow(label: 'Método de pago', value: methodName),
          _DetailRow(label: 'Fecha', value: _dateLabel(transaction.date)),
          _DetailRow(
            label: 'Nota',
            value: note == null || note.isEmpty ? 'Sin nota' : note,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.pushNamed(
              'transactionEdit',
              pathParameters: {'id': transaction.id.toString()},
            ),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar movimiento'),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              try {
                final id = await ref
                    .read(transactionRepositoryProvider)
                    .duplicate(transaction.id);
                if (context.mounted && id != null) {
                  context.goNamed('transactions');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Movimiento duplicado con la fecha de hoy.',
                      ),
                    ),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No encontramos el movimiento.'),
                    ),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo duplicar el movimiento.'),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.copy_outlined),
            label: const Text('Duplicar movimiento'),
          ),
          TextButton.icon(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar movimiento'),
                  content: const Text('Esta acción no se puede deshacer.'),
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
                await ref
                    .read(transactionRepositoryProvider)
                    .delete(transaction.id);
                if (context.mounted) context.goNamed('transactions');
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo eliminar el movimiento.'),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Eliminar movimiento'),
          ),
        ],
      ),
    );
  }

  Widget _missing(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Movimiento no encontrado')),
    body: Center(
      child: FilledButton.tonalIcon(
        onPressed: () => context.goNamed('transactions'),
        icon: const Icon(Icons.arrow_back),
        label: const Text('Volver al historial'),
      ),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text(value),
  );
}

String _dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
