import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/notifications/data/local_reminder_scheduler.dart';
import 'package:mony_multiplatform/features/notifications/domain/reminder_plan.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation.dart';
import 'package:mony_multiplatform/features/recurring/domain/recurring_entry.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'schedules obligation due dates and the day before recurring entries',
    () async {
      final client = _FakeNotificationClient();
      final scheduler = _scheduler(
        client: client,
        obligations: [_obligation(dueDate: DateTime(2026, 7, 4))],
        recurring: [_recurring(nextDate: DateTime(2026, 7, 10))],
      );

      await scheduler.reconcile(enabled: true, now: DateTime(2026, 7, 1, 12));

      expect(
        client.scheduled.map((plan) => plan.scheduledAt),
        containsAll([DateTime(2026, 7, 4, 9), DateTime(2026, 7, 9, 9)]),
      );
    },
  );

  test('updates changed reminders and cancels settled obligations', () async {
    var obligations = [_obligation(dueDate: DateTime(2026, 7, 4))];
    final client = _FakeNotificationClient();
    final scheduler = _scheduler(
      client: client,
      loadObligations: () async => obligations,
    );
    final now = DateTime(2026, 7, 1, 12);

    await scheduler.reconcile(enabled: true, now: now);
    final originalId = client.scheduled.single.id;
    obligations = [
      _obligation(dueDate: DateTime(2026, 7, 4), title: 'Nuevo alquiler'),
    ];
    await scheduler.reconcile(enabled: true, now: now);
    expect(client.cancelled, [originalId]);
    expect(client.scheduled.last.title, 'Vence Nuevo alquiler');

    obligations = [
      _obligation(dueDate: DateTime(2026, 7, 4), paidAmountInCents: 10000),
    ];
    await scheduler.reconcile(enabled: true, now: now);
    expect(client.pending, isEmpty);
  });

  test(
    'foreground fallback sends due notices once and skips future schedules',
    () async {
      final client = _FakeNotificationClient(supportsScheduling: false);
      final scheduler = _scheduler(
        client: client,
        obligations: [
          _obligation(id: 1, dueDate: DateTime(2026, 7, 1)),
          _obligation(id: 2, dueDate: DateTime(2026, 7, 3)),
        ],
      );

      await scheduler.reconcile(enabled: true, now: DateTime(2026, 7, 1, 10));
      await scheduler.reconcile(
        enabled: true,
        now: DateTime(2026, 7, 1, 10, 1),
      );

      expect(client.shown, hasLength(1));
      expect(client.shown.single.title, 'Vence Obligación 1');
      expect(client.scheduled, isEmpty);
    },
  );

  test('caps the scheduled queue at sixty notifications', () async {
    final client = _FakeNotificationClient();
    final scheduler = _scheduler(
      client: client,
      obligations: List.generate(
        65,
        (index) =>
            _obligation(id: index + 1, dueDate: DateTime(2026, 7, 5 + index)),
      ),
    );

    await scheduler.reconcile(enabled: true, now: DateTime(2026, 7, 1, 12));

    expect(client.scheduled, hasLength(60));
  });

  test('disabling notifications cancels only this app reminders', () async {
    final client = _FakeNotificationClient();
    final scheduler = _scheduler(
      client: client,
      obligations: [_obligation(dueDate: DateTime(2026, 7, 4))],
    );
    await scheduler.reconcile(enabled: true, now: DateTime(2026, 7, 1, 12));
    client.pending.add(
      const ReminderRequest(id: 900, payload: 'other-app-notification'),
    );

    await scheduler.reconcile(enabled: false);

    expect(client.pending.map((item) => item.id), [900]);
  });
}

LocalReminderScheduler _scheduler({
  required _FakeNotificationClient client,
  List<Obligation> obligations = const [],
  List<RecurringEntry> recurring = const [],
  Future<List<Obligation>> Function()? loadObligations,
}) => LocalReminderScheduler(
  client: client,
  loadObligations: loadObligations ?? () async => obligations,
  loadRecurringEntries: () async => recurring,
);

Obligation _obligation({
  int id = 1,
  String? title,
  required DateTime dueDate,
  int paidAmountInCents = 0,
}) => Obligation(
  id: id,
  direction: ObligationDirection.payable,
  title: title ?? 'Obligación $id',
  counterparty: 'Proveedor',
  amountInCents: 10000,
  dueDate: dueDate,
  categoryId: 8,
  defaultPaymentMethodId: 1,
  isCancelled: false,
  notes: null,
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
  paidAmountInCents: paidAmountInCents,
);

RecurringEntry _recurring({required DateTime nextDate}) => RecurringEntry(
  id: 7,
  title: 'Internet',
  amountInCents: 5000,
  type: TransactionType.expense,
  categoryId: 10,
  paymentMethodId: 1,
  frequency: RecurrenceFrequency.monthly,
  startDate: DateTime(2026, 1, 10),
  nextDate: nextDate,
);

class _FakeNotificationClient implements ReminderNotificationClient {
  _FakeNotificationClient({this.supportsScheduling = true});

  @override
  final bool supportsScheduling;
  final pending = <ReminderRequest>[];
  final scheduled = <ReminderPlan>[];
  final shown = <ReminderPlan>[];
  final cancelled = <int>[];
  bool permissionGranted = true;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<bool> notificationsEnabled() async => permissionGranted;

  @override
  Future<List<ReminderRequest>> pendingRequests() async => [...pending];

  @override
  Future<void> schedule(ReminderPlan plan) async {
    scheduled.add(plan);
    pending.removeWhere((request) => request.id == plan.id);
    pending.add(
      ReminderRequest(
        id: plan.id,
        title: plan.title,
        body: plan.body,
        payload: plan.payload,
      ),
    );
  }

  @override
  Future<void> show(ReminderPlan plan) async => shown.add(plan);

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
    pending.removeWhere((request) => request.id == id);
  }
}
