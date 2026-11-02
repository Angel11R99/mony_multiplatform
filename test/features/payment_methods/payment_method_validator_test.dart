import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/payment_methods/domain/payment_method.dart';
import 'package:mony_multiplatform/features/payment_methods/domain/payment_method_validator.dart';

void main() {
  final cash = PaymentMethod(
    id: 1,
    name: 'Efectivo',
    icon: 'cash',
    colorArgb: 0xFF16A34A,
    isActive: true,
    isDefault: true,
    createdAt: DateTime(2026),
  );

  test('requires a valid unique name ignoring case and surrounding spaces', () {
    expect(
      PaymentMethodValidator.validateName('  ', [cash]),
      'Escribe el nombre del método de pago',
    );
    expect(
      PaymentMethodValidator.validateName('x' * 41, [cash]),
      'El nombre no puede tener más de 40 caracteres',
    );
    expect(
      PaymentMethodValidator.validateName(' efectivo ', [cash]),
      'Ya existe un método de pago con ese nombre',
    );
    expect(
      PaymentMethodValidator.validateName('Efectivo', [cash], excludeId: 1),
      isNull,
    );
    expect(
      PaymentMethodValidator.validateName('Transferencia', [cash]),
      isNull,
    );
  });
}
