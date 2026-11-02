import 'payment_method.dart';

abstract final class PaymentMethodValidator {
  static const maxNameLength = 40;

  static String? validateName(
    String rawName,
    List<PaymentMethod> existing, {
    int? excludeId,
  }) {
    final name = rawName.trim();
    if (name.isEmpty) return 'Escribe el nombre del método de pago';
    if (name.length > maxNameLength) {
      return 'El nombre no puede tener más de $maxNameLength caracteres';
    }
    if (existing.any(
      (method) =>
          method.id != excludeId &&
          method.name.toLowerCase() == name.toLowerCase(),
    )) {
      return 'Ya existe un método de pago con ese nombre';
    }
    return null;
  }
}
