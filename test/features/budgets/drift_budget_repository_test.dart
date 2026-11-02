import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/budgets/data/drift_budget_repository.dart';
import 'package:mony_multiplatform/features/budgets/domain/budget.dart';
import 'package:mony_multiplatform/features/budgets/domain/budget_repository.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  late AppDatabase database;
  late DriftBudgetRepository budgets;
  late DriftTransactionRepository transactions;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    budgets = DriftBudgetRepository(database);
    transactions = DriftTransactionRepository(database);
  });

  tearDown(() => database.close());

  test(
    'saves one budget income and updates that row when amount changes',
    () async {
      await budgets.saveConfig(
        amountInCents: 100000,
        period: BudgetPeriod.monthly,
        now: DateTime(2026, 1, 5),
      );
      var config = (await budgets.getConfig())!;
      final incomeId = config.incomeTransactionId!;
      var income = (await transactions.get(incomeId))!;
      expect(config.cycleStart, DateTime(2026, 1, 1));
      expect(income.amountInCents, 100000);
      expect(income.type, TransactionType.income);
      expect(income.categoryId, 1);
      expect(income.paymentMethodId, 1);
      expect(income.date, DateTime(2026, 1, 1));
      expect(income.description, 'Ingreso mensual');

      await budgets.saveConfig(
        amountInCents: 150000,
        period: BudgetPeriod.monthly,
        now: DateTime(2026, 1, 7),
      );
      config = (await budgets.getConfig())!;
      income = (await transactions.get(incomeId))!;
      expect(config.incomeTransactionId, incomeId);
      expect(income.amountInCents, 150000);
      expect(await transactions.watchAll().first, hasLength(1));

      await budgets.saveConfig(
        amountInCents: 175000,
        period: BudgetPeriod.fortnightly,
        now: DateTime(2026, 1, 10),
      );
      config = (await budgets.getConfig())!;
      income = (await transactions.get(incomeId))!;
      expect(config.period, BudgetPeriod.fortnightly);
      expect(config.cycleStart, DateTime(2026, 1, 1));
      expect(
        config.cycleSchedules
            .map((schedule) => (schedule.openingDay, schedule.closingDay))
            .toList(),
        defaultBudgetCycleSchedules(BudgetPeriod.fortnightly)
            .map((schedule) => (schedule.openingDay, schedule.closingDay))
            .toList(),
      );
      expect(income.description, 'Ingreso por ciclo');
      expect(income.amountInCents, 175000);
      expect(await transactions.watchAll().first, hasLength(1));
    },
  );

  test(
    'manual close archives the cycle once and starts the next cycle',
    () async {
      await budgets.saveConfig(
        amountInCents: 100000,
        period: BudgetPeriod.monthly,
        now: DateTime(2026, 8, 5),
      );
      final oldIncomeId = (await budgets.getConfig())!.incomeTransactionId!;
      await transactions.create(
        FinanceTransaction(
          amountInCents: 25000,
          type: TransactionType.expense,
          categoryId: 6,
          paymentMethodId: 1,
          description: 'Compra del ciclo',
          date: DateTime(2026, 8, 31),
          createdAt: DateTime(2026, 7, 30),
          updatedAt: DateTime(2026, 7, 30),
        ),
      );

      final closed = await budgets.closeNextCycle(
        now: DateTime(2026, 8, 31, 12),
        automatic: false,
      );
      expect(closed, isTrue);
      final history = await budgets.watchHistory().first;
      expect(history, hasLength(1));
      expect(history.single.startDate, DateTime(2026, 8, 1));
      expect(history.single.endDate, DateTime(2026, 8, 31));
      expect(history.single.incomeInCents, 100000);
      expect(history.single.expenseInCents, 25000);
      expect(history.single.remainingInCents, 75000);

      final nextConfig = (await budgets.getConfig())!;
      expect(nextConfig.cycleStart, DateTime(2026, 9, 1));
      expect(nextConfig.incomeTransactionId, isNot(oldIncomeId));
      final nextIncome = (await transactions.get(
        nextConfig.incomeTransactionId!,
      ))!;
      expect(nextIncome.date, DateTime(2026, 9, 1));
      expect(nextIncome.amountInCents, 100000);
      expect(await transactions.watchAll().first, hasLength(3));

      expect(
        await budgets.closeNextCycle(
          now: DateTime(2026, 8, 31, 12),
          automatic: false,
        ),
        isFalse,
      );
      expect(await budgets.watchHistory().first, hasLength(1));
    },
  );

  test(
    'automatic close waits for configured time and catches up due cycles',
    () async {
      await budgets.saveConfig(
        amountInCents: 80000,
        period: BudgetPeriod.fortnightly,
        now: DateTime(2026, 8, 3),
      );
      await budgets.setAutomaticClose(enabled: true, minuteOfDay: 21 * 60);
      expect(
        await budgets.closeDueCycles(now: DateTime(2026, 8, 15, 20, 59)),
        0,
      );
      expect(await budgets.closeDueCycles(now: DateTime(2026, 8, 15, 21)), 1);
      expect((await budgets.getConfig())!.cycleStart, DateTime(2026, 8, 16));

      expect(await budgets.closeDueCycles(now: DateTime(2026, 9, 1, 12)), 1);
      final history = await budgets.watchHistory().first;
      expect(history, hasLength(2));
      expect(history.map((cycle) => cycle.startDate).toSet(), {
        DateTime(2026, 8, 1),
        DateTime(2026, 8, 16),
      });
      expect((await budgets.getConfig())!.cycleStart, DateTime(2026, 9, 1));
    },
  );

  test('automatic close remains off until enabled and stores time', () async {
    await budgets.saveConfig(
      amountInCents: 10000,
      period: BudgetPeriod.monthly,
      now: DateTime(2026, 2, 2),
    );
    await budgets.setAutomaticClose(enabled: true, minuteOfDay: 18 * 60 + 30);
    final config = (await budgets.getConfig())!;
    expect(config.autoCloseEnabled, isTrue);
    expect(config.autoCloseMinuteOfDay, 1110);
    expect(await budgets.closeDueCycles(now: DateTime(2026, 2, 28, 18, 29)), 0);
    expect(await budgets.closeDueCycles(now: DateTime(2026, 2, 28, 18, 30)), 1);
  });

  test(
    'persists custom cycle schedules and rejects duplicate opening days',
    () async {
      await budgets.saveConfig(
        amountInCents: 10000,
        period: BudgetPeriod.monthly,
        now: DateTime(2026, 2, 2),
      );
      const schedules = [
        BudgetCycleSchedule(openingDay: 5, closingDay: 12),
        BudgetCycleSchedule(openingDay: 13, closingDay: 4),
      ];
      await budgets.updateCycleSchedules(schedules);
      final config = (await budgets.getConfig())!;
      expect(
        config.cycleSchedules
            .map((schedule) => (schedule.openingDay, schedule.closingDay))
            .toList(),
        [(5, 12), (13, 4)],
      );
      await expectLater(
        budgets.updateCycleSchedules(const [
          BudgetCycleSchedule(openingDay: 1, closingDay: 10),
          BudgetCycleSchedule(openingDay: 1, closingDay: 20),
        ]),
        throwsA(isA<BudgetRepositoryException>()),
      );
    },
  );

  test('rejects zero budget and invalid automatic close time', () async {
    await expectLater(
      budgets.saveConfig(
        amountInCents: 0,
        period: BudgetPeriod.monthly,
        now: DateTime(2026),
      ),
      throwsA(isA<BudgetRepositoryException>()),
    );
    await budgets.saveConfig(
      amountInCents: 1,
      period: BudgetPeriod.monthly,
      now: DateTime(2026),
    );
    await expectLater(
      budgets.setAutomaticClose(enabled: true, minuteOfDay: 1440),
      throwsA(isA<BudgetRepositoryException>()),
    );
  });
}
