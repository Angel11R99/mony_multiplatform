import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/budgets/domain/budget.dart';
import 'package:mony_multiplatform/features/budgets/domain/budget_validator.dart';

void main() {
  group('budget periods', () {
    test('monthly period is inclusive and clamps to February end', () {
      final period = activeBudgetPeriod(
        _budget(BudgetPeriod.monthly),
        DateTime(2028, 2, 29),
      );
      expect(period.start, DateTime(2028, 2, 1));
      expect(period.endInclusive, DateTime(2028, 2, 29));
      expect(period.contains(DateTime(2028, 2, 29, 22)), isTrue);
      expect(period.contains(DateTime(2028, 3, 1)), isFalse);
    });

    test('default fortnight splits the month at days 15 and 16', () {
      final first = activeBudgetPeriod(
        _budget(BudgetPeriod.fortnightly),
        DateTime(2026, 8, 15),
      );
      final second = budgetPeriodForView(
        _budget(BudgetPeriod.fortnightly),
        BudgetPeriodView.next,
        DateTime(2026, 8, 15),
      );
      expect(first.start, DateTime(2026, 8, 1));
      expect(first.endInclusive, DateTime(2026, 8, 15));
      expect(second.start, DateTime(2026, 8, 16));
      expect(second.endInclusive, DateTime(2026, 8, 31));
    });

    test('custom schedule handles cross-month cycle and clamped days', () {
      final config = _budget(
        BudgetPeriod.fortnightly,
        schedules: const [
          BudgetCycleSchedule(openingDay: 15, closingDay: 29),
          BudgetCycleSchedule(openingDay: 30, closingDay: 14),
        ],
      );
      final range = activeBudgetPeriod(config, DateTime(2026, 9, 14));
      expect(range.start, DateTime(2026, 8, 30));
      expect(range.endInclusive, DateTime(2026, 9, 14));
      expect(
        activeBudgetPeriod(config, DateTime(2026, 2, 20)).endInclusive,
        DateTime(2026, 2, 28),
      );
    });

    test('monthly next period advances across year boundary', () {
      final next = budgetPeriodForView(
        _budget(BudgetPeriod.monthly),
        BudgetPeriodView.next,
        DateTime(2026, 12, 31),
      );
      expect(next.start, DateTime(2027, 1, 1));
      expect(next.endInclusive, DateTime(2027, 1, 31));
    });
  });

  test(
    'summary filters inclusively by transaction date and counts income separately',
    () {
      final result = summarizeBudgetPeriod(
        DateRange(
          start: DateTime(2026, 8, 1),
          endInclusive: DateTime(2026, 8, 15),
        ),
        [
          (amountInCents: 50000, type: 'income', date: DateTime(2026, 8, 1)),
          (
            amountInCents: 1250,
            type: 'expense',
            date: DateTime(2026, 8, 15, 23),
          ),
          (amountInCents: 4000, type: 'expense', date: DateTime(2026, 8, 16)),
        ],
      );
      expect(result.incomeInCents, 50000);
      expect(result.expenseInCents, 1250);
      expect(result.availableInCents(10000), 8750);
      expect(result.usagePercent(1000), 125);
      expect(budgetUsagePercent(1, 0), 0);
    },
  );

  test('manual and automatic close honor period end and configured time', () {
    final config = _budget(
      BudgetPeriod.monthly,
      cycleStart: DateTime(2026, 8, 1),
      autoClose: true,
      closeMinute: 21 * 60,
    );
    expect(canManuallyCloseBudgetCycle(config, DateTime(2026, 8, 30)), isFalse);
    expect(canManuallyCloseBudgetCycle(config, DateTime(2026, 8, 31)), isTrue);
    expect(
      shouldAutomaticallyCloseBudgetCycle(
        config,
        DateTime(2026, 8, 31, 20, 59),
      ),
      isFalse,
    );
    expect(
      shouldAutomaticallyCloseBudgetCycle(config, DateTime(2026, 8, 31, 21)),
      isTrue,
    );
    expect(
      shouldAutomaticallyCloseBudgetCycle(config, DateTime(2026, 9, 1)),
      isTrue,
    );
  });

  test('automation wakes at the next relevant date or close time', () {
    final now = DateTime(2026, 8, 31, 20, 30);
    final noBudget = nextBudgetAutomationCheckAt(null, now);
    expect(noBudget, DateTime(2026, 9, 1));

    final enabledBudget = _budget(
      BudgetPeriod.monthly,
      cycleStart: DateTime(2026, 8, 1),
      autoClose: true,
      closeMinute: 21 * 60,
    );
    expect(
      nextBudgetAutomationCheckAt(enabledBudget, now),
      DateTime(2026, 8, 31, 21),
    );
    expect(
      nextBudgetAutomationCheckAt(enabledBudget, DateTime(2026, 9, 1, 8)),
      DateTime(2026, 9, 1, 8),
    );
  });

  test('validates positive amounts and cycle definitions', () {
    expect(BudgetValidator.validateAmount(0), isNotNull);
    expect(BudgetValidator.validateAmount(1), isNull);
    expect(
      BudgetValidator.validateSchedules(
        defaultBudgetCycleSchedules(BudgetPeriod.fortnightly),
      ),
      isNull,
    );
    expect(
      BudgetValidator.validateSchedules(const [
        BudgetCycleSchedule(openingDay: 0, closingDay: 15),
      ]),
      isNotNull,
    );
    expect(BudgetValidator.validateSchedules(const []), isNotNull);
  });
}

BudgetConfig _budget(
  BudgetPeriod period, {
  List<BudgetCycleSchedule>? schedules,
  DateTime? cycleStart,
  bool autoClose = false,
  int closeMinute = 21 * 60,
}) => BudgetConfig(
  amountInCents: 100000,
  period: period,
  cycleStart: cycleStart,
  cycleStartedAt: cycleStart,
  incomeTransactionId: null,
  cycleSchedules: schedules ?? defaultBudgetCycleSchedules(period),
  autoCloseEnabled: autoClose,
  autoCloseMinuteOfDay: closeMinute,
);
