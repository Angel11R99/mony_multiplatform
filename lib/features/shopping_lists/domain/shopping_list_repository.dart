import 'shopping_list.dart';

abstract interface class ShoppingListRepository {
  Stream<List<ShoppingListOverview>> watchOverviews();
  Stream<ShoppingListDetails?> watchDetails(int listId);
  Future<ShoppingListDetails?> getDetails(int listId);
  Future<int> create(ShoppingList list);
  Future<void> update(ShoppingList list);
  Future<void> delete(int listId);
  Future<int> saveItem(ShoppingListItem item);
  Future<void> deleteItem(int itemId);
  Future<int> saveAdjustment(ShoppingAdjustment adjustment);
  Future<void> deleteAdjustment(int adjustmentId);
  Future<int?> duplicate(int listId);
  Future<int> finalizePurchase({
    required int listId,
    required int categoryId,
    required DateTime purchaseDate,
    required int paymentMethodId,
  });
  Future<void> reopen(int listId);
}

class ShoppingListException implements Exception {
  const ShoppingListException(this.message);
  final String message;
  @override
  String toString() => message;
}
