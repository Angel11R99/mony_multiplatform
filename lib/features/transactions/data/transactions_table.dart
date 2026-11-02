import 'package:drift/drift.dart';

import '../../categories/data/categories_table.dart';
import '../../payment_methods/data/payment_methods_table.dart';

@DataClassName('FinanceTransactionRow')
@TableIndex(name: 'transactions_date_idx', columns: {#dateEpochDay})
@TableIndex(name: 'transactions_category_idx', columns: {#categoryId})
@TableIndex(
  name: 'transactions_payment_method_idx',
  columns: {#paymentMethodId},
)
@TableIndex(name: 'transactions_fixed_entry_idx', columns: {#fixedEntryId})
@TableIndex(name: 'transactions_savings_goal_idx', columns: {#savingsGoalId})
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountInCents =>
      integer().check(amountInCents.isBiggerThanValue(0))();
  TextColumn get type => text().withLength(min: 1, max: 10)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.restrict)();
  IntColumn get paymentMethodId =>
      integer().references(PaymentMethods, #id, onDelete: KeyAction.restrict)();
  TextColumn get description => text().nullable()();
  IntColumn get dateEpochDay => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get fixedEntryId => integer().nullable()();
  IntColumn get savingsGoalId => integer().nullable()();
}

// ignore_for_file: recursive_getters
