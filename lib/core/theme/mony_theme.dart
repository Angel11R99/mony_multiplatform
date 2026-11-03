import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final brandColor = Color(preferences.primaryColorArgb);
    final accentColor = Color(preferences.accentColorArgb);
    final accessiblePrimary = brightness == Brightness.light
        ? _lightSurfaceAccent(brandColor)
        : brandColor;
    final accessibleSecondary = brightness == Brightness.light
        ? _lightSurfaceAccent(accentColor)
        : accentColor;
    final seedScheme = ColorScheme.fromSeed(
      seedColor: brandColor,
      secondary: accentColor,
      brightness: brightness,
    );
    final dark = brightness == Brightness.dark;
    final colorScheme = seedScheme.copyWith(
      primary: accessiblePrimary,
      onPrimary: _contrastingForeground(accessiblePrimary),
      secondary: accessibleSecondary,
      onSecondary: _contrastingForeground(accessibleSecondary),
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

    final baseTheme = themeBuilder(
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
    final text = GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme);
    final readingText = GoogleFonts.interTextTheme(text);
    return baseTheme.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: readingText.copyWith(
        headlineLarge:
            GoogleFonts.plusJakartaSans(textStyle: text.headlineLarge).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -1.1,
              height: 1.08,
            ),
        headlineMedium:
            GoogleFonts.plusJakartaSans(
              textStyle: text.headlineMedium,
            ).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.7,
              height: 1.12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          textStyle: text.headlineSmall,
        ).copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.35),
        titleLarge: GoogleFonts.plusJakartaSans(
          textStyle: text.titleLarge,
        ).copyWith(fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.plusJakartaSans(
          textStyle: text.titleMedium,
        ).copyWith(fontWeight: FontWeight.w600),
        displayLarge: text.displayLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        displayMedium: text.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        displaySmall: text.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        centerTitle: false,
        titleTextStyle: readingText.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MonySpace.x4,
          vertical: MonySpace.x3,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MonyRadius.medium),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MonyRadius.medium),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MonyRadius.medium),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MonyRadius.medium),
          borderSide: BorderSide(color: colorScheme.error, width: 1.6),
        ),
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MonyRadius.extraLarge),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MonyRadius.extraLarge),
          ),
        ),
      ),
      textSelectionTheme: baseTheme.textSelectionTheme.copyWith(
        selectionColor: colorScheme.primary.withValues(alpha: .28),
        cursorColor: colorScheme.primary,
        selectionHandleColor: colorScheme.primary,
      ),
    );
  }

  static Color _lightSurfaceAccent(Color color) {
    final source = HSLColor.fromColor(color);
    for (var lightness = source.lightness; lightness >= 0; lightness -= .015) {
      final candidate = source.withLightness(lightness).toColor();
      if (_contrastRatio(candidate, Colors.white) >= 4.5) return candidate;
    }
    return MonyPalette.lavenderDark;
  }

  static Color _contrastingForeground(Color background) {
    const light = Colors.white;
    const dark = Color(0xFF241D2B);
    return _contrastRatio(background, light) >= _contrastRatio(background, dark)
        ? light
        : dark;
  }

  static double _contrastRatio(Color foreground, Color background) {
    final first = foreground.computeLuminance();
    final second = background.computeLuminance();
    final lighter = first > second ? first : second;
    final darker = first > second ? second : first;
    return (lighter + .05) / (darker + .05);
  }
}
