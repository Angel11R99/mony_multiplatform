import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/logging/app_log.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) =>
        AppLog.error('flutter_framework_error', details.exception);
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLog.error('platform_error', error);
      return true;
    };

    runApp(const ProviderScope(child: MonyApp()));
  }, (error, stackTrace) => AppLog.error('uncaught_async_error', error));
}
