import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/shared_preferences_repository.dart';
import '../domain/app_preferences.dart';
import '../domain/preferences_repository.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => SharedPreferencesRepository(),
);

final appPreferencesProvider =
    AsyncNotifierProvider<AppPreferencesController, AppPreferences>(
      AppPreferencesController.new,
    );

class AppPreferencesController extends AsyncNotifier<AppPreferences> {
  late PreferencesRepository _repository;
  Future<void> _writeQueue = Future<void>.value();

  @override
  Future<AppPreferences> build() {
    _repository = ref.watch(preferencesRepositoryProvider);
    return _repository.load();
  }

  Future<void> setThemeMode(AppThemeMode value) =>
      _update((current) => current.copyWith(themeMode: value));

  Future<void> setPrimaryColor(int argb) =>
      _update((current) => current.copyWith(primaryColorArgb: argb));

  Future<void> setAccentColor(int argb) =>
      _update((current) => current.copyWith(accentColorArgb: argb));

  Future<void> setCurrencyFormatStyle(CurrencyFormatStyle value) =>
      _update((current) => current.copyWith(currencyFormatStyle: value));

  Future<void> setNotificationsEnabled(bool value) =>
      _update((current) => current.copyWith(notificationsEnabled: value));

  Future<void> setVisibleNavigationModules(List<String> value) => _update(
    (current) =>
        current.copyWith(visibleNavigationModules: List.unmodifiable(value)),
  );

  Future<void> setShowNavigationLabels(bool value) =>
      _update((current) => current.copyWith(showNavigationLabels: value));

  Future<void> setNavigationLabelScale(double value) => _update(
    (current) => current.copyWith(
      navigationLabelScale: value.clamp(0.75, 1.2).toDouble(),
    ),
  );

  Future<void> reset() => _update((_) => AppPreferences.defaults);

  Future<void> _update(
    AppPreferences Function(AppPreferences) transform,
  ) async {
    final previous = state;
    final updated = transform(state.requireValue);
    final optimisticState = AsyncData(updated);
    state = optimisticState;

    final write = _writeQueue.then((_) => _repository.save(updated));
    _writeQueue = write.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );

    try {
      await write;
    } catch (_) {
      if (identical(state, optimisticState)) state = previous;
      rethrow;
    }
  }
}
