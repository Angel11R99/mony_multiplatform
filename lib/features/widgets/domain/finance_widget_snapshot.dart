import '../../budgets/domain/budget.dart';
import '../../categories/domain/category.dart';
import '../../obligations/domain/obligation.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../recurring/domain/recurring_entry.dart';
import '../../savings/domain/savings_goal.dart';
import '../../transactions/domain/transaction.dart';

class FinanceWidgetSnapshot {
  const FinanceWidgetSnapshot({
    required this.createdAt,
    required this.themeMode,
    required this.currencyStyle,
    required this.primaryColorArgb,
    required this.accentColorArgb,
    required this.periodStart,
    required this.periodEnd,
    required this.budgetInCents,
    required this.incomeInCents,
    required this.expenseInCents,
    required this.balanceInCents,
    required this.availableInCents,
    required this.usagePercent,
    required this.daysLeft,
    required this.todayExpenseInCents,
    required this.dailyAllowanceInCents,
    required this.previousExpenseInCents,
    required this.recentMovements,
    required this.categoryLimits,
    required this.pendingItems,
    required this.pendingToPayInCents,
    required this.pendingToCollectInCents,
    required this.savingsGoals,
    required this.savedInCents,
    required this.savingsTargetInCents,
    required this.fixedEntries,
    required this.fixedIncomeInCents,
    required this.fixedExpenseInCents,
  });

  final DateTime createdAt;
  final AppThemeMode themeMode;
  final CurrencyFormatStyle currencyStyle;
  final int primaryColorArgb;
  final int accentColorArgb;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int? budgetInCents;
  final int incomeInCents;
  final int expenseInCents;
  final int balanceInCents;
  final int availableInCents;
  final int usagePercent;
  final int daysLeft;
  final int todayExpenseInCents;
  final int? dailyAllowanceInCents;
  final int? previousExpenseInCents;
  final List<WidgetMovement> recentMovements;
  final List<WidgetCategoryLimit> categoryLimits;
  final List<WidgetPendingItem> pendingItems;
  final int pendingToPayInCents;
  final int pendingToCollectInCents;
  final List<WidgetSavingsGoal> savingsGoals;
  final int savedInCents;
  final int savingsTargetInCents;
  final List<WidgetFixedEntry> fixedEntries;
  final int fixedIncomeInCents;
  final int fixedExpenseInCents;

  factory FinanceWidgetSnapshot.fromData({
    required DateTime now,
    required List<FinanceTransaction> transactions,
    required BudgetConfig? budget,
    required List<Category> categories,
    required List<Obligation> obligations,
    required List<SavingsGoalProgress> savingsGoals,
    required List<RecurringEntry> recurringEntries,
    required AppPreferences preferences,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final period = activeBudgetPeriod(budget, today);
    final inPeriod = transactions.where((item) => period.contains(item.date));
    final income = inPeriod
        .where((item) => item.type == TransactionType.income)
        .fold<int>(0, (sum, item) => sum + item.amountInCents);
    final expenses = inPeriod
        .where((item) => item.type == TransactionType.expense)
        .fold<int>(0, (sum, item) => sum + item.amountInCents);
    final balance = income - expenses;
    final budgetAmount = budget?.amountInCents;
    final daysLeft = period.endInclusive.difference(today).inDays + 1;
    final priorEnd = period.start.subtract(const Duration(days: 1));
    final priorPeriod = activeBudgetPeriod(budget, priorEnd);
    final previousExpenses = transactions
        .where(
          (item) =>
              item.type == TransactionType.expense &&
              priorPeriod.contains(item.date),
        )
        .fold<int>(0, (sum, item) => sum + item.amountInCents);
    final hasPreviousPeriod = transactions.any(
      (item) => priorPeriod.contains(item.date),
    );
    final todayExpenses = transactions
        .where(
          (item) =>
              item.type == TransactionType.expense &&
              _sameDay(item.date, today),
        )
        .fold<int>(0, (sum, item) => sum + item.amountInCents);

    final categoryAmounts = <int, int>{};
    for (final item in inPeriod.where(
      (item) => item.type == TransactionType.expense,
    )) {
      categoryAmounts.update(
        item.categoryId,
        (amount) => amount + item.amountInCents,
        ifAbsent: () => item.amountInCents,
      );
    }
    final limits = categories
        .where(
          (category) =>
              category.isActive &&
              category.type == CategoryType.expense &&
              (category.budgetLimitInCents ?? 0) > 0,
        )
        .map(
          (category) => WidgetCategoryLimit(
            name: category.name,
            spentInCents: categoryAmounts[category.id] ?? 0,
            limitInCents: category.budgetLimitInCents!,
          ),
        )
        .toList()
      ..sort((a, b) {
        final aOver = a.spentInCents > a.limitInCents;
        final bOver = b.spentInCents > b.limitInCents;
        if (aOver != bOver) return aOver ? -1 : 1;
        return b.fraction.compareTo(a.fraction);
      });

    final activeObligations = obligations
        .where((item) {
          final status = item.statusAt(today);
          return status != ObligationStatus.settled &&
              status != ObligationStatus.cancelled;
        })
        .toList()
      ..sort((a, b) {
        final left = a.dueDate;
        final right = b.dueDate;
        if (left == null) return right == null ? 0 : 1;
        if (right == null) return -1;
        return left.compareTo(right);
      });
    final toPay = activeObligations
        .where((item) => item.direction == ObligationDirection.payable)
        .fold<int>(0, (sum, item) => sum + item.remainingAmountInCents);
    final toCollect = activeObligations
        .where((item) => item.direction == ObligationDirection.receivable)
        .fold<int>(0, (sum, item) => sum + item.remainingAmountInCents);

    final goals = savingsGoals.where((item) => item.isActive).toList()
      ..sort((a, b) => b.percent.compareTo(a.percent));
    final activeRecurring = recurringEntries
        .where((item) => item.isActive)
        .toList()
      ..sort((a, b) => b.amountInCents.compareTo(a.amountInCents));

    final recent = transactions.toList()
      ..sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        if (byDate != 0) return byDate;
        final byCreated = b.createdAt.compareTo(a.createdAt);
        return byCreated != 0 ? byCreated : b.id.compareTo(a.id);
      });

