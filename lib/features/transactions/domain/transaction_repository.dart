import 'transaction.dart';

abstract interface class TransactionRepository {
  Stream<List<FinanceTransaction>> watchAll();
  Future<FinanceTransaction?> get(int id);
  Future<int> create(FinanceTransaction transaction);
  Future<void> update(FinanceTransaction transaction);
  Future<int?> duplicate(int id);
  Future<void> delete(int id);
}

final class InvalidTransactionException implements Exception {
  const InvalidTransactionException(this.message);
  final String message;

  @override
  String toString() => message;
}
