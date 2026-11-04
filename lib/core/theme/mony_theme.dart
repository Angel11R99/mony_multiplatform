import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/preferences/domain/app_preferences.dart';
import 'mony_finance_colors.dart';
import 'mony_tokens.dart';
import 'brush_border.dart';

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
    final japanese = preferences.visualTheme == AppVisualTheme.japaneseSumie;
    final dark = brightness == Brightness.dark;
    final brandColor =
        japanese &&
            preferences.primaryColorArgb ==
                AppPreferences.defaults.primaryColorArgb
        ? const Color(0xFF171717)
        : Color(preferences.primaryColorArgb);
    final accentColor =
        japanese &&
            preferences.accentColorArgb ==
                AppPreferences.defaults.accentColorArgb
        ? const Color(0xFFB43C30)
        : Color(preferences.accentColorArgb);
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
    final colorScheme = seedScheme.copyWith(
      primary: accessiblePrimary,
      onPrimary: _contrastingForeground(accessiblePrimary),
      secondary: accessibleSecondary,
      onSecondary: _contrastingForeground(accessibleSecondary),
      surface: japanese
          ? (dark ? const Color(0xFF211F1D) : const Color(0xFFF1E5D3))
          : dark
          ? MonyPalette.darkBackground
          : MonyPalette.lightBackground,
      onSurface: japanese
          ? (dark ? const Color(0xFFF3EBDD) : const Color(0xFF242220))
          : dark
          ? const Color(0xFFF4EFF8)
          : const Color(0xFF241D2B),
      surfaceContainerLow: dark
          ? (japanese ? const Color(0xFF2A2825) : MonyPalette.darkSurface)
          : (japanese ? const Color(0xFFF8EFE2) : MonyPalette.lightSurface),
      surfaceContainer: dark
          ? (japanese
                ? const Color(0xFF35322E)
                : MonyPalette.darkSurfaceVariant)
          : (japanese
                ? const Color(0xFFE8D9C5)
                : MonyPalette.lightSurfaceVariant),
      onSurfaceVariant: dark
          ? const Color(0xFFD0C6D8)
          : const Color(0xFF5F5667),
      outline: japanese
          ? (dark ? const Color(0xFFB4A99A) : const Color(0xFF77716B))
          : dark
          ? const Color(0xFF81778A)
          : const Color(0xFF817889),
      outlineVariant: japanese
          ? (dark ? const Color(0xFF625B52) : const Color(0xFFD8C7B0))
          : dark
          ? const Color(0xFF51485A)
          : const Color(0xFFD8D1DE),
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
    final brushSubtle = BrushBorder(
      radius: MonyRadius.medium,
      variation: .12,
      side: BorderSide(color: colorScheme.outlineVariant, width: 1.05),
    );
    final brushMedium = BrushBorder(
      radius: MonyRadius.large,
      variation: .24,
      side: BorderSide(color: colorScheme.outlineVariant, width: 1.45),
    );
    final brushStrong = BrushBorder(
      radius: MonyRadius.medium,
      variation: .32,
      side: BorderSide(color: colorScheme.secondary, width: 1.8),
    );
    BrushOutlineInputBorder brushInput(
      Color color,
      double width,
      double variation,
    ) => BrushOutlineInputBorder(
      borderRadius: BorderRadius.circular(MonyRadius.medium),
      borderSide: BorderSide(color: color, width: width),
      variation: variation,
    );
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
        border: japanese
            ? brushInput(colorScheme.outline, 1.05, .1)
            : baseTheme.inputDecorationTheme.border,
        enabledBorder: japanese
            ? brushInput(colorScheme.outlineVariant, 1.05, .1)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
        focusedBorder: japanese
            ? brushInput(colorScheme.primary, 1.8, .2)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
              ),
        errorBorder: japanese
            ? brushInput(colorScheme.error, 1.2, .12)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.error),
              ),
        focusedErrorBorder: japanese
            ? brushInput(colorScheme.error, 1.8, .2)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.error, width: 1.6),
              ),
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: japanese
            ? BrushBorder(
                radius: MonyRadius.extraLarge,
                variation: .2,
                side: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1.35,
                ),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MonyRadius.extraLarge),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
      ),
      bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: japanese
            ? BrushTopBorder(
                radius: MonyRadius.extraLarge,
                side: BorderSide(color: colorScheme.outlineVariant, width: 1.3),
                variation: .18,
              )
            : const RoundedRectangleBorder(
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
      cardTheme: baseTheme.cardTheme.copyWith(
        color: colorScheme.surfaceContainerLow,
        shape: japanese ? brushMedium : baseTheme.cardTheme.shape,
      ),
      outlinedButtonTheme: japanese
          ? OutlinedButtonThemeData(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(brushSubtle),
                side: WidgetStatePropertyAll(
                  BorderSide(color: colorScheme.outline, width: 1.15),
                ),
              ),
            )
          : baseTheme.outlinedButtonTheme,
      filledButtonTheme: japanese
          ? FilledButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
                foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
                shape: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? brushMedium
                      : brushStrong,
                ),
                side: WidgetStateProperty.resolveWith(
                  (states) => BorderSide(
                    color: states.contains(WidgetState.disabled)
                        ? colorScheme.outlineVariant
                        : colorScheme.secondary,
                    width: states.contains(WidgetState.disabled) ? 1 : 1.5,
                  ),
                ),
              ),
            )
          : baseTheme.filledButtonTheme,
      elevatedButtonTheme: japanese
          ? ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  colorScheme.surfaceContainer,
                ),
                foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
                elevation: const WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(brushMedium),
              ),
            )
          : baseTheme.elevatedButtonTheme,
      floatingActionButtonTheme: japanese
          ? baseTheme.floatingActionButtonTheme.copyWith(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              shape: BrushCircleBorder(
                side: BorderSide(color: colorScheme.onSecondary, width: 1.2),
                variation: .24,
              ),
            )
          : baseTheme.floatingActionButtonTheme,
      chipTheme: japanese
          ? baseTheme.chipTheme.copyWith(
              color: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return colorScheme.surfaceContainer;
                }
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.secondary.withValues(alpha: .14);
                }
                return colorScheme.surfaceContainerLow;
              }),
              backgroundColor: colorScheme.surfaceContainerLow,
              selectedColor: colorScheme.secondary.withValues(alpha: .14),
              checkmarkColor: colorScheme.secondary,
              side: BorderSide(color: colorScheme.outlineVariant, width: .95),
              shape: BrushBorder(
                radius: MonyRadius.small,
                variation: .2,
                side: BorderSide(color: colorScheme.outlineVariant, width: 1.1),
              ),
              labelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              secondaryLabelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w700,
              ),
            )
          : baseTheme.chipTheme,
      segmentedButtonTheme: japanese
          ? SegmentedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.secondary.withValues(alpha: .14)
                      : colorScheme.surfaceContainerLow,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.secondary
                      : colorScheme.onSurfaceVariant,
                ),
                shape: WidgetStateProperty.resolveWith(
                  (states) => BrushBorder(
                    radius: MonyRadius.small,
                    variation: states.contains(WidgetState.selected)
                        ? .28
                        : .16,
                    side: BorderSide(
                      color: states.contains(WidgetState.selected)
                          ? colorScheme.secondary
                          : colorScheme.outlineVariant,
                      width: states.contains(WidgetState.selected)
                          ? 1.65
                          : 1.05,
                    ),
                  ),
                ),
              ),
            )
          : baseTheme.segmentedButtonTheme,
      searchBarTheme: japanese
          ? SearchBarThemeData(
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.surfaceContainerLow,
              ),
              elevation: const WidgetStatePropertyAll(0),
              side: WidgetStatePropertyAll(
                BorderSide(color: colorScheme.outlineVariant, width: 1.1),
              ),
              shape: WidgetStatePropertyAll(brushSubtle),
              overlayColor: WidgetStatePropertyAll(
                colorScheme.secondary.withValues(alpha: .08),
              ),
            )
          : baseTheme.searchBarTheme,
      navigationRailTheme: japanese
          ? baseTheme.navigationRailTheme.copyWith(
              backgroundColor: colorScheme.surfaceContainerLow,
              indicatorColor: colorScheme.secondary.withValues(alpha: .14),
              indicatorShape: BrushBorder(
                radius: MonyRadius.medium,
                variation: .26,
                side: BorderSide(color: colorScheme.secondary, width: 1.4),
              ),
              selectedIconTheme: IconThemeData(color: colorScheme.secondary),
              selectedLabelTextStyle: TextStyle(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w700,
              ),
            )
          : baseTheme.navigationRailTheme,
      dividerTheme: japanese
          ? baseTheme.dividerTheme.copyWith(
              color: colorScheme.outlineVariant.withValues(alpha: .72),
              thickness: .8,
            )
          : baseTheme.dividerTheme,
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
