import 'obligation.dart';

abstract interface class ObligationRepository {
  Stream<List<Obligation>> watchAll();
  Stream<List<Obligation>> watchReminderCandidates();
  Stream<List<Obligation>> watchList({
    required ObligationListFilter filter,
    DateTime? dueFrom,
    DateTime? dueThrough,
    required int limit,
  });
  Stream<ObligationOverview> watchOverview();
  Future<List<Obligation>> getReminderCandidates();
  Stream<ObligationDetails?> watchDetails(int obligationId);
  Future<ObligationDetails?> getDetails(int obligationId);
  Future<int> create(Obligation obligation);
  Future<void> update(Obligation obligation);
  Future<void> cancel(int obligationId);
  Future<int> recordPayment({
    required int obligationId,
    required int amountInCents,
    required DateTime date,
    required int paymentMethodId,
    String? note,
  });
  Future<void> deletePayment(int paymentId);
}

enum ObligationListFilter { active, payable, receivable, history }

class ObligationException implements Exception {
  const ObligationException(this.message);
  final String message;

  @override
  String toString() => message;
}
