import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/preferences/domain/app_preferences.dart';
import 'mony_finance_colors.dart';
import 'mony_tokens.dart';
import 'brush_border.dart';
import 'sumi_visuals.dart';
import 'coquette_visuals.dart';
import 'cyberpunk_visuals.dart';

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
    final cyberpunk = preferences.visualTheme == AppVisualTheme.cyberpunk;
    final dark = cyberpunk || brightness == Brightness.dark;
    const sumie = SumiThemeColors.defaults;
    const bloom = CoquetteThemeColors.defaults;
    const atelierDark = CoquetteSurfaceTokens.dark;
    final atelier = CoquetteSurfaceTokens.forBrightness(brightness);
    final brandColor =
        cyberpunk &&
            preferences.primaryColorArgb ==
                AppPreferences.defaults.primaryColorArgb
        ? CyberpunkTokens.defaults.cyan
        : coquette &&
              preferences.primaryColorArgb ==
                  AppPreferences.defaults.primaryColorArgb
        ? (dark ? atelierDark.primaryAccent : bloom.berry)
        : japanese &&
              preferences.primaryColorArgb ==
                  AppPreferences.defaults.primaryColorArgb
        ? sumie.vermilion
        : Color(preferences.primaryColorArgb);
    final accentColor =
        cyberpunk &&
            preferences.accentColorArgb ==
                AppPreferences.defaults.accentColorArgb
        ? CyberpunkTokens.defaults.magenta
        : coquette &&
              preferences.accentColorArgb ==
                  AppPreferences.defaults.accentColorArgb
        ? (dark ? atelierDark.secondaryAccent : bloom.champagne)
        : japanese &&
              preferences.accentColorArgb ==
                  AppPreferences.defaults.accentColorArgb
        ? sumie.gold
        : Color(preferences.accentColorArgb);
    final accessiblePrimary = !dark
        ? _lightSurfaceAccent(brandColor)
        : brandColor;
    final accessibleSecondary = !dark
        ? _lightSurfaceAccent(accentColor)
        : accentColor;
    final seedScheme = ColorScheme.fromSeed(
      seedColor: brandColor,
      secondary: accentColor,
      brightness: dark ? Brightness.dark : Brightness.light,
    );
    final colorScheme = cyberpunk
        ? _cyberpunkColorScheme(
            seedScheme,
            brandColor: brandColor,
            accentColor: accentColor,
          )
        : coquette
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

    final themeBuilder = dark
        ? FlexThemeData.dark
        : brightness == Brightness.light
        ? FlexThemeData.light
        : FlexThemeData.dark;

    final baseTheme = themeBuilder(
      colorScheme: colorScheme,
      useMaterial3: true,
      extensions: [
        MonyFinanceColors.forBrightness(
          dark ? Brightness.dark : Brightness.light,
          japanese: japanese,
          coquette: coquette,
          cyberpunk: cyberpunk,
        ),
        if (japanese) sumie,
        if (coquette) bloom,
        if (coquette) atelier,
        if (cyberpunk) CyberpunkTokens.defaults,
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
      scaffoldBackgroundColor: cyberpunk
          ? Colors.transparent
          : colorScheme.surface,
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
        border: cyberpunk
            ? OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colorScheme.outline),
              )
            : coquette
            ? bloomInput(colorScheme.outline, 1)
            : japanese
            ? brushInput(colorScheme.outline, 1.05, .1)
            : baseTheme.inputDecorationTheme.border,
        enabledBorder: cyberpunk
            ? OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: .9,
                ),
              )
            : coquette
            ? bloomInput(colorScheme.outlineVariant, 1)
            : japanese
            ? brushInput(colorScheme.outlineVariant, 1.05, .1)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
        focusedBorder: cyberpunk
            ? OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colorScheme.primary, width: 1.7),
              )
            : coquette
            ? bloomInput(colorScheme.primary, 2)
            : japanese
            ? brushInput(colorScheme.primary, 1.8, .2)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
              ),
        errorBorder: cyberpunk
            ? OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colorScheme.error, width: 1.2),
              )
            : coquette
            ? bloomInput(colorScheme.error, 1.2)
            : japanese
            ? brushInput(colorScheme.error, 1.2, .12)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(MonyRadius.medium),
                borderSide: BorderSide(color: colorScheme.error),
              ),
        focusedErrorBorder: cyberpunk
            ? OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colorScheme.error, width: 1.8),
              )
            : coquette
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
        shape: cyberpunk
            ? HudPanelBorder(
                side: BorderSide(color: colorScheme.outline, width: 1),
              )
            : coquette
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: dark ? atelier.mutedBorder : bloom.champagne,
                ),
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
        shape: cyberpunk
            ? HudPanelBorder(
                side: BorderSide(color: colorScheme.outline, width: 1),
              )
            : coquette
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
        shape: cyberpunk
            ? HudPanelBorder(
                side: BorderSide(color: colorScheme.outlineVariant, width: .8),
              )
            : coquette
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  color: dark ? atelier.mutedBorder : bloom.champagne,
                ),
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
      outlinedButtonTheme: cyberpunk
          ? OutlinedButtonThemeData(
              style: ButtonStyle(
                shape: const WidgetStatePropertyAll(HudPanelBorder()),
                side: WidgetStatePropertyAll(
                  BorderSide(color: colorScheme.outline, width: 1),
                ),
                foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
              ),
            )
          : japanese
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
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? (dark
                            ? atelier.disabledText
                            : colorScheme.onSurfaceVariant)
                      : colorScheme.primary,
                ),
              ),
            )
          : baseTheme.outlinedButtonTheme,
      filledButtonTheme: cyberpunk
          ? FilledButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? colorScheme.surfaceContainer
                      : colorScheme.primary,
                ),
                foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
                shape: const WidgetStatePropertyAll(HudPanelBorder()),
                side: WidgetStatePropertyAll(
                  BorderSide(color: colorScheme.secondary, width: 1),
                ),
              ),
            )
          : japanese
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
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? (dark
                            ? atelier.disabledSurface
                            : colorScheme.surfaceContainer)
                      : colorScheme.primary,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? (dark
                            ? atelier.disabledText
                            : colorScheme.onSurfaceVariant)
                      : colorScheme.onPrimary,
                ),
                side: WidgetStateProperty.resolveWith(
                  (states) => BorderSide(
                    color: states.contains(WidgetState.disabled)
                        ? atelier.mutedBorder
                        : (dark ? atelier.primaryAccent : bloom.champagne),
                    width: states.contains(WidgetState.disabled) ? .9 : 1.2,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  CoquettePetalBorder(
                    side: BorderSide(
                      color: dark ? atelier.primaryAccent : bloom.champagne,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            )
          : baseTheme.filledButtonTheme,
      elevatedButtonTheme: cyberpunk
          ? ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  colorScheme.surfaceContainer,
                ),
                foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
                elevation: const WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  HudPanelBorder(side: BorderSide(color: colorScheme.outline)),
                ),
              ),
            )
          : japanese
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
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? (dark
                            ? atelier.disabledSurface
                            : colorScheme.surfaceContainer)
                      : colorScheme.surfaceContainer,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.disabled)
                      ? (dark
                            ? atelier.disabledText
                            : colorScheme.onSurfaceVariant)
                      : colorScheme.onSurface,
                ),
                elevation: const WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  CoquettePetalBorder(
                    side: BorderSide(
                      color: dark ? atelier.mutedBorder : colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
              ),
            )
          : baseTheme.elevatedButtonTheme,
      floatingActionButtonTheme: cyberpunk
          ? baseTheme.floatingActionButtonTheme.copyWith(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: const HudPanelBorder(),
              elevation: 4,
              focusElevation: 5,
              hoverElevation: 6,
            )
          : coquette
          ? baseTheme.floatingActionButtonTheme.copyWith(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: CoquettePetalBorder(
                side: BorderSide(
                  color: dark ? atelier.primaryAccent : bloom.champagne,
                  width: 1.3,
                ),
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
      chipTheme: cyberpunk
          ? baseTheme.chipTheme.copyWith(
              color: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainer,
              ),
              backgroundColor: colorScheme.surfaceContainer,
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.outlineVariant),
              shape: const HudPanelBorder(),
              labelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              secondaryLabelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : coquette
          ? baseTheme.chipTheme.copyWith(
              color: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return dark
                      ? atelier.disabledSurface
                      : colorScheme.surfaceContainer;
                }
                if (states.contains(WidgetState.selected)) {
                  return dark
                      ? atelier.selectedSurface
                      : colorScheme.primaryContainer;
                }
                return dark
                    ? atelier.subtleSurface
                    : colorScheme.surfaceContainerLow;
              }),
              backgroundColor: colorScheme.surfaceContainerLow,
              selectedColor: colorScheme.primaryContainer,
              showCheckmark: true,
              checkmarkColor: colorScheme.onPrimaryContainer,
              side: BorderSide(color: atelier.mutedBorder, width: .9),
              shape: CoquettePetalBorder(
                side: BorderSide(color: colorScheme.outline, width: .9),
              ),
              labelStyle: baseTheme.textTheme.labelLarge?.copyWith(
                color: dark
                    ? atelier.secondaryText
                    : colorScheme.onSurfaceVariant,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: MonySpace.x3,
                vertical: MonySpace.x1,
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
      segmentedButtonTheme: cyberpunk
          ? SegmentedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerLow,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                shape: WidgetStateProperty.resolveWith(
                  (states) => HudPanelBorder(
                    side: BorderSide(
                      color: states.contains(WidgetState.selected)
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: states.contains(WidgetState.selected) ? 1.3 : .8,
                    ),
                  ),
                ),
              ),
            )
          : coquette
          ? SegmentedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? (dark
                            ? atelier.selectedSurface
                            : colorScheme.primaryContainer)
                      : (dark ? atelier.subtleSurface : Colors.transparent),
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? (dark
                            ? atelier.primaryText
                            : colorScheme.onPrimaryContainer)
                      : (dark
                            ? atelier.secondaryText
                            : colorScheme.onSurfaceVariant),
                ),
                shape: WidgetStateProperty.resolveWith(
                  (states) => CoquettePetalBorder(
                    side: BorderSide(
                      color: states.contains(WidgetState.selected)
                          ? colorScheme.primary
                          : (dark
                                ? atelier.mutedBorder
                                : colorScheme.outlineVariant),
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
      searchBarTheme: cyberpunk
          ? SearchBarThemeData(
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.surfaceContainerLow,
              ),
              elevation: const WidgetStatePropertyAll(0),
              side: WidgetStatePropertyAll(
                BorderSide(color: colorScheme.outlineVariant),
              ),
              shape: const WidgetStatePropertyAll(HudPanelBorder()),
            )
          : coquette
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
      navigationRailTheme: cyberpunk
          ? baseTheme.navigationRailTheme.copyWith(
              backgroundColor: colorScheme.surface,
              indicatorColor: colorScheme.primaryContainer,
              indicatorShape: const HudPanelBorder(),
              selectedIconTheme: IconThemeData(color: colorScheme.primary),
              selectedLabelTextStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : coquette
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
    const darkTokens = CoquetteSurfaceTokens.dark;
    final surfaceTokens = CoquetteSurfaceTokens.forBrightness(
      dark ? Brightness.dark : Brightness.light,
    );
    final surface = surfaceTokens.page;
    final onSurface = surfaceTokens.primaryText;
    final lowSurface = dark ? darkTokens.primarySurface : bloom.cream;
    final mediumSurface = dark
        ? darkTokens.elevatedSurface
        : const Color(0xFFF9EAF0);
    final highSurface = dark
        ? darkTokens.selectedSurface
        : const Color(0xFFF5DCE4);
    return seed.copyWith(
      primary: brandColor,
      onPrimary: _contrastingForeground(brandColor),
      secondary: accentColor,
      onSecondary: _contrastingForeground(accentColor),
      tertiary: dark ? darkTokens.secondaryAccent : bloom.mauve,
      onTertiary: dark ? darkTokens.page : Colors.white,
      error: dark ? darkTokens.expenseAccent : const Color(0xFF9B3E57),
      onError: dark ? darkTokens.page : Colors.white,
      primaryContainer: dark ? darkTokens.selectedSurface : bloom.blush,
      onPrimaryContainer: dark ? darkTokens.primaryText : bloom.berry,
      secondaryContainer: dark
          ? darkTokens.elevatedSurface
          : const Color(0xFFEAE2F5),
      onSecondaryContainer: dark ? darkTokens.primaryText : bloom.cocoa,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerLowest: dark ? darkTokens.subtleSurface : Colors.white,
      surfaceContainerLow: lowSurface,
      surfaceContainer: mediumSurface,
      surfaceContainerHigh: highSurface,
      surfaceContainerHighest: dark ? darkTokens.selectedSurface : bloom.blush,
      surfaceDim: dark ? darkTokens.page : const Color(0xFFF3E8E6),
      surfaceBright: dark ? darkTokens.elevatedSurface : Colors.white,
      onSurfaceVariant: dark ? darkTokens.secondaryText : bloom.mauve,
      outline: dark ? darkTokens.primaryAccent : bloom.dustyRose,
      outlineVariant: dark ? darkTokens.mutedBorder : const Color(0xFFE8D4DB),
      shadow: dark ? Colors.black : bloom.cocoa.withValues(alpha: .12),
      scrim: Colors.black.withValues(alpha: .54),
    );
  }

  static ColorScheme _cyberpunkColorScheme(
    ColorScheme seed, {
    required Color brandColor,
    required Color accentColor,
  }) {
    const cyber = CyberpunkTokens.defaults;
    return seed.copyWith(
      primary: brandColor,
      onPrimary: _contrastingForeground(brandColor),
      secondary: accentColor,
      onSecondary: _contrastingForeground(accentColor),
      tertiary: cyber.purple,
      onTertiary: cyber.text,
      error: cyber.expense,
      onError: _contrastingForeground(cyber.expense),
      primaryContainer: const Color(0xFF12303A),
      onPrimaryContainer: cyber.text,
      secondaryContainer: const Color(0xFF35172D),
      onSecondaryContainer: cyber.text,
      surface: cyber.voidBlack,
      onSurface: cyber.text,
      surfaceContainerLowest: cyber.voidBlack,
      surfaceContainerLow: cyber.deepNight,
      surfaceContainer: cyber.panel,
      surfaceContainerHigh: cyber.elevatedPanel,
      surfaceContainerHighest: const Color(0xFF222B40),
      surfaceDim: cyber.voidBlack,
      surfaceBright: cyber.elevatedPanel,
      onSurfaceVariant: cyber.mutedText,
      outline: cyber.cyan.withValues(alpha: .72),
      outlineVariant: cyber.steel.withValues(alpha: .55),
      shadow: Colors.black,
      scrim: Colors.black.withValues(alpha: .7),
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
