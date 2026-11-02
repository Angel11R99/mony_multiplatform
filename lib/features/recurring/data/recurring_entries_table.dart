// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../../categories/data/categories_table.dart';
import '../../payment_methods/data/payment_methods_table.dart';

@DataClassName('RecurringEntryRow')
@TableIndex(
  name: 'recurring_entries_active_next_idx',
  columns: {#isActive, #nextDateEpochDay},
)
class RecurringEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  IntColumn get amountInCents =>
      integer().check(amountInCents.isBiggerThanValue(0))();
  TextColumn get type => text().withLength(min: 1, max: 10)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.restrict)();
  IntColumn get paymentMethodId =>
      integer().references(PaymentMethods, #id, onDelete: KeyAction.restrict)();
  TextColumn get frequency => text().withLength(min: 1, max: 10)();
  IntColumn get interval => integer().withDefault(const Constant(1))();
  IntColumn get startDateEpochDay => integer()();
  IntColumn get nextDateEpochDay => integer()();
  IntColumn get endDateEpochDay => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
