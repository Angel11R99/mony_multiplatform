import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/core/database/app_database_provider.dart';
import 'package:mony_multiplatform/core/routing/app_router.dart';
import 'package:mony_multiplatform/core/routing/mony_navigation_shell.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';
import 'package:mony_multiplatform/features/categories/presentation/categories_page.dart';
import 'package:mony_multiplatform/features/payment_methods/presentation/payment_methods_page.dart';
import 'package:mony_multiplatform/features/transactions/presentation/transactions_page.dart';

void main() {
  testWidgets('starts at Home and preserves the transaction tab state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase(NativeDatabase.memory());
    final router = createAppRouter();
    addTearDown(() async {
      router.dispose();
      await database.close();
    });

    await _pumpApp(tester, router, database);
    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    expect(find.byType(NativeGlassNavBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byKey(const ValueKey('main-nav-home')), findsOneWidget);
    expect(find.bySemanticsLabel('Inicio'), findsNWidgets(2));
    expect(find.bySemanticsLabel('Historial'), findsOneWidget);
    expect(find.byType(MonyNavigationShell), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('main-nav-transactions')));
    await tester.pumpAndSettle();
    expect(find.text('Buscar movimientos'), findsOneWidget);
    expect(find.text('Todavía no hay movimientos.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'supermercado');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('main-nav-home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('main-nav-transactions')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'supermercado',
    );

    await tester.tap(find.byKey(const ValueKey('main-nav-home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Administrar categorías'));
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesPage), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Métodos de pago'));
    await tester.pumpAndSettle();
    expect(find.byType(PaymentMethodsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens Categories from a cold deep link', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final router = createAppRouter(initialLocation: '/categories');
    addTearDown(() async {
      router.dispose();
      await database.close();
    });

    await _pumpApp(tester, router, database);
    expect(find.byType(CategoriesPage), findsOneWidget);
    expect(find.byKey(const ValueKey('main-nav-home')), findsNothing);
  });

  testWidgets('uses a navigation rail on a wide viewport', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase(NativeDatabase.memory());
    final router = createAppRouter();
    addTearDown(() async {
      router.dispose();
      await database.close();
    });

    await _pumpApp(tester, router, database);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byKey(const ValueKey('main-nav-home')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested deep links can be popped back to the shell', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final router = createAppRouter();
    addTearDown(() async {
      router.dispose();
      await database.close();
    });

    await _pumpApp(tester, router, database);
    router.push('/transactions/not-a-number');
    await tester.pumpAndSettle();
    expect(find.text('Página no encontrada'), findsOneWidget);
    expect(find.byKey(const ValueKey('main-nav-home')), findsNothing);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    expect(find.byKey(const ValueKey('main-nav-home')), findsOneWidget);
  });

  testWidgets('warns before discarding an edited transaction form', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final router = createAppRouter(initialLocation: '/transactions/new');
    addTearDown(() async {
      router.dispose();
      await database.close();
    });

    await _pumpApp(tester, router, database);
    await tester.enterText(find.byType(TextFormField).first, '12');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Descartar cambios'), findsOneWidget);

    await tester.tap(find.text('Seguir editando'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      '12',
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionsPage), findsOneWidget);
  });
}

Future<void> _pumpApp(
  WidgetTester tester,
  GoRouter router,
  AppDatabase database,
) async {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        preferencesRepositoryProvider.overrideWithValue(
          _MemoryPreferencesRepository(),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

class _MemoryPreferencesRepository implements PreferencesRepository {
  AppPreferences value = AppPreferences.defaults;

  @override
  Future<AppPreferences> load() async => value;

  @override
  Future<void> save(AppPreferences preferences) async {
    value = preferences;
  }
}
