import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/obligations/data/drift_obligation_repository.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation_repository.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_repository.dart';

void main() {
  late AppDatabase database;
  late DriftObligationRepository repository;
  final today = DateTime(2026, 11, 2);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftObligationRepository(database);
  });
  tearDown(() => database.close());

  Future<int> createPayable({int amount = 10000}) => repository.create(
    Obligation(
      direction: ObligationDirection.payable,
      title: 'Factura de luz',
      counterparty: 'Edesur',
      amountInCents: amount,
      dueDate: today.add(const Duration(days: 5)),
      categoryId: 8,
      defaultPaymentMethodId: 1,
      createdAt: today,
      updatedAt: today,
    ),
  );

  test(
    'partial payments update balance and full settlement creates one movement per payment',
    () async {
      final id = await createPayable();
      final firstPayment = await repository.recordPayment(
        obligationId: id,
        amountInCents: 3500,
        date: today,
        paymentMethodId: 1,
        note: 'Primer abono',
      );
      var details = (await repository.getDetails(id))!;
      expect(details.obligation.paidAmountInCents, 3500);
      expect(details.obligation.remainingAmountInCents, 6500);
      expect(
        details.obligation.statusAt(today),
        ObligationStatus.partiallyPaid,
      );
      expect(details.payments.single.id, firstPayment);
      expect(await database.select(database.transactions).get(), hasLength(1));
      expect(
        (await repository.watchAll().first).single.remainingAmountInCents,
        6500,
      );

      final secondPayment = await repository.recordPayment(
        obligationId: id,
        amountInCents: 6500,
        date: today.add(const Duration(days: 1)),
        paymentMethodId: 2,
      );
      details = (await repository.getDetails(id))!;
      expect(details.obligation.remainingAmountInCents, 0);
      expect(details.obligation.statusAt(today), ObligationStatus.settled);
      expect(details.payments, hasLength(2));
      expect(await database.select(database.transactions).get(), hasLength(2));

      await expectLater(
        repository.recordPayment(
          obligationId: id,
          amountInCents: 1,
          date: today,
          paymentMethodId: 1,
        ),
        throwsA(isA<ObligationException>()),
      );

      final transactions = DriftTransactionRepository(database);
      final linkedTransaction = details.payments
          .firstWhere((payment) => payment.id == secondPayment)
          .transactionId!;
      await expectLater(
        transactions.delete(linkedTransaction),
        throwsA(isA<InvalidTransactionException>()),
      );
      final linkedMovement = (await transactions.get(linkedTransaction))!;
      await expectLater(
        transactions.update(linkedMovement.copyWith(amountInCents: 6000)),
        throwsA(isA<InvalidTransactionException>()),
      );

      await repository.deletePayment(secondPayment);
      details = (await repository.getDetails(id))!;
      expect(details.obligation.remainingAmountInCents, 6500);
      expect(
        details.obligation.statusAt(today),
        ObligationStatus.partiallyPaid,
      );
      expect(await database.select(database.transactions).get(), hasLength(1));

      await repository.deletePayment(firstPayment);
      details = (await repository.getDetails(id))!;
      expect(details.obligation.paidAmountInCents, 0);
      expect(details.obligation.statusAt(today), ObligationStatus.pending);
      expect(await database.select(database.transactions).get(), isEmpty);
    },
  );

  test(
    'receivable installments record income and cancellation cannot post payments',
    () async {
      final id = await repository.create(
        Obligation(
          direction: ObligationDirection.receivable,
          title: 'Préstamo a Ana',
          counterparty: 'Ana',
          amountInCents: 8000,
          categoryId: 1,
          createdAt: today,
          updatedAt: today,
        ),
      );
      final paymentId = await repository.recordPayment(
        obligationId: id,
        amountInCents: 3000,
        date: today,
        paymentMethodId: 1,
      );
      final payment = await (database.select(
        database.obligationPayments,
      )..where((row) => row.id.equals(paymentId))).getSingle();
      final transaction = await (database.select(
        database.transactions,
      )..where((row) => row.id.equals(payment.transactionId!))).getSingle();
      expect(transaction.type, 'income');
      expect(transaction.amountInCents, 3000);

      final unpaidId = await createPayable(amount: 7000);
      await repository.cancel(unpaidId);
      expect(
        (await repository.getDetails(unpaidId))!.obligation.statusAt(today),
        ObligationStatus.cancelled,
      );
      await expectLater(
        repository.recordPayment(
          obligationId: unpaidId,
          amountInCents: 100,
          date: today,
          paymentMethodId: 1,
        ),
        throwsA(isA<ObligationException>()),
      );
    },
  );

  test(
    'rejects overpayment, invalid category, and cancelling with installments',
    () async {
      final id = await createPayable(amount: 5000);
      await expectLater(
        repository.recordPayment(
          obligationId: id,
          amountInCents: 5001,
          date: today,
          paymentMethodId: 1,
        ),
        throwsA(isA<ObligationException>()),
      );
      await expectLater(
        repository.create(
          Obligation(
            direction: ObligationDirection.payable,
            title: 'Categoría incompatible',
            amountInCents: 500,
            categoryId: 1,
            createdAt: today,
            updatedAt: today,
          ),
        ),
        throwsA(isA<ObligationException>()),
      );
      await repository.recordPayment(
        obligationId: id,
        amountInCents: 1000,
        date: today,
        paymentMethodId: 1,
      );
      await expectLater(
        repository.cancel(id),
        throwsA(isA<ObligationException>()),
      );
    },
  );
}
