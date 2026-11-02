import 'package:flutter/material.dart';

import '../../features/preferences/domain/app_preferences.dart';

abstract final class MonyTheme {
  static ThemeData light(AppPreferences preferences) =>
      _build(preferences, brightness: Brightness.light);

  static ThemeData dark(AppPreferences preferences) =>
      _build(preferences, brightness: Brightness.dark);

  static ThemeMode themeMode(AppThemeMode mode) => switch (mode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  static ThemeData _build(
    AppPreferences preferences, {
    required Brightness brightness,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color(preferences.primaryColorArgb),
      secondary: Color(preferences.accentColorArgb),
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: false),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
