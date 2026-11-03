import 'package:flutter/material.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../domain/transaction.dart';
import '../domain/transaction_repository.dart';
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
        actions: transaction.fixedEntryId == null
            ? [
                IconButton(
                  tooltip: 'Editar movimiento',
                  onPressed: () => context.pushNamed(
                    'transactionEdit',
                    pathParameters: {'id': transaction.id.toString()},
                  ),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ]
            : const [],
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
          if (transaction.fixedEntryId != null) ...[
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.repeat),
              title: Text('Movimiento generado por una serie recurrente'),
            ),
            FilledButton.icon(
              onPressed: () => context.goNamed('recurringEntries'),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Administrar series'),
            ),
          ],
          if (transaction.fixedEntryId == null) ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.pushNamed(
                'transactionEdit',
                pathParameters: {'id': transaction.id.toString()},
              ),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar movimiento'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  final id = await ref
                      .read(transactionRepositoryProvider)
                      .duplicate(transaction.id);
                  if (context.mounted && id != null) {
                    context.goNamed('transactions');
                    MonyFeedback.success(
                      context,
                      'Movimiento duplicado con la fecha de hoy.',
                    );
                  } else if (context.mounted) {
                    MonyFeedback.error(
                      context,
                      'No encontramos el movimiento.',
                    );
                  }
                } on InvalidTransactionException catch (error) {
                  if (context.mounted) {
                    MonyFeedback.error(context, error.message);
                  }
                } catch (_) {
                  if (context.mounted) {
                    MonyFeedback.error(
                      context,
                      'No se pudo duplicar el movimiento.',
                    );
                  }
                }
              },
              icon: const Icon(Icons.copy_outlined),
              label: const Text('Duplicar movimiento'),
            ),
            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: () async {
                final confirmed = await MonyConfirmDialog.show(
                  context,
                  title: 'Eliminar movimiento',
                  message: 'Esta acción no se puede deshacer.',
                  confirmLabel: 'Eliminar',
                  destructive: true,
                );
                if (confirmed != true || !context.mounted) return;
                try {
                  await ref
                      .read(transactionRepositoryProvider)
                      .delete(transaction.id);
                  if (context.mounted) context.goNamed('transactions');
                } on InvalidTransactionException catch (error) {
                  if (context.mounted) {
                    MonyFeedback.error(context, error.message);
                  }
                } catch (_) {
                  if (context.mounted) {
                    MonyFeedback.error(
                      context,
                      'No se pudo eliminar el movimiento.',
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar movimiento'),
            ),
          ],
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

String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);
