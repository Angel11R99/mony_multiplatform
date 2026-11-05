import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';
import 'package:mony_multiplatform/features/shopping_lists/domain/shopping_list.dart';
import 'package:mony_multiplatform/features/shopping_lists/domain/shopping_list_repository.dart';
import 'package:mony_multiplatform/features/shopping_lists/presentation/shopping_lists_page.dart';
import 'package:mony_multiplatform/features/shopping_lists/presentation/shopping_lists_providers.dart';
import 'dart:async';

class _MemoryPreferencesRepository implements PreferencesRepository {
  @override
  Future<AppPreferences> load() async => AppPreferences.defaults;

  @override
  Future<void> save(AppPreferences preferences) async {}
}

void main() {
  testWidgets('creates a named shopping list and opens its detail route', (
    tester,
  ) async {
    final repository = _ShoppingListRepositoryFake();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ShoppingListsPage(),
        ),
        GoRoute(
          path: '/shopping-lists/:id',
          name: 'shoppingListDetail',
          builder: (context, state) =>
              Scaffold(body: Text('Lista ${state.pathParameters['id']}')),
        ),
      ],
    );
    addTearDown(() async {
      router.dispose();
      await repository.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shoppingListRepositoryProvider.overrideWithValue(repository),
          preferencesRepositoryProvider.overrideWithValue(
            _MemoryPreferencesRepository(),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Prepara la lista antes de salir y mantén el total estimado a la vista.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Crear lista de compra'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Compra semanal');
    await tester.tap(find.text('Crear').last);
    await tester.pumpAndSettle();

    expect(find.text('Lista 1'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

class _ShoppingListRepositoryFake implements ShoppingListRepository {
  final _updates = StreamController<List<ShoppingListOverview>>.broadcast();
  var _overviews = const <ShoppingListOverview>[];
  var _nextId = 1;

  Future<void> dispose() => _updates.close();

  @override
  Stream<List<ShoppingListOverview>> watchOverviews() => Stream.multi((sink) {
    sink.add(_overviews);
    final subscription = _updates.stream.listen(
      sink.add,
      onError: sink.addError,
    );
    sink.onCancel = subscription.cancel;
  });

  @override
  Future<int> create(ShoppingList list) async {
    final id = _nextId++;
    final saved = ShoppingList(
      id: id,
      name: list.name.trim(),
      budgetInCents: list.budgetInCents,
      createdAt: list.createdAt,
      updatedAt: list.updatedAt,
    );
    _overviews = [
      ..._overviews,
      ShoppingListOverview(list: saved, itemCount: 0, totalInCents: 0),
    ];
    _updates.add(_overviews);
    return id;
  }

  @override
  Stream<ShoppingListDetails?> watchDetails(int listId) => Stream.value(null);

  @override
  Future<ShoppingListDetails?> getDetails(int listId) async => null;

  @override
  Future<void> update(ShoppingList list) => throw UnimplementedError();

  @override
  Future<void> delete(int listId) => throw UnimplementedError();

  @override
  Future<int> saveItem(ShoppingListItem item) => throw UnimplementedError();

  @override
  Future<void> deleteItem(int itemId) => throw UnimplementedError();

  @override
  Future<int> saveAdjustment(ShoppingAdjustment adjustment) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAdjustment(int adjustmentId) => throw UnimplementedError();

  @override
  Future<int?> duplicate(int listId) => throw UnimplementedError();

  @override
  Future<int> finalizePurchase({
    required int listId,
    required int categoryId,
    required DateTime purchaseDate,
    required int paymentMethodId,
  }) => throw UnimplementedError();

  @override
  Future<void> reopen(int listId) => throw UnimplementedError();
}
