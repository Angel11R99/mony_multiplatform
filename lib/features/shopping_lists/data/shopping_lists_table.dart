// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../../categories/data/categories_table.dart';
import '../../payment_methods/data/payment_methods_table.dart';
import '../../transactions/data/transactions_table.dart';

@DataClassName('ShoppingListRow')
@TableIndex.sql(
  'CREATE UNIQUE INDEX shopping_lists_expense_idx ON shopping_lists (expense_transaction_id) WHERE expense_transaction_id IS NOT NULL',
)
class ShoppingLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get status => text().withLength(min: 1, max: 20)();
  IntColumn get budgetInCents => integer().nullable()();
  IntColumn get expenseTransactionId => integer().nullable().references(
    Transactions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get payableId => integer().nullable()();
  IntColumn get purchaseDateEpochDay => integer().nullable()();
  IntColumn get paymentMethodId => integer().nullable().references(
    PaymentMethods,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get expenseCategoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

@DataClassName('ShoppingListItemRow')
@TableIndex(name: 'shopping_list_items_list_idx', columns: {#shoppingListId})
class ShoppingListItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shoppingListId =>
      integer().references(ShoppingLists, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get quantity => integer().check(quantity.isBiggerOrEqualValue(1))();
  IntColumn get estimatedUnitPriceInCents => integer().nullable()();
  IntColumn get actualUnitPriceInCents => integer().nullable()();
  BoolColumn get isPurchased => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get barcode => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('ShoppingAdjustmentRow')
@TableIndex(name: 'shopping_adjustments_list_idx', columns: {#shoppingListId})
class ShoppingAdjustments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shoppingListId =>
      integer().references(ShoppingLists, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  BoolColumn get isPositive => boolean()();
  IntColumn get amountInCents =>
      integer().check(amountInCents.isBiggerThanValue(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Credit purchases remain pending until the obligations module settles them.
@DataClassName('ShoppingPayableRow')
class ShoppingPayables extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shoppingListId => integer().unique().references(
    ShoppingLists,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get amountInCents =>
      integer().check(amountInCents.isBiggerThanValue(0))();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.restrict)();
  IntColumn get paymentMethodId =>
      integer().references(PaymentMethods, #id, onDelete: KeyAction.restrict)();
  IntColumn get dateEpochDay => integer()();
  TextColumn get description => text().withLength(min: 1, max: 160)();
  BoolColumn get isSettled => boolean().withDefault(const Constant(false))();
  IntColumn get transactionId => integer().nullable().references(
    Transactions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
