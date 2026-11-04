import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toastification/toastification.dart';
import 'package:mony_multiplatform/core/database/app_database_provider.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';
import 'package:mony_multiplatform/features/savings/presentation/savings_goals_page.dart';
import '../../support/test_database.dart';

class _MemoryPreferencesRepository implements PreferencesRepository {
  @override
  Future<AppPreferences> load() async => AppPreferences.defaults;

  @override
  Future<void> save(AppPreferences preferences) async {}
}

void main() {
  testWidgets(
    'creates a goal, records one contribution and shows its history',
    (tester) async {
      final database = createTestDatabase();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            preferencesRepositoryProvider.overrideWithValue(
              _MemoryPreferencesRepository(),
            ),
          ],
          child: ToastificationWrapper(
            child: const MaterialApp(home: SavingsGoalsPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Nueva meta'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Viaje');
      await tester.enterText(find.byType(TextFormField).at(1), '100.00');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.text('Viaje'), findsOneWidget);
      expect(find.text('RD\$0.00 de RD\$100.00'), findsOneWidget);

      await tester.tap(find.text('Aportar'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), '25.00');
      await tester.enterText(find.byType(TextFormField).at(1), 'Vuelo');
      await tester.tap(find.text('Aportar').last);
      await tester.pumpAndSettle();
      expect(find.text('RD\$25.00 de RD\$100.00'), findsOneWidget);
      expect(find.textContaining('· 25%'), findsOneWidget);

      await tester.tap(find.text('Aportes'));
      await tester.pumpAndSettle();
      expect(find.text('Aporte · Viaje · Vuelo'), findsOneWidget);
      expect(find.text('RD\$25.00'), findsOneWidget);

      toastification.dismissAll(delayForAnimation: false);
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpWidget(const SizedBox.shrink());
      await database.close();
    },
  );
}
