import 'package:drift/drift.dart';

@DataClassName('BudgetConfigRow')
class Budgets extends Table {
  IntColumn get id => integer()();
  IntColumn get amountInCents =>
      integer().check(amountInCents.isBiggerThanValue(0))();
  TextColumn get period => text().withLength(min: 1, max: 20)();
  IntColumn get cycleStartEpochDay => integer()();
  DateTimeColumn get cycleStartedAt => dateTime()();
  IntColumn get incomeTransactionId => integer().nullable()();
  TextColumn get cycleSchedulesJson => text()();
  BoolColumn get autoCloseEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get autoCloseMinuteOfDay => integer()
      .withDefault(const Constant(1260))
      .check(autoCloseMinuteOfDay.isBetweenValues(0, 1439))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('BudgetCycleRow')
@TableIndex(
  name: 'budget_cycles_start_end_idx',
  columns: {#startDateEpochDay, #endDateEpochDay},
)
class BudgetCycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get period => text().withLength(min: 1, max: 20)();
  IntColumn get budgetAmountInCents => integer()();
  IntColumn get incomeInCents => integer()();
  IntColumn get expenseInCents => integer()();
  IntColumn get startDateEpochDay => integer()();
  IntColumn get endDateEpochDay => integer()();
  DateTimeColumn get closedAt => dateTime()();
}

// ignore_for_file: recursive_getters
