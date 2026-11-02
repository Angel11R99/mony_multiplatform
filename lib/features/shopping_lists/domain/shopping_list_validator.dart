import 'shopping_list.dart';

abstract final class ShoppingListValidator {
  static String? validateName(String value) => value.trim().isEmpty
      ? 'El nombre de la lista es obligatorio.'
      : value.trim().length > 80
      ? 'El nombre no puede superar 80 caracteres.'
      : null;

  static String? validateBudget(int? value) => value != null && value < 0
      ? 'El presupuesto no puede ser negativo.'
      : null;

  static String? validateItem({
    required String name,
    required int quantity,
    int? estimatedUnitPriceInCents,
    int? actualUnitPriceInCents,
  }) {
    if (name.trim().isEmpty) return 'Escribe el nombre del producto.';
    if (quantity < 1 || quantity > 1000000) {
      return 'La cantidad debe estar entre 1 y 1,000,000.';
    }
    if ((estimatedUnitPriceInCents ?? 0) < 0 ||
        (actualUnitPriceInCents ?? 0) < 0) {
      return 'Los precios no pueden ser negativos.';
    }
    try {
      _checkedLine(quantity, estimatedUnitPriceInCents);
      _checkedLine(quantity, actualUnitPriceInCents);
    } on ShoppingListCalculationException {
      return 'El precio o la cantidad son demasiado grandes.';
    }
    return null;
  }

  static String? validateAdjustment(String name, int amountInCents) =>
      name.trim().isEmpty
      ? 'Escribe el concepto del ajuste.'
      : amountInCents <= 0
      ? 'El ajuste debe ser mayor que cero.'
      : amountInCents > 9007199254740991
      ? 'El monto del ajuste es demasiado grande.'
      : null;

  static void _checkedLine(int quantity, int? amount) {
    if (amount == null) return;
    final details = ShoppingListDetails(
      list: ShoppingList(
        name: 'Validación',
        createdAt: DateTime(2000),
        updatedAt: DateTime(2000),
      ),
      items: [
        ShoppingListItem(
          shoppingListId: 0,
          name: 'Producto',
          quantity: quantity,
          actualUnitPriceInCents: amount,
          createdAt: DateTime(2000),
          updatedAt: DateTime(2000),
        ),
      ],
      adjustments: const [],
    );
    details.finalizableSubtotalInCents;
  }
}
