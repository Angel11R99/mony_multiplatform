import 'transaction.dart';

enum TransactionSortOrder { newest, oldest, amountHighToLow, amountLowToHigh }

class TransactionHistoryFilter {
  const TransactionHistoryFilter({
    this.query = '',
    this.type,
    this.categoryId,
    this.startDate,
    this.endDate,
    this.sortOrder = TransactionSortOrder.newest,
  });

  final String query;
  final TransactionType? type;
  final int? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionSortOrder sortOrder;

  bool get hasCriteria =>
      query.trim().isNotEmpty ||
      type != null ||
      categoryId != null ||
      startDate != null ||
      endDate != null;

  List<FinanceTransaction> apply(
    Iterable<FinanceTransaction> transactions, {
    Map<int, String> categoryNames = const {},
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final startDay = startDate == null ? null : dateToEpochDay(startDate!);
    final endDay = endDate == null ? null : dateToEpochDay(endDate!);
    final result = transactions.where((transaction) {
      if (type != null && transaction.type != type) return false;
      if (categoryId != null && transaction.categoryId != categoryId) {
        return false;
      }
      final day = dateToEpochDay(transaction.date);
      if (startDay != null && day < startDay) return false;
      if (endDay != null && day > endDay) return false;
      if (normalizedQuery.isNotEmpty) {
        final note = transaction.description?.toLowerCase() ?? '';
        final category =
            categoryNames[transaction.categoryId]?.toLowerCase() ?? '';
        if (!note.contains(normalizedQuery) &&
            !category.contains(normalizedQuery)) {
          return false;
        }
      }
      return true;
    }).toList();

    result.sort((a, b) {
      final byDate = dateToEpochDay(a.date).compareTo(dateToEpochDay(b.date));
      final byCreated = a.createdAt.compareTo(b.createdAt);
      final byId = a.id.compareTo(b.id);
      final byNewest = byDate != 0
          ? -byDate
          : byCreated != 0
          ? -byCreated
          : -byId;
      return switch (sortOrder) {
        TransactionSortOrder.newest => byNewest,
        TransactionSortOrder.oldest => byDate != 0
            ? byDate
            : byCreated != 0
            ? byCreated
            : byId,
        TransactionSortOrder.amountHighToLow =>
          a.amountInCents != b.amountInCents
              ? b.amountInCents.compareTo(a.amountInCents)
              : byNewest,
        TransactionSortOrder.amountLowToHigh =>
          a.amountInCents != b.amountInCents
              ? a.amountInCents.compareTo(b.amountInCents)
              : byNewest,
      };
    });
    return result;
  }
}
