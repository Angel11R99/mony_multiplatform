import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:screenshot_shield/screenshot_shield.dart';

import 'app/app.dart';
import 'core/logging/app_log.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    if (!kIsWeb &&
        const {
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.windows,
        }.contains(defaultTargetPlatform)) {
      try {
        await ScreenshotShield().setProtection(backgroundBlur: true);
      } catch (error) {
        AppLog.error('app_switcher_privacy_setup_failed', error);
      }
    }
    FlutterError.onError = (details) =>
        AppLog.error('flutter_framework_error', details.exception);
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLog.error('platform_error', error);
      return true;
    };

    runApp(const ProviderScope(child: MonyApp()));
  }, (error, stackTrace) => AppLog.error('uncaught_async_error', error));
}
