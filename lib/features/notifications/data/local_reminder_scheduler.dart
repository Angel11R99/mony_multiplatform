import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../obligations/domain/obligation.dart';
import '../../recurring/domain/recurring_entry.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/reminder_plan.dart';

typedef LoadReminders<T> = Future<List<T>> Function();

class LocalReminderScheduler {
  LocalReminderScheduler({
    required this.client,
    required this.loadObligations,
    required this.loadRecurringEntries,
    Future<SharedPreferences> Function()? loadPreferences,
  }) : _loadPreferences = loadPreferences ?? SharedPreferences.getInstance;

  static const _scheduledKeysPreference = 'mony.reminders.scheduled.v1';
  static const _deliveredKeysPreference = 'mony.reminders.delivered.v1';
  static const _payloadPrefix = 'mony-reminder:v1:';
  static const _notificationLimit = 60;

  final ReminderNotificationClient client;
  final LoadReminders<Obligation> loadObligations;
  final LoadReminders<RecurringEntry> loadRecurringEntries;
  final Future<SharedPreferences> Function() _loadPreferences;

  Future<void> reconcile({required bool enabled, DateTime? now}) async {
    final preferences = await _loadPreferences();
    if (!enabled) {
      final scheduledKeys =
          preferences.getStringList(_scheduledKeysPreference) ?? const [];
      if (scheduledKeys.isNotEmpty) {
        await client.initialize();
        await _cancelOwnedNotifications();
      }
      await preferences.setStringList(_scheduledKeysPreference, const []);
      return;
    }

    await client.initialize();
    if (!await client.notificationsEnabled()) {
      await _cancelOwnedNotifications();
      await preferences.setStringList(_scheduledKeysPreference, const []);
      return;
    }

    final currentTime = now ?? DateTime.now();
    final previousKeys =
        preferences.getStringList(_scheduledKeysPreference) ?? const <String>[];
    final deliveredKeys =
        (preferences.getStringList(_deliveredKeysPreference) ??
                const <String>[])
            .toSet();
    final candidates = (await _buildCandidates(currentTime))
        .where((candidate) => !deliveredKeys.contains(candidate.eventKey))
        .toList(growable: false);
    final upcoming =
        candidates
            .where((candidate) => candidate.scheduledAt.isAfter(currentTime))
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    final plans = client.supportsScheduling
        ? _assignIds(upcoming.take(_notificationLimit).toList())
        : const <ReminderPlan>[];

    for (final candidate in candidates.where(
      (item) => !item.scheduledAt.isAfter(currentTime),
    )) {
      if (deliveredKeys.contains(candidate.eventKey)) {
        continue;
      }
      if (previousKeys.contains(candidate.eventKey)) {
        deliveredKeys.add(candidate.eventKey);
        continue;
      }
      final plan = _assignIds([candidate]).single;
      await client.show(plan);
      deliveredKeys.add(candidate.eventKey);
    }

    final existing = client.supportsScheduling
        ? await client.pendingRequests()
        : const <ReminderRequest>[];
    final owned = existing
        .where(
          (request) => request.payload?.startsWith(_payloadPrefix) ?? false,
        )
        .toList(growable: false);
    final planById = {for (final plan in plans) plan.id: plan};
    final retainedIds = <int>{};

    for (final request in owned) {
      final plan = planById[request.id];
      if (plan != null &&
          request.payload == plan.payload &&
          request.title == plan.title &&
          request.body == plan.body) {
        retainedIds.add(request.id);
      } else {
        await client.cancel(request.id);
      }
    }

    final scheduledKeys = <String>[];
    for (final plan in plans) {
      if (!retainedIds.contains(plan.id)) await client.schedule(plan);
      scheduledKeys.add(plan.eventKey);
    }
    await preferences.setStringList(_scheduledKeysPreference, scheduledKeys);
    await preferences.setStringList(
      _deliveredKeysPreference,
      deliveredKeys.toList(growable: false).reversed.take(300).toList(),
    );
  }

  Future<void> _cancelOwnedNotifications() async {
    if (!client.supportsScheduling) return;
    final requests = await client.pendingRequests();
    for (final request in requests) {
      if (request.payload?.startsWith(_payloadPrefix) ?? false) {
        await client.cancel(request.id);
      }
    }
  }

  Future<List<_ReminderCandidate>> _buildCandidates(DateTime now) async {
    final obligations = await loadObligations();
    final recurring = await loadRecurringEntries();
    final candidates = <_ReminderCandidate>[];
    final today = DateTime(now.year, now.month, now.day);

    for (final obligation in obligations) {
      final dueDate = obligation.dueDate;
      if (dueDate == null ||
          obligation.isCancelled ||
          obligation.remainingAmountInCents <= 0) {
        continue;
      }
      final day = DateTime(dueDate.year, dueDate.month, dueDate.day);
      final key = 'obligation:${obligation.id}:${dateToEpochDay(day)}';
      candidates.add(
        _ReminderCandidate(
          eventKey: key,
          title: 'Vence ${obligation.title}',
          body: obligation.counterparty == null
              ? 'Revisa el pago pendiente de hoy.'
              : 'Pago pendiente con ${obligation.counterparty}.',
          scheduledAt: _atNine(day.isBefore(today) ? today : day),
        ),
      );
    }

    for (final entry in recurring.where((item) => item.isActive)) {
      var occurrence = entry.nextDate;
      for (var index = 0; index < _notificationLimit; index++) {
        if (entry.endDate != null && occurrence.isAfter(entry.endDate!)) break;
        final reminderDay = DateTime(
          occurrence.year,
          occurrence.month,
          occurrence.day - 1,
        );
        if (!reminderDay.isBefore(today)) {
          candidates.add(
            _ReminderCandidate(
              eventKey: 'recurring:${entry.id}:${dateToEpochDay(occurrence)}',
              title: 'Movimiento recurrente próximo',
              body:
                  '${entry.title} está programado para ${_dateLabel(occurrence)}.',
              scheduledAt: _atNine(reminderDay),
            ),
          );
        }
        occurrence = nextOccurrence(entry, occurrence);
      }
    }
    return candidates;
  }

  List<ReminderPlan> _assignIds(List<_ReminderCandidate> candidates) {
    final plans = <ReminderPlan>[];
    final usedIds = <int, String>{};
    for (final candidate in candidates) {
      var id = _stableId(candidate.eventKey);
      while (usedIds.containsKey(id) && usedIds[id] != candidate.eventKey) {
        id = id == 0x7fffffff ? 1 : id + 1;
      }
      usedIds[id] = candidate.eventKey;
      plans.add(
        ReminderPlan(
          id: id,
          eventKey: candidate.eventKey,
          title: candidate.title,
          body: candidate.body,
          scheduledAt: candidate.scheduledAt,
        ),
      );
    }
    return plans;
  }

  int _stableId(String value) {
    var hash = 0x811c9dc5;
    for (final byte in utf8.encode(value)) {
      hash = ((hash ^ byte) * 0x01000193) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  DateTime _atNine(DateTime day) => DateTime(day.year, day.month, day.day, 9);

  String _dateLabel(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _ReminderCandidate {
  const _ReminderCandidate({
    required this.eventKey,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  final String eventKey;
  final String title;
  final String body;
  final DateTime scheduledAt;
}
