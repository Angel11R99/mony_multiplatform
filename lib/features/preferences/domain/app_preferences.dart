enum AppThemeMode { system, light, dark }

enum CurrencyFormatStyle { symbol, code }

class AppPreferences {
  const AppPreferences({
    this.themeMode = AppThemeMode.system,
    this.primaryColorArgb = 0xFF7C3AED,
    this.accentColorArgb = 0xFFFF6B73,
    this.currencyCode = 'DOP',
    this.currencyFormatStyle = CurrencyFormatStyle.symbol,
    this.notificationsEnabled = false,
  });

  static const defaults = AppPreferences();

  final AppThemeMode themeMode;
  final int primaryColorArgb;
  final int accentColorArgb;
  final String currencyCode;
  final CurrencyFormatStyle currencyFormatStyle;
  final bool notificationsEnabled;

  AppPreferences copyWith({
    AppThemeMode? themeMode,
    int? primaryColorArgb,
    int? accentColorArgb,
    String? currencyCode,
    CurrencyFormatStyle? currencyFormatStyle,
    bool? notificationsEnabled,
  }) => AppPreferences(
    themeMode: themeMode ?? this.themeMode,
    primaryColorArgb: primaryColorArgb ?? this.primaryColorArgb,
    accentColorArgb: accentColorArgb ?? this.accentColorArgb,
    currencyCode: currencyCode ?? this.currencyCode,
    currencyFormatStyle: currencyFormatStyle ?? this.currencyFormatStyle,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferences &&
          themeMode == other.themeMode &&
          primaryColorArgb == other.primaryColorArgb &&
          accentColorArgb == other.accentColorArgb &&
          currencyCode == other.currencyCode &&
          currencyFormatStyle == other.currencyFormatStyle &&
          notificationsEnabled == other.notificationsEnabled;

  @override
  int get hashCode => Object.hash(
    themeMode,
    primaryColorArgb,
    accentColorArgb,
    currencyCode,
    currencyFormatStyle,
    notificationsEnabled,
  );
}
