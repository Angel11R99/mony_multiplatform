import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/categories/data/drift_categories_repository.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';

void main() {
  late AppDatabase database;
  late DriftCategoriesRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftCategoriesRepository(database);
  });

  tearDown(() async => database.close());

  test(
    'seeds the original category catalog once on first database creation',
    () async {
      final all = await repository.watchAll().first;
      expect(all, hasLength(21));
      expect(
        all.where((item) => item.type == CategoryType.income),
        hasLength(5),
      );
      expect(
        all.where((item) => item.type == CategoryType.expense),
        hasLength(16),
      );
      expect(all.firstWhere((item) => item.name == 'Salario').icon, 'payments');
    },
  );

  test(
    'persists custom category attributes and exposes active choices by type',
    () async {
      await repository.create(
        name: '  Mascotas ',
        type: CategoryType.expense,
        icon: 'pets',
        colorArgb: 0xFF0891B2,
        budgetLimitInCents: 125050,
      );

      final all = await repository.watchAll().first;
      final pets = all.singleWhere((item) => item.name == 'Mascotas');
      expect(pets.type, CategoryType.expense);
      expect(pets.icon, 'pets');
      expect(pets.colorArgb, 0xFF0891B2);
      expect(pets.budgetLimitInCents, 125050);
      expect(
        await repository.watchActive(CategoryType.expense).first,
        contains(predicate<Category>((item) => item.id == pets.id)),
      );
      expect(
        await repository.watchActive(CategoryType.income).first,
        isNot(contains(predicate<Category>((item) => item.id == pets.id))),
      );
    },
  );

  test(
    'archives and restores without deleting the category or its stable ID',
    () async {
      await repository.create(
        name: 'Mascotas',
        type: CategoryType.expense,
        icon: 'pets',
        colorArgb: 0xFF0891B2,
      );
      final saved = (await repository.watchAll().first).singleWhere(
        (item) => item.name == 'Mascotas',
      );

      await repository.setActive(saved.id, false);
      expect(
        await repository.watchActive(CategoryType.expense).first,
        isNot(contains(saved)),
      );
      final archived = (await repository.watchAll().first).singleWhere(
        (item) => item.id == saved.id,
      );
      expect(archived.isActive, isFalse);

      await repository.setActive(saved.id, true);
      expect(
        (await repository.watchActive(CategoryType.expense).first)
            .singleWhere((item) => item.id == saved.id)
            .isActive,
        isTrue,
      );
    },
  );

  test('database uniqueness protects normalized names within a type', () async {
    await repository.create(
      name: 'Mascotas',
      type: CategoryType.expense,
      icon: 'pets',
      colorArgb: 0xFF0891B2,
    );
    await expectLater(
      repository.create(
        name: 'MASCOTAS',
        type: CategoryType.expense,
        icon: 'pets',
        colorArgb: 0xFF0891B2,
      ),
      throwsA(anything),
    );
    await repository.create(
      name: 'Mascotas',
      type: CategoryType.income,
      icon: 'pets',
      colorArgb: 0xFF0891B2,
    );
  });
}
