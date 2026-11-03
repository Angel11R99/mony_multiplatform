import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/recurring_entry.dart';
import '../domain/recurring_repository.dart';

class DriftRecurringRepository implements RecurringRepository {
  const DriftRecurringRepository(this.db);
  final AppDatabase db;

  @override
  Stream<List<RecurringEntry>> watchAll() =>
      (db.select(db.recurringEntries)..orderBy([
            (row) => OrderingTerm.desc(row.isActive),
            (row) => OrderingTerm.asc(row.nextDateEpochDay),
            (row) => OrderingTerm.asc(row.title),
          ]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList(growable: false));

  @override
  Future<int> create(RecurringEntry entry) async {
    _validate(entry);
    await _validateReferences(entry);
    final next = entry.nextDate.isBefore(entry.startDate)
        ? entry.startDate
        : entry.nextDate;
    return db
        .into(db.recurringEntries)
        .insert(
          RecurringEntriesCompanion.insert(
            title: entry.title.trim(),
            amountInCents: entry.amountInCents,
            type: entry.type.name,
            categoryId: entry.categoryId,
            paymentMethodId: entry.paymentMethodId,
            frequency: entry.frequency.name,
            interval: Value(entry.interval),
            startDateEpochDay: dateToEpochDay(entry.startDate),
            nextDateEpochDay: dateToEpochDay(next),
            endDateEpochDay: Value(
              entry.endDate == null ? null : dateToEpochDay(entry.endDate!),
            ),
          ),
        );
  }

  @override
  Future<void> update(RecurringEntry entry) => db.transaction(() async {
    _validate(entry);
    await _validateReferences(entry);
    final old = await (db.select(
      db.recurringEntries,
    )..where((r) => r.id.equals(entry.id))).getSingleOrNull();
    if (old == null) throw StateError('La serie recurrente ya no existe.');
    final next = entry.nextDate.isBefore(entry.startDate)
        ? entry.startDate
        : entry.nextDate;
    await (db.update(
      db.recurringEntries,
    )..where((r) => r.id.equals(entry.id))).write(
      RecurringEntriesCompanion(
        title: Value(entry.title.trim()),
        amountInCents: Value(entry.amountInCents),
        type: Value(entry.type.name),
        categoryId: Value(entry.categoryId),
        paymentMethodId: Value(entry.paymentMethodId),
        frequency: Value(entry.frequency.name),
        interval: Value(entry.interval),
        startDateEpochDay: Value(dateToEpochDay(entry.startDate)),
        nextDateEpochDay: Value(dateToEpochDay(next)),
        endDateEpochDay: Value(
          entry.endDate == null ? null : dateToEpochDay(entry.endDate!),
        ),
        isActive: Value(entry.isActive),
        updatedAt: Value(DateTime.now()),
      ),
    );
  });

  @override
  Future<void> setActive(int id, bool active, {DateTime? now}) async {
    final row = await (db.select(
      db.recurringEntries,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (row == null) throw StateError('La serie recurrente ya no existe.');
    var next = row.nextDateEpochDay;
    if (active) {
      final rule = _fromRow(row);
      final today = dateToEpochDay(now ?? DateTime.now());
      while (next < today) {
        next = dateToEpochDay(nextOccurrence(rule, dateFromEpochDay(next)));
      }
    }
    await (db.update(db.recurringEntries)..where((r) => r.id.equals(id))).write(
      RecurringEntriesCompanion(
        isActive: Value(active),
        nextDateEpochDay: Value(next),
        updatedAt: Value(now ?? DateTime.now()),
      ),
    );
  }

  @override
  Future<bool> registerOccurrence(int id, DateTime date) =>
      db.transaction(() async {
        final row = await (db.select(
          db.recurringEntries,
        )..where((r) => r.id.equals(id))).getSingleOrNull();
        if (row == null) throw StateError('La serie recurrente ya no existe.');
        final entry = _fromRow(row);
        final day = dateToEpochDay(date);
        if (day < row.startDateEpochDay ||
            (row.endDateEpochDay != null && day > row.endDateEpochDay!)) {
          throw ArgumentError('La fecha está fuera del período de esta serie.');
        }
        final existing =
            await (db.select(db.transactions)..where(
                  (r) => r.fixedEntryId.equals(id) & r.dateEpochDay.equals(day),
                ))
                .getSingleOrNull();
        if (existing != null) return false;
        await db
            .into(db.transactions)
            .insert(
              TransactionsCompanion.insert(
                amountInCents: entry.amountInCents,
                type: entry.type.name,
                categoryId: entry.categoryId,
                paymentMethodId: entry.paymentMethodId,
                description: Value(entry.title),
                dateEpochDay: day,
                fixedEntryId: Value(entry.id),
                createdAt: Value(DateTime.now()),
                updatedAt: Value(DateTime.now()),
              ),
            );
        if (day == row.nextDateEpochDay) {
          final next = dateToEpochDay(nextOccurrence(entry, date));
          final exhausted =
              row.endDateEpochDay != null && next > row.endDateEpochDay!;
          await (db.update(
            db.recurringEntries,
          )..where((r) => r.id.equals(id))).write(
            RecurringEntriesCompanion(
              nextDateEpochDay: Value(next),
              isActive: Value(!exhausted),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
        return true;
      });

  @override
  Future<int> processDue({DateTime? now}) => db.transaction(() async {
    final today = dateToEpochDay(now ?? DateTime.now());
    final due =
        await (db.select(db.recurringEntries)
              ..where(
                (r) =>
                    r.isActive.equals(true) &
                    r.nextDateEpochDay.isSmallerOrEqualValue(today),
              )
              ..orderBy([(r) => OrderingTerm.asc(r.nextDateEpochDay)]))
            .get();
    var generated = 0;
    for (final row in due) {
      final entry = _fromRow(row);
      var nextDay = row.nextDateEpochDay;
      final endDay = row.endDateEpochDay;
      while (nextDay <= today && (endDay == null || nextDay <= endDay)) {
        final inserted = await db
            .into(db.transactions)
            .insert(
              TransactionsCompanion.insert(
                amountInCents: entry.amountInCents,
                type: entry.type.name,
                categoryId: entry.categoryId,
                paymentMethodId: entry.paymentMethodId,
                description: Value(entry.title),
                dateEpochDay: nextDay,
                fixedEntryId: Value(entry.id),
                createdAt: Value(now ?? DateTime.now()),
                updatedAt: Value(now ?? DateTime.now()),
              ),
              onConflict: DoNothing(),
            );
        if (inserted > 0) generated++;
        nextDay = dateToEpochDay(
          nextOccurrence(entry, dateFromEpochDay(nextDay)),
        );
      }
      final exhausted = endDay != null && nextDay > endDay;
      await (db.update(
        db.recurringEntries,
      )..where((r) => r.id.equals(row.id))).write(
        RecurringEntriesCompanion(
          nextDateEpochDay: Value(nextDay),
          isActive: Value(!exhausted),
          updatedAt: Value(now ?? DateTime.now()),
        ),
      );
    }
    return generated;
  });

  Future<void> _validateReferences(RecurringEntry entry) async {
    final category = await (db.select(
      db.categories,
    )..where((r) => r.id.equals(entry.categoryId))).getSingleOrNull();
    final method = await (db.select(
      db.paymentMethods,
    )..where((r) => r.id.equals(entry.paymentMethodId))).getSingleOrNull();
    if (category == null ||
        category.type != entry.type.name ||
        !category.isActive) {
      throw ArgumentError('Selecciona una categoría activa del tipo correcto.');
    }
    if (method == null || !method.isActive) {
      throw ArgumentError('Selecciona un método de pago activo.');
    }
  }

  void _validate(RecurringEntry e) {
    if (e.title.trim().isEmpty || e.title.trim().length > 120) {
      throw ArgumentError('El nombre debe tener entre 1 y 120 caracteres.');
    }
    if (e.amountInCents <= 0) {
      throw ArgumentError('El monto debe ser mayor que cero.');
    }
    if (e.interval < 1 || e.interval > 365) {
      throw ArgumentError(
        'La frecuencia debe repetirse entre 1 y 365 periodos.',
      );
    }
    if (e.endDate != null && e.endDate!.isBefore(e.startDate)) {
      throw ArgumentError('La fecha final debe ser posterior al inicio.');
    }
  }

  RecurringEntry _fromRow(RecurringEntryRow r) => RecurringEntry(
    id: r.id,
    title: r.title,
    amountInCents: r.amountInCents,
    type: TransactionType.values.byName(r.type),
    categoryId: r.categoryId,
    paymentMethodId: r.paymentMethodId,
    frequency: RecurrenceFrequency.values.byName(r.frequency),
    interval: r.interval,
    startDate: dateFromEpochDay(r.startDateEpochDay),
    nextDate: dateFromEpochDay(r.nextDateEpochDay),
    endDate: r.endDateEpochDay == null
        ? null
        : dateFromEpochDay(r.endDateEpochDay!),
    isActive: r.isActive,
  );
}
