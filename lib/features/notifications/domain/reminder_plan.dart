class ReminderPlan {
  const ReminderPlan({
    required this.id,
    required this.eventKey,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  final int id;
  final String eventKey;
  final String title;
  final String body;
  final DateTime scheduledAt;

  String get payload =>
      'mony-reminder:v1:$eventKey:${scheduledAt.millisecondsSinceEpoch}';
}

class ReminderRequest {
  const ReminderRequest({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

abstract interface class ReminderNotificationClient {
  bool get supportsScheduling;
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<bool> notificationsEnabled();
  Future<List<ReminderRequest>> pendingRequests();
  Future<void> schedule(ReminderPlan plan);
  Future<void> show(ReminderPlan plan);
  Future<void> cancel(int id);
}
