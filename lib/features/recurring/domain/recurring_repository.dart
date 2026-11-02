import 'recurring_entry.dart';

abstract interface class RecurringRepository {
  Stream<List<RecurringEntry>> watchAll();
  Future<int> create(RecurringEntry entry);
  Future<void> update(RecurringEntry entry);
  Future<void> setActive(int id, bool active, {DateTime? now});
  Future<int> processDue({DateTime? now});
}
