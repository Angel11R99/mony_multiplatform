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
    const sumieVermilion = Color(0xFFB63A2B);
    const sumieDeepVermilion = Color(0xFF8F2A22);
    const sumieAgedGold = Color(0xFFA98A52);
    const sumieMutedJade = Color(0xFF3E6B64);
    final brandColor =
        japanese &&
            preferences.primaryColorArgb ==
                AppPreferences.defaults.primaryColorArgb
        ? sumieVermilion
        : Color(preferences.primaryColorArgb);
    final accentColor =
        japanese &&
            preferences.accentColorArgb ==
                AppPreferences.defaults.accentColorArgb
        ? sumieAgedGold
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
      tertiary: japanese ? sumieMutedJade : seedScheme.tertiary,
      onTertiary: japanese ? const Color(0xFFFFF7E8) : seedScheme.onTertiary,
      primaryContainer: japanese
          ? (dark ? sumieDeepVermilion : const Color(0xFFE9CFC6))
          : seedScheme.primaryContainer,
      onPrimaryContainer: japanese
          ? (dark ? const Color(0xFFF3E7D3) : const Color(0xFF3B1D18))
          : seedScheme.onPrimaryContainer,
      secondaryContainer: japanese
          ? (dark ? const Color(0xFF463A25) : const Color(0xFFE8D8B8))
          : seedScheme.secondaryContainer,
      onSecondaryContainer: japanese
          ? (dark ? const Color(0xFFF3E7D3) : const Color(0xFF342A1A))
          : seedScheme.onSecondaryContainer,
      surface: japanese
          ? (dark ? const Color(0xFF151311) : const Color(0xFFF3E7D3))
          : dark
          ? MonyPalette.darkBackground
          : MonyPalette.lightBackground,
      onSurface: japanese
          ? (dark ? const Color(0xFFF3E7D3) : const Color(0xFF221D1A))
          : dark
          ? const Color(0xFFF4EFF8)
          : const Color(0xFF241D2B),
      surfaceContainerLow: dark
          ? (japanese ? const Color(0xFF221D1A) : MonyPalette.darkSurface)
          : (japanese ? const Color(0xFFF8EFE2) : MonyPalette.lightSurface),
      surfaceContainer: dark
          ? (japanese
                ? const Color(0xFF2A2420)
                : MonyPalette.darkSurfaceVariant)
          : (japanese
                ? const Color(0xFFE7D7BE)
                : MonyPalette.lightSurfaceVariant),
      onSurfaceVariant: dark
          ? (japanese ? const Color(0xFFCDBA9E) : const Color(0xFFD0C6D8))
          : (japanese ? const Color(0xFF6A5944) : const Color(0xFF5F5667)),
      outline: japanese
          ? (dark ? sumieAgedGold : const Color(0xFF8B6B3F))
          : dark
          ? const Color(0xFF81778A)
          : const Color(0xFF817889),
      outlineVariant: japanese
          ? (dark ? const Color(0xFF705938) : const Color(0xFFCDBA9E))
          : dark
          ? const Color(0xFF51485A)
          : const Color(0xFFD8D1DE),
      surfaceDim: japanese
          ? (dark ? const Color(0xFF110F0D) : const Color(0xFFE7D7BE))
          : seedScheme.surfaceDim,
      surfaceBright: japanese
          ? (dark ? const Color(0xFF342D27) : const Color(0xFFFFFAF1))
          : seedScheme.surfaceBright,
      surfaceContainerLowest: japanese
          ? (dark ? const Color(0xFF100E0C) : const Color(0xFFFFFCF6))
          : seedScheme.surfaceContainerLowest,
      surfaceContainerHigh: japanese
          ? (dark ? const Color(0xFF342D27) : const Color(0xFFDDCAB0))
          : seedScheme.surfaceContainerHigh,
      surfaceContainerHighest: japanese
          ? (dark ? const Color(0xFF40362D) : const Color(0xFFCDBA9E))
          : seedScheme.surfaceContainerHighest,
    );

    final themeBuilder = brightness == Brightness.light
        ? FlexThemeData.light
        : FlexThemeData.dark;

    final baseTheme = themeBuilder(
      colorScheme: colorScheme,
      useMaterial3: true,
      extensions: [
        MonyFinanceColors.forBrightness(brightness, japanese: japanese),
      ],
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
      side: BorderSide(color: colorScheme.outline, width: 1.55),
    );
    final brushStrong = BrushBorder(
      radius: MonyRadius.medium,
      variation: .32,
      side: BorderSide(color: colorScheme.primary, width: 1.9),
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
              fontFamily: japanese ? 'serif' : null,
              letterSpacing: japanese ? .15 : -1.1,
              height: 1.08,
            ),
        headlineMedium:
            GoogleFonts.plusJakartaSans(
              textStyle: text.headlineMedium,
            ).copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: japanese ? 'serif' : null,
              letterSpacing: japanese ? .1 : -0.7,
              height: 1.12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          textStyle: text.headlineSmall,
        ).copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.35),
        titleLarge: GoogleFonts.plusJakartaSans(textStyle: text.titleLarge)
            .copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: japanese ? 'serif' : null,
            ),
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
                side: BorderSide(color: colorScheme.outline, width: 1.35),
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
                side: BorderSide(color: colorScheme.outline, width: 1.35),
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
                        : colorScheme.outline,
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
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: BrushCircleBorder(
                side: BorderSide(color: colorScheme.secondary, width: 1.5),
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
                  return colorScheme.primary.withValues(alpha: .16);
                }
                return colorScheme.surfaceContainerLow;
              }),
              backgroundColor: colorScheme.surfaceContainerLow,
              selectedColor: colorScheme.primary.withValues(alpha: .16),
              checkmarkColor: colorScheme.primary,
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
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : baseTheme.chipTheme,
      segmentedButtonTheme: japanese
          ? SegmentedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.primary.withValues(alpha: .16)
                      : colorScheme.surfaceContainerLow,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.primary
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
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: states.contains(WidgetState.selected) ? 1.8 : 1.05,
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
                colorScheme.primary.withValues(alpha: .08),
              ),
            )
          : baseTheme.searchBarTheme,
      navigationRailTheme: japanese
          ? baseTheme.navigationRailTheme.copyWith(
              backgroundColor: colorScheme.surfaceContainerLow,
              indicatorColor: colorScheme.primary.withValues(alpha: .16),
              indicatorShape: BrushBorder(
                radius: MonyRadius.medium,
                variation: .26,
                side: BorderSide(color: colorScheme.primary, width: 1.6),
              ),
              selectedIconTheme: IconThemeData(color: colorScheme.primary),
              selectedLabelTextStyle: TextStyle(
                color: colorScheme.primary,
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
