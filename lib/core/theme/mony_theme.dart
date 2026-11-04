import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/preferences/domain/app_preferences.dart';
import 'mony_finance_colors.dart';
import 'mony_tokens.dart';
import 'brush_border.dart';
import 'sumi_visuals.dart';
import 'coquette_visuals.dart';

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
    final coquette = preferences.visualTheme == AppVisualTheme.coquetteBloom;
    final dark = brightness == Brightness.dark;
    const sumie = SumiThemeColors.defaults;
    const bloom = CoquetteThemeColors.defaults;
    final brandColor =
        coquette &&
            preferences.primaryColorArgb ==
                AppPreferences.defaults.primaryColorArgb
        ? bloom.berry
        : japanese &&
              preferences.primaryColorArgb ==
                  AppPreferences.defaults.primaryColorArgb
        ? sumie.vermilion
        : Color(preferences.primaryColorArgb);
    final accentColor =
        coquette &&
            preferences.accentColorArgb ==
                AppPreferences.defaults.accentColorArgb
        ? bloom.champagne
        : japanese &&
              preferences.accentColorArgb ==
                  AppPreferences.defaults.accentColorArgb
        ? sumie.gold
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
    final colorScheme = coquette
        ? _coquetteColorScheme(
            seedScheme,
            brandColor: accessiblePrimary,
            accentColor: accessibleSecondary,
            dark: dark,
          )
        : seedScheme.copyWith(
            primary: accessiblePrimary,
            onPrimary: _contrastingForeground(accessiblePrimary),
            secondary: accessibleSecondary,
            onSecondary: _contrastingForeground(accessibleSecondary),
            tertiary: japanese ? sumie.jade : seedScheme.tertiary,
            onTertiary: japanese ? sumie.paper : seedScheme.onTertiary,
            primaryContainer: japanese
                ? (dark ? sumie.deepVermilion : const Color(0xFFE9CFC6))
                : seedScheme.primaryContainer,
            onPrimaryContainer: japanese
                ? (dark ? sumie.paper : const Color(0xFF3B1D18))
                : seedScheme.onPrimaryContainer,
            secondaryContainer: japanese
                ? (dark ? const Color(0xFF463A25) : const Color(0xFFE8D8B8))
                : seedScheme.secondaryContainer,
            onSecondaryContainer: japanese
                ? (dark ? const Color(0xFFF3E7D3) : const Color(0xFF342A1A))
                : seedScheme.onSecondaryContainer,
            surface: japanese
                ? (dark ? sumie.ink : sumie.paper)
                : dark
                ? MonyPalette.darkBackground
                : MonyPalette.lightBackground,
            onSurface: japanese
                ? (dark ? sumie.paper : sumie.ink)
                : dark
                ? const Color(0xFFF4EFF8)
                : const Color(0xFF241D2B),
            surfaceContainerLow: dark
                ? (japanese ? sumie.charcoal : MonyPalette.darkSurface)
                : (japanese
                      ? const Color(0xFFF8EFE2)
                      : MonyPalette.lightSurface),
            surfaceContainer: dark
                ? (japanese
                      ? const Color(0xFF342A23)
                      : MonyPalette.darkSurfaceVariant)
                : (japanese
                      ? const Color(0xFFE7D7BE)
                      : MonyPalette.lightSurfaceVariant),
            onSurfaceVariant: dark
                ? (japanese ? const Color(0xFFCDBA9E) : const Color(0xFFD0C6D8))
                : (japanese
                      ? const Color(0xFF6A5944)
                      : const Color(0xFF5F5667)),
            outline: japanese
                ? (dark ? sumie.gold : sumie.bronze)
                : dark
                ? const Color(0xFF81778A)
                : const Color(0xFF817889),
            outlineVariant: japanese
                ? (dark ? sumie.bronze : sumie.warmPaper)
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
        MonyFinanceColors.forBrightness(
          brightness,
          japanese: japanese,
          coquette: coquette,
        ),
        if (japanese) sumie,
        if (coquette) bloom,
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
    final brushSubtle = SumiOpenFrameBorder(
      variation: .12,
      side: BorderSide(color: colorScheme.outlineVariant, width: 1.05),
    );
    final brushMedium = SumiOpenFrameBorder(
      variation: .24,
      side: BorderSide(color: colorScheme.outline, width: 1.55),
    );
    final brushStrong = SumiOpenFrameBorder(
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
    CoquettePearlInputBorder bloomInput(Color color, double width) =>
        CoquettePearlInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );
    return baseTheme.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: readingText.copyWith(
        headlineLarge:
            GoogleFonts.plusJakartaSans(textStyle: text.headlineLarge).copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: japanese || coquette ? 'serif' : null,
              letterSpacing: japanese ? .15 : -1.1,
              height: 1.08,
            ),
        headlineMedium:
            GoogleFonts.plusJakartaSans(
              textStyle: text.headlineMedium,
            ).copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: japanese || coquette ? 'serif' : null,
              letterSpacing: japanese ? .1 : -0.7,
              height: 1.12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
        headlineSmall:
            GoogleFonts.plusJakartaSans(textStyle: text.headlineSmall).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.35,
              fontFamily: coquette ? 'serif' : null,
            ),
        titleLarge: GoogleFonts.plusJakartaSans(textStyle: text.titleLarge)
            .copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: japanese || coquette ? 'serif' : null,
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
          fontFamily: coquette ? 'serif' : null,
        ),
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MonySpace.x4,
          vertical: MonySpace.x3,
        ),
        border: coquette
            ? bloomInput(colorScheme.outline, 1)
            : japanese
            ? brushInput(colorScheme.outline, 1.05, .1)
            : baseTheme.inputDecorationTheme.border,
        enabledBorder: coquette
            ? bloomInput(colorScheme.outlineVariant, 1)
            : japanese
            ? brushInput(colorScheme.outlineVariant, 1.05, .1)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
        focusedBorder: coquette
            ? bloomInput(colorScheme.primary, 2)
            : japanese
            ? brushInput(colorScheme.primary, 1.8, .2)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
              ),
        errorBorder: coquette
            ? bloomInput(colorScheme.error, 1.2)
            : japanese
            ? brushInput(colorScheme.error, 1.2, .12)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.error),
              ),
        focusedErrorBorder: coquette
            ? bloomInput(colorScheme.error, 2)
            : japanese
            ? brushInput(colorScheme.error, 1.8, .2)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.error, width: 1.6),
              ),
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: coquette
            ? CoquettePetalBorder(
                side: BorderSide(color: colorScheme.outline, width: 1.1),
              )
            : japanese
            ? SumiOpenFrameBorder(
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
        shape: coquette
            ? CoquettePetalBorder(
                side: BorderSide(color: colorScheme.outline, width: 1.1),
              )
            : japanese
            ? SumiOpenFrameBorder(
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
        shape: coquette
            ? CoquettePetalBorder(
                side: BorderSide(color: colorScheme.outlineVariant, width: 1),
              )
            : japanese
            ? SumiOpenFrameBorder(
                variation: .24,
                side: BorderSide(
                  color: colorScheme.onSurfaceVariant,
                  width: 1.25,
                ),
              )
            : baseTheme.cardTheme.shape,
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
          : coquette
          ? OutlinedButtonThemeData(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  CoquettePetalBorder(
                    side: BorderSide(color: colorScheme.outline, width: 1),
                  ),
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(color: colorScheme.outline, width: 1),
                ),
                foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
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
          : coquette
          ? FilledButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
                foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
                shape: WidgetStatePropertyAll(
                  CoquettePetalBorder(
                    side: BorderSide(color: bloom.champagne, width: 1.2),
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
          : coquette
          ? ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  colorScheme.surfaceContainer,
                ),
                foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
                elevation: const WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  CoquettePetalBorder(
                    side: BorderSide(color: colorScheme.outline, width: 1),
                  ),
                ),
              ),
            )
          : baseTheme.elevatedButtonTheme,
      floatingActionButtonTheme: coquette
          ? baseTheme.floatingActionButtonTheme.copyWith(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: CoquettePetalBorder(
                side: BorderSide(color: bloom.champagne, width: 1.3),
              ),
            )
          : japanese
          ? baseTheme.floatingActionButtonTheme.copyWith(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: SumiOpenFrameBorder(
                side: BorderSide(color: colorScheme.secondary, width: 1.5),
                variation: .32,
              ),
            )
          : baseTheme.floatingActionButtonTheme,
      chipTheme: coquette
          ? baseTheme.chipTheme.copyWith(
              color: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return colorScheme.surfaceContainer;
                }
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primaryContainer;
                }
                return colorScheme.surfaceContainerLow;
              }),
              backgroundColor: colorScheme.surfaceContainerLow,
              selectedColor: colorScheme.primaryContainer,
              showCheckmark: true,
              checkmarkColor: colorScheme.onPrimaryContainer,
              side: BorderSide(color: colorScheme.outlineVariant, width: .9),
              shape: CoquettePetalBorder(
                side: BorderSide(color: colorScheme.outline, width: .9),
              ),
              labelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              secondaryLabelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            )
          : japanese
          ? baseTheme.chipTheme.copyWith(
              color: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return colorScheme.surfaceContainer;
                }
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primary;
                }
                return colorScheme.surfaceContainerLow;
              }),
              backgroundColor: colorScheme.surfaceContainerLow,
              selectedColor: colorScheme.primary,
              showCheckmark: true,
              checkmarkColor: colorScheme.onPrimary,
              side: BorderSide(color: colorScheme.outlineVariant, width: .95),
              shape: SumiOpenFrameBorder(
                variation: .2,
                side: BorderSide(color: colorScheme.outline, width: 1.1),
              ),
              labelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              secondaryLabelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            )
          : baseTheme.chipTheme,
      segmentedButtonTheme: coquette
          ? SegmentedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.primaryContainer
                      : Colors.transparent,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
                shape: WidgetStateProperty.resolveWith(
                  (states) => CoquettePetalBorder(
                    side: BorderSide(
                      color: states.contains(WidgetState.selected)
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: states.contains(WidgetState.selected) ? 1.4 : .8,
                    ),
                  ),
                ),
              ),
            )
          : japanese
          ? SegmentedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.primary
                      : Colors.transparent,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
                shape: WidgetStateProperty.resolveWith(
                  (states) => SumiOpenFrameBorder(
                    variation: states.contains(WidgetState.selected)
                        ? .28
                        : .16,
                    side: BorderSide(
                      color: states.contains(WidgetState.selected)
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: states.contains(WidgetState.selected) ? 2.1 : .8,
                    ),
                  ),
                ),
              ),
            )
          : baseTheme.segmentedButtonTheme,
      searchBarTheme: coquette
          ? SearchBarThemeData(
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.surfaceContainerLow,
              ),
              elevation: const WidgetStatePropertyAll(0),
              side: WidgetStatePropertyAll(
                BorderSide(color: colorScheme.outlineVariant, width: 1),
              ),
              shape: WidgetStatePropertyAll(
                CoquettePetalBorder(
                  side: BorderSide(color: colorScheme.outline, width: 1),
                ),
              ),
            )
          : japanese
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
      navigationRailTheme: coquette
          ? baseTheme.navigationRailTheme.copyWith(
              backgroundColor: colorScheme.surfaceContainerLow,
              indicatorColor: colorScheme.primaryContainer,
              indicatorShape: const CoquettePetalBorder(),
              selectedIconTheme: IconThemeData(color: colorScheme.primary),
              selectedLabelTextStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : japanese
          ? baseTheme.navigationRailTheme.copyWith(
              backgroundColor: colorScheme.surfaceContainerLow,
              indicatorColor: Colors.transparent,
              indicatorShape: const RoundedRectangleBorder(),
              selectedIconTheme: IconThemeData(color: colorScheme.primary),
              selectedLabelTextStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : baseTheme.navigationRailTheme,
      dividerTheme: coquette
          ? baseTheme.dividerTheme.copyWith(
              color: colorScheme.outlineVariant.withValues(alpha: .7),
              thickness: .8,
              indent: 4,
              endIndent: 4,
            )
          : japanese
          ? baseTheme.dividerTheme.copyWith(
              color: colorScheme.outlineVariant.withValues(alpha: .72),
              thickness: .8,
            )
          : baseTheme.dividerTheme,
    );
  }

  static ColorScheme _coquetteColorScheme(
    ColorScheme seed, {
    required Color brandColor,
    required Color accentColor,
    required bool dark,
  }) {
    const bloom = CoquetteThemeColors.defaults;
    final surface = dark ? const Color(0xFF211B22) : bloom.ivory;
    final onSurface = dark ? bloom.cream : bloom.cocoa;
    final lowSurface = dark ? const Color(0xFF302631) : bloom.cream;
    final mediumSurface = dark
        ? const Color(0xFF3B303D)
        : const Color(0xFFF9EAF0);
    final highSurface = dark
        ? const Color(0xFF493A4A)
        : const Color(0xFFF5DCE4);
    return seed.copyWith(
      primary: brandColor,
      onPrimary: _contrastingForeground(brandColor),
      secondary: accentColor,
      onSecondary: _contrastingForeground(accentColor),
      tertiary: dark ? bloom.lavender : bloom.mauve,
      onTertiary: dark ? bloom.cocoa : Colors.white,
      error: dark ? const Color(0xFFF0A0B0) : const Color(0xFF9B3E57),
      onError: dark ? const Color(0xFF351B25) : Colors.white,
      primaryContainer: dark ? const Color(0xFF633B53) : bloom.blush,
      onPrimaryContainer: dark ? bloom.cream : bloom.berry,
      secondaryContainer: dark
          ? const Color(0xFF473A50)
          : const Color(0xFFEAE2F5),
      onSecondaryContainer: dark ? bloom.cream : bloom.cocoa,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerLowest: dark ? const Color(0xFF19141B) : Colors.white,
      surfaceContainerLow: lowSurface,
      surfaceContainer: mediumSurface,
      surfaceContainerHigh: highSurface,
      surfaceContainerHighest: dark ? const Color(0xFF59475A) : bloom.blush,
      surfaceDim: dark ? const Color(0xFF19141B) : const Color(0xFFF3E8E6),
      surfaceBright: dark ? const Color(0xFF493A4A) : Colors.white,
      onSurfaceVariant: dark ? const Color(0xFFE2CEDB) : bloom.mauve,
      outline: dark ? const Color(0xFFB99AAA) : bloom.dustyRose,
      outlineVariant: dark ? const Color(0xFF5A4859) : const Color(0xFFE8D4DB),
      shadow: dark ? Colors.black : bloom.cocoa.withValues(alpha: .12),
      scrim: Colors.black.withValues(alpha: .54),
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
