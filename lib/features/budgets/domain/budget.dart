enum BudgetPeriod { monthly, fortnightly }

enum BudgetPeriodView { current, next }

class DateRange {
  const DateRange({required this.start, required this.endInclusive});

  final DateTime start;
  final DateTime endInclusive;

  bool contains(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return !day.isBefore(start) && !day.isAfter(endInclusive);
  }
}

class BudgetCycleSchedule {
  const BudgetCycleSchedule({
    required this.openingDay,
    required this.closingDay,
  });

  final int openingDay;
  final int closingDay;

  String? validate() {
    if (openingDay < 1 || openingDay > 31) {
      return 'El inicio debe estar entre 1 y 31.';
    }
    if (closingDay < 1 || closingDay > 31) {
      return 'El cierre debe estar entre 1 y 31.';
    }
    return null;
  }

  Map<String, int> toJson() => {
    'openingDay': openingDay,
    'closingDay': closingDay,
  };

  static BudgetCycleSchedule? fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final opening = value['openingDay'];
    final closing = value['closingDay'];
    if (opening is! int || closing is! int) return null;
    final schedule = BudgetCycleSchedule(
      openingDay: opening,
      closingDay: closing,
    );
    return schedule.validate() == null ? schedule : null;
  }
}

List<BudgetCycleSchedule> defaultBudgetCycleSchedules(BudgetPeriod period) =>
    switch (period) {
      BudgetPeriod.monthly => const [
        BudgetCycleSchedule(openingDay: 1, closingDay: 31),
      ],
      BudgetPeriod.fortnightly => const [
        BudgetCycleSchedule(openingDay: 1, closingDay: 15),
        BudgetCycleSchedule(openingDay: 16, closingDay: 31),
      ],
    };

class BudgetConfig {
  const BudgetConfig({
    required this.amountInCents,
    required this.period,
    required this.cycleStart,
    required this.cycleStartedAt,
    required this.incomeTransactionId,
    required this.cycleSchedules,
    required this.autoCloseEnabled,
    required this.autoCloseMinuteOfDay,
  });

  final int amountInCents;
  final BudgetPeriod period;
  final DateTime? cycleStart;
  final DateTime? cycleStartedAt;
  final int? incomeTransactionId;
  final List<BudgetCycleSchedule> cycleSchedules;
  final bool autoCloseEnabled;
  final int autoCloseMinuteOfDay;

  BudgetConfig copyWith({
    int? amountInCents,
    BudgetPeriod? period,
    DateTime? cycleStart,
    DateTime? cycleStartedAt,
    int? incomeTransactionId,
    List<BudgetCycleSchedule>? cycleSchedules,
    bool? autoCloseEnabled,
    int? autoCloseMinuteOfDay,
  }) => BudgetConfig(
    amountInCents: amountInCents ?? this.amountInCents,
    period: period ?? this.period,
    cycleStart: cycleStart ?? this.cycleStart,
    cycleStartedAt: cycleStartedAt ?? this.cycleStartedAt,
    incomeTransactionId: incomeTransactionId ?? this.incomeTransactionId,
    cycleSchedules: cycleSchedules ?? this.cycleSchedules,
    autoCloseEnabled: autoCloseEnabled ?? this.autoCloseEnabled,
    autoCloseMinuteOfDay: autoCloseMinuteOfDay ?? this.autoCloseMinuteOfDay,
  );
}

class BudgetCycle {
  const BudgetCycle({
    required this.id,
    required this.period,
    required this.budgetAmountInCents,
    required this.incomeInCents,
    required this.expenseInCents,
    required this.startDate,
    required this.endDate,
    required this.closedAt,
  });

  final int id;
  final BudgetPeriod period;
  final int budgetAmountInCents;
  final int incomeInCents;
  final int expenseInCents;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime closedAt;

  int get remainingInCents => budgetAmountInCents - expenseInCents;
}

class BudgetPeriodSummary {
  const BudgetPeriodSummary({
    required this.period,
    required this.incomeInCents,
    required this.expenseInCents,
  });

  final DateRange period;
  final int incomeInCents;
  final int expenseInCents;

  int availableInCents(int budgetInCents) => budgetInCents - expenseInCents;

  int usagePercent(int budgetInCents) =>
      budgetUsagePercent(expenseInCents, budgetInCents);
}

int budgetUsagePercent(int expensesInCents, int budgetInCents) {
  if (budgetInCents <= 0) return 0;
  return (expensesInCents * 100) ~/ budgetInCents;
}

DateRange activeBudgetPeriod(
  BudgetConfig? budget,
  DateTime today, {
  List<BudgetCycleSchedule>? schedulesOverride,
}) {
  final period = budget?.period ?? BudgetPeriod.fortnightly;
  final schedules = schedulesOverride ?? budget?.cycleSchedules;
  final effectiveSchedules = schedules == null || schedules.isEmpty
      ? defaultBudgetCycleSchedules(period)
      : schedules;
  final month = DateTime(today.year, today.month);
  final candidates = <DateRange>[];
  for (var offset = -2; offset <= 2; offset++) {
    final reference = DateTime(month.year, month.month + offset);
    for (final schedule in effectiveSchedules) {
      candidates.add(schedule.toDateRange(reference));
    }
  }
  return candidates.where((range) => range.contains(today)).fold<DateRange?>(
        null,
        (latest, range) {
          if (latest == null || range.start.isAfter(latest.start)) return range;
          return latest;
        },
      ) ??
      _fallbackRange(today, period);
}

