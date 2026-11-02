import '../../transactions/domain/transaction.dart';

enum RecurrenceFrequency { daily, weekly, monthly, yearly }

class RecurringEntry {
  const RecurringEntry({
    this.id = 0,
    required this.title,
    required this.amountInCents,
    required this.type,
    required this.categoryId,
    required this.paymentMethodId,
    required this.frequency,
    this.interval = 1,
    required this.startDate,
    required this.nextDate,
    this.endDate,
    this.isActive = true,
  });

  final int id;
  final String title;
  final int amountInCents;
  final TransactionType type;
  final int categoryId;
  final int paymentMethodId;
  final RecurrenceFrequency frequency;
  final int interval;
  final DateTime startDate;
  final DateTime nextDate;
  final DateTime? endDate;
  final bool isActive;

  RecurringEntry copyWith({
    String? title,
    int? amountInCents,
    TransactionType? type,
    int? categoryId,
    int? paymentMethodId,
    RecurrenceFrequency? frequency,
    int? interval,
    DateTime? startDate,
    DateTime? nextDate,
    DateTime? endDate,
    bool? isActive,
  }) => RecurringEntry(
    id: id,
    title: title ?? this.title,
    amountInCents: amountInCents ?? this.amountInCents,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    startDate: startDate ?? this.startDate,
    nextDate: nextDate ?? this.nextDate,
    endDate: endDate ?? this.endDate,
    isActive: isActive ?? this.isActive,
  );
}

/// Calendar based recurrence preserving the anchor day through short months.
DateTime nextOccurrence(RecurringEntry entry, DateTime current) {
  final day = DateTime(current.year, current.month, current.day);
  switch (entry.frequency) {
    case RecurrenceFrequency.daily:
      return day.add(Duration(days: entry.interval));
    case RecurrenceFrequency.weekly:
      return day.add(Duration(days: 7 * entry.interval));
    case RecurrenceFrequency.monthly:
      final target = day.month - 1 + entry.interval;
      final year = day.year + target ~/ 12;
      final month = target % 12 + 1;
      final last = DateTime(year, month + 1, 0).day;
      return DateTime(year, month, entry.startDate.day.clamp(1, last));
    case RecurrenceFrequency.yearly:
      final year = day.year + entry.interval;
      final month = entry.startDate.month;
      final last = DateTime(year, month + 1, 0).day;
      return DateTime(year, month, entry.startDate.day.clamp(1, last));
  }
}
