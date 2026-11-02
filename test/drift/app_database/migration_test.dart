// dart format width=80
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  group('schema migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (index, fromVersion) in versions.indexed) {
      group('from v$fromVersion', () {
        for (final toVersion in versions.skip(index + 1)) {
          test('migrates to v$toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final database = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(database, toVersion);
            await database.close();
          });
        }
      });
    }
  });

  test('v1 to v2 keeps categories and seeds payment methods', () async {
    const oldCategories = <v1.CategoriesData>[
      v1.CategoriesData(
        id: 201,
        name: 'Mascotas',
        normalizedName: 'mascotas',
        type: 'expense',
        icon: 'pets',
        colorArgb: 0xFF0891B2,
        isActive: 1,
        createdAt: 1_762_000_000,
      ),
    ];
    const expectedCategories = <v2.CategoriesData>[
      v2.CategoriesData(
        id: 201,
        name: 'Mascotas',
        normalizedName: 'mascotas',
        type: 'expense',
        icon: 'pets',
        colorArgb: 0xFF0891B2,
        isActive: 1,
        createdAt: 1_762_000_000,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDatabase) {
        batch.insertAll(oldDatabase.categories, oldCategories);
      },
      validateItems: (database) async {
        expect(
          expectedCategories,
          await database.select(database.categories).get(),
        );
        final methods = await database.select(database.paymentMethods).get();
        expect(methods.map((method) => method.name).toSet(), {
          'Efectivo',
          'Débito',
          'Crédito',
        });
        expect(methods.where((method) => method.isDefault == 1), hasLength(1));
        expect(
          methods.singleWhere((method) => method.isDefault == 1).name,
          'Efectivo',
        );
      },
    );
  });

  test('v2 to v3 preserves category and payment method IDs', () async {
    const oldCategories = <v2.CategoriesData>[
      v2.CategoriesData(
        id: 315,
        name: 'Transporte',
        normalizedName: 'transporte',
        type: 'expense',
        icon: 'directions_car',
        colorArgb: 0xFF3B82F6,
        isActive: 1,
        createdAt: 1_762_000_000,
      ),
    ];
    const oldMethods = <v2.PaymentMethodsData>[
      v2.PaymentMethodsData(
        id: 91,
        name: 'Tarjeta local',
        normalizedName: 'tarjeta local',
        icon: 'debit_card',
        colorArgb: 0xFF3B82F6,
        isActive: 1,
        isDefault: 0,
        createdAt: 1_762_000_000,
      ),
    ];
    const expectedCategories = <v3.CategoriesData>[
      v3.CategoriesData(
        id: 315,
        name: 'Transporte',
        normalizedName: 'transporte',
        type: 'expense',
        icon: 'directions_car',
        colorArgb: 0xFF3B82F6,
        isActive: 1,
        createdAt: 1_762_000_000,
      ),
    ];
    const expectedMethods = <v3.PaymentMethodsData>[
      v3.PaymentMethodsData(
        id: 91,
        name: 'Tarjeta local',
        normalizedName: 'tarjeta local',
        icon: 'debit_card',
        colorArgb: 0xFF3B82F6,
        isActive: 1,
        isDefault: 0,
        createdAt: 1_762_000_000,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDatabase) {
        batch.insertAll(oldDatabase.categories, oldCategories);
        batch.insertAll(oldDatabase.paymentMethods, oldMethods);
      },
      validateItems: (database) async {
        expect(
          expectedCategories,
          await database.select(database.categories).get(),
        );
        expect(
          expectedMethods,
          await database.select(database.paymentMethods).get(),
        );
        expect(await database.select(database.transactions).get(), isEmpty);
      },
    );
  });
}
