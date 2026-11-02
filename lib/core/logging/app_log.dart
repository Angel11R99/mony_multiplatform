import 'dart:developer' as developer;

abstract final class AppLog {
  static const _name = 'mony';

  /// Logs a stable event identifier and error type, never error contents.
  static void error(String event, Object error) {
    developer.log(
      'event=$event errorType=${error.runtimeType}',
      name: _name,
      level: 1000,
    );
  }

  static void info(String event) {
    developer.log('event=$event', name: _name);
  }
}
