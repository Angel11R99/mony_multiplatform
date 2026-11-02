import 'app_preferences.dart';

abstract interface class PreferencesRepository {
  Future<AppPreferences> load();

  Future<void> save(AppPreferences preferences);
}
