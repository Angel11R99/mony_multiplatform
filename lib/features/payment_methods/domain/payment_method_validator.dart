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
    final digitCount = RegExp(r'\d').allMatches(name).length;
    final containsSensitiveToken = RegExp(
      r'\b(?:cvv|cvc|código de seguridad|codigo de seguridad|security code|pin|password|contraseña|contrasena|credencial(?:es)?|credential(?:s)?)\b',
      caseSensitive: false,
    ).hasMatch(name);
    if (digitCount >= 12 || containsSensitiveToken) {
      return 'No guardes números de tarjeta, CVV, PIN ni credenciales; usa un nombre general como “Débito”.';
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
