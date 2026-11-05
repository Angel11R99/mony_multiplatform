import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/recurring/data/drift_recurring_repository.dart';
import 'package:mony_multiplatform/features/recurring/domain/recurring_entry.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  late AppDatabase db;
  late DriftRecurringRepository repository;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftRecurringRepository(db);
  });
  tearDown(() => db.close());

  RecurringEntry monthly({DateTime? start, DateTime? end}) {
    final date = start ?? DateTime(2026, 1, 31);
    return RecurringEntry(
      title: 'Alquiler',
      amountInCents: 50000,
      type: TransactionType.expense,
      categoryId: 8,
      paymentMethodId: 1,
      frequency: RecurrenceFrequency.monthly,
      startDate: date,
      nextDate: date,
      endDate: end,
    );
  }

  test('loads only active series for reminder generation', () async {
    final activeId = await repository.create(monthly());
    final inactiveId = await repository.create(
      monthly(start: DateTime(2026, 2, 1)),
    );
    await repository.setActive(inactiveId, false);

    final entries = await repository.getActiveForReminders();

    expect(entries.map((entry) => entry.id), [activeId]);
    expect(entries.single.isActive, isTrue);
    expect(entries.map((entry) => entry.id), isNot(contains(inactiveId)));
  });

  test('catches up missed calendar occurrences exactly once', () async {
    final id = await repository.create(monthly());
    expect(await repository.processDue(now: DateTime(2026, 3, 31)), 3);
    expect(await repository.processDue(now: DateTime(2026, 3, 31)), 0);
    final rows = await (db.select(
      db.transactions,
    )..orderBy([(r) => OrderingTerm.asc(r.dateEpochDay)])).get();
    expect(rows.map((r) => dateFromEpochDay(r.dateEpochDay)).toList(), [
      DateTime(2026, 1, 31),
      DateTime(2026, 2, 28),
      DateTime(2026, 3, 31),
    ]);
    expect(rows.every((r) => r.fixedEntryId == id), isTrue);
    expect(
      (await repository.watchAll().first).single.nextDate,
      DateTime(2026, 4, 30),
    );
    final transactions = DriftTransactionRepository(db);
    final movement = await transactions.get(rows.first.id);
    await expectLater(
      transactions.update(movement!.copyWith(amountInCents: 1)),
      throwsA(isA<InvalidTransactionException>()),
    );
    await expectLater(
      transactions.delete(rows.first.id),
      throwsA(isA<InvalidTransactionException>()),
    );
  });

  test(
    'batches large daily catch-up and skips existing occurrence dates',
    () async {
      final start = DateTime(2025, 1, 1);
      final id = await repository.create(
        RecurringEntry(
          title: 'Pago diario',
          amountInCents: 500,
          type: TransactionType.expense,
          categoryId: 8,
          paymentMethodId: 1,
          frequency: RecurrenceFrequency.daily,
          startDate: start,
          nextDate: start,
        ),
      );
      await db
          .into(db.transactions)
          .insert(
            TransactionsCompanion.insert(
              amountInCents: 500,
              type: 'expense',
              categoryId: 8,
              paymentMethodId: 1,
              description: const Value('Pago diario'),
              dateEpochDay: dateToEpochDay(start),
              fixedEntryId: Value(id),
            ),
          );

      final through = start.add(const Duration(days: 600));
      expect(await repository.processDue(now: through), 600);
      final rows = await (db.select(
        db.transactions,
      )..where((row) => row.fixedEntryId.equals(id))).get();
      expect(rows, hasLength(601));
      expect(
        (await repository.watchAll().first).single.nextDate,
        through.add(const Duration(days: 1)),
      );
    },
  );

  test('pause skips paused periods and end date stops the series', () async {
    final id = await repository.create(
      monthly(start: DateTime(2026, 1, 1), end: DateTime(2026, 4, 1)),
    );
    await repository.setActive(id, false, now: DateTime(2026, 1, 2));
    await repository.setActive(id, true, now: DateTime(2026, 3, 15));
    expect(await repository.processDue(now: DateTime(2026, 3, 15)), 0);
    expect(await repository.processDue(now: DateTime(2026, 4, 1)), 1);
    final item = (await repository.watchAll().first).single;
    expect(item.isActive, isFalse);
    expect(item.nextDate, DateTime(2026, 5, 1));
  });

  test('manually registers an occurrence once on its selected date', () async {
    final id = await repository.create(monthly());
    final selectedDate = DateTime(2026, 1, 31);

    expect(await repository.registerOccurrence(id, selectedDate), isTrue);
    expect(await repository.registerOccurrence(id, selectedDate), isFalse);
    expect((await db.select(db.transactions).get()).length, 1);
    expect(
      (await repository.watchAll().first).single.nextDate,
      DateTime(2026, 2, 28),
    );
  });
}
