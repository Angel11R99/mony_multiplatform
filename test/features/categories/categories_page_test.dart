import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/routing/app_router.dart';
import 'package:mony_multiplatform/features/categories/domain/categories_repository.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/categories/presentation/categories_page.dart';
import 'package:mony_multiplatform/features/categories/presentation/categories_providers.dart';

void main() {
  late _FakeCategoriesRepository repository;

  setUp(() => repository = _FakeCategoriesRepository());
  tearDown(() async => repository.dispose());

  Future<void> openPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [categoriesRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: CategoriesPage()),
      ),
    );
    await tester.pumpAndSettle();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });
  }

  testWidgets('shows the seeded expenses and switches to income categories', (
    tester,
  ) async {
    await openPage(tester);

    expect(find.text('Alimentación'), findsOneWidget);
    expect(find.text('Transporte'), findsOneWidget);
    await tester.tap(find.text('Ingresos'));
    await tester.pumpAndSettle();
    expect(find.text('Salario'), findsOneWidget);
    expect(find.text('Alimentación'), findsNothing);
  });

  testWidgets('archives a category without removing its historical record', (
    tester,
  ) async {
    await openPage(tester);

    await tester.tap(find.byTooltip('Acciones para Alimentación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archivar'));
    await tester.pumpAndSettle();
    expect(find.text('Alimentación'), findsNothing);

    await tester.tap(find.text('Archivadas'));
    await tester.pumpAndSettle();
    expect(find.text('Alimentación'), findsOneWidget);
    expect(find.text('Archivada'), findsOneWidget);
  });

  testWidgets('creates a custom category with a trimmed name', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('Nueva categoría'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '  Mascotas  ');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Mascotas'), findsOneWidget);
    expect(find.text('Categoría creada correctamente.'), findsOneWidget);
  });

  testWidgets('edits a category and keeps it in the active catalog', (
    tester,
  ) async {
    await openPage(tester);
    await tester.tap(find.byTooltip('Acciones para Transporte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Movilidad');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Movilidad'), findsOneWidget);
    expect(find.text('Transporte'), findsNothing);
    expect(find.text('Categoría actualizada.'), findsOneWidget);
  });

  testWidgets('blocks archiving the last active income category', (
    tester,
  ) async {
    await openPage(tester);
    await tester.tap(find.text('Ingresos'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Acciones para Salario'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archivar'));
    await tester.pumpAndSettle();

    expect(find.text('Salario'), findsOneWidget);
    expect(
      find.text('Debe existir al menos una categoría de ingresos activa'),
      findsOneWidget,
    );
  });

  testWidgets('opens category management from the home route', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [categoriesRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(routerConfig: createAppRouter()),
      ),
    );
    await tester.pumpAndSettle();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    await tester.tap(find.byTooltip('Administrar categorías'));
    await tester.pumpAndSettle();
    expect(find.text('Categorías'), findsOneWidget);
    expect(find.text('Alimentación'), findsOneWidget);
  });
}

class _FakeCategoriesRepository implements CategoriesRepository {
  _FakeCategoriesRepository()
    : _categories = [
        _category(1, 'Salario', CategoryType.income, 'payments'),
        _category(2, 'Alimentación', CategoryType.expense, 'restaurant'),
        _category(3, 'Transporte', CategoryType.expense, 'directions_car'),
      ];

  final StreamController<List<Category>> _changes =
      StreamController<List<Category>>.broadcast(sync: true);
  final List<Category> _categories;

  @override
  Stream<List<Category>> watchAll() async* {
    yield List.unmodifiable(_categories);
    yield* _changes.stream;
  }

  @override
  Stream<List<Category>> watchActive(CategoryType type) => watchAll().map(
    (items) => items
        .where((item) => item.type == type && item.isActive)
        .toList(growable: false),
  );

  @override
  Future<void> create({
    required String name,
    required CategoryType type,
    required String icon,
    required int colorArgb,
    int? budgetLimitInCents,
  }) async {
    _categories.add(
      Category(
        id: 4,
        name: name.trim(),
        type: type,
        icon: icon,
        colorArgb: colorArgb,
        isActive: true,
        createdAt: DateTime(2026),
        budgetLimitInCents: budgetLimitInCents,
      ),
    );
    _emit();
  }

  @override
  Future<void> update({
    required int id,
    required String name,
    required String icon,
    required int colorArgb,
    int? budgetLimitInCents,
  }) async {
    final index = _categories.indexWhere((item) => item.id == id);
    final current = _categories[index];
    _categories[index] = Category(
      id: id,
      name: name.trim(),
      type: current.type,
      icon: icon,
      colorArgb: colorArgb,
      isActive: current.isActive,
      createdAt: current.createdAt,
      budgetLimitInCents: budgetLimitInCents,
    );
    _emit();
  }

  @override
  Future<void> setActive(int id, bool isActive) async {
    final index = _categories.indexWhere((item) => item.id == id);
    final current = _categories[index];
    _categories[index] = Category(
      id: current.id,
      name: current.name,
      type: current.type,
      icon: current.icon,
      colorArgb: current.colorArgb,
      isActive: isActive,
      createdAt: current.createdAt,
      budgetLimitInCents: current.budgetLimitInCents,
    );
    _emit();
  }

  void _emit() => _changes.add(List.unmodifiable(_categories));

  Future<void> dispose() => _changes.close();
}

Category _category(int id, String name, CategoryType type, String icon) =>
    Category(
      id: id,
      name: name,
      type: type,
      icon: icon,
      colorArgb: 0xFF7C3AED,
      isActive: true,
      createdAt: DateTime(2026),
    );
