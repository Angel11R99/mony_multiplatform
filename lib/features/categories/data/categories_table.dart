import 'package:drift/drift.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get normalizedName => text().withLength(min: 1, max: 40)();
  TextColumn get type => text().withLength(min: 1, max: 10)();
  TextColumn get icon => text().withLength(min: 1, max: 40)();
  IntColumn get colorArgb => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get budgetLimitInCents => integer().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {type, normalizedName},
  ];
}
