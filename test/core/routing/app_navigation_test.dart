import 'package:drift/native.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/core/database/app_database_provider.dart';
import 'package:mony_multiplatform/core/routing/app_router.dart';
import 'package:mony_multiplatform/core/routing/mony_navigation_shell.dart';
import 'package:mony_multiplatform/core/theme/mony_finance_colors.dart';
import 'package:mony_multiplatform/core/theme/sumi_visuals.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';
import 'package:mony_multiplatform/features/categories/presentation/categories_page.dart';
import 'package:mony_multiplatform/features/transactions/presentation/transactions_page.dart';

void main() {
  testWidgets('starts at Home and preserves the transaction tab state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = _newTestDatabase();
    final router = createAppRouter();

    await _pumpApp(tester, router, database);
    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    expect(find.byTooltip('Historial'), findsOneWidget);
    expect(find.byType(MonyNavigationShell), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _tapNavigationItem(tester, 7);
    await tester.pumpAndSettle();
    expect(find.text('Buscar movimientos'), findsOneWidget);
    expect(find.text('Todavía no hay movimientos.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'supermercado');
    await tester.pumpAndSettle();
    await _tapNavigationItem(tester, 0);
    await tester.pumpAndSettle();
    await _tapNavigationItem(tester, 7);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'supermercado',
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('opens Categories from a cold deep link', (tester) async {
    final database = _newTestDatabase();
    final router = createAppRouter(initialLocation: '/categories');

    await _pumpApp(tester, router, database);
    expect(find.byType(CategoriesPage), findsOneWidget);
    expect(find.byTooltip('Historial'), findsNothing);
  });

  testWidgets('keeps the Sumi selection legible and low-profile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(480, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = _newTestDatabase();
    final router = createAppRouter();
    final preferences = _MemoryPreferencesRepository()
      ..value = AppPreferences.defaults.copyWith(
        visualTheme: AppVisualTheme.japaneseSumie,
      );

    await _pumpApp(
      tester,
      router,
      database,
      preferencesRepository: preferences,
    );
    await _tapNavigationItem(tester, 7);
    await tester.pumpAndSettle();

    final selectedScale = tester.widget<Transform>(
      find.byKey(const ValueKey('sumi-selected-icon-scale')),
    );
    expect(selectedScale.transform.storage[0], closeTo(1, .001));
    final selectedLift = tester.widget<Transform>(
      find.byKey(const ValueKey('sumi-selected-icon-lift')),
    );
    expect(selectedLift.transform.storage[13], closeTo(-.0390625, .001));
    expect(tester.widget<Icon>(find.byIcon(Icons.receipt_long)).size, 42);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    final unselectedHome = tester.widget<Icon>(find.byIcon(Icons.home));
    expect(unselectedHome.size, 30);
    expect(unselectedHome.color, isNot(SumiThemeColors.defaults.paper));
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a navigation rail on a wide viewport', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = _newTestDatabase();
    final router = createAppRouter();

    await _pumpApp(tester, router, database);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byTooltip('Historial'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested deep links can be popped back to the shell', (
    tester,
  ) async {
    final database = _newTestDatabase();
    final router = createAppRouter();

    await _pumpApp(tester, router, database);
    router.push('/transactions/not-a-number');
    await tester.pumpAndSettle();
    expect(find.text('Página no encontrada'), findsOneWidget);
    expect(find.byTooltip('Historial'), findsNothing);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    expect(find.byTooltip('Historial'), findsOneWidget);
  });

  testWidgets('warns before discarding an edited transaction form', (
    tester,
  ) async {
    final database = _newTestDatabase();
    final router = createAppRouter(initialLocation: '/transactions/new');

    await _pumpApp(tester, router, database);
    await tester.enterText(find.byType(TextFormField).first, '12');
    await tester.pump();
    final popScopeFinder = find.byWidgetPredicate(
      (widget) => widget is PopScope<Object>,
    );
    expect(popScopeFinder, findsOneWidget);
    expect(tester.widget<PopScope<Object>>(popScopeFinder).canPop, isFalse);
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
  AppDatabase database, {
  _MemoryPreferencesRepository? preferencesRepository,
}) async {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    await database.close();
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        preferencesRepositoryProvider.overrideWithValue(
          preferencesRepository ?? _MemoryPreferencesRepository(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          extensions: [MonyFinanceColors.forBrightness(Brightness.light)],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

AppDatabase _newTestDatabase() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

Future<void> _tapNavigationItem(WidgetTester tester, int index) async {
  const labels = [
    'Inicio',
    'Fijos',
    'Recordatorios',
    'Ahorros',
    'Lista',
    'Estadísticas',
    'Plan de ciclo',
    'Historial',
  ];
  await tester.tap(find.byTooltip(labels[index]));
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
