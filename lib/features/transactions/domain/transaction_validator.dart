import 'transaction.dart';

abstract final class TransactionValidator {
  static String? validateAmount(int? amountInCents) =>
      amountInCents == null || amountInCents <= 0
      ? 'Ingresa un monto válido mayor que cero.'
      : null;

  static String? validateSelection({
    required int? categoryId,
    required int? paymentMethodId,
  }) {
    if (categoryId == null) return 'Selecciona una categoría.';
    if (paymentMethodId == null) return 'Selecciona un método de pago.';
    return null;
  }

  static FinanceTransaction normalize(FinanceTransaction transaction) =>
      FinanceTransaction(
        id: transaction.id,
        amountInCents: transaction.amountInCents,
        type: transaction.type,
        categoryId: transaction.categoryId,
        paymentMethodId: transaction.paymentMethodId,
        description: transaction.description?.trim().isEmpty ?? true
            ? null
            : transaction.description?.trim(),
        date: transaction.date,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
        fixedEntryId: transaction.fixedEntryId,
        savingsGoalId: transaction.savingsGoalId,
      );
}
