import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/budgets/domain/budget.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/recurring/domain/recurring_entry.dart';
import 'package:mony_multiplatform/features/savings/domain/savings_goal.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/widgets/domain/finance_widget_snapshot.dart';

void main() {
  final now = DateTime(2026, 11, 2, 12);
  final budget = BudgetConfig(
    amountInCents: 100000,
    period: BudgetPeriod.monthly,
    cycleStart: DateTime(2026, 11, 1),
    cycleStartedAt: DateTime(2026, 11, 1),
    incomeTransactionId: null,
    cycleSchedules: const [BudgetCycleSchedule(openingDay: 1, closingDay: 31)],
    autoCloseEnabled: false,
    autoCloseMinuteOfDay: 0,
  );
  final transactions = [
    FinanceTransaction(
      id: 1,
      amountInCents: 100000,
      type: TransactionType.income,
      categoryId: 1,
      paymentMethodId: 1,
      description: 'Nómina',
      date: DateTime(2026, 11, 1),
      createdAt: DateTime(2026, 11, 1),
      updatedAt: DateTime(2026, 11, 1),
    ),
    FinanceTransaction(
      id: 2,
      amountInCents: 25000,
      type: TransactionType.expense,
      categoryId: 2,
      paymentMethodId: 1,
      description: 'Supermercado',
      date: DateTime(2026, 11, 2),
      createdAt: DateTime(2026, 11, 2, 10),
      updatedAt: DateTime(2026, 11, 2, 10),
    ),
    FinanceTransaction(
      id: 3,
      amountInCents: 10000,
      type: TransactionType.expense,
      categoryId: 2,
      paymentMethodId: 1,
      description: 'Mercado anterior',
      date: DateTime(2026, 10, 10),
      createdAt: DateTime(2026, 10, 10),
      updatedAt: DateTime(2026, 10, 10),
    ),
  ];

  FinanceWidgetSnapshot createSnapshot() => FinanceWidgetSnapshot.fromData(
    now: now,
    transactions: transactions,
    budget: budget,
    categories: [
      Category(
        id: 2,
        name: 'Comida',
        type: CategoryType.expense,
        icon: 'food',
        colorArgb: 0xff00aa88,
        isActive: true,
        createdAt: DateTime(2025),
        budgetLimitInCents: 50000,
      ),
      Category(
        id: 3,
        name: 'Transporte',
        type: CategoryType.expense,
        icon: 'car',
        colorArgb: 0xff0088aa,
        isActive: true,
        createdAt: DateTime(2025),
      ),
    ],
    obligations: [
      Obligation(
        id: 1,
        direction: ObligationDirection.payable,
        title: 'Internet',
        amountInCents: 1000,
        paidAmountInCents: 200,
        dueDate: DateTime(2026, 11, 2),
        categoryId: 2,
        createdAt: now,
        updatedAt: now,
      ),
      Obligation(
        id: 2,
        direction: ObligationDirection.receivable,
        title: 'Préstamo',
        amountInCents: 2000,
        dueDate: DateTime(2026, 11, 1),
        categoryId: 2,
        createdAt: now,
        updatedAt: now,
      ),
      Obligation(
        id: 3,
        direction: ObligationDirection.payable,
        title: 'Liquidada',
        amountInCents: 2000,
        paidAmountInCents: 2000,
        categoryId: 2,
        createdAt: now,
        updatedAt: now,
      ),
    ],
    savingsGoals: [
      SavingsGoalProgress(
        goal: SavingsGoal(
          id: 1,
          name: 'Emergencia',
          targetAmountInCents: 10000,
          createdAt: now,
          completedAt: null,
        ),
        savedInCents: 5000,
      ),
    ],
    recurringEntries: [
      RecurringEntry(
        id: 1,
        title: 'Alquiler',
        amountInCents: 3000,
        type: TransactionType.expense,
        categoryId: 2,
        paymentMethodId: 1,
        frequency: RecurrenceFrequency.monthly,
        startDate: DateTime(2026, 1, 1),
        nextDate: DateTime(2026, 12, 1),
      ),
      RecurringEntry(
        id: 2,
        title: 'Trabajo extra',
        amountInCents: 5000,
        type: TransactionType.income,
        categoryId: 1,
        paymentMethodId: 1,
        frequency: RecurrenceFrequency.weekly,
        startDate: DateTime(2026, 1, 1),
        nextDate: DateTime(2026, 11, 9),
      ),
      RecurringEntry(
        id: 3,
        title: 'Archivado',
        amountInCents: 9000,
        type: TransactionType.expense,
        categoryId: 2,
        paymentMethodId: 1,
        frequency: RecurrenceFrequency.monthly,
        startDate: DateTime(2026, 1, 1),
        nextDate: DateTime(2026, 11, 3),
        isActive: false,
      ),
    ],
    preferences: const AppPreferences(
      currencyFormatStyle: CurrencyFormatStyle.code,
    ),
  );

  test('builds complete widget snapshots from local feature data', () {
    final snapshot = createSnapshot();

    expect(snapshot.periodStart, DateTime(2026, 11, 1));
    expect(snapshot.incomeInCents, 100000);
    expect(snapshot.expenseInCents, 25000);
    expect(snapshot.balanceInCents, 75000);
    expect(snapshot.availableInCents, 75000);
    expect(snapshot.usagePercent, 25);
    expect(snapshot.todayExpenseInCents, 25000);
    expect(snapshot.dailyAllowanceInCents, 2586);
    expect(snapshot.previousExpenseInCents, 10000);
    expect(snapshot.recentMovements.first.title, 'Supermercado');
    expect(snapshot.categoryLimits.single.name, 'Comida');
    expect(snapshot.categoryLimits.single.fraction, 0.5);
    expect(snapshot.pendingToPayInCents, 800);
    expect(snapshot.pendingToCollectInCents, 2000);
    expect(snapshot.pendingItems.map((item) => item.title), [
      'Préstamo',
      'Internet',
    ]);
    expect(snapshot.savedInCents, 5000);
    expect(snapshot.savingsTargetInCents, 10000);
    expect(snapshot.fixedIncomeInCents, 5000);
    expect(snapshot.fixedExpenseInCents, 3000);
    expect(snapshot.fixedEntries.map((item) => item.title), [
      'Trabajo extra',
      'Alquiler',
    ]);
  });

  test('serializes shared widget data without floating-point money', () {
    final json = createSnapshot().toJson();

    expect(json['currencyStyle'], 'code');
    expect(json['expenseInCents'], 25000);
    expect(json['todayExpenseInCents'], 25000);
    expect(json['recentMovements'], hasLength(3));
    expect(json, contains('categoryLimits'));
    expect(json, contains('pendingItems'));
    expect(json, contains('savingsGoals'));
    expect(json, contains('fixedEntries'));
  });

  test('uses net cash balance when no budget is configured', () {
    final snapshot = FinanceWidgetSnapshot.fromData(
      now: now,
      transactions: transactions,
      budget: null,
      categories: const [],
      obligations: const [],
      savingsGoals: const [],
      recurringEntries: const [],
      preferences: AppPreferences.defaults,
    );

    expect(snapshot.budgetInCents, isNull);
    expect(snapshot.availableInCents, 75000);
    expect(snapshot.dailyAllowanceInCents, isNull);
    expect(snapshot.usagePercent, 0);
  });
}
