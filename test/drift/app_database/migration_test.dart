// dart format width=80
import 'package:drift/drift.dart' hide isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;
import 'generated/schema_v5.dart' as v5;
import 'generated/schema_v6.dart' as v6;

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

  test(
    'v3 to v4 preserves existing finance data and starts with no goals',
    () async {
      const oldCategories = <v3.CategoriesData>[
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
      const oldMethods = <v3.PaymentMethodsData>[
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
      const oldTransactions = <v3.TransactionsData>[
        v3.TransactionsData(
          id: 451,
          amountInCents: 1275,
          type: 'expense',
          categoryId: 315,
          paymentMethodId: 91,
          description: 'Histórico anterior',
          dateEpochDay: 20500,
          createdAt: 1_762_000_000,
          updatedAt: 1_762_000_000,
          fixedEntryId: null,
          savingsGoalId: null,
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 3,
        newVersion: 4,
        createOld: v3.DatabaseAtV3.new,
        createNew: v4.DatabaseAtV4.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDatabase) {
          batch.insertAll(oldDatabase.categories, oldCategories);
          batch.insertAll(oldDatabase.paymentMethods, oldMethods);
          batch.insertAll(oldDatabase.transactions, oldTransactions);
        },
        validateItems: (database) async {
          expect(
            await database.select(database.categories).get(),
            hasLength(1),
          );
          expect(
            await database.select(database.paymentMethods).get(),
            hasLength(1),
          );
          expect(
            await database.select(database.transactions).get(),
            hasLength(1),
          );
          final transaction =
              (await database.select(database.transactions).get()).single;
          expect(transaction.id, 451);
          expect(transaction.amountInCents, 1275);
          expect(transaction.savingsGoalId, isNull);
          expect(await database.select(database.savingsGoals).get(), isEmpty);
        },
      );
    },
  );

  test(
    'v4 to v5 preserves savings goals and starts budget configuration empty',
    () async {
      const oldGoals = <v4.SavingsGoalsData>[
        v4.SavingsGoalsData(
          id: 73,
          name: 'Reserva',
          targetAmountInCents: 125000,
          createdAt: 1_762_000_000,
          completedAt: null,
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 4,
        newVersion: 5,
        createOld: v4.DatabaseAtV4.new,
        createNew: v5.DatabaseAtV5.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDatabase) {
          batch.insertAll(oldDatabase.savingsGoals, oldGoals);
        },
        validateItems: (database) async {
          final goals = await database.select(database.savingsGoals).get();
          expect(goals, hasLength(1));
          expect(goals.single.id, 73);
          expect(goals.single.name, 'Reserva');
          expect(goals.single.targetAmountInCents, 125000);
          expect(await database.select(database.budgets).get(), isEmpty);
          expect(await database.select(database.budgetCycles).get(), isEmpty);
        },
      );
    },
  );

  test(
    'v5 to v6 preserves finance data and creates shopping tables empty',
    () async {
      const oldGoals = <v5.SavingsGoalsData>[
        v5.SavingsGoalsData(
          id: 73,
          name: 'Reserva',
          targetAmountInCents: 125000,
          createdAt: 1_762_000_000,
          completedAt: null,
        ),
      ];
      const oldCategories = <v5.CategoriesData>[
        v5.CategoriesData(
          id: 315,
          name: 'Mercado',
          normalizedName: 'mercado',
          type: 'expense',
          icon: 'shopping_cart',
          colorArgb: 0xFF3B82F6,
          isActive: 1,
          createdAt: 1_762_000_000,
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 5,
        newVersion: 6,
        createOld: v5.DatabaseAtV5.new,
        createNew: v6.DatabaseAtV6.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDatabase) {
          batch.insertAll(oldDatabase.savingsGoals, oldGoals);
          batch.insertAll(oldDatabase.categories, oldCategories);
        },
        validateItems: (database) async {
          expect(
            await database.select(database.savingsGoals).get(),
            hasLength(1),
          );
          expect(
            await database.select(database.categories).get(),
            hasLength(1),
          );
          expect(await database.select(database.shoppingLists).get(), isEmpty);
          expect(
            await database.select(database.shoppingListItems).get(),
            isEmpty,
          );
          expect(
            await database.select(database.shoppingAdjustments).get(),
            isEmpty,
          );
          expect(
            await database.select(database.shoppingPayables).get(),
            isEmpty,
          );
        },
      );
    },
  );
}
