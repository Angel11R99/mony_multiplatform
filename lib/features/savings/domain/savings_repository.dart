import 'savings_goal.dart';

abstract interface class SavingsRepository {
  Stream<List<SavingsGoalProgress>> watchAll();
  Stream<List<SavingsContribution>> watchContributions(int goalId);
  Future<SavingsGoalProgress?> get(int id);
  Future<int> create({required String name, required int targetAmountInCents});
  Future<void> update({
    required int id,
    required String name,
    required int targetAmountInCents,
  });
  Future<void> complete(int id);
  Future<void> reopen(int id);
  Future<void> delete(int id);
  Future<int> addContribution({
    required int goalId,
    required int amountInCents,
    String? note,
  });
}

final class InvalidSavingsGoalException implements Exception {
  const InvalidSavingsGoalException(this.message);
  final String message;

  @override
  String toString() => message;
}
