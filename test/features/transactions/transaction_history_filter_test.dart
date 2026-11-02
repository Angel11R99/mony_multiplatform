import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_history_filter.dart';

void main() {
  final transactions = [
    _transaction(
      1,
      TransactionType.expense,
      4,
      DateTime(2025, 1, 4),
      'Mercado',
      8000,
    ),
    _transaction(
      2,
      TransactionType.income,
      8,
      DateTime(2025, 1, 5),
      'Salario',
      50000,
    ),
    _transaction(
      3,
      TransactionType.expense,
      4,
      DateTime(2025, 1, 10),
      'Farmacia',
      1250,
    ),
    _transaction(
      4,
      TransactionType.expense,
      7,
      DateTime(2025, 1, 10),
      'Pasaje',
      300,
    ),
  ];
  final categories = {4: 'Alimentación', 7: 'Transporte', 8: 'Trabajo'};

  test(
    'combines case-insensitive search, type, category and inclusive dates',
    () {
      final results = TransactionHistoryFilter(
        query: 'ALIMEN',
        type: TransactionType.expense,
        categoryId: 4,
        startDate: DateTime(2025, 1, 5),
        endDate: DateTime(2025, 1, 10),
      ).apply(transactions, categoryNames: categories);

      expect(results.map((item) => item.id), [3]);
    },
  );

  test('search matches notes as well as category names', () {
    expect(
      const TransactionHistoryFilter(
        query: 'salario',
      ).apply(transactions, categoryNames: categories).map((item) => item.id),
      [2],
    );
    expect(
      const TransactionHistoryFilter(
        query: 'farmacia',
      ).apply(transactions, categoryNames: categories).map((item) => item.id),
      [3],
    );
  });

  test('sorts by date or amount and resolves ties consistently', () {
    expect(
      const TransactionHistoryFilter()
          .apply(transactions, categoryNames: categories)
          .map((item) => item.id),
      [4, 3, 2, 1],
    );
    expect(
      const TransactionHistoryFilter(
        sortOrder: TransactionSortOrder.amountLowToHigh,
      ).apply(transactions).map((item) => item.id),
      [4, 3, 1, 2],
    );
  });
}

FinanceTransaction _transaction(
  int id,
  TransactionType type,
  int categoryId,
  DateTime date,
  String description,
  int amount,
) => FinanceTransaction(
  id: id,
  amountInCents: amount,
  type: type,
  categoryId: categoryId,
  paymentMethodId: 1,
  description: description,
  date: date,
  createdAt: DateTime(2025, 1, 1).add(Duration(minutes: id)),
  updatedAt: DateTime(2025, 1, 1).add(Duration(minutes: id)),
);
