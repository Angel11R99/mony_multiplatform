import 'budget.dart';

abstract final class BudgetValidator {
  static String? validateAmount(int? amountInCents) =>
      amountInCents == null || amountInCents <= 0
      ? 'El monto debe ser mayor que cero.'
      : null;

  static String? validateSchedules(List<BudgetCycleSchedule> schedules) {
    if (schedules.isEmpty) return 'Configura al menos un ciclo.';
    for (final schedule in schedules) {
      final error = schedule.validate();
      if (error != null) return error;
    }
    final ordered = [...schedules]
      ..sort((a, b) => a.openingDay.compareTo(b.openingDay));
    if (ordered.map((schedule) => schedule.openingDay).toSet().length !=
        ordered.length) {
      return 'Cada ciclo debe comenzar en un día distinto.';
    }
    return null;
  }
}
