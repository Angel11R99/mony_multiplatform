enum TransactionType { income, expense }

class FinanceTransaction {
  const FinanceTransaction({
    this.id = 0,
    required this.amountInCents,
    required this.type,
    required this.categoryId,
    required this.paymentMethodId,
    required this.description,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.fixedEntryId,
    this.savingsGoalId,
  });

  final int id;
  final int amountInCents;
  final TransactionType type;
  final int categoryId;
  final int paymentMethodId;
  final String? description;

  /// A calendar day. Its time component is ignored.
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? fixedEntryId;
  final int? savingsGoalId;

  FinanceTransaction copyWith({
    int? id,
    int? amountInCents,
    TransactionType? type,
    int? categoryId,
    int? paymentMethodId,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? fixedEntryId,
    int? savingsGoalId,
  }) => FinanceTransaction(
    id: id ?? this.id,
    amountInCents: amountInCents ?? this.amountInCents,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    description: description ?? this.description,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fixedEntryId: fixedEntryId ?? this.fixedEntryId,
    savingsGoalId: savingsGoalId ?? this.savingsGoalId,
  );
}

/// Encodes civil year/month/day fields without applying a timezone offset.
int dateToEpochDay(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
    Duration.millisecondsPerDay;

/// Decodes an epoch day to a local civil date at midnight.
DateTime dateFromEpochDay(int epochDay) {
  final utcDate = DateTime.fromMillisecondsSinceEpoch(
    epochDay * Duration.millisecondsPerDay,
    isUtc: true,
  );
  return DateTime(utcDate.year, utcDate.month, utcDate.day);
}
