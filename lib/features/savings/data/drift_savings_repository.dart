import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/savings_goal.dart';
import '../domain/savings_goal_validator.dart';
import '../domain/savings_repository.dart';

class DriftSavingsRepository implements SavingsRepository {
  const DriftSavingsRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<SavingsGoalProgress>> watchAll() {
    final savedAmount = _database.transactions.amountInCents.sum();
    final query =
        _database.select(_database.savingsGoals).join([
            leftOuterJoin(
              _database.transactions,
              _database.transactions.savingsGoalId.equalsExp(
                _database.savingsGoals.id,
              ),
            ),
          ])
          ..addColumns([savedAmount])
          ..groupBy([_database.savingsGoals.id])
          ..orderBy([
            OrderingTerm(
              expression: _database.savingsGoals.completedAt.isNull(),
              mode: OrderingMode.desc,
            ),
            OrderingTerm.desc(_database.savingsGoals.createdAt),
          ]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => _progress(
              row.readTable(_database.savingsGoals),
              row.read(savedAmount) ?? 0,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Stream<List<SavingsContribution>> watchContributions(int goalId) =>
      (_database.select(_database.transactions)
            ..where((row) => row.savingsGoalId.equals(goalId))
            ..orderBy([
              (row) => OrderingTerm.desc(row.dateEpochDay),
              (row) => OrderingTerm.desc(row.createdAt),
            ]))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => SavingsContribution(
                    transactionId: row.id,
                    amountInCents: row.amountInCents,
                    date: dateFromEpochDay(row.dateEpochDay),
                    description: row.description,
                  ),
                )
                .toList(growable: false),
          );

  @override
  Future<SavingsGoalProgress?> get(int id) async {
    final goal = await (_database.select(
      _database.savingsGoals,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (goal == null) return null;
    final saved = _database.transactions.amountInCents.sum();
    final result =
        await (_database.selectOnly(_database.transactions)
              ..addColumns([saved])
              ..where(_database.transactions.savingsGoalId.equals(id)))
            .getSingle();
    return _progress(goal, result.read(saved) ?? 0);
  }

  @override
  Future<int> create({
    required String name,
    required int targetAmountInCents,
  }) async {
    _validate(name, targetAmountInCents);
    return _database
        .into(_database.savingsGoals)
        .insert(
          SavingsGoalsCompanion.insert(
            name: SavingsGoalValidator.normalizeName(name),
            targetAmountInCents: targetAmountInCents,
          ),
        );
  }

  @override
  Future<void> update({
    required int id,
    required String name,
    required int targetAmountInCents,
  }) async {
    _validate(name, targetAmountInCents);
    if (id <= 0) throw const InvalidSavingsGoalException('Meta no encontrada.');
    final changed =
        await (_database.update(
          _database.savingsGoals,
        )..where((row) => row.id.equals(id))).write(
          SavingsGoalsCompanion(
            name: Value(SavingsGoalValidator.normalizeName(name)),
            targetAmountInCents: Value(targetAmountInCents),
          ),
        );
    if (changed == 0) {
      throw const InvalidSavingsGoalException('Meta no encontrada.');
    }
  }

  @override
  Future<void> complete(int id) async {
    final changed =
        await (_database.update(_database.savingsGoals)
              ..where((row) => row.id.equals(id)))
            .write(SavingsGoalsCompanion(completedAt: Value(DateTime.now())));
    if (changed == 0) {
      throw const InvalidSavingsGoalException('Meta no encontrada.');
    }
  }

  @override
  Future<void> reopen(int id) async {
    final changed =
        await (_database.update(_database.savingsGoals)
              ..where((row) => row.id.equals(id)))
            .write(const SavingsGoalsCompanion(completedAt: Value(null)));
    if (changed == 0) {
      throw const InvalidSavingsGoalException('Meta no encontrada.');
    }
  }

  @override
  Future<void> delete(int id) => _database.transaction(() async {
    await (_database.update(_database.transactions)
          ..where((row) => row.savingsGoalId.equals(id)))
        .write(const TransactionsCompanion(savingsGoalId: Value(null)));
    final deleted = await (_database.delete(
      _database.savingsGoals,
    )..where((row) => row.id.equals(id))).go();
    if (deleted == 0) {
      throw const InvalidSavingsGoalException('Meta no encontrada.');
    }
  });

  @override
  Future<int> addContribution({
    required int goalId,
    required int amountInCents,
    String? note,
  }) => _database.transaction(() async {
    final amountError = SavingsGoalValidator.validateContribution(
      amountInCents,
    );
    if (amountError != null) throw InvalidSavingsGoalException(amountError);
    final goal = await (_database.select(
      _database.savingsGoals,
    )..where((row) => row.id.equals(goalId))).getSingleOrNull();
    if (goal == null) {
      throw const InvalidSavingsGoalException('Meta no encontrada.');
    }
    if (goal.completedAt != null) {
      throw const InvalidSavingsGoalException(
        'Reabre la meta para registrar otro aporte.',
      );
    }

    final category =
        await (_database.select(_database.categories)..where(
              (row) =>
                  row.normalizedName.equals('ahorro') &
                  row.type.equals('expense') &
                  row.isActive.equals(true),
            ))
            .getSingleOrNull();
    if (category == null) {
      throw const InvalidSavingsGoalException(
        'Activa la categoría de gasto “Ahorro” para registrar aportes.',
      );
    }
    final paymentMethod =
        await (_database.select(_database.paymentMethods)..where(
              (row) => row.isActive.equals(true) & row.isDefault.equals(true),
            ))
            .getSingleOrNull();
    if (paymentMethod == null) {
      throw const InvalidSavingsGoalException(
        'Configura un método de pago predeterminado para registrar aportes.',
      );
    }

    final now = DateTime.now();
    final cleanNote = note?.trim() ?? '';
    final description =
        'Aporte · ${goal.name}${cleanNote.isEmpty ? '' : ' · $cleanNote'}';
    return _database
        .into(_database.transactions)
        .insert(
          TransactionsCompanion.insert(
            amountInCents: amountInCents,
            type: TransactionType.expense.name,
            categoryId: category.id,
            paymentMethodId: paymentMethod.id,
            description: Value(description),
            dateEpochDay: dateToEpochDay(now),
            createdAt: Value(now),
            updatedAt: Value(now),
            savingsGoalId: Value(goalId),
          ),
        );
  });

  void _validate(String name, int targetAmountInCents) {
    final nameError = SavingsGoalValidator.validateName(name);
    if (nameError != null) throw InvalidSavingsGoalException(nameError);
    final targetError = SavingsGoalValidator.validateTarget(
      targetAmountInCents,
    );
    if (targetError != null) throw InvalidSavingsGoalException(targetError);
  }

  SavingsGoalProgress _progress(SavingsGoalRow row, int saved) =>
      SavingsGoalProgress(
        goal: SavingsGoal(
          id: row.id,
          name: row.name,
          targetAmountInCents: row.targetAmountInCents,
          createdAt: row.createdAt,
          completedAt: row.completedAt,
        ),
        savedInCents: saved,
      );
}
