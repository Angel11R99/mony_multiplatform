import 'package:drift/drift.dart';

@DataClassName('PaymentMethodRow')
@TableIndex.sql('''
  CREATE UNIQUE INDEX payment_methods_single_default
  ON payment_methods (is_default) WHERE is_default = 1;
''')
class PaymentMethods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get normalizedName => text().withLength(min: 1, max: 40)();
  TextColumn get icon => text().withLength(min: 1, max: 40)();
  IntColumn get colorArgb => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {normalizedName},
  ];
}
