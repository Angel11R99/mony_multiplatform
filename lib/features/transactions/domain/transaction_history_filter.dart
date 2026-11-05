import 'transaction.dart';

enum TransactionSortOrder {
  newest,
  oldest,
  amountHighToLow,
  amountLowToHigh,
  categoryAscending,
  categoryDescending,
}

class TransactionHistorySummary {
  const TransactionHistorySummary({
    required this.totalCount,
    required this.incomeInCents,
    required this.expenseInCents,
  });

  final int totalCount;
  final int incomeInCents;
  final int expenseInCents;
}

class TransactionPeriodSummary {
  const TransactionPeriodSummary({
    this.incomeInCents = 0,
    this.expenseInCents = 0,
    this.expenseByCategory = const {},
  });

  final int incomeInCents;
  final int expenseInCents;
  final Map<int, int> expenseByCategory;
}

class TransactionHistoryFilter {
  const TransactionHistoryFilter({
    this.query = '',
    this.type,
    this.categoryId,
    this.categoryIds = const {},
    this.paymentMethodIds = const {},
    this.minimumAmountInCents,
    this.maximumAmountInCents,
    this.startDate,
    this.endDate,
    this.sortOrder = TransactionSortOrder.newest,
  });

  final String query;
  final TransactionType? type;
  final int? categoryId;
  final Set<int> categoryIds;
  final Set<int> paymentMethodIds;
  final int? minimumAmountInCents;
  final int? maximumAmountInCents;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionSortOrder sortOrder;

  bool get hasCriteria =>
      query.trim().isNotEmpty ||
      type != null ||
      categoryId != null ||
      categoryIds.isNotEmpty ||
      paymentMethodIds.isNotEmpty ||
      minimumAmountInCents != null ||
      maximumAmountInCents != null ||
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
      if (categoryIds.isNotEmpty &&
          !categoryIds.contains(transaction.categoryId)) {
        return false;
      }
      if (paymentMethodIds.isNotEmpty &&
          !paymentMethodIds.contains(transaction.paymentMethodId)) {
        return false;
      }
      if (minimumAmountInCents != null &&
          transaction.amountInCents < minimumAmountInCents!) {
        return false;
      }
      if (maximumAmountInCents != null &&
          transaction.amountInCents > maximumAmountInCents!) {
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
        TransactionSortOrder.oldest =>
          byDate != 0
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
        TransactionSortOrder.categoryAscending ||
        TransactionSortOrder.categoryDescending => _compareCategoryNames(
          categoryNames[a.categoryId] ?? '',
          categoryNames[b.categoryId] ?? '',
          sortOrder == TransactionSortOrder.categoryAscending,
          byNewest,
        ),
      };
    });
    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is TransactionHistoryFilter &&
      other.query == query &&
      other.type == type &&
      other.categoryId == categoryId &&
      _sameSet(other.categoryIds, categoryIds) &&
      _sameSet(other.paymentMethodIds, paymentMethodIds) &&
      other.minimumAmountInCents == minimumAmountInCents &&
      other.maximumAmountInCents == maximumAmountInCents &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(
    query,
    type,
    categoryId,
    Object.hashAllUnordered(categoryIds),
    Object.hashAllUnordered(paymentMethodIds),
    minimumAmountInCents,
    maximumAmountInCents,
    startDate,
    endDate,
    sortOrder,
  );

  static bool _sameSet(Set<int> first, Set<int> second) =>
      first.length == second.length && first.containsAll(second);

  static int _compareCategoryNames(
    String first,
    String second,
    bool ascending,
    int tieBreak,
  ) {
    final comparison = first.toLowerCase().compareTo(second.toLowerCase());
    if (comparison == 0) return tieBreak;
    return ascending ? comparison : -comparison;
  }
}
