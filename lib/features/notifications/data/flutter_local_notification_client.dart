import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../domain/reminder_plan.dart';

class FlutterLocalNotificationClient implements ReminderNotificationClient {
  FlutterLocalNotificationClient({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialization;

  @override
  bool get supportsScheduling =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    timezone_data.initializeTimeZones();
    final deviceZone = await FlutterTimezone.getLocalTimezone();
    try {
      timezone.setLocalLocation(timezone.getLocation(deviceZone.identifier));
    } on ArgumentError {
      timezone.setLocalLocation(timezone.UTC);
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        macOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        linux: LinuxInitializationSettings(defaultActionName: 'Abrir Mony'),
        windows: WindowsInitializationSettings(
          appName: 'Mony',
          appUserModelId: 'Mony.Multiplatform.App',
          guid: 'f21dbd2c-c16d-465f-a81d-39c96d3d3a01',
        ),
        web: WebInitializationSettings(),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    await initialize();
    if (kIsWeb) {
      final web = _plugin
          .resolvePlatformSpecificImplementation<
            WebFlutterLocalNotificationsPlugin
          >();
      if (web == null) return false;
      if (web.permissionStatus == WebNotificationPermission.granted) {
        return true;
      }
      return await web.requestNotificationsPermission() ?? false;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await android?.requestNotificationsPermission();
        return await android?.areNotificationsEnabled() ?? false;
      case TargetPlatform.iOS:
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        await ios?.requestPermissions(alert: true, sound: true);
        return await ios?.checkPermissions().then(
              (status) => status?.isEnabled ?? false,
            ) ??
            false;
      case TargetPlatform.macOS:
        final macos = _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
        await macos?.requestPermissions(alert: true, sound: true);
        return await macos?.checkPermissions().then(
              (status) => status?.isEnabled ?? false,
            ) ??
            false;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return true;
    }
  }

  @override
  Future<bool> notificationsEnabled() async {
    await initialize();
    if (kIsWeb) {
      return _plugin
              .resolvePlatformSpecificImplementation<
                WebFlutterLocalNotificationsPlugin
              >()
              ?.permissionStatus ==
          WebNotificationPermission.granted;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _plugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >()
                ?.areNotificationsEnabled() ??
            false;
      case TargetPlatform.iOS:
        return await _plugin
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >()
                ?.checkPermissions()
                .then((status) => status?.isEnabled ?? false) ??
            false;
      case TargetPlatform.macOS:
        return await _plugin
                .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin
                >()
                ?.checkPermissions()
                .then((status) => status?.isEnabled ?? false) ??
            false;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return true;
    }
  }

  @override
  Future<List<ReminderRequest>> pendingRequests() async {
    await initialize();
    return (await _plugin.pendingNotificationRequests())
        .map(
          (request) => ReminderRequest(
            id: request.id,
            title: request.title,
            body: request.body,
            payload: request.payload,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> schedule(ReminderPlan plan) async {
    await initialize();
    await _plugin.zonedSchedule(
      id: plan.id,
      title: plan.title,
      body: plan.body,
      payload: plan.payload,
      scheduledDate: timezone.TZDateTime.from(plan.scheduledAt, timezone.local),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> show(ReminderPlan plan) async {
    await initialize();
    await _plugin.show(
      id: plan.id,
      title: plan.title,
      body: plan.body,
      payload: plan.payload,
      notificationDetails: _details,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await initialize();
    await _plugin.cancel(id: id);
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'mony_reminders',
      'Recordatorios de Mony',
      channelDescription: 'Vencimientos y movimientos recurrentes.',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    ),
    macOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
    web: WebNotificationDetails(lang: 'es'),
    linux: LinuxNotificationDetails(),
    windows: WindowsNotificationDetails(),
  );
}
