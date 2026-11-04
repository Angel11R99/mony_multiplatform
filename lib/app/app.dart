import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../core/config/app_config.dart';
import '../core/routing/app_router.dart';
import '../core/theme/mony_theme.dart';
import '../core/theme/cyberpunk_visuals.dart';
import '../features/budgets/presentation/budget_cycle_automation.dart';
import '../features/notifications/presentation/reminder_automation.dart';
import '../features/preferences/domain/app_preferences.dart';
import '../features/preferences/presentation/preferences_controller.dart';
import '../features/widgets/presentation/finance_widget_sync.dart';

class MonyApp extends ConsumerWidget {
  const MonyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final router = ref.watch(appRouterProvider);
    final preferences =
        ref.watch(appPreferencesProvider).value ?? AppPreferences.defaults;

    return BudgetCycleAutomation(
      child: ReminderAutomation(
        child: FinanceWidgetSync(
          router: router,
          child: ToastificationWrapper(
            config: const ToastificationConfig(
              alignment: Alignment.bottomCenter,
              animationDuration: Duration(milliseconds: 120),
              maxToastLimit: 3,
              maxTitleLines: 3,
            ),
            child: MaterialApp.router(
              title: config.appName,
              debugShowCheckedModeBanner: false,
              theme: MonyTheme.light(preferences),
              darkTheme: MonyTheme.dark(preferences),
              themeMode: MonyTheme.themeMode(preferences.themeMode),
              builder: (context, child) =>
                  preferences.visualTheme == AppVisualTheme.cyberpunk
                  ? CyberBackdrop(child: child ?? const SizedBox.shrink())
                  : child ?? const SizedBox.shrink(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('es'), Locale('en')],
              routerConfig: router,
            ),
          ),
        ),
      ),
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
