import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/receipts/domain/receipt_draft.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  group('ReceiptParser.parse', () {
    test(
      'extracts merchant, Dominican date, priced items and explicit total',
      () {
        const text = '''
SUPERMERCADO LA ESQUINA
RNC: 123456789
Fecha: 14/03/2026
Leche 1.5L 85.50
Pan integral 65.00
Subtotal 150.50
ITBIS 0.00
TOTAL RD\$ 150.50
''';

        final draft = ReceiptParser.parse(text);

        expect(draft.merchant, 'SUPERMERCADO LA ESQUINA');
        expect(draft.date, DateTime(2026, 3, 14));
        expect(draft.totalInCents, 15050);
        expect(draft.items.map((item) => item.name), [
          'Leche 1.5L',
          'Pan integral',
        ]);
        expect(draft.items.map((item) => item.amountInCents), [8550, 6500]);
        expect(draft.rawText, text);
      },
    );

    test('parses ISO date and comma grouped total', () {
      final draft = ReceiptParser.parse('''
Tienda Central
2026-03-14
TOTAL: 1,234.56
''');

      expect(draft.date, DateTime(2026, 3, 14));
      expect(draft.totalInCents, 123456);
    });

    test('sums item values when the ticket has no explicit total', () {
      final draft = ReceiptParser.parse('''
Colmado
Arroz 100.00
Habichuelas 75.25
''');

      expect(draft.totalInCents, 17525);
      expect(draft.itemSummary, 'Arroz, Habichuelas');
    });

    test(
      'rejects impossible dates and leaves total unknown without prices',
      () {
        final draft = ReceiptParser.parse('''
Mercado
31/02/2026
Manzanas
''');

        expect(draft.date, isNull);
        expect(draft.totalInCents, isNull);
        expect(draft.items, isEmpty);
      },
    );
  });

  group('ReceiptParser.potentialDuplicates', () {
    final date = DateTime(2026, 3, 14);
    FinanceTransaction transaction({
      int amount = 15050,
      TransactionType type = TransactionType.expense,
      DateTime? onDate,
      String? description = 'SUPERMERCADO LA ESQUINA · Artículos: Pan',
    }) => FinanceTransaction(
      amountInCents: amount,
      type: type,
      categoryId: 1,
      paymentMethodId: 1,
      description: description,
      date: onDate ?? date,
      createdAt: date,
      updatedAt: date,
    );

    test('matches same expense, amount, date and normalized merchant', () {
      final match = transaction();
      final result = ReceiptParser.potentialDuplicates(
        amountInCents: 15050,
        date: date,
        merchant: 'Supermercado La Esquina',
        transactions: [
          match,
          transaction(type: TransactionType.income),
          transaction(onDate: DateTime(2026, 3, 13)),
          transaction(amount: 15051),
          transaction(description: 'Farmacia'),
        ],
      );

      expect(result, [match]);
    });

    test('uses same amount and date when merchant could not be read', () {
      final match = transaction(description: 'Gasto');
      final result = ReceiptParser.potentialDuplicates(
        amountInCents: 15050,
        date: date,
        merchant: '',
        transactions: [match],
      );

      expect(result, [match]);
    });
  });
}
