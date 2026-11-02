import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config/app_config.dart';
import '../core/routing/app_router.dart';
import '../core/theme/mony_theme.dart';
import '../features/preferences/domain/app_preferences.dart';
import '../features/preferences/presentation/preferences_controller.dart';

class MonyApp extends ConsumerWidget {
  const MonyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final router = ref.watch(appRouterProvider);
    final preferences =
        ref.watch(appPreferencesProvider).value ?? AppPreferences.defaults;

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: MonyTheme.light(preferences),
      darkTheme: MonyTheme.dark(preferences),
      themeMode: MonyTheme.themeMode(preferences.themeMode),
      routerConfig: router,
    );
  }
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter();
  ref.onDispose(router.dispose);
  return router;
});
