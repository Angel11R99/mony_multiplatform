import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_preferences.dart';
import '../domain/preferences_repository.dart';

class SharedPreferencesRepository implements PreferencesRepository {
  SharedPreferencesRepository({
    Future<SharedPreferences> Function()? loadPreferences,
  }) : _loadPreferences = loadPreferences ?? SharedPreferences.getInstance;

  static const _storageKey = 'mony.app_preferences.v1';

  final Future<SharedPreferences> Function() _loadPreferences;

  @override
  Future<AppPreferences> load() async {
    final preferences = await _loadPreferences();
    final encoded = preferences.getString(_storageKey);
    if (encoded == null) return AppPreferences.defaults;

    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map<String, dynamic>) return AppPreferences.defaults;

      return AppPreferences(
        themeMode:
            _enumValue(AppThemeMode.values, decoded['themeMode']) ??
            AppPreferences.defaults.themeMode,
        primaryColorArgb:
            _intValue(
              decoded['primaryColorArgb'],
              AppPreferences.defaults.primaryColorArgb,
            ) |
            0xFF000000,
        accentColorArgb:
            _intValue(
              decoded['accentColorArgb'],
              AppPreferences.defaults.accentColorArgb,
            ) |
            0xFF000000,
        currencyCode: _currencyCode(decoded['currencyCode']),
        currencyFormatStyle:
            _enumValue(
              CurrencyFormatStyle.values,
              decoded['currencyFormatStyle'],
            ) ??
            AppPreferences.defaults.currencyFormatStyle,
        notificationsEnabled: decoded['notificationsEnabled'] == true,
        visibleNavigationModules: _visibleNavigationModules(
          decoded['visibleNavigationModules'],
        ),
        showNavigationLabels: decoded['showNavigationLabels'] == true,
        navigationLabelScale: _doubleValue(
          decoded['navigationLabelScale'],
          AppPreferences.defaults.navigationLabelScale,
        ).clamp(0.75, 1.2).toDouble(),
      );
    } on FormatException {
      return AppPreferences.defaults;
    }
  }

  @override
  Future<void> save(AppPreferences preferences) async {
    final storage = await _loadPreferences();
    final saved = await storage.setString(
      _storageKey,
      jsonEncode({
        'themeMode': preferences.themeMode.name,
        'primaryColorArgb': preferences.primaryColorArgb,
        'accentColorArgb': preferences.accentColorArgb,
        'currencyCode': preferences.currencyCode,
        'currencyFormatStyle': preferences.currencyFormatStyle.name,
        'notificationsEnabled': preferences.notificationsEnabled,
        'visibleNavigationModules': preferences.visibleNavigationModules,
        'showNavigationLabels': preferences.showNavigationLabels,
        'navigationLabelScale': preferences.navigationLabelScale,
      }),
    );
    if (!saved) throw StateError('Preferences could not be persisted.');
  }

  T? _enumValue<T extends Enum>(List<T> values, Object? value) {
    if (value is! String) return null;
    for (final candidate in values) {
      if (candidate.name == value) return candidate;
    }
    return null;
  }

  int _intValue(Object? value, int fallback) => value is int ? value : fallback;

  double _doubleValue(Object? value, double fallback) =>
      value is num ? value.toDouble() : fallback;

  String _currencyCode(Object? value) => value is String && value == 'DOP'
      ? value
      : AppPreferences.defaults.currencyCode;

  List<String> _visibleNavigationModules(Object? value) {
    if (value is! List) return defaultNavigationModuleIds;
    final selected = value.whereType<String>().toSet();
    final valid = defaultNavigationModuleIds
        .where(selected.contains)
        .toList(growable: false);
    return valid.isEmpty ? defaultNavigationModuleIds : valid;
  }
}
