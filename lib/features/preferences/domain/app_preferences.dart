enum AppThemeMode { system, light, dark }

enum CurrencyFormatStyle { symbol, code }

const defaultNavigationModuleIds = <String>[
  'home',
  'recurring',
  'obligations',
  'savings',
  'shoppingLists',
  'statistics',
  'cyclePlan',
  'transactions',
];

class AppPreferences {
  const AppPreferences({
    this.themeMode = AppThemeMode.system,
    this.primaryColorArgb = 0xFFC8A8F4,
    this.accentColorArgb = 0xFFB794E8,
    this.currencyCode = 'DOP',
    this.currencyFormatStyle = CurrencyFormatStyle.symbol,
    this.notificationsEnabled = false,
    this.visibleNavigationModules = defaultNavigationModuleIds,
  });

  static const defaults = AppPreferences();

  final AppThemeMode themeMode;
  final int primaryColorArgb;
  final int accentColorArgb;
  final String currencyCode;
  final CurrencyFormatStyle currencyFormatStyle;
  final bool notificationsEnabled;
  final List<String> visibleNavigationModules;

  AppPreferences copyWith({
    AppThemeMode? themeMode,
    int? primaryColorArgb,
    int? accentColorArgb,
    String? currencyCode,
    CurrencyFormatStyle? currencyFormatStyle,
    bool? notificationsEnabled,
    List<String>? visibleNavigationModules,
  }) => AppPreferences(
    themeMode: themeMode ?? this.themeMode,
    primaryColorArgb: primaryColorArgb ?? this.primaryColorArgb,
    accentColorArgb: accentColorArgb ?? this.accentColorArgb,
    currencyCode: currencyCode ?? this.currencyCode,
    currencyFormatStyle: currencyFormatStyle ?? this.currencyFormatStyle,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    visibleNavigationModules:
        visibleNavigationModules ?? this.visibleNavigationModules,
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
          notificationsEnabled == other.notificationsEnabled &&
          _sameList(visibleNavigationModules, other.visibleNavigationModules);

  @override
  int get hashCode => Object.hash(
    themeMode,
    primaryColorArgb,
    accentColorArgb,
    currencyCode,
    currencyFormatStyle,
    notificationsEnabled,
    Object.hashAll(visibleNavigationModules),
  );

  static bool _sameList(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
