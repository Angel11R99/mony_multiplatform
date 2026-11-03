import 'recurring_entry.dart';

abstract interface class RecurringRepository {
  Stream<List<RecurringEntry>> watchAll();
  Future<int> create(RecurringEntry entry);
  Future<void> update(RecurringEntry entry);
  Future<void> setActive(int id, bool active, {DateTime? now});

  /// Creates the selected occurrence once; returns false when it already exists.
  Future<bool> registerOccurrence(int id, DateTime date);
  Future<int> processDue({DateTime? now});
}
