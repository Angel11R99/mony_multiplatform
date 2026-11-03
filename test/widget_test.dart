import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/app/app.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/core/database/app_database_provider.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';
import 'package:mony_multiplatform/features/notifications/domain/reminder_plan.dart';
import 'package:mony_multiplatform/features/notifications/presentation/notifications_providers.dart';

void main() {
  testWidgets('requests notification permission before saving the switch', (
    tester,
  ) async {
    addTearDown(() async => tester.pumpWidget(const SizedBox.shrink()));
    final repository = _FakePreferencesRepository();
    final client = _FakeReminderNotificationClient();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          preferencesRepositoryProvider.overrideWithValue(repository),
          notificationClientProvider.overrideWithValue(client),
        ],
        child: const MonyApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personalización'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Activar notificaciones'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Activar notificaciones'));
    await tester.pumpAndSettle();

    expect(client.permissionRequests, 1);
    expect(repository.saved.notificationsEnabled, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('opens appearance settings and persists selections', (
    tester,
  ) async {
    final repository = _FakePreferencesRepository();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          preferencesRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MonyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personalización'));
    await tester.pumpAndSettle();

    expect(find.text('Haz Mony tuya'), findsOneWidget);
    await tester.tap(find.text('Oscuro'));
    await tester.pumpAndSettle();
    final redSwatch = find.byTooltip('Rojo').first;
    await tester.ensureVisible(redSwatch);
    await tester.tap(redSwatch);
    await tester.pumpAndSettle();

    expect(repository.saved.themeMode, AppThemeMode.dark);
    expect(repository.saved.primaryColorArgb, 0xFFEF4444);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('navigation preferences hide modules and persist', (
    tester,
  ) async {
    final repository = _FakePreferencesRepository();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          preferencesRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MonyApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Navegación'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Estadísticas'));
    await tester.pumpAndSettle();

    expect(
      repository.saved.visibleNavigationModules,
      isNot(contains('statistics')),
    );
    expect(find.byTooltip('Ajustes'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('retains the home and about example navigation', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          preferencesRepositoryProvider.overrideWithValue(
            _FakePreferencesRepository(),
          ),
        ],
        child: const MonyApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Acerca de Mony'));
    await tester.pumpAndSettle();
    expect(find.text('Acerca de Mony'), findsOneWidget);

    await tester.tap(find.text('Volver al inicio'));
    await tester.pumpAndSettle();
    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('shows reactive monthly totals and starts a new income', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTransactionRepository(database);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    await repository.create(
      FinanceTransaction(
        amountInCents: 12345,
        type: TransactionType.income,
        categoryId: 1,
        paymentMethodId: 1,
        description: 'Nómina',
        date: today,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repository.create(
      FinanceTransaction(
        amountInCents: 2500,
        type: TransactionType.expense,
        categoryId: 6,
        paymentMethodId: 1,
        description: 'Mercado',
        date: today,
        createdAt: now.add(const Duration(minutes: 1)),
        updatedAt: now.add(const Duration(minutes: 1)),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          preferencesRepositoryProvider.overrideWithValue(
            _FakePreferencesRepository(),
          ),
        ],
        child: const MonyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Balance del mes'), findsOneWidget);
    expect(find.text('RD\$98.45'), findsOneWidget);
    expect(find.text('RD\$123.45'), findsOneWidget);
    expect(find.text('RD\$25.00'), findsOneWidget);
    await repository.create(
      FinanceTransaction(
        amountInCents: 100,
        type: TransactionType.income,
        categoryId: 1,
        paymentMethodId: 1,
        description: 'Propina',
        date: today,
        createdAt: now.add(const Duration(minutes: 2)),
        updatedAt: now.add(const Duration(minutes: 2)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('RD\$99.45'), findsOneWidget);
    expect(find.text('RD\$124.45'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Nómina'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Nómina'), findsOneWidget);
    expect(find.text('Mercado'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nuevo ingreso'));
    await tester.pumpAndSettle();
    final typeControl = tester.widget<SegmentedButton<TransactionType>>(
      find.byType(SegmentedButton<TransactionType>),
    );
    expect(typeControl.selected, {TransactionType.income});
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}

class _FakePreferencesRepository implements PreferencesRepository {
  AppPreferences saved = AppPreferences.defaults;

  @override
  Future<AppPreferences> load() async => saved;

  @override
  Future<void> save(AppPreferences preferences) async {
    saved = preferences;
  }
}

class _FakeReminderNotificationClient implements ReminderNotificationClient {
  int permissionRequests = 0;

  @override
  bool get supportsScheduling => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return true;
  }

  @override
  Future<bool> notificationsEnabled() async => true;

  @override
  Future<List<ReminderRequest>> pendingRequests() async => const [];

  @override
  Future<void> schedule(ReminderPlan plan) async {}

  @override
  Future<void> show(ReminderPlan plan) async {}

  @override
  Future<void> cancel(int id) async {}
}
