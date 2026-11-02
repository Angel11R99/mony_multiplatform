enum AppEnvironment { development, staging, production }

class AppConfig {
  const AppConfig({required this.environment});

  factory AppConfig.fromEnvironment() {
    const value = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    return AppConfig(
      environment: AppEnvironment.values.firstWhere(
        (environment) => environment.name == value,
        orElse: () => AppEnvironment.development,
      ),
    );
  }

  final AppEnvironment environment;

  String get appName => switch (environment) {
    AppEnvironment.development => 'Mony · Desarrollo',
    AppEnvironment.staging => 'Mony · Pruebas',
    AppEnvironment.production => 'Mony',
  };

  bool get showDebugBanner => environment == AppEnvironment.development;
}
