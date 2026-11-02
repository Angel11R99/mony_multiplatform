import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/money/money_formatter.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_validator.dart';

void main() {
  group('DOP minor units', () {
    test('parses decimal values into exact integer centavos', () {
      expect(MoneyFormatter.parseDopMinorUnits('1,234.5'), isNull);
      expect(MoneyFormatter.parseDopMinorUnits('1234,5'), 123450);
      expect(MoneyFormatter.parseDopMinorUnits('0.01'), 1);
      expect(MoneyFormatter.parseDopMinorUnits('1234.50'), 123450);
      expect(MoneyFormatter.parseDopMinorUnits(' 15 '), 1500);
      expect(MoneyFormatter.parseDopMinorUnits('1.234'), isNull);
      expect(MoneyFormatter.parseDopMinorUnits('abc'), isNull);
      expect(MoneyFormatter.toDopInput(123450), '1234.50');
    });
  });

  test('requires positive amount and both references', () {
    expect(TransactionValidator.validateAmount(null), isNotNull);
    expect(TransactionValidator.validateAmount(0), isNotNull);
    expect(TransactionValidator.validateAmount(-1), isNotNull);
    expect(TransactionValidator.validateAmount(1), isNull);
    expect(
      TransactionValidator.validateSelection(
        categoryId: null,
        paymentMethodId: 1,
      ),
      isNotNull,
    );
    expect(
      TransactionValidator.validateSelection(
        categoryId: 1,
        paymentMethodId: null,
      ),
      isNotNull,
    );
    expect(
      TransactionValidator.validateSelection(categoryId: 1, paymentMethodId: 1),
      isNull,
    );
  });

  test(
    'normalizes blank notes and preserves calendar date across timezone',
    () {
      final transaction = FinanceTransaction(
        amountInCents: 123,
        type: TransactionType.expense,
        categoryId: 1,
        paymentMethodId: 1,
        description: '   ',
        date: DateTime(2025, 3, 9),
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      );
      expect(TransactionValidator.normalize(transaction).description, isNull);
      expect(
        dateFromEpochDay(dateToEpochDay(transaction.date)),
        DateTime(2025, 3, 9),
      );
    },
  );
}
