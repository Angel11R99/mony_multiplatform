import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import '../../features/preferences/domain/app_preferences.dart';
import 'mony_finance_colors.dart';
import 'mony_tokens.dart';

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
    final seedScheme = ColorScheme.fromSeed(
      seedColor: Color(preferences.primaryColorArgb),
      secondary: Color(preferences.accentColorArgb),
      brightness: brightness,
    );
    final dark = brightness == Brightness.dark;
    final colorScheme = seedScheme.copyWith(
      primary: Color(preferences.primaryColorArgb),
      surface: dark ? MonyPalette.darkBackground : MonyPalette.lightBackground,
      onSurface: dark ? const Color(0xFFF4EFF8) : const Color(0xFF241D2B),
      surfaceContainerLow: dark
          ? MonyPalette.darkSurface
          : MonyPalette.lightSurface,
      surfaceContainer: dark
          ? MonyPalette.darkSurfaceVariant
          : MonyPalette.lightSurfaceVariant,
      onSurfaceVariant: dark
          ? const Color(0xFFD0C6D8)
          : const Color(0xFF5F5667),
      outline: dark ? const Color(0xFF81778A) : const Color(0xFF817889),
      outlineVariant: dark ? const Color(0xFF51485A) : const Color(0xFFD8D1DE),
    );

    final themeBuilder = brightness == Brightness.light
        ? FlexThemeData.light
        : FlexThemeData.dark;

    return themeBuilder(
      colorScheme: colorScheme,
      useMaterial3: true,
      extensions: [MonyFinanceColors.forBrightness(brightness)],
      appBarStyle: FlexAppBarStyle.surface,
      appBarElevation: 0,
      subThemesData: FlexSubThemesData(
        interactionEffects: true,
        defaultRadius: MonyRadius.medium,
        buttonMinSize: const Size(48, 48),
        cardRadius: MonyRadius.large,
        cardElevation: 0,
        cardBorderSchemeColor: SchemeColor.outlineVariant,
        cardBorderWidth: 1,
        filledButtonRadius: MonyRadius.medium,
        outlinedButtonRadius: MonyRadius.medium,
        outlinedButtonOutlineSchemeColor: SchemeColor.outline,
        textButtonRadius: MonyRadius.medium,
        inputDecoratorRadius: MonyRadius.medium,
        inputDecoratorIsFilled: true,
      ),
    );
  }
}
