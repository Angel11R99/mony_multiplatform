enum ObligationDirection { payable, receivable }

enum ObligationStatus { pending, partiallyPaid, overdue, settled, cancelled }

class Obligation {
  const Obligation({
    this.id = 0,
    required this.direction,
    required this.title,
    this.counterparty,
    required this.amountInCents,
    this.dueDate,
    required this.categoryId,
    this.defaultPaymentMethodId,
    this.sourceShoppingListId,
    this.isCancelled = false,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.paidAmountInCents = 0,
  });

  final int id;
  final ObligationDirection direction;
  final String title;
  final String? counterparty;
  final int amountInCents;
  final DateTime? dueDate;
  final int categoryId;
  final int? defaultPaymentMethodId;
  final int? sourceShoppingListId;
  final bool isCancelled;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int paidAmountInCents;

  int get remainingAmountInCents => amountInCents - paidAmountInCents;

  ObligationStatus statusAt(DateTime date) {
    if (isCancelled) return ObligationStatus.cancelled;
    if (remainingAmountInCents <= 0) return ObligationStatus.settled;
    final due = dueDate;
    if (due != null && _day(due).isBefore(_day(date))) {
      return ObligationStatus.overdue;
    }
    if (paidAmountInCents > 0) return ObligationStatus.partiallyPaid;
    return ObligationStatus.pending;
  }

  Obligation copyWith({
    String? title,
    String? counterparty,
    bool clearCounterparty = false,
    int? amountInCents,
    DateTime? dueDate,
    bool clearDueDate = false,
    int? categoryId,
    int? defaultPaymentMethodId,
    bool clearDefaultPaymentMethod = false,
    bool? isCancelled,
    String? notes,
    bool clearNotes = false,
    DateTime? updatedAt,
  }) => Obligation(
    id: id,
    direction: direction,
    title: title ?? this.title,
    counterparty: clearCounterparty ? null : counterparty ?? this.counterparty,
    amountInCents: amountInCents ?? this.amountInCents,
    dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
    categoryId: categoryId ?? this.categoryId,
    defaultPaymentMethodId: clearDefaultPaymentMethod
        ? null
        : defaultPaymentMethodId ?? this.defaultPaymentMethodId,
    sourceShoppingListId: sourceShoppingListId,
    isCancelled: isCancelled ?? this.isCancelled,
    notes: clearNotes ? null : notes ?? this.notes,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    paidAmountInCents: paidAmountInCents,
  );
}

class ObligationPayment {
  const ObligationPayment({
    this.id = 0,
    required this.obligationId,
    required this.amountInCents,
    required this.date,
    required this.paymentMethodId,
    this.transactionId,
    this.note,
    required this.createdAt,
  });

  final int id;
  final int obligationId;
  final int amountInCents;
  final DateTime date;
  final int paymentMethodId;
  final int? transactionId;
  final String? note;
  final DateTime createdAt;
}

class ObligationDetails {
  const ObligationDetails({required this.obligation, required this.payments});

  final Obligation obligation;
  final List<ObligationPayment> payments;
}

/// Compact pending-obligation data for summaries that do not need the full
/// obligation list.
class ObligationOverview {
  const ObligationOverview({
    required this.pending,
    required this.payableRemainingInCents,
    required this.receivableRemainingInCents,
  });

  final List<Obligation> pending;
  final int payableRemainingInCents;
  final int receivableRemainingInCents;
}

DateTime _day(DateTime date) => DateTime(date.year, date.month, date.day);
