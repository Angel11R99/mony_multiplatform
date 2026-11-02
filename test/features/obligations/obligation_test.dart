import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation_validator.dart';

void main() {
  final today = DateTime(2026, 11, 2);

  Obligation obligation({
    DateTime? dueDate,
    int paid = 0,
    bool cancelled = false,
  }) => Obligation(
    direction: ObligationDirection.payable,
    title: 'Servicio',
    amountInCents: 10000,
    dueDate: dueDate,
    categoryId: 6,
    isCancelled: cancelled,
    createdAt: today,
    updatedAt: today,
    paidAmountInCents: paid,
  );

  test(
    'derives pending, partially paid, overdue, settled and cancelled states',
    () {
      expect(obligation().statusAt(today), ObligationStatus.pending);
      expect(
        obligation(paid: 2000).statusAt(today),
        ObligationStatus.partiallyPaid,
      );
      expect(
        obligation(
          dueDate: today.subtract(const Duration(days: 1)),
        ).statusAt(today),
        ObligationStatus.overdue,
      );
      expect(obligation(paid: 10000).statusAt(today), ObligationStatus.settled);
      expect(
        obligation(cancelled: true).statusAt(today),
        ObligationStatus.cancelled,
      );
      expect(
        obligation(dueDate: today).statusAt(today),
        ObligationStatus.pending,
      );
    },
  );

  test(
    'validates positive safe amounts and prevents paying above the balance',
    () {
      expect(ObligationValidator.validateTitle(' '), isNotNull);
      expect(ObligationValidator.validateAmount(0), isNotNull);
      expect(ObligationValidator.validateAmount(9007199254740992), isNotNull);
      expect(
        ObligationValidator.validatePayment(
          amountInCents: 100,
          remainingInCents: 99,
        ),
        isNotNull,
      );
      expect(
        ObligationValidator.validatePayment(
          amountInCents: 99,
          remainingInCents: 99,
        ),
        isNull,
      );
    },
  );
}
