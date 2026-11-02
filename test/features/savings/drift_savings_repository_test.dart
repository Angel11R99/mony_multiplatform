import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/savings/data/drift_savings_repository.dart';
import 'package:mony_multiplatform/features/savings/domain/savings_repository.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_repository.dart';

void main() {
  late AppDatabase database;
  late DriftSavingsRepository savings;
  late DriftTransactionRepository transactions;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    savings = DriftSavingsRepository(database);
    transactions = DriftTransactionRepository(database);
  });
  tearDown(() => database.close());

  test(
    'creates and updates a goal with progress derived from its transactions',
    () async {
      final id = await savings.create(
        name: '  Fondo  ',
        targetAmountInCents: 10000,
      );
      expect((await savings.get(id))!.goal.name, 'Fondo');
      await savings.addContribution(
        goalId: id,
        amountInCents: 2500,
        note: '  Inicial  ',
      );

      var goal = (await savings.get(id))!;
      expect(goal.savedInCents, 2500);
      expect(goal.percent, 25);
      expect(goal.remainingInCents, 7500);

      await savings.update(
        id: id,
        name: 'Emergencia',
        targetAmountInCents: 5000,
      );
      goal = (await savings.get(id))!;
      expect(goal.goal.name, 'Emergencia');
      expect(goal.percent, 50);
      final goals = await savings.watchAll().first;
      expect(goals, hasLength(1));
      expect(goals.single.goal.id, goal.goal.id);
    },
  );

  test(
    'stores a contribution as one linked expense in the savings category',
    () async {
      final goalId = await savings.create(
        name: 'Viaje',
        targetAmountInCents: 30000,
      );
      final transactionId = await savings.addContribution(
        goalId: goalId,
        amountInCents: 12550,
        note: '  Primer abono  ',
      );
      final savedTransaction = await transactions.get(transactionId);
      final progress = (await savings.get(goalId))!;
      final history = await savings.watchContributions(goalId).first;

      expect(savedTransaction, isNotNull);
      expect(savedTransaction!.type, TransactionType.expense);
      expect(savedTransaction.categoryId, 19);
      expect(savedTransaction.paymentMethodId, 1);
      expect(savedTransaction.savingsGoalId, goalId);
      expect(savedTransaction.amountInCents, 12550);
      expect(savedTransaction.description, 'Aporte · Viaje · Primer abono');
      expect(progress.savedInCents, 12550);
      expect(history.single.amountInCents, 12550);
      expect(await transactions.watchAll().first, hasLength(1));
    },
  );

  test(
    'contribution history and progress follow edits and deletions once',
    () async {
      final goalId = await savings.create(
        name: 'Cámara',
        targetAmountInCents: 10000,
      );
      final transactionId = await savings.addContribution(
        goalId: goalId,
        amountInCents: 7000,
      );
      final contribution = (await transactions.get(transactionId))!;

      await expectLater(
        transactions.update(
          contribution.copyWith(type: TransactionType.income),
        ),
        throwsA(isA<InvalidTransactionException>()),
      );
      await transactions.update(contribution.copyWith(amountInCents: 8000));
      expect((await savings.get(goalId))!.savedInCents, 8000);

      await transactions.delete(transactionId);
      expect((await savings.get(goalId))!.savedInCents, 0);
      expect(await savings.watchContributions(goalId).first, isEmpty);
    },
  );

  test(
    'completes and reopens a goal, and rejects contributions while complete',
    () async {
      final goalId = await savings.create(
        name: 'Audífonos',
        targetAmountInCents: 5000,
      );
      await savings.addContribution(goalId: goalId, amountInCents: 5000);
      await savings.complete(goalId);
      expect((await savings.get(goalId))!.isActive, isFalse);
      expect((await savings.get(goalId))!.isCompleted, isTrue);
      await expectLater(
        savings.addContribution(goalId: goalId, amountInCents: 1),
        throwsA(isA<InvalidSavingsGoalException>()),
      );
      await savings.reopen(goalId);
      expect((await savings.get(goalId))!.isActive, isTrue);
      await savings.addContribution(goalId: goalId, amountInCents: 100);
      expect((await savings.get(goalId))!.savedInCents, 5100);
    },
  );

  test(
    'deleting a goal unlinks contributions but preserves their expense history',
    () async {
      final goalId = await savings.create(
        name: 'Bicicleta',
        targetAmountInCents: 25000,
      );
      final transactionId = await savings.addContribution(
        goalId: goalId,
        amountInCents: 4000,
      );
      await savings.delete(goalId);

      expect(await savings.get(goalId), isNull);
      expect(await savings.watchAll().first, isEmpty);
      final preservedTransaction = await transactions.get(transactionId);
      expect(preservedTransaction, isNotNull);
      expect(preservedTransaction!.amountInCents, 4000);
      expect(preservedTransaction.type, TransactionType.expense);
      expect(preservedTransaction.savingsGoalId, isNull);
      expect(await transactions.watchAll().first, hasLength(1));
    },
  );

  test(
    'rejects invalid names, targets, contributions and missing savings category',
    () async {
      await expectLater(
        savings.create(name: ' ', targetAmountInCents: 1),
        throwsA(isA<InvalidSavingsGoalException>()),
      );
      await expectLater(
        savings.create(name: 'Fondo', targetAmountInCents: 0),
        throwsA(isA<InvalidSavingsGoalException>()),
      );
      final goalId = await savings.create(
        name: 'Fondo',
        targetAmountInCents: 1000,
      );
      await expectLater(
        savings.addContribution(goalId: goalId, amountInCents: 0),
        throwsA(isA<InvalidSavingsGoalException>()),
      );
      await (database.update(database.categories)
            ..where((row) => row.normalizedName.equals('ahorro')))
          .write(const CategoriesCompanion(isActive: Value(false)));
      await expectLater(
        savings.addContribution(goalId: goalId, amountInCents: 100),
        throwsA(isA<InvalidSavingsGoalException>()),
      );
    },
  );
}
