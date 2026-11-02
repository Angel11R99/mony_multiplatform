import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/obligations/data/drift_obligation_repository.dart';
import 'package:mony_multiplatform/features/shopping_lists/data/drift_shopping_list_repository.dart';
import 'package:mony_multiplatform/features/shopping_lists/domain/shopping_list.dart';
import 'package:mony_multiplatform/features/shopping_lists/domain/shopping_list_repository.dart';

void main() {
  late AppDatabase database;
  late DriftShoppingListRepository repository;
  final now = DateTime(2026, 11, 2);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftShoppingListRepository(database);
  });
  tearDown(() => database.close());

  Future<int> createList({String name = 'Mercado'}) => repository.create(
    ShoppingList(name: name, createdAt: now, updatedAt: now),
  );

  Future<void> addPurchasedItem(int listId) => repository.saveItem(
    ShoppingListItem(
      shoppingListId: listId,
      name: 'Arroz',
      quantity: 2,
      estimatedUnitPriceInCents: 1200,
      actualUnitPriceInCents: 1250,
      isPurchased: true,
      createdAt: now,
      updatedAt: now,
    ),
  );

  test(
    'persists live overview totals and duplicates a clean shopping list',
    () async {
      final listId = await createList();
      await addPurchasedItem(listId);
      await repository.saveAdjustment(
        ShoppingAdjustment(
          shoppingListId: listId,
          name: 'Cupón',
          isPositive: false,
          amountInCents: 100,
          createdAt: now,
        ),
      );

      final overview = (await repository.watchOverviews().first).single;
      expect(overview.itemCount, 1);
      expect(overview.totalInCents, 2400);

      final duplicateId = await repository.duplicate(listId);
      final duplicate = (await repository.getDetails(duplicateId!))!;
      expect(duplicate.list.name, 'Mercado (copia)');
      expect(duplicate.list.status, ShoppingListStatus.pending);
      expect(duplicate.items.single.isPurchased, isFalse);
      expect(duplicate.items.single.actualUnitPriceInCents, isNull);
      expect(duplicate.items.single.estimatedUnitPriceInCents, 1200);
      expect(duplicate.adjustments.single.amountInCents, 100);
    },
  );

  test(
    'finalizes a cash purchase once and reopening removes the linked expense',
    () async {
      final listId = await createList();
      await addPurchasedItem(listId);
      final transactionId = await repository.finalizePurchase(
        listId: listId,
        categoryId: 6,
        purchaseDate: now,
        paymentMethodId: 1,
      );

      final transaction = await (database.select(
        database.transactions,
      )..where((row) => row.id.equals(transactionId))).getSingle();
      final completed = (await repository.getDetails(listId))!;
      expect(transaction.amountInCents, 2500);
      expect(transaction.description, 'Mercado');
      expect(completed.list.status, ShoppingListStatus.completed);
      expect(completed.list.expenseTransactionId, transactionId);
      expect(await database.select(database.transactions).get(), hasLength(1));

      await repository.reopen(listId);
      final reopened = (await repository.getDetails(listId))!;
      expect(reopened.list.status, ShoppingListStatus.shopping);
      expect(reopened.items.single.isPurchased, isTrue);
      expect(await database.select(database.transactions).get(), isEmpty);
    },
  );

  test(
    'credit checkout creates an obligation without booking an expense',
    () async {
      final listId = await createList(name: 'Compra a crédito');
      await addPurchasedItem(listId);
      final payableId = await repository.finalizePurchase(
        listId: listId,
        categoryId: 6,
        purchaseDate: now,
        paymentMethodId: 3,
      );

      final payable = await (database.select(
        database.obligations,
      )..where((row) => row.id.equals(payableId))).getSingle();
      expect(payable.amountInCents, 2500);
      expect(payable.direction, 'payable');
      expect(payable.sourceShoppingListId, listId);
      expect(payable.isCancelled, isFalse);
      expect(await database.select(database.transactions).get(), isEmpty);

      await repository.reopen(listId);
      expect(await database.select(database.obligations).get(), isEmpty);
    },
  );

  test(
    'reopening a credit purchase waits until its abonos are removed',
    () async {
      final listId = await createList(name: 'Compra con abonos');
      await addPurchasedItem(listId);
      final obligationId = await repository.finalizePurchase(
        listId: listId,
        categoryId: 6,
        purchaseDate: now,
        paymentMethodId: 3,
      );
      final obligations = DriftObligationRepository(database);
      final paymentId = await obligations.recordPayment(
        obligationId: obligationId,
        amountInCents: 1000,
        date: now,
        paymentMethodId: 1,
      );

      await expectLater(
        repository.reopen(listId),
        throwsA(isA<ShoppingListException>()),
      );
      await obligations.deletePayment(paymentId);
      await repository.reopen(listId);
      expect(await database.select(database.obligations).get(), isEmpty);
      expect(await database.select(database.transactions).get(), isEmpty);
    },
  );

  test(
    'requires all actual prices and an active expense category at checkout',
    () async {
      final listId = await createList();
      await repository.saveItem(
        ShoppingListItem(
          shoppingListId: listId,
          name: 'Leche',
          estimatedUnitPriceInCents: 500,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await expectLater(
        repository.finalizePurchase(
          listId: listId,
          categoryId: 6,
          purchaseDate: now,
          paymentMethodId: 1,
        ),
        throwsA(isA<ShoppingListException>()),
      );
      await expectLater(
        repository.finalizePurchase(
          listId: listId,
          categoryId: 1,
          purchaseDate: now,
          paymentMethodId: 1,
        ),
        throwsA(isA<ShoppingListException>()),
      );
    },
  );
}
