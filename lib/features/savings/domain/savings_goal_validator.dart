abstract final class SavingsGoalValidator {
  static const maxNameLength = 80;

  static String normalizeName(String value) => value.trim();

  static String? validateName(String value) {
    final name = normalizeName(value);
    if (name.isEmpty) return 'Escribe el nombre de la meta.';
    if (name.length > maxNameLength) {
      return 'El nombre no puede tener más de $maxNameLength caracteres.';
    }
    return null;
  }

  static String? validateTarget(int? amountInCents) =>
      amountInCents == null || amountInCents <= 0
      ? 'El objetivo debe ser mayor que cero.'
      : null;

  static String? validateContribution(int? amountInCents) =>
      amountInCents == null || amountInCents <= 0
      ? 'El aporte debe ser mayor que cero.'
      : null;
}
