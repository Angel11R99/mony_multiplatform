import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/recurring/domain/recurring_entry.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  RecurringEntry entry(DateTime start, RecurrenceFrequency frequency) =>
      RecurringEntry(
        title: 'Regla',
        amountInCents: 100,
        type: TransactionType.expense,
        categoryId: 1,
        paymentMethodId: 1,
        frequency: frequency,
        startDate: start,
        nextDate: start,
      );

  test('monthly rules preserve the anchor day across shorter months', () {
    final rule = entry(DateTime(2026, 1, 31), RecurrenceFrequency.monthly);
    final february = nextOccurrence(rule, DateTime(2026, 1, 31));
    expect(february, DateTime(2026, 2, 28));
    expect(nextOccurrence(rule, february), DateTime(2026, 3, 31));
  });

  test('yearly leap day returns to February 29 in the next leap year', () {
    final rule = entry(DateTime(2024, 2, 29), RecurrenceFrequency.yearly);
    final ordinary = nextOccurrence(rule, DateTime(2024, 2, 29));
    expect(ordinary, DateTime(2025, 2, 28));
    expect(nextOccurrence(rule, ordinary), DateTime(2026, 2, 28));
  });

  test('daily and weekly schedules advance by calendar days', () {
    expect(
      nextOccurrence(
        entry(DateTime(2026, 3, 7), RecurrenceFrequency.daily),
        DateTime(2026, 3, 7),
      ),
      DateTime(2026, 3, 8),
    );
    final weekly = entry(
      DateTime(2026, 3, 7),
      RecurrenceFrequency.weekly,
    ).copyWith(interval: 2);
    expect(nextOccurrence(weekly, DateTime(2026, 3, 7)), DateTime(2026, 3, 21));
  });
}
