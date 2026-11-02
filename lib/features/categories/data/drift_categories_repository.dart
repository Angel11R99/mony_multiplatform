import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/categories_repository.dart';
import '../domain/category.dart';
import '../domain/category_validator.dart';

class DriftCategoriesRepository implements CategoriesRepository {
  const DriftCategoriesRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Category>> watchAll() =>
      (_database.select(_database.categories)..orderBy([
            (row) => OrderingTerm.asc(row.type),
            (row) => OrderingTerm.asc(row.name),
          ]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList(growable: false));

  @override
  Stream<List<Category>> watchActive(CategoryType type) =>
      (_database.select(_database.categories)
            ..where(
              (row) => row.type.equals(type.name) & row.isActive.equals(true),
            )
            ..orderBy([(row) => OrderingTerm.asc(row.name)]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList(growable: false));

  @override
  Future<void> create({
    required String name,
    required CategoryType type,
    required String icon,
    required int colorArgb,
    int? budgetLimitInCents,
  }) => _database.transaction(() async {
    await _validateName(name, type);
    await _database
        .into(_database.categories)
        .insert(
          CategoriesCompanion.insert(
            name: name.trim(),
            normalizedName: name.trim().toLowerCase(),
            type: type.name,
            icon: icon,
            colorArgb: colorArgb,
            budgetLimitInCents: Value(budgetLimitInCents),
          ),
        );
  });

  @override
  Future<void> update({
    required int id,
    required String name,
    required String icon,
    required int colorArgb,
    int? budgetLimitInCents,
  }) => _database.transaction(() async {
    final existing = await (_database.select(
      _database.categories,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (existing == null) throw const CategoryUnavailableException();
    final type = CategoryType.values.byName(existing.type);
    await _validateName(name, type, excludeId: id);
    await (_database.update(
      _database.categories,
    )..where((row) => row.id.equals(id))).write(
      CategoriesCompanion(
        name: Value(name.trim()),
        normalizedName: Value(name.trim().toLowerCase()),
        icon: Value(icon),
        colorArgb: Value(colorArgb),
        budgetLimitInCents: Value(budgetLimitInCents),
      ),
    );
  });

  @override
  Future<void> setActive(int id, bool isActive) =>
      _database.transaction(() async {
        final selected = await (_database.select(
          _database.categories,
        )..where((row) => row.id.equals(id))).getSingleOrNull();
        if (selected == null) throw const CategoryUnavailableException();
        if (selected.isActive == isActive) return;

        if (!isActive && selected.type == CategoryType.income.name) {
          final otherActive =
              await (_database.select(_database.categories)..where(
                    (row) =>
                        row.type.equals(CategoryType.income.name) &
                        row.isActive.equals(true) &
                        row.id.isNotIn([id]),
                  ))
                  .get();
          if (otherActive.isEmpty) {
            throw const LastActiveIncomeCategoryException();
          }
        }
        await (_database.update(_database.categories)
              ..where((row) => row.id.equals(id)))
            .write(CategoriesCompanion(isActive: Value(isActive)));
      });

  Future<void> _validateName(
    String name,
    CategoryType type, {
    int? excludeId,
  }) async {
    final rows = await _database.select(_database.categories).get();
    final existing = rows.map(_fromRow).toList(growable: false);
    final error = CategoryValidator.validateName(
      name,
      type,
      existing,
      excludeId: excludeId,
    );
    if (error != null) throw InvalidCategoryException(error);
  }

  Category _fromRow(CategoryRow row) => Category(
    id: row.id,
    name: row.name,
    type: CategoryType.values.byName(row.type),
    icon: row.icon,
    colorArgb: row.colorArgb,
    isActive: row.isActive,
    createdAt: row.createdAt,
    budgetLimitInCents: row.budgetLimitInCents,
  );
}
