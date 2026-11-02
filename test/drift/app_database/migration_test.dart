// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v1 to v2 does not corrupt data', () async {
    final oldCategoriesData = <v1.CategoriesData>[
      const v1.CategoriesData(
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
    final expectedNewCategoriesData = <v2.CategoriesData>[
      const v2.CategoriesData(
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
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.categories, oldCategoriesData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewCategoriesData,
          await newDb.select(newDb.categories).get(),
        );
        final methods = await newDb.select(newDb.paymentMethods).get();
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
}
