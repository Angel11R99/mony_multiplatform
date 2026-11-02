import 'budget.dart';

abstract interface class BudgetRepository {
  Stream<BudgetConfig?> watchConfig();
  Stream<List<BudgetCycle>> watchHistory();
  Future<BudgetConfig?> getConfig();
  Future<void> saveConfig({
    required int amountInCents,
    required BudgetPeriod period,
    required DateTime now,
  });
  Future<void> setAutomaticClose({
    required bool enabled,
    required int minuteOfDay,
  });
  Future<void> updateCycleSchedules(List<BudgetCycleSchedule> schedules);
  Future<bool> closeNextCycle({required DateTime now, required bool automatic});
  Future<int> closeDueCycles({required DateTime now});
}

final class BudgetRepositoryException implements Exception {
  const BudgetRepositoryException(this.message);
  final String message;

  @override
  String toString() => message;
}
