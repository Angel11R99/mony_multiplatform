import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../obligations/presentation/obligations_providers.dart';
import '../../recurring/presentation/recurring_providers.dart';
import '../data/flutter_local_notification_client.dart';
import '../data/local_reminder_scheduler.dart';
import '../domain/reminder_plan.dart';

final notificationClientProvider = Provider<ReminderNotificationClient>(
  (ref) => FlutterLocalNotificationClient(),
);

final localReminderSchedulerProvider = Provider<LocalReminderScheduler>((ref) {
  final obligations = ref.watch(obligationRepositoryProvider);
  final recurringEntries = ref.watch(recurringRepositoryProvider);
  return LocalReminderScheduler(
    client: ref.watch(notificationClientProvider),
    loadObligations: () => obligations.watchAll().first,
    loadRecurringEntries: () => recurringEntries.watchAll().first,
  );
});