DateRange budgetPeriodForView(
  BudgetConfig? budget,
  BudgetPeriodView view,
  DateTime today,
) {
  final current = activeBudgetPeriod(budget, today);
  if (view == BudgetPeriodView.current) return current;
  return _periodAfter(budget, current.endInclusive);
}

DateRange nextBudgetPeriod(BudgetConfig? budget, DateTime fromDate) =>
    _periodAfter(budget, activeBudgetPeriod(budget, fromDate).endInclusive);

DateRange budgetPeriodToClose(BudgetConfig budget, DateTime today) {
  final start = budget.cycleStart ?? activeBudgetPeriod(budget, today).start;
  final found = _periodForStart(budget, start);
  return found;
}

bool canManuallyCloseBudgetCycle(BudgetConfig? budget, DateTime today) {
  if (budget == null || budget.cycleStart == null) return false;
  final period = budgetPeriodToClose(budget, today);
  final day = DateTime(today.year, today.month, today.day);
  return budget.cycleStart!.isBefore(day) && !period.endInclusive.isAfter(day);
}

bool shouldAutomaticallyCloseBudgetCycle(BudgetConfig? budget, DateTime now) {
  if (budget == null || budget.cycleStart == null || !budget.autoCloseEnabled) {
    return false;
  }
  final period = budgetPeriodToClose(budget, now);
  final today = DateTime(now.year, now.month, now.day);
  if (period.endInclusive.isBefore(today)) return true;
  if (period.endInclusive.isAfter(today)) return false;
  final closeAt = Duration(minutes: budget.autoCloseMinuteOfDay);
  final timeNow = Duration(hours: now.hour, minutes: now.minute);
  return timeNow >= closeAt;
}

/// Returns the next time the foreground automation needs to wake.
///
/// Recurring entries are date-based, so the next local midnight is the normal
/// wake point. An enabled automatic budget close may require an earlier wake.
DateTime nextBudgetAutomationCheckAt(BudgetConfig? budget, DateTime now) {
  final nextMidnight = DateTime(now.year, now.month, now.day + 1);
  if (budget == null || !budget.autoCloseEnabled || budget.cycleStart == null) {
    return nextMidnight;
  }

  final closingPeriod = budgetPeriodToClose(budget, now);
  final endDate = closingPeriod.endInclusive;
  final today = DateTime(now.year, now.month, now.day);
  if (DateTime(endDate.year, endDate.month, endDate.day).isBefore(today)) {
    return now;
  }

  final closeAt = DateTime(
    endDate.year,
    endDate.month,
    endDate.day,
  ).add(Duration(minutes: budget.autoCloseMinuteOfDay));
  if (!closeAt.isAfter(now)) return now;
  return closeAt.isBefore(nextMidnight) ? closeAt : nextMidnight;
}

BudgetPeriodSummary summarizeBudgetPeriod(
  DateRange period,
  Iterable<({int amountInCents, String type, DateTime date})> transactions,
) {
  var income = 0;
  var expenses = 0;
  for (final transaction in transactions) {
    if (!period.contains(transaction.date)) continue;
    if (transaction.type == 'income') {
      income += transaction.amountInCents;
    } else if (transaction.type == 'expense') {
      expenses += transaction.amountInCents;
    }
  }
  return BudgetPeriodSummary(
    period: period,
    incomeInCents: income,
    expenseInCents: expenses,
  );
}

String budgetIncomeDescription(BudgetPeriod period) => switch (period) {
  BudgetPeriod.monthly => 'Ingreso mensual',
  BudgetPeriod.fortnightly => 'Ingreso por ciclo',
};

DateRange _periodForStart(BudgetConfig budget, DateTime start) {
  final period = activeBudgetPeriod(budget, start);
  if (_sameDay(period.start, start)) return period;
  final next = _periodAfter(budget, start.subtract(const Duration(days: 1)));
  if (_sameDay(next.start, start)) return next;
  return period;
}

DateRange _periodAfter(BudgetConfig? budget, DateTime date) {
  final period = budget?.period ?? BudgetPeriod.fortnightly;
  final schedules = budget?.cycleSchedules;
  final dayAfter = date.add(const Duration(days: 1));
  final active = activeBudgetPeriod(
    budget,
    dayAfter,
    schedulesOverride: schedules,
  );
  if (active.start.isAfter(date)) return active;
  final farMonth = DateTime(dayAfter.year, dayAfter.month + 1);
  return (schedules ?? defaultBudgetCycleSchedules(period))
      .map((schedule) => schedule.toDateRange(farMonth))
      .where((range) => range.start.isAfter(date))
      .reduce((a, b) => a.start.isBefore(b.start) ? a : b);
}

DateRange _fallbackRange(DateTime today, BudgetPeriod period) {
  final schedules = defaultBudgetCycleSchedules(period);
  for (final schedule in schedules) {
    final range = schedule.toDateRange(DateTime(today.year, today.month));
    if (range.contains(today)) return range;
  }
  return schedules.first.toDateRange(DateTime(today.year, today.month));
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

extension BudgetCycleScheduleDateRange on BudgetCycleSchedule {
  DateRange toDateRange(DateTime openingMonth) {
    final start = _atClampedDay(openingMonth, openingDay);
    final closingMonth = closingDay < openingDay
        ? DateTime(openingMonth.year, openingMonth.month + 1)
        : openingMonth;
    return DateRange(
      start: start,
      endInclusive: _atClampedDay(closingMonth, closingDay),
    );
  }
}

DateTime _atClampedDay(DateTime month, int day) {
  final lastDay = DateTime(month.year, month.month + 1, 0).day;
  return DateTime(month.year, month.month, day.clamp(1, lastDay));
}
