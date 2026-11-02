import 'payment_method.dart';

abstract interface class PaymentMethodsRepository {
  Stream<List<PaymentMethod>> watchAll();
  Stream<List<PaymentMethod>> watchActive();
  Stream<PaymentMethod?> watchDefault();
  Future<void> create({
    required String name,
    required String icon,
    required int colorArgb,
  });
  Future<void> update({
    required int id,
    required String name,
    required String icon,
    required int colorArgb,
  });
  Future<void> setDefault(int id);
  Future<void> setActive(int id, bool isActive);
}

final class LastActivePaymentMethodException implements Exception {
  const LastActivePaymentMethodException();
}

final class PaymentMethodUnavailableException implements Exception {
  const PaymentMethodUnavailableException();
}