    return FinanceWidgetSnapshot(
      createdAt: now,
      themeMode: preferences.themeMode,
      currencyStyle: preferences.currencyFormatStyle,
      primaryColorArgb: preferences.primaryColorArgb,
      accentColorArgb: preferences.accentColorArgb,
      periodStart: period.start,
      periodEnd: period.endInclusive,
      budgetInCents: budgetAmount,
      incomeInCents: income,
      expenseInCents: expenses,
      balanceInCents: balance,
      availableInCents: budgetAmount == null
          ? balance
          : budgetAmount - expenses,
      usagePercent: budgetAmount == null || budgetAmount <= 0
          ? 0
          : (expenses * 100) ~/ budgetAmount,
      daysLeft: daysLeft,
      todayExpenseInCents: todayExpenses,
      dailyAllowanceInCents: budgetAmount == null || budgetAmount <= 0
          ? null
          : (budgetAmount - expenses) ~/ daysLeft,
      previousExpenseInCents: hasPreviousPeriod ? previousExpenses : null,
      recentMovements: recent.take(5).map(WidgetMovement.fromTransaction).toList(),
      categoryLimits: limits.take(5).toList(),
      pendingItems: activeObligations.take(5).map(WidgetPendingItem.fromObligation).toList(),
      pendingToPayInCents: toPay,
      pendingToCollectInCents: toCollect,
      savingsGoals: goals.take(5).map(WidgetSavingsGoal.fromProgress).toList(),
      savedInCents: goals.fold(0, (sum, item) => sum + item.savedInCents),
      savingsTargetInCents: goals.fold(
        0,
        (sum, item) => sum + item.goal.targetAmountInCents,
      ),
      fixedEntries: activeRecurring.take(5).map(WidgetFixedEntry.fromRecurring).toList(),
      fixedIncomeInCents: activeRecurring
          .where((item) => item.type == TransactionType.income)
          .fold<int>(0, (sum, item) => sum + item.amountInCents),
      fixedExpenseInCents: activeRecurring
          .where((item) => item.type == TransactionType.expense)
          .fold<int>(0, (sum, item) => sum + item.amountInCents),
    );
  }

  Map<String, Object?> toJson() => {
    'createdAt': createdAt.toIso8601String(),
    'themeMode': themeMode.name,
    'currencyStyle': currencyStyle.name,
    'primaryColorArgb': primaryColorArgb,
    'accentColorArgb': accentColorArgb,
    'periodStart': _date(periodStart),
    'periodEnd': _date(periodEnd),
    'budgetInCents': budgetInCents,
    'incomeInCents': incomeInCents,
    'expenseInCents': expenseInCents,
    'balanceInCents': balanceInCents,
    'availableInCents': availableInCents,
    'usagePercent': usagePercent,
    'daysLeft': daysLeft,
    'todayExpenseInCents': todayExpenseInCents,
    'dailyAllowanceInCents': dailyAllowanceInCents,
    'previousExpenseInCents': previousExpenseInCents,
    'recentMovements': recentMovements.map((item) => item.toJson()).toList(),
    'categoryLimits': categoryLimits.map((item) => item.toJson()).toList(),
    'pendingItems': pendingItems.map((item) => item.toJson()).toList(),
    'pendingToPayInCents': pendingToPayInCents,
    'pendingToCollectInCents': pendingToCollectInCents,
    'savingsGoals': savingsGoals.map((item) => item.toJson()).toList(),
    'savedInCents': savedInCents,
    'savingsTargetInCents': savingsTargetInCents,
    'fixedEntries': fixedEntries.map((item) => item.toJson()).toList(),
    'fixedIncomeInCents': fixedIncomeInCents,
    'fixedExpenseInCents': fixedExpenseInCents,
  };
}

