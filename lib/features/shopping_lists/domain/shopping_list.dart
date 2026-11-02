enum ShoppingListStatus { pending, shopping, completed }

class ShoppingList {
  const ShoppingList({
    this.id = 0,
    required this.name,
    this.status = ShoppingListStatus.pending,
    this.budgetInCents,
    this.expenseTransactionId,
    this.payableId,
    this.purchaseDate,
    this.paymentMethodId,
    this.expenseCategoryId,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  final int id;
  final String name;
  final ShoppingListStatus status;
  final int? budgetInCents;
  final int? expenseTransactionId;
  final int? payableId;
  final DateTime? purchaseDate;
  final int? paymentMethodId;
  final int? expenseCategoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  ShoppingList copyWith({
    String? name,
    ShoppingListStatus? status,
    int? budgetInCents,
    bool clearBudget = false,
    DateTime? purchaseDate,
    int? paymentMethodId,
    int? expenseCategoryId,
    DateTime? updatedAt,
    DateTime? completedAt,
    bool clearPurchase = false,
  }) => ShoppingList(
    id: id,
    name: name ?? this.name,
    status: status ?? this.status,
    budgetInCents: clearBudget ? null : budgetInCents ?? this.budgetInCents,
    expenseTransactionId: clearPurchase ? null : expenseTransactionId,
    payableId: clearPurchase ? null : payableId,
    purchaseDate: clearPurchase ? null : purchaseDate ?? this.purchaseDate,
    paymentMethodId: clearPurchase
        ? null
        : paymentMethodId ?? this.paymentMethodId,
    expenseCategoryId: clearPurchase
        ? null
        : expenseCategoryId ?? this.expenseCategoryId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: clearPurchase ? null : completedAt ?? this.completedAt,
  );
}

class ShoppingListItem {
  const ShoppingListItem({
    this.id = 0,
    required this.shoppingListId,
    required this.name,
    this.quantity = 1,
    this.estimatedUnitPriceInCents,
    this.actualUnitPriceInCents,
    this.isPurchased = false,
    this.notes,
    this.barcode,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int shoppingListId;
  final String name;
  final int quantity;
  final int? estimatedUnitPriceInCents;
  final int? actualUnitPriceInCents;
  final bool isPurchased;
  final String? notes;
  final String? barcode;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShoppingListItem copyWith({
    String? name,
    int? quantity,
    int? estimatedUnitPriceInCents,
    bool clearEstimatedPrice = false,
    int? actualUnitPriceInCents,
    bool clearActualPrice = false,
    bool? isPurchased,
    String? notes,
    bool clearNotes = false,
    String? barcode,
    bool clearBarcode = false,
    DateTime? updatedAt,
  }) => ShoppingListItem(
    id: id,
    shoppingListId: shoppingListId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    estimatedUnitPriceInCents: clearEstimatedPrice
        ? null
        : estimatedUnitPriceInCents ?? this.estimatedUnitPriceInCents,
    actualUnitPriceInCents: clearActualPrice
        ? null
        : actualUnitPriceInCents ?? this.actualUnitPriceInCents,
    isPurchased: isPurchased ?? this.isPurchased,
    notes: clearNotes ? null : notes ?? this.notes,
    barcode: clearBarcode ? null : barcode ?? this.barcode,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class ShoppingAdjustment {
  const ShoppingAdjustment({
    this.id = 0,
    required this.shoppingListId,
    required this.name,
    required this.isPositive,
    required this.amountInCents,
    required this.createdAt,
  });
  final int id;
  final int shoppingListId;
  final String name;

  /// Positive adjustments are taxes or surcharges; negative adjustments are discounts.
  final bool isPositive;
  final int amountInCents;
  final DateTime createdAt;
}

class ShoppingListDetails {
  const ShoppingListDetails({
    required this.list,
    required this.items,
    required this.adjustments,
  });
  final ShoppingList list;
  final List<ShoppingListItem> items;
  final List<ShoppingAdjustment> adjustments;

  int get estimatedSubtotalInCents => _safeSum(
    items.map(
      (item) => _lineTotal(item.quantity, item.estimatedUnitPriceInCents),
    ),
  );

  int get purchasedSubtotalInCents => _safeSum(
    items
        .where((item) => item.isPurchased)
        .map((item) => _lineTotal(item.quantity, item.actualUnitPriceInCents)),
  );

  int get finalizableSubtotalInCents => _safeSum(
    items.map((item) => _lineTotal(item.quantity, item.actualUnitPriceInCents)),
  );

  int get adjustmentTotalInCents => _safeSum(
    adjustments.map(
      (item) => item.isPositive ? item.amountInCents : -item.amountInCents,
    ),
  );

  int get actualTotalInCents =>
      _safeAdd(purchasedSubtotalInCents, adjustmentTotalInCents);
  int get finalizableTotalInCents =>
      _safeAdd(finalizableSubtotalInCents, adjustmentTotalInCents);
  int? get remainingBudgetInCents => list.budgetInCents == null
      ? null
      : _safeAdd(list.budgetInCents!, -actualTotalInCents);
  int get purchasedItemCount => items.where((item) => item.isPurchased).length;
  int get pendingItemCount => items.length - purchasedItemCount;
  List<ShoppingListItem> get missingActualPriceItems => items
      .where((item) => item.actualUnitPriceInCents == null)
      .toList(growable: false);
}

class ShoppingListOverview {
  const ShoppingListOverview({
    required this.list,
    required this.itemCount,
    required this.totalInCents,
  });
  final ShoppingList list;
  final int itemCount;
  final int totalInCents;
}

int _lineTotal(int quantity, int? unitPrice) =>
    _safeMultiply(quantity, unitPrice ?? 0);

int _safeMultiply(int a, int b) {
  final result = BigInt.from(a) * BigInt.from(b);
  return _safeInt(result);
}

int _safeAdd(int a, int b) => _safeInt(BigInt.from(a) + BigInt.from(b));

int _safeSum(Iterable<int> values) => _safeInt(
  values.fold<BigInt>(
    BigInt.zero,
    (total, value) => total + BigInt.from(value),
  ),
);

int _safeInt(BigInt value) {
  const maxSafeWebInteger = 9007199254740991;
  if (value > BigInt.from(maxSafeWebInteger) ||
      value < BigInt.from(-maxSafeWebInteger)) {
    throw const ShoppingListCalculationException();
  }
  return value.toInt();
}

class ShoppingListCalculationException implements Exception {
  const ShoppingListCalculationException();
}
