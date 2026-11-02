import 'package:drift/drift.dart';

@DataClassName('SavingsGoalRow')
@TableIndex(name: 'savings_goals_completed_idx', columns: {#completedAt})
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get targetAmountInCents =>
      integer().check(targetAmountInCents.isBiggerThanValue(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

// ignore_for_file: recursive_getters
