import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../categories/domain/category.dart';
import '../../obligations/domain/obligation.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/shopping_list.dart';
import '../domain/shopping_list_repository.dart';
import '../domain/shopping_list_validator.dart';

class DriftShoppingListRepository implements ShoppingListRepository {
  const DriftShoppingListRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<ShoppingListOverview>> watchOverviews() => _database
      .customSelect(
        '''SELECT shopping_lists.*,
          (SELECT COUNT(*) FROM shopping_list_items
            WHERE shopping_list_id = shopping_lists.id) AS item_count,
          COALESCE((SELECT SUM(quantity * actual_unit_price_in_cents)
            FROM shopping_list_items WHERE shopping_list_id = shopping_lists.id
              AND is_purchased = 1 AND actual_unit_price_in_cents IS NOT NULL), 0)
          + COALESCE((SELECT SUM(CASE WHEN is_positive = 1 THEN amount_in_cents
            ELSE -amount_in_cents END) FROM shopping_adjustments
            WHERE shopping_list_id = shopping_lists.id), 0) AS total_in_cents
          FROM shopping_lists
          ORDER BY CASE status WHEN 'shopping' THEN 0 WHEN 'pending' THEN 1 ELSE 2 END,
            updated_at DESC''',
        readsFrom: {
          _database.shoppingLists,
          _database.shoppingListItems,
          _database.shoppingAdjustments,
        },
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => ShoppingListOverview(
                list: _fromListRow(_readListRow(row)),
                itemCount: row.read<int>('item_count'),
                totalInCents: row.read<int>('total_in_cents'),
              ),
            )
            .toList(growable: false),
      );

  @override
  Stream<ShoppingListDetails?> watchDetails(int listId) {
    return Stream<ShoppingListDetails?>.multi((controller) {
      ShoppingListRow? list;
      List<ShoppingListItemRow> items = const [];
      List<ShoppingAdjustmentRow> adjustments = const [];
      var listReady = false;
      var itemsReady = false;
      var adjustmentsReady = false;
      void emit() {
        if (!listReady || !itemsReady || !adjustmentsReady) return;
        controller.add(
          list == null
              ? null
              : ShoppingListDetails(
                  list: _fromListRow(list!),
                  items: items.map(_fromItemRow).toList(growable: false),
                  adjustments: adjustments
                      .map(_fromAdjustmentRow)
                      .toList(growable: false),
                ),
        );
      }

      final listSubscription =
          (_database.select(_database.shoppingLists)
                ..where((row) => row.id.equals(listId)))
              .watchSingleOrNull()
              .listen((value) {
                list = value;
                listReady = true;
                emit();
              }, onError: controller.addError);
      final itemSubscription =
          (_database.select(_database.shoppingListItems)
                ..where((row) => row.shoppingListId.equals(listId))
                ..orderBy([
                  (row) => OrderingTerm.asc(row.isPurchased),
                  (row) => OrderingTerm.asc(row.createdAt),
                ]))
              .watch()
              .listen((value) {
                items = value;
                itemsReady = true;
                emit();
              }, onError: controller.addError);
      final adjustmentSubscription =
          (_database.select(_database.shoppingAdjustments)
                ..where((row) => row.shoppingListId.equals(listId))
                ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
              .watch()
              .listen((value) {
                adjustments = value;
                adjustmentsReady = true;
                emit();
              }, onError: controller.addError);
      controller.onCancel = () async {
        await listSubscription.cancel();
        await itemSubscription.cancel();
        await adjustmentSubscription.cancel();
      };
    });
  }

  @override
  Future<ShoppingListDetails?> getDetails(int listId) async {
    final list = await (_database.select(
      _database.shoppingLists,
    )..where((row) => row.id.equals(listId))).getSingleOrNull();
    if (list == null) return null;
    final items =
        await (_database.select(_database.shoppingListItems)
              ..where((row) => row.shoppingListId.equals(listId))
              ..orderBy([
                (row) => OrderingTerm.asc(row.isPurchased),
                (row) => OrderingTerm.asc(row.createdAt),
              ]))
            .get();
    final adjustments =
        await (_database.select(_database.shoppingAdjustments)
              ..where((row) => row.shoppingListId.equals(listId))
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
            .get();
    return ShoppingListDetails(
      list: _fromListRow(list),
      items: items.map(_fromItemRow).toList(growable: false),
      adjustments: adjustments.map(_fromAdjustmentRow).toList(growable: false),
    );
  }

  @override
  Future<int> create(ShoppingList list) async {
    final name = list.name.trim();
    if (name.isEmpty) {
      throw const ShoppingListException('Escribe un nombre para la lista.');
    }
    if (list.budgetInCents != null && list.budgetInCents! < 0) {
      throw const ShoppingListException(
        'El presupuesto no puede ser negativo.',
      );
    }
    return _database
        .into(_database.shoppingLists)
        .insert(
          ShoppingListsCompanion.insert(
            name: name,
            status: 'pending',
            budgetInCents: Value(list.budgetInCents),
            createdAt: Value(list.createdAt),
            updatedAt: Value(list.updatedAt),
          ),
        );
  }

  @override
  Future<void> update(ShoppingList list) async {
    final name = list.name.trim();
    if (name.isEmpty) {
      throw const ShoppingListException(
        'El nombre de la lista es obligatorio.',
      );
    }
    if (list.budgetInCents != null && list.budgetInCents! < 0) {
      throw const ShoppingListException(
        'El presupuesto no puede ser negativo.',
      );
    }
    final row = await (_database.select(
      _database.shoppingLists,
    )..where((item) => item.id.equals(list.id))).getSingleOrNull();
    if (row == null) {
      throw const ShoppingListException('La lista ya no existe.');
    }
    if (row.status == ShoppingListStatus.completed.name) {
      throw const ShoppingListException(
        'Reabre la lista para editar sus datos.',
      );
    }
    await (_database.update(
      _database.shoppingLists,
    )..where((item) => item.id.equals(list.id))).write(
      ShoppingListsCompanion(
        name: Value(name),
        budgetInCents: Value(list.budgetInCents),
        status: Value(list.status.name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(int listId) async {
    final row = await (_database.select(
      _database.shoppingLists,
    )..where((item) => item.id.equals(listId))).getSingleOrNull();
    if (row == null) {
      throw const ShoppingListException('La lista ya no existe.');
    }
    if (row.status == ShoppingListStatus.completed.name) {
      throw const ShoppingListException('Reabre la lista antes de eliminarla.');
    }
    await (_database.delete(
      _database.shoppingLists,
    )..where((item) => item.id.equals(listId))).go();
  }

  @override
  Future<int> saveItem(ShoppingListItem item) async {
    _validateItem(item);
    final list = await (_database.select(
      _database.shoppingLists,
    )..where((row) => row.id.equals(item.shoppingListId))).getSingleOrNull();
    if (list == null) {
      throw const ShoppingListException('La lista ya no existe.');
    }
    final id = await _database.transaction(() async {
      if (item.id == 0) {
        return _database
            .into(_database.shoppingListItems)
            .insert(
              ShoppingListItemsCompanion.insert(
                shoppingListId: item.shoppingListId,
                name: item.name.trim(),
                quantity: item.quantity,
                estimatedUnitPriceInCents: Value(
                  item.estimatedUnitPriceInCents,
                ),
                actualUnitPriceInCents: Value(item.actualUnitPriceInCents),
                isPurchased: Value(item.isPurchased),
                notes: Value(_emptyToNull(item.notes)),
                createdAt: Value(item.createdAt),
                updatedAt: Value(DateTime.now()),
              ),
            );
      }
      final current = await (_database.select(
        _database.shoppingListItems,
      )..where((row) => row.id.equals(item.id))).getSingleOrNull();
      if (current == null || current.shoppingListId != item.shoppingListId) {
        throw const ShoppingListException('El producto ya no existe.');
      }
      await (_database.update(
        _database.shoppingListItems,
      )..where((row) => row.id.equals(item.id))).write(
        ShoppingListItemsCompanion(
          name: Value(item.name.trim()),
          quantity: Value(item.quantity),
          estimatedUnitPriceInCents: Value(item.estimatedUnitPriceInCents),
          actualUnitPriceInCents: Value(item.actualUnitPriceInCents),
          isPurchased: Value(item.isPurchased),
          notes: Value(_emptyToNull(item.notes)),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return item.id;
    });
    await _touch(list.id);
    if (list.status == ShoppingListStatus.completed.name) {
      await _syncCompletedPurchase(list.id);
    }
    return id;
  }

  @override
  Future<void> deleteItem(int itemId) async {
    final item = await (_database.select(
      _database.shoppingListItems,
    )..where((row) => row.id.equals(itemId))).getSingleOrNull();
    if (item == null) {
      throw const ShoppingListException('El producto ya no existe.');
    }
    final list = await _getList(item.shoppingListId);
    await (_database.delete(
      _database.shoppingListItems,
    )..where((row) => row.id.equals(itemId))).go();
    await _touch(list.id);
    if (list.status == ShoppingListStatus.completed.name) {
      await _syncCompletedPurchase(list.id);
    }
  }

  @override
  Future<int> saveAdjustment(ShoppingAdjustment adjustment) async {
    final name = adjustment.name.trim();
    final validationError = ShoppingListValidator.validateAdjustment(
      name,
      adjustment.amountInCents,
    );
    if (validationError != null) {
      throw ShoppingListException(validationError);
    }
    final list = await _getList(adjustment.shoppingListId);
    final id = await _database.transaction(() async {
      if (adjustment.id == 0) {
        return _database
            .into(_database.shoppingAdjustments)
            .insert(
              ShoppingAdjustmentsCompanion.insert(
                shoppingListId: adjustment.shoppingListId,
                name: name,
                isPositive: adjustment.isPositive,
                amountInCents: adjustment.amountInCents,
                createdAt: Value(adjustment.createdAt),
              ),
            );
      }
      final current = await (_database.select(
        _database.shoppingAdjustments,
      )..where((row) => row.id.equals(adjustment.id))).getSingleOrNull();
      if (current == null ||
          current.shoppingListId != adjustment.shoppingListId) {
        throw const ShoppingListException('El ajuste ya no existe.');
      }
      await (_database.update(
        _database.shoppingAdjustments,
      )..where((row) => row.id.equals(adjustment.id))).write(
        ShoppingAdjustmentsCompanion(
          name: Value(name),
          isPositive: Value(adjustment.isPositive),
          amountInCents: Value(adjustment.amountInCents),
        ),
      );
      return adjustment.id;
    });
    await _touch(list.id);
    if (list.status == ShoppingListStatus.completed.name) {
      await _syncCompletedPurchase(list.id);
    }
    return id;
  }

  @override
  Future<void> deleteAdjustment(int adjustmentId) async {
    final adjustment = await (_database.select(
      _database.shoppingAdjustments,
    )..where((row) => row.id.equals(adjustmentId))).getSingleOrNull();
    if (adjustment == null) {
      throw const ShoppingListException('El ajuste ya no existe.');
    }
    final list = await _getList(adjustment.shoppingListId);
    await (_database.delete(
      _database.shoppingAdjustments,
    )..where((row) => row.id.equals(adjustmentId))).go();
    await _touch(list.id);
    if (list.status == ShoppingListStatus.completed.name) {
      await _syncCompletedPurchase(list.id);
    }
  }

  @override
  Future<int?> duplicate(int listId) async {
    final details = await getDetails(listId);
    if (details == null) return null;
    final now = DateTime.now();
    return _database.transaction(() async {
      final newId = await _database
          .into(_database.shoppingLists)
          .insert(
            ShoppingListsCompanion.insert(
              name: '${details.list.name} (copia)'.substring(
                0,
                '${details.list.name} (copia)'.length.clamp(0, 80),
              ),
              status: 'pending',
              budgetInCents: Value(details.list.budgetInCents),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      for (final item in details.items) {
        await _database
            .into(_database.shoppingListItems)
            .insert(
              ShoppingListItemsCompanion.insert(
                shoppingListId: newId,
                name: item.name,
                quantity: item.quantity,
                estimatedUnitPriceInCents: Value(
                  item.estimatedUnitPriceInCents,
                ),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      }
      for (final adjustment in details.adjustments) {
        await _database
            .into(_database.shoppingAdjustments)
            .insert(
              ShoppingAdjustmentsCompanion.insert(
                shoppingListId: newId,
                name: adjustment.name,
                isPositive: adjustment.isPositive,
                amountInCents: adjustment.amountInCents,
                createdAt: Value(now),
              ),
            );
      }
      return newId;
    });
  }

  @override
  Future<int> finalizePurchase({
    required int listId,
    required int categoryId,
    required DateTime purchaseDate,
    required int paymentMethodId,
  }) async => _database.transaction(() async {
    final list = await _getList(listId);
    if (list.status == ShoppingListStatus.completed.name) {
      throw const ShoppingListException('Esta compra ya fue finalizada.');
    }
    final category = await (_database.select(
      _database.categories,
    )..where((row) => row.id.equals(categoryId))).getSingleOrNull();
    if (category == null ||
        category.type != CategoryType.expense.name ||
        !category.isActive) {
      throw const ShoppingListException(
        'Selecciona una categoría de gasto activa.',
      );
    }
    final method = await (_database.select(
      _database.paymentMethods,
    )..where((row) => row.id.equals(paymentMethodId))).getSingleOrNull();
    if (method == null || !method.isActive) {
      throw const ShoppingListException('Selecciona un método de pago activo.');
    }
    final details = await getDetails(listId);
    if (details == null) {
      throw const ShoppingListException('La lista ya no existe.');
    }
    if (details.items.isEmpty) {
      throw const ShoppingListException(
        'Agrega productos antes de finalizar la compra.',
      );
    }
    if (details.missingActualPriceItems.isNotEmpty) {
      throw ShoppingListException(
        'Falta el precio real de ${details.missingActualPriceItems.length} producto(s).',
      );
    }
    final total = details.finalizableTotalInCents;
    if (total <= 0) {
      throw const ShoppingListException('El total debe ser mayor que cero.');
    }
    final now = DateTime.now();
    await (_database.update(_database.shoppingListItems)
          ..where((row) => row.shoppingListId.equals(listId)))
        .write(ShoppingListItemsCompanion(isPurchased: const Value(true)));
    await (_database.update(
      _database.shoppingLists,
    )..where((row) => row.id.equals(listId))).write(
      ShoppingListsCompanion(
        status: const Value('completed'),
        purchaseDateEpochDay: Value(dateToEpochDay(purchaseDate)),
        paymentMethodId: Value(paymentMethodId),
        expenseCategoryId: Value(categoryId),
        completedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    return _syncCompletedPurchase(listId);
  });

  @override
  Future<void> reopen(int listId) async => _database.transaction(() async {
    final list = await _getList(listId);
    if (list.status != ShoppingListStatus.completed.name) {
      throw const ShoppingListException('La lista no está finalizada.');
    }
    final legacyPayable = await (_database.select(
      _database.shoppingPayables,
    )..where((row) => row.shoppingListId.equals(listId))).getSingleOrNull();
    final obligation =
        await (_database.select(_database.obligations)
              ..where((row) => row.sourceShoppingListId.equals(listId)))
            .getSingleOrNull();
    if (obligation != null &&
        await (_database.select(_database.obligationPayments)
              ..where((row) => row.obligationId.equals(obligation.id)))
            .get()
            .then((payments) => payments.isNotEmpty)) {
      throw const ShoppingListException(
        'Elimina los abonos de la obligación antes de reabrir la compra.',
      );
    }
    final transactionId =
        legacyPayable?.transactionId ?? list.expenseTransactionId;
    if (transactionId != null) {
      await (_database.delete(
        _database.transactions,
      )..where((row) => row.id.equals(transactionId))).go();
    }
    if (obligation != null) {
      await (_database.delete(
        _database.obligations,
      )..where((row) => row.id.equals(obligation.id))).go();
    }
    if (legacyPayable != null) {
      await (_database.delete(
        _database.shoppingPayables,
      )..where((row) => row.id.equals(legacyPayable.id))).go();
    }
    await (_database.update(
      _database.shoppingLists,
    )..where((row) => row.id.equals(listId))).write(
      ShoppingListsCompanion(
        status: const Value('shopping'),
        payableId: const Value(null),
        expenseTransactionId: const Value(null),
        purchaseDateEpochDay: const Value(null),
        paymentMethodId: const Value(null),
        expenseCategoryId: const Value(null),
        completedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  });

  Future<int> _syncCompletedPurchase(int listId) async {
    final list = await _getList(listId);
    final categoryId = list.expenseCategoryId;
    final methodId = list.paymentMethodId;
    final dateEpoch = list.purchaseDateEpochDay;
    if (categoryId == null || methodId == null || dateEpoch == null) {
      throw const ShoppingListException(
        'Completa categoría, fecha y método de pago.',
      );
    }
    final details = await getDetails(listId);
    if (details == null) {
      throw const ShoppingListException('La lista ya no existe.');
    }
    final total = details.actualTotalInCents;
    if (total <= 0) {
      throw const ShoppingListException(
        'El total de la compra debe ser mayor que cero.',
      );
    }
    final method = await (_database.select(
      _database.paymentMethods,
    )..where((row) => row.id.equals(methodId))).getSingleOrNull();
    if (method == null) {
      throw const ShoppingListException('El método de pago ya no existe.');
    }
    final isCredit =
        method.normalizedName.contains('credit') ||
        method.normalizedName.contains('crédito') ||
        method.normalizedName.contains('credito');
    final now = DateTime.now();
    if (isCredit) {
      if (list.expenseTransactionId != null) {
        await (_database.delete(
          _database.transactions,
        )..where((row) => row.id.equals(list.expenseTransactionId!))).go();
      }
      final existing =
          await (_database.select(_database.obligations)
                ..where((row) => row.sourceShoppingListId.equals(listId)))
              .getSingleOrNull();
      final paidAmount = existing == null
          ? 0
          : (await (_database.select(
                  _database.obligationPayments,
                )..where((row) => row.obligationId.equals(existing.id))).get())
                .fold<int>(
                  0,
                  (total, payment) => total + payment.amountInCents,
                );
      if (existing != null &&
          paidAmount > 0 &&
          (existing.amountInCents != total ||
              existing.categoryId != categoryId)) {
        throw const ShoppingListException(
          'El importe y la categoría no se pueden cambiar después de registrar abonos.',
        );
      }
      if (paidAmount > total) {
        throw const ShoppingListException(
          'El nuevo total no puede quedar por debajo de los abonos registrados.',
        );
      }
      final payableId = existing == null
          ? await _database
                .into(_database.obligations)
                .insert(
                  ObligationsCompanion.insert(
                    direction: ObligationDirection.payable.name,
                    title: list.name,
                    amountInCents: total,
                    categoryId: categoryId,
                    defaultPaymentMethodId: Value(methodId),
                    sourceShoppingListId: Value(listId),
                    createdAt: Value(now),
                    updatedAt: Value(now),
                  ),
                )
          : existing.id;
      if (existing != null) {
        await (_database.update(
          _database.obligations,
        )..where((row) => row.id.equals(existing.id))).write(
          ObligationsCompanion(
            title: Value(list.name),
            amountInCents: Value(total),
            categoryId: Value(categoryId),
            defaultPaymentMethodId: Value(methodId),
            updatedAt: Value(now),
          ),
        );
      }
      await (_database.update(
        _database.shoppingLists,
      )..where((row) => row.id.equals(listId))).write(
        ShoppingListsCompanion(
          payableId: Value(payableId),
          expenseTransactionId: const Value(null),
        ),
      );
      return payableId;
    }

    final existing = list.expenseTransactionId == null
        ? null
        : await (_database.select(_database.transactions)
                ..where((row) => row.id.equals(list.expenseTransactionId!)))
              .getSingleOrNull();
    final linkedObligation =
        await (_database.select(_database.obligations)
              ..where((row) => row.sourceShoppingListId.equals(listId)))
            .getSingleOrNull();
    if (linkedObligation != null) {
      final payments = await (_database.select(
        _database.obligationPayments,
      )..where((row) => row.obligationId.equals(linkedObligation.id))).get();
      if (payments.isNotEmpty) {
        throw const ShoppingListException(
          'Elimina los abonos de la obligación antes de cambiar el método de pago.',
        );
      }
      await (_database.delete(
        _database.obligations,
      )..where((row) => row.id.equals(linkedObligation.id))).go();
    }
    final legacyPayable = await (_database.select(
      _database.shoppingPayables,
    )..where((row) => row.shoppingListId.equals(listId))).getSingleOrNull();
    if (legacyPayable != null) {
      await (_database.delete(
        _database.shoppingPayables,
      )..where((row) => row.id.equals(legacyPayable.id))).go();
    }
    final transactionValues = TransactionsCompanion(
      amountInCents: Value(total),
      type: const Value('expense'),
      categoryId: Value(categoryId),
      paymentMethodId: Value(methodId),
      description: Value(list.name),
      dateEpochDay: Value(dateEpoch),
      updatedAt: Value(now),
    );
    final transactionId = existing == null
        ? await _database
              .into(_database.transactions)
              .insert(
                TransactionsCompanion.insert(
                  amountInCents: total,
                  type: 'expense',
                  categoryId: categoryId,
                  paymentMethodId: methodId,
                  description: Value(list.name),
                  dateEpochDay: dateEpoch,
                  createdAt: Value(now),
                  updatedAt: Value(now),
                ),
              )
        : existing.id;
    if (existing != null) {
      await (_database.update(
        _database.transactions,
      )..where((row) => row.id.equals(existing.id))).write(transactionValues);
    }
    final oldPayable = await (_database.select(
      _database.shoppingPayables,
    )..where((row) => row.shoppingListId.equals(listId))).getSingleOrNull();
    if (oldPayable != null) {
      await (_database.delete(
        _database.shoppingPayables,
      )..where((row) => row.id.equals(oldPayable.id))).go();
    }
    await (_database.update(
      _database.shoppingLists,
    )..where((row) => row.id.equals(listId))).write(
      ShoppingListsCompanion(
        expenseTransactionId: Value(transactionId),
        payableId: const Value(null),
      ),
    );
    return transactionId;
  }

  Future<ShoppingListRow> _getList(int id) async =>
      await (_database.select(
        _database.shoppingLists,
      )..where((row) => row.id.equals(id))).getSingleOrNull() ??
      (throw const ShoppingListException('La lista ya no existe.'));

  Future<void> _touch(int listId) async =>
      (_database.update(_database.shoppingLists)
            ..where((row) => row.id.equals(listId)))
          .write(ShoppingListsCompanion(updatedAt: Value(DateTime.now())));

  static void _validateItem(ShoppingListItem item) {
    if (item.name.trim().isEmpty ||
        item.name.trim().length > 100 ||
        item.quantity < 1) {
      throw const ShoppingListException(
        'El producto necesita un nombre y una cantidad válida.',
      );
    }
    if ((item.estimatedUnitPriceInCents ?? 0) < 0 ||
        (item.actualUnitPriceInCents ?? 0) < 0) {
      throw const ShoppingListException('Los precios no pueden ser negativos.');
    }
    try {
      ShoppingListDetails(
        list: ShoppingList(
          name: 'Validación',
          createdAt: DateTime(2000),
          updatedAt: DateTime(2000),
        ),
        items: [item],
        adjustments: const [],
      ).finalizableSubtotalInCents;
    } on ShoppingListCalculationException {
      throw const ShoppingListException(
        'El precio o la cantidad son demasiado grandes.',
      );
    }
  }

  static String? _emptyToNull(String? value) =>
      value?.trim().isEmpty == true ? null : value?.trim();

  static ShoppingList _fromListRow(ShoppingListRow row) => ShoppingList(
    id: row.id,
    name: row.name,
    status: ShoppingListStatus.values.byName(row.status),
    budgetInCents: row.budgetInCents,
    expenseTransactionId: row.expenseTransactionId,
    payableId: row.payableId,
    purchaseDate: row.purchaseDateEpochDay == null
        ? null
        : dateFromEpochDay(row.purchaseDateEpochDay!),
    paymentMethodId: row.paymentMethodId,
    expenseCategoryId: row.expenseCategoryId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    completedAt: row.completedAt,
  );

  static ShoppingListItem _fromItemRow(ShoppingListItemRow row) =>
      ShoppingListItem(
        id: row.id,
        shoppingListId: row.shoppingListId,
        name: row.name,
        quantity: row.quantity,
        estimatedUnitPriceInCents: row.estimatedUnitPriceInCents,
        actualUnitPriceInCents: row.actualUnitPriceInCents,
        isPurchased: row.isPurchased,
        notes: row.notes,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  static ShoppingAdjustment _fromAdjustmentRow(ShoppingAdjustmentRow row) =>
      ShoppingAdjustment(
        id: row.id,
        shoppingListId: row.shoppingListId,
        name: row.name,
        isPositive: row.isPositive,
        amountInCents: row.amountInCents,
        createdAt: row.createdAt,
      );

  static ShoppingListRow _readListRow(QueryRow row) => ShoppingListRow(
    id: row.read<int>('id'),
    name: row.read<String>('name'),
    status: row.read<String>('status'),
    budgetInCents: row.read<int?>('budget_in_cents'),
    expenseTransactionId: row.read<int?>('expense_transaction_id'),
    payableId: row.read<int?>('payable_id'),
    purchaseDateEpochDay: row.read<int?>('purchase_date_epoch_day'),
    paymentMethodId: row.read<int?>('payment_method_id'),
    expenseCategoryId: row.read<int?>('expense_category_id'),
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('created_at')),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('updated_at')),
    completedAt: row.read<int?>('completed_at') == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(row.read<int>('completed_at')),
  );
}
