import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/app/app.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';

void main() {
  testWidgets('opens appearance settings and persists selections', (
    tester,
  ) async {
    final repository = _FakePreferencesRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MonyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    await tester.tap(find.byTooltip('Apariencia y preferencias'));
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
  });

  testWidgets('retains the home and about example navigation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
