abstract final class ObligationValidator {
  static String? validateTitle(String value) => value.trim().isEmpty
      ? 'Escribe una descripción para la obligación.'
      : value.trim().length > 120
      ? 'La descripción no puede superar 120 caracteres.'
      : null;

  static String? validateCounterparty(String? value) =>
      value != null && value.trim().length > 100
      ? 'El nombre no puede superar 100 caracteres.'
      : null;

  static String? validateNotes(String? value) =>
      value != null && value.length > 500
      ? 'Las notas no pueden superar 500 caracteres.'
      : null;

  static String? validateAmount(int amountInCents) => amountInCents <= 0
      ? 'El monto debe ser mayor que cero.'
      : amountInCents > 9007199254740991
      ? 'El monto es demasiado grande.'
      : null;

  static String? validatePayment({
    required int amountInCents,
    required int remainingInCents,
  }) {
    final amountError = validateAmount(amountInCents);
    if (amountError != null) return amountError;
    if (amountInCents > remainingInCents) {
      return 'El abono no puede superar el saldo pendiente.';
    }
    return null;
  }
}
