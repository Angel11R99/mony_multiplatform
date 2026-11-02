import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/shopping_lists/domain/shopping_list.dart';
import 'package:mony_multiplatform/features/shopping_lists/domain/shopping_list_validator.dart';

void main() {
  final now = DateTime(2026, 11, 2);

  test('calculates estimated, purchased, and finalizable totals in cents', () {
    final details = ShoppingListDetails(
      list: ShoppingList(
        name: 'Mercado',
        budgetInCents: 15000,
        createdAt: now,
        updatedAt: now,
      ),
      items: [
        ShoppingListItem(
          shoppingListId: 1,
          name: 'Arroz',
          quantity: 2,
          estimatedUnitPriceInCents: 1200,
          actualUnitPriceInCents: 1250,
          isPurchased: true,
          createdAt: now,
          updatedAt: now,
        ),
        ShoppingListItem(
          shoppingListId: 1,
          name: 'Leche',
          quantity: 3,
          estimatedUnitPriceInCents: 500,
          actualUnitPriceInCents: 550,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      adjustments: [
        ShoppingAdjustment(
          shoppingListId: 1,
          name: 'Cupón',
          isPositive: false,
          amountInCents: 200,
          createdAt: now,
        ),
        ShoppingAdjustment(
          shoppingListId: 1,
          name: 'Impuesto',
          isPositive: true,
          amountInCents: 100,
          createdAt: now,
        ),
      ],
    );

    expect(details.estimatedSubtotalInCents, 3900);
    expect(details.purchasedSubtotalInCents, 2500);
    expect(details.finalizableSubtotalInCents, 4150);
    expect(details.adjustmentTotalInCents, -100);
    expect(details.actualTotalInCents, 2400);
    expect(details.finalizableTotalInCents, 4050);
    expect(details.remainingBudgetInCents, 12600);
    expect(details.pendingItemCount, 1);
  });

  test('rejects invalid product values and calculation overflow', () {
    expect(ShoppingListValidator.validateName(' '), isNotNull);
    expect(ShoppingListValidator.validateBudget(-1), isNotNull);
    expect(
      ShoppingListValidator.validateItem(name: 'Producto', quantity: 0),
      isNotNull,
    );
    expect(
      ShoppingListValidator.validateItem(
        name: 'Producto',
        quantity: 2,
        actualUnitPriceInCents: 9007199254740991,
      ),
      isNotNull,
    );
    expect(ShoppingListValidator.validateAdjustment('Cupón', 1), isNull);
    expect(ShoppingListValidator.validateAdjustment('Cupón', 0), isNotNull);
    expect(
      ShoppingListValidator.validateAdjustment('Recargo', 9007199254740992),
      isNotNull,
    );
  });
}
