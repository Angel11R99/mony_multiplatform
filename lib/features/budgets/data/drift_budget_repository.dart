import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/budget.dart';
import '../domain/budget_repository.dart';
import '../domain/budget_validator.dart';

class DriftBudgetRepository implements BudgetRepository {
  const DriftBudgetRepository(this._database);

  static const _configId = 1;
  final AppDatabase _database;

  @override
  Stream<BudgetConfig?> watchConfig() =>
      (_database.select(_database.budgets)
            ..where((row) => row.id.equals(_configId)))
          .watchSingleOrNull()
          .map(_fromConfigRow);

  @override
  Stream<List<BudgetCycle>> watchHistory() =>
      (_database.select(_database.budgetCycles)..orderBy([
            (row) => OrderingTerm.desc(row.endDateEpochDay),
            (row) => OrderingTerm.desc(row.closedAt),
          ]))
          .watch()
          .map((rows) => rows.map(_fromCycleRow).toList(growable: false));

  @override
  Future<BudgetConfig?> getConfig() async => _fromConfigRow(
    await (_database.select(
      _database.budgets,
    )..where((row) => row.id.equals(_configId))).getSingleOrNull(),
  );

  @override
  Future<void> saveConfig({
    required int amountInCents,
    required BudgetPeriod period,
    required DateTime now,
  }) async {
    final amountError = BudgetValidator.validateAmount(amountInCents);
    if (amountError != null) throw BudgetRepositoryException(amountError);
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.budgets,
      )..where((row) => row.id.equals(_configId))).getSingleOrNull();
      final periodChanged = existing != null && existing.period != period.name;
      final schedules = existing == null || periodChanged
          ? defaultBudgetCycleSchedules(period)
          : _decodeSchedules(existing.cycleSchedulesJson, period);
      final scheduleError = BudgetValidator.validateSchedules(schedules);
      if (scheduleError != null) throw BudgetRepositoryException(scheduleError);
      final provisional = BudgetConfig(
        amountInCents: amountInCents,
        period: period,
        cycleStart: null,
        cycleStartedAt: null,
        incomeTransactionId: existing?.incomeTransactionId,
        cycleSchedules: schedules,
        autoCloseEnabled: existing?.autoCloseEnabled ?? false,
        autoCloseMinuteOfDay: existing?.autoCloseMinuteOfDay ?? 21 * 60,
      );
      final currentPeriod = activeBudgetPeriod(provisional, now);
      final resetsCycle = existing == null || periodChanged;
      final cycleStart = resetsCycle
          ? currentPeriod.start
          : dateFromEpochDay(existing.cycleStartEpochDay);
      final cycleStartedAt = resetsCycle ? now : existing.cycleStartedAt;
      final oldIncomeId = existing?.incomeTransactionId;
      final oldIncome = oldIncomeId == null
          ? null
          : await (_database.select(
              _database.transactions,
            )..where((row) => row.id.equals(oldIncomeId))).getSingleOrNull();
      final incomeCategory = await _incomeCategory(oldIncome?.categoryId);
      if (incomeCategory == null) {
        throw const BudgetRepositoryException(
          'Activa al menos una categoría de ingreso para configurar el presupuesto.',
        );
      }
      final paymentMethod =
          await (_database.select(_database.paymentMethods)..where(
                (row) => row.isActive.equals(true) & row.isDefault.equals(true),
              ))
              .getSingleOrNull();
      if (paymentMethod == null) {
        throw const BudgetRepositoryException(
          'Configura un método de pago predeterminado para asignar el ingreso del presupuesto.',
        );
      }
      final incomeId = await _upsertBudgetIncome(
        existing: oldIncome,
        amountInCents: amountInCents,
        period: period,
        categoryId: incomeCategory.id,
        paymentMethodId: paymentMethod.id,
        date: resetsCycle
            ? cycleStart
            : dateFromEpochDay(
                oldIncome?.dateEpochDay ?? dateToEpochDay(cycleStart),
              ),
        now: now,
      );
      final companion = BudgetsCompanion.insert(
        id: const Value(_configId),
        amountInCents: amountInCents,
        period: period.name,
        cycleStartEpochDay: dateToEpochDay(cycleStart),
        cycleStartedAt: cycleStartedAt,
        incomeTransactionId: Value(incomeId),
        cycleSchedulesJson: jsonEncode(
          schedules.map((schedule) => schedule.toJson()).toList(),
        ),
        autoCloseEnabled: Value(existing?.autoCloseEnabled ?? false),
        autoCloseMinuteOfDay: Value(existing?.autoCloseMinuteOfDay ?? 21 * 60),
      );
      await _database.into(_database.budgets).insertOnConflictUpdate(companion);
    });
  }

  @override
  Future<void> setAutomaticClose({
    required bool enabled,
    required int minuteOfDay,
  }) async {
    if (minuteOfDay < 0 || minuteOfDay >= 24 * 60) {
      throw const BudgetRepositoryException('Selecciona una hora válida.');
    }
    final updated =
        await (_database.update(
          _database.budgets,
        )..where((row) => row.id.equals(_configId))).write(
          BudgetsCompanion(
            autoCloseEnabled: Value(enabled),
            autoCloseMinuteOfDay: Value(minuteOfDay),
          ),
        );
    if (updated == 0) {
      throw const BudgetRepositoryException(
        'Primero configura un presupuesto.',
      );
    }
  }

  @override
  Future<void> updateCycleSchedules(List<BudgetCycleSchedule> schedules) async {
    final scheduleError = BudgetValidator.validateSchedules(schedules);
    if (scheduleError != null) {
      throw BudgetRepositoryException(scheduleError);
    }
    final updated =
        await (_database.update(
          _database.budgets,
        )..where((row) => row.id.equals(_configId))).write(
          BudgetsCompanion(
            cycleSchedulesJson: Value(
              jsonEncode(
                schedules.map((schedule) => schedule.toJson()).toList(),
              ),
            ),
          ),
        );
    if (updated == 0) {
      throw const BudgetRepositoryException(
        'Primero configura un presupuesto.',
      );
    }
  }

  @override
  Future<bool> closeNextCycle({
    required DateTime now,
    required bool automatic,
  }) async {
    var closed = false;
    await _database.transaction(() async {
      final row = await (_database.select(
        _database.budgets,
      )..where((item) => item.id.equals(_configId))).getSingleOrNull();
      final config = _fromConfigRow(row);
      if (row == null || config == null) return;
      final closeAllowed = automatic
          ? shouldAutomaticallyCloseBudgetCycle(config, now)
          : canManuallyCloseBudgetCycle(config, now);
      if (!closeAllowed) return;
      final period = budgetPeriodToClose(config, now);
      final startEpochDay = dateToEpochDay(period.start);
      final endEpochDay = dateToEpochDay(period.endInclusive);
      final transactions =
          await (_database.select(_database.transactions)..where(
                (item) =>
                    item.dateEpochDay.isBiggerOrEqualValue(startEpochDay) &
                    item.dateEpochDay.isSmallerOrEqualValue(endEpochDay),
              ))
              .get();
      var income = 0;
      var expenses = 0;
      for (final transaction in transactions) {
        if (transaction.type == 'income') {
          income += transaction.amountInCents;
        }
        if (transaction.type == 'expense') {
          expenses += transaction.amountInCents;
        }
      }
      final nextStart = nextBudgetPeriod(config, period.endInclusive).start;
      final category = await _incomeCategory(null);
      if (category == null) {
        throw const BudgetRepositoryException(
          'Activa una categoría de ingreso antes de cerrar el ciclo.',
        );
      }
      final method =
          await (_database.select(_database.paymentMethods)..where(
                (item) =>
                    item.isActive.equals(true) & item.isDefault.equals(true),
              ))
              .getSingleOrNull();
      if (method == null) {
        throw const BudgetRepositoryException(
          'Configura un método de pago predeterminado antes de cerrar el ciclo.',
        );
      }
      await _database
          .into(_database.budgetCycles)
          .insert(
            BudgetCyclesCompanion.insert(
              period: config.period.name,
              budgetAmountInCents: config.amountInCents,
              incomeInCents: income,
              expenseInCents: expenses,
              startDateEpochDay: startEpochDay,
              endDateEpochDay: endEpochDay,
              closedAt: now,
            ),
          );
      final nextIncomeId = await _upsertBudgetIncome(
        amountInCents: config.amountInCents,
        period: config.period,
        categoryId: category.id,
        paymentMethodId: method.id,
        date: nextStart,
        now: now,
      );
      await (_database.update(
        _database.budgets,
      )..where((item) => item.id.equals(_configId))).write(
        BudgetsCompanion(
          cycleStartEpochDay: Value(dateToEpochDay(nextStart)),
          cycleStartedAt: Value(now),
          incomeTransactionId: Value(nextIncomeId),
        ),
      );
      closed = true;
    });
    return closed;
  }

  @override
  Future<int> closeDueCycles({required DateTime now}) async {
    var count = 0;
    while (count < 120 && await closeNextCycle(now: now, automatic: true)) {
      count++;
    }
    return count;
  }

  Future<CategoryRow?> _incomeCategory(int? preferredCategoryId) async {
    if (preferredCategoryId != null) {
      final preferred =
          await (_database.select(_database.categories)..where(
                (row) =>
                    row.id.equals(preferredCategoryId) &
                    row.type.equals('income') &
                    row.isActive.equals(true),
              ))
              .getSingleOrNull();
      if (preferred != null) return preferred;
    }
    final salary =
        await (_database.select(_database.categories)..where(
              (row) =>
                  row.normalizedName.equals('salario') &
                  row.type.equals('income') &
                  row.isActive.equals(true),
            ))
            .getSingleOrNull();
    if (salary != null) return salary;
    return (_database.select(_database.categories)
          ..where(
            (row) => row.type.equals('income') & row.isActive.equals(true),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.id)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> _upsertBudgetIncome({
    FinanceTransactionRow? existing,
    required int amountInCents,
    required BudgetPeriod period,
    required int categoryId,
    required int paymentMethodId,
    required DateTime date,
    required DateTime now,
  }) async {
    if (existing == null) {
      return _database
          .into(_database.transactions)
          .insert(
            TransactionsCompanion.insert(
              amountInCents: amountInCents,
              type: 'income',
              categoryId: categoryId,
              paymentMethodId: paymentMethodId,
              description: Value(budgetIncomeDescription(period)),
              dateEpochDay: dateToEpochDay(date),
              createdAt: Value(now),
              updatedAt: Value(now),
              fixedEntryId: const Value(null),
              savingsGoalId: const Value(null),
            ),
          );
    }
    await (_database.update(
      _database.transactions,
    )..where((row) => row.id.equals(existing.id))).write(
      TransactionsCompanion(
        amountInCents: Value(amountInCents),
        type: const Value('income'),
        categoryId: Value(categoryId),
        paymentMethodId: Value(paymentMethodId),
        description: Value(budgetIncomeDescription(period)),
        dateEpochDay: Value(dateToEpochDay(date)),
        updatedAt: Value(now),
      ),
    );
    return existing.id;
  }

  BudgetConfig? _fromConfigRow(BudgetConfigRow? row) {
    if (row == null) return null;
    final period = BudgetPeriod.values.firstWhere(
      (value) => value.name == row.period,
      orElse: () => BudgetPeriod.monthly,
    );
    return BudgetConfig(
      amountInCents: row.amountInCents,
      period: period,
      cycleStart: dateFromEpochDay(row.cycleStartEpochDay),
      cycleStartedAt: row.cycleStartedAt,
      incomeTransactionId: row.incomeTransactionId,
      cycleSchedules: _decodeSchedules(row.cycleSchedulesJson, period),
      autoCloseEnabled: row.autoCloseEnabled,
      autoCloseMinuteOfDay: row.autoCloseMinuteOfDay,
    );
  }

  List<BudgetCycleSchedule> _decodeSchedules(
    String encoded,
    BudgetPeriod period,
  ) {
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is List) {
        final schedules = decoded
            .map(BudgetCycleSchedule.fromJson)
            .whereType<BudgetCycleSchedule>()
            .toList(growable: false);
        if (BudgetValidator.validateSchedules(schedules) == null) {
          return schedules;
        }
      }
    } on FormatException {
      // Fall back to the period defaults for a malformed local configuration.
    }
    return defaultBudgetCycleSchedules(period);
  }

  BudgetCycle _fromCycleRow(BudgetCycleRow row) => BudgetCycle(
    id: row.id,
    period: BudgetPeriod.values.firstWhere(
      (value) => value.name == row.period,
      orElse: () => BudgetPeriod.monthly,
    ),
    budgetAmountInCents: row.budgetAmountInCents,
    incomeInCents: row.incomeInCents,
    expenseInCents: row.expenseInCents,
    startDate: dateFromEpochDay(row.startDateEpochDay),
    endDate: dateFromEpochDay(row.endDateEpochDay),
    closedAt: row.closedAt,
  );
}