class WidgetMovement {
  const WidgetMovement({
    required this.title,
    required this.amountInCents,
    required this.isIncome,
    required this.date,
  });

  final String title;
  final int amountInCents;
  final bool isIncome;
  final DateTime date;

  factory WidgetMovement.fromTransaction(FinanceTransaction item) =>
      WidgetMovement(
        title: item.description?.trim().isNotEmpty == true
            ? item.description!.trim()
            : item.type == TransactionType.income
            ? 'Ingreso'
            : 'Gasto',
        amountInCents: item.amountInCents,
        isIncome: item.type == TransactionType.income,
        date: item.date,
      );

  Map<String, Object?> toJson() => {
    'title': title,
    'amountInCents': amountInCents,
    'isIncome': isIncome,
    'date': _date(date),
  };
}

class WidgetCategoryLimit {
  const WidgetCategoryLimit({
    required this.name,
    required this.spentInCents,
    required this.limitInCents,
  });

  final String name;
  final int spentInCents;
  final int limitInCents;
  double get fraction => limitInCents <= 0 ? 0 : spentInCents / limitInCents;

  Map<String, Object?> toJson() => {
    'name': name,
    'spentInCents': spentInCents,
    'limitInCents': limitInCents,
  };
}

class WidgetPendingItem {
  const WidgetPendingItem({
    required this.title,
    required this.counterparty,
    required this.amountInCents,
    required this.isPayable,
    required this.dueDate,
  });

  final String title;
  final String? counterparty;
  final int amountInCents;
  final bool isPayable;
  final DateTime? dueDate;

  factory WidgetPendingItem.fromObligation(Obligation item) => WidgetPendingItem(
    title: item.title,
    counterparty: item.counterparty,
    amountInCents: item.remainingAmountInCents,
    isPayable: item.direction == ObligationDirection.payable,
    dueDate: item.dueDate,
  );

  Map<String, Object?> toJson() => {
    'title': title,
    'counterparty': counterparty,
    'amountInCents': amountInCents,
    'isPayable': isPayable,
    'dueDate': dueDate == null ? null : _date(dueDate!),
  };
}

class WidgetSavingsGoal {
  const WidgetSavingsGoal({
    required this.name,
    required this.savedInCents,
    required this.targetInCents,
    required this.percent,
  });

  final String name;
  final int savedInCents;
  final int targetInCents;
  final int percent;

  factory WidgetSavingsGoal.fromProgress(SavingsGoalProgress item) =>
      WidgetSavingsGoal(
        name: item.goal.name,
        savedInCents: item.savedInCents,
        targetInCents: item.goal.targetAmountInCents,
        percent: item.percent,
      );

  Map<String, Object?> toJson() => {
    'name': name,
    'savedInCents': savedInCents,
    'targetInCents': targetInCents,
    'percent': percent,
  };
}

class WidgetFixedEntry {
  const WidgetFixedEntry({
    required this.title,
    required this.amountInCents,
    required this.isIncome,
    required this.nextDate,
  });

  final String title;
  final int amountInCents;
  final bool isIncome;
  final DateTime nextDate;

  factory WidgetFixedEntry.fromRecurring(RecurringEntry item) =>
      WidgetFixedEntry(
        title: item.title,
        amountInCents: item.amountInCents,
        isIncome: item.type == TransactionType.income,
        nextDate: item.nextDate,
      );

  Map<String, Object?> toJson() => {
    'title': title,
    'amountInCents': amountInCents,
    'isIncome': isIncome,
    'nextDate': _date(nextDate),
  };
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
