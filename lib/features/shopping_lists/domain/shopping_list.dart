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
  ShoppingListDetails({
    required this.list,
    required List<ShoppingListItem> items,
    required List<ShoppingAdjustment> adjustments,
  }) : items = List.unmodifiable(items),
       adjustments = List.unmodifiable(adjustments) {
    var estimatedSubtotal = BigInt.zero;
    var purchasedSubtotal = BigInt.zero;
    var finalizableSubtotal = BigInt.zero;
    var adjustmentTotal = BigInt.zero;
    var purchasedCount = 0;
    final missingPrices = <ShoppingListItem>[];
    for (final item in this.items) {
      estimatedSubtotal += BigInt.from(
        _lineTotal(item.quantity, item.estimatedUnitPriceInCents),
      );
      final actualLine = BigInt.from(
        _lineTotal(item.quantity, item.actualUnitPriceInCents),
      );
      finalizableSubtotal += actualLine;
      if (item.isPurchased) {
        purchasedCount++;
        purchasedSubtotal += actualLine;
      }
      if (item.actualUnitPriceInCents == null) missingPrices.add(item);
    }
    for (final adjustment in this.adjustments) {
      final amount = BigInt.from(adjustment.amountInCents);
      adjustmentTotal += adjustment.isPositive ? amount : -amount;
    }
    estimatedSubtotalInCents = _safeInt(estimatedSubtotal);
    purchasedSubtotalInCents = _safeInt(purchasedSubtotal);
    finalizableSubtotalInCents = _safeInt(finalizableSubtotal);
    adjustmentTotalInCents = _safeInt(adjustmentTotal);
    purchasedItemCount = purchasedCount;
    missingActualPriceItems = List.unmodifiable(missingPrices);
  }

  final ShoppingList list;
  final List<ShoppingListItem> items;
  final List<ShoppingAdjustment> adjustments;

  late final int estimatedSubtotalInCents;
  late final int purchasedSubtotalInCents;
  late final int finalizableSubtotalInCents;
  late final int adjustmentTotalInCents;
  late final int purchasedItemCount;
  late final List<ShoppingListItem> missingActualPriceItems;

  int get actualTotalInCents =>
      _safeAdd(purchasedSubtotalInCents, adjustmentTotalInCents);
  int get finalizableTotalInCents =>
      _safeAdd(finalizableSubtotalInCents, adjustmentTotalInCents);
  int? get remainingBudgetInCents => list.budgetInCents == null
      ? null
      : _safeAdd(list.budgetInCents!, -actualTotalInCents);
  int get pendingItemCount => items.length - purchasedItemCount;
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
