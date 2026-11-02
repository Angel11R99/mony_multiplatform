import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/payment_method.dart';
import 'payment_method_icons.dart';
import 'payment_methods_providers.dart';

/// Payment selector for future movement and purchase forms.
class PaymentMethodPicker extends ConsumerWidget {
  const PaymentMethodPicker({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int? value;
  final ValueChanged<PaymentMethod?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(activePaymentMethodsProvider);
    final defaultMethod = ref.watch(defaultPaymentMethodProvider).value;

    return methods.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stack) =>
          const Text('No se pudieron cargar los métodos de pago.'),
      data: (items) {
        if (items.isEmpty) {
          return const Text('No hay métodos de pago activos.');
        }
        final candidate = value ?? defaultMethod?.id;
        final initialId = items.any((item) => item.id == candidate)
            ? candidate
            : null;
        return DropdownButtonFormField<int>(
          key: ValueKey(initialId),
          initialValue: initialId,
          decoration: const InputDecoration(labelText: 'Método de pago'),
          items: items
              .map(
                (method) => DropdownMenuItem(
                  value: method.id,
                  child: Row(
                    children: [
                      Icon(
                        paymentMethodIcons[method.icon] ?? Icons.payment,
                        color: Color(method.colorArgb),
                      ),
                      const SizedBox(width: 10),
                      Text(method.name),
                      if (method.isDefault) ...[
                        const SizedBox(width: 6),
                        const Text('· Predeterminado'),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (id) => onChanged(
            id == null ? null : items.firstWhere((item) => item.id == id),
          ),
          validator: (id) => id == null ? 'Selecciona un método de pago' : null,
        );
      },
    );
  }
}
