import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/preferences/data/shared_preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loads defaults and persists user preferences', () async {
    final repository = SharedPreferencesRepository();

    expect(await repository.load(), AppPreferences.defaults);

    const changed = AppPreferences(
      themeMode: AppThemeMode.dark,
      primaryColorArgb: 0xFF16A34A,
      accentColorArgb: 0xFF3B82F6,
      currencyFormatStyle: CurrencyFormatStyle.code,
      notificationsEnabled: true,
      visibleNavigationModules: ['home', 'statistics', 'transactions'],
    );
    await repository.save(changed);

    expect(await SharedPreferencesRepository().load(), changed);
  });

  test('recovers safely from malformed saved preferences', () async {
    SharedPreferences.setMockInitialValues({
      'mony.app_preferences.v1': '{not valid json',
    });

    final repository = SharedPreferencesRepository();

    expect(await repository.load(), AppPreferences.defaults);
  });
}
