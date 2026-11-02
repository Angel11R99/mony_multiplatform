// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../../categories/data/categories_table.dart';
import '../../payment_methods/data/payment_methods_table.dart';
import '../../shopping_lists/data/shopping_lists_table.dart';
import '../../transactions/data/transactions_table.dart';

@DataClassName('ObligationRow')
class Obligations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get direction => text().withLength(min: 1, max: 12)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get counterparty => text().nullable().withLength(max: 100)();
  IntColumn get amountInCents =>
      integer().check(amountInCents.isBiggerThanValue(0))();
  IntColumn get dueDateEpochDay => integer().nullable()();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.restrict)();
  IntColumn get defaultPaymentMethodId => integer().nullable().references(
    PaymentMethods,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get sourceShoppingListId => integer()
      .nullable()
      .unique()
      .references(ShoppingLists, #id, onDelete: KeyAction.setNull)();
  BoolColumn get isCancelled => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('ObligationPaymentRow')
@TableIndex(
  name: 'obligation_payments_obligation_idx',
  columns: {#obligationId},
)
class ObligationPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get obligationId =>
      integer().references(Obligations, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountInCents =>
      integer().check(amountInCents.isBiggerThanValue(0))();
  IntColumn get dateEpochDay => integer()();
  IntColumn get paymentMethodId =>
      integer().references(PaymentMethods, #id, onDelete: KeyAction.restrict)();
  IntColumn get transactionId => integer().nullable().unique().references(
    Transactions,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get note => text().nullable().withLength(max: 120)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
