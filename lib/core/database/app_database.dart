import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/categories/data/categories_table.dart';
import '../../features/categories/domain/category.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'mony',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await batch((batch) {
        batch.insertAll(
          categories,
          _initialCategories
              .map(
                (category) => CategoriesCompanion.insert(
                  name: category.$1,
                  normalizedName: category.$1.toLowerCase(),
                  type: category.$2.name,
                  icon: category.$3,
                  colorArgb: category.$4,
                ),
              )
              .toList(),
        );
      });
    },
  );

  @override
  int get schemaVersion => 1;
}

const _initialCategories = <(String, CategoryType, String, int)>[
  ('Salario', CategoryType.income, 'payments', 0xFF16A34A),
  ('Trabajo extra', CategoryType.income, 'work', 0xFF0891B2),
  ('Freelance', CategoryType.income, 'laptop', 0xFF3B82F6),
  ('Venta', CategoryType.income, 'sell', 0xFFD97706),
  ('Otros ingresos', CategoryType.income, 'add_circle', 0xFF71717A),
  ('Alimentación', CategoryType.expense, 'restaurant', 0xFFEA580C),
  ('Transporte', CategoryType.expense, 'directions_car', 0xFF3B82F6),
  ('Vivienda', CategoryType.expense, 'home', 0xFF9333EA),
  ('Servicios', CategoryType.expense, 'receipt_long', 0xFF0891B2),
  ('Internet', CategoryType.expense, 'wifi', 0xFF7C3AED),
  ('Teléfono', CategoryType.expense, 'phone_android', 0xFFEC4899),
  ('Salud', CategoryType.expense, 'medical_services', 0xFFEF4444),
  ('Educación', CategoryType.expense, 'school', 0xFF0D9488),
  ('Entretenimiento', CategoryType.expense, 'movie', 0xFF9333EA),
  ('Compras', CategoryType.expense, 'shopping_cart', 0xFFEC4899),
  ('Deudas', CategoryType.expense, 'credit_card', 0xFF71717A),
  ('Suscripciones', CategoryType.expense, 'subscriptions', 0xFF0891B2),
  ('Familia', CategoryType.expense, 'family_restroom', 0xFF16A34A),
  ('Ahorro', CategoryType.expense, 'savings', 0xFF16A34A),
  ('Emergencias', CategoryType.expense, 'emergency', 0xFFEF4444),
  ('Otros', CategoryType.expense, 'more_horiz', 0xFF71717A),
];
