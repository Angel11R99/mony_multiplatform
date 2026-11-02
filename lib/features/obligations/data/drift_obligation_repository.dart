import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../categories/domain/category.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/obligation.dart';
import '../domain/obligation_repository.dart';
import '../domain/obligation_validator.dart';

class DriftObligationRepository implements ObligationRepository {
  const DriftObligationRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Obligation>> watchAll() => _database
      .customSelect(
        '''SELECT obligations.*,
          COALESCE((SELECT SUM(amount_in_cents) FROM obligation_payments
            WHERE obligation_id = obligations.id), 0) AS paid_amount_in_cents
          FROM obligations
          ORDER BY is_cancelled ASC,
            CASE WHEN due_date_epoch_day IS NULL THEN 1 ELSE 0 END,
            due_date_epoch_day ASC, updated_at DESC''',
        readsFrom: {_database.obligations, _database.obligationPayments},
      )
      .watch()
      .map(
        (rows) =>
            rows.map((row) => _fromOverviewRow(row)).toList(growable: false),
      );

  @override
  Stream<ObligationDetails?> watchDetails(int obligationId) =>
      Stream<ObligationDetails?>.multi((controller) {
        ObligationRow? obligation;
        List<ObligationPaymentRow> payments = const [];
        var obligationReady = false;
        var paymentsReady = false;

        void emit() {
          if (!obligationReady || !paymentsReady) return;
          controller.add(
            obligation == null
                ? null
                : ObligationDetails(
                    obligation: _fromRow(obligation!, _paidTotal(payments)),
                    payments: payments.map(_fromPaymentRow).toList(),
                  ),
          );
        }

        final obligationSubscription =
            (_database.select(_database.obligations)
                  ..where((row) => row.id.equals(obligationId)))
                .watchSingleOrNull()
                .listen((value) {
                  obligation = value;
                  obligationReady = true;
                  emit();
                }, onError: controller.addError);
        final paymentsSubscription =
            (_database.select(_database.obligationPayments)
                  ..where((row) => row.obligationId.equals(obligationId))
                  ..orderBy([
                    (row) => OrderingTerm.desc(row.dateEpochDay),
                    (row) => OrderingTerm.desc(row.id),
                  ]))
                .watch()
                .listen((value) {
                  payments = value;
                  paymentsReady = true;
                  emit();
                }, onError: controller.addError);
        controller.onCancel = () async {
          await obligationSubscription.cancel();
          await paymentsSubscription.cancel();
        };
      });

  @override
  Future<ObligationDetails?> getDetails(int obligationId) async {
    final obligation = await (_database.select(
      _database.obligations,
    )..where((row) => row.id.equals(obligationId))).getSingleOrNull();
    if (obligation == null) return null;
    final payments =
        await (_database.select(_database.obligationPayments)
              ..where((row) => row.obligationId.equals(obligationId))
              ..orderBy([
                (row) => OrderingTerm.desc(row.dateEpochDay),
                (row) => OrderingTerm.desc(row.id),
              ]))
            .get();
    return ObligationDetails(
      obligation: _fromRow(obligation, _paidTotal(payments)),
      payments: payments.map(_fromPaymentRow).toList(growable: false),
    );
  }

  @override
  Future<int> create(Obligation obligation) async {
    _validateInput(obligation);
    await _validateCategory(obligation.direction, obligation.categoryId);
    await _validatePaymentMethod(obligation.defaultPaymentMethodId);
    final now = DateTime.now();
    return _database
        .into(_database.obligations)
        .insert(
          ObligationsCompanion.insert(
            direction: obligation.direction.name,
            title: obligation.title.trim(),
            counterparty: Value(_emptyToNull(obligation.counterparty)),
            amountInCents: obligation.amountInCents,
            dueDateEpochDay: Value(
              obligation.dueDate == null
                  ? null
                  : dateToEpochDay(obligation.dueDate!),
            ),
            categoryId: obligation.categoryId,
            defaultPaymentMethodId: Value(obligation.defaultPaymentMethodId),
            notes: Value(_emptyToNull(obligation.notes)),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> update(Obligation obligation) => _database.transaction(() async {
    _validateInput(obligation);
    final current = await _getRow(obligation.id);
    final details = await getDetails(obligation.id);
    if (details == null) {
      throw const ObligationException('La obligación ya no existe.');
    }
    if (current.isCancelled) {
      throw const ObligationException('Una obligación cancelada no se edita.');
    }
    if (current.sourceShoppingListId != null &&
        (obligation.direction.name != current.direction ||
            obligation.title.trim() != current.title ||
            obligation.amountInCents != current.amountInCents ||
            obligation.categoryId != current.categoryId)) {
      throw const ObligationException(
        'El importe y la descripción se administran desde la lista de compras.',
      );
    }
    if (obligation.amountInCents < details.obligation.paidAmountInCents) {
      throw const ObligationException(
        'El monto no puede quedar por debajo de los abonos registrados.',
      );
    }
    if (details.payments.isNotEmpty &&
        obligation.direction.name != current.direction) {
      throw const ObligationException(
        'No se puede cambiar el sentido después de registrar abonos.',
      );
    }
    await _validateCategory(obligation.direction, obligation.categoryId);
    await _validatePaymentMethod(
      obligation.defaultPaymentMethodId,
      allowInactiveId: current.defaultPaymentMethodId,
    );
    await (_database.update(
      _database.obligations,
    )..where((row) => row.id.equals(obligation.id))).write(
      ObligationsCompanion(
        title: Value(
          current.sourceShoppingListId == null
              ? obligation.title.trim()
              : current.title,
        ),
        counterparty: Value(_emptyToNull(obligation.counterparty)),
        amountInCents: Value(obligation.amountInCents),
        dueDateEpochDay: Value(
          obligation.dueDate == null
              ? null
              : dateToEpochDay(obligation.dueDate!),
        ),
        categoryId: Value(obligation.categoryId),
        defaultPaymentMethodId: Value(obligation.defaultPaymentMethodId),
        notes: Value(_emptyToNull(obligation.notes)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  });

  @override
  Future<void> cancel(int obligationId) => _database.transaction(() async {
    final row = await _getRow(obligationId);
    final details = await getDetails(obligationId);
    if (row.sourceShoppingListId != null) {
      throw const ObligationException(
        'Reabre la lista de compras para cancelar esta obligación.',
      );
    }
    if (details?.payments.isNotEmpty ?? false) {
      throw const ObligationException(
        'Elimina los abonos antes de cancelar la obligación.',
      );
    }
    if (row.isCancelled) return;
    await (_database.update(
      _database.obligations,
    )..where((item) => item.id.equals(obligationId))).write(
      ObligationsCompanion(
        isCancelled: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  });

  @override
  Future<int> recordPayment({
    required int obligationId,
    required int amountInCents,
    required DateTime date,
    required int paymentMethodId,
    String? note,
  }) => _database.transaction(() async {
    final details = await getDetails(obligationId);
    if (details == null) {
      throw const ObligationException('La obligación ya no existe.');
    }
    final obligation = details.obligation;
    if (obligation.isCancelled) {
      throw const ObligationException('La obligación está cancelada.');
    }
    final validation = ObligationValidator.validatePayment(
      amountInCents: amountInCents,
      remainingInCents: obligation.remainingAmountInCents,
    );
    if (validation != null) throw ObligationException(validation);
    if (note != null && note.trim().length > 120) {
      throw const ObligationException(
        'La nota no puede superar 120 caracteres.',
      );
    }
    await _validateCategory(obligation.direction, obligation.categoryId);
    await _validatePaymentMethod(paymentMethodId);

    final now = DateTime.now();
    final paymentId = await _database
        .into(_database.obligationPayments)
        .insert(
          ObligationPaymentsCompanion.insert(
            obligationId: obligationId,
            amountInCents: amountInCents,
            dateEpochDay: dateToEpochDay(date),
            paymentMethodId: paymentMethodId,
            note: Value(_emptyToNull(note)),
            createdAt: Value(now),
          ),
        );
    final transactionId = await _database
        .into(_database.transactions)
        .insert(
          TransactionsCompanion.insert(
            amountInCents: amountInCents,
            type: obligation.direction == ObligationDirection.payable
                ? 'expense'
                : 'income',
            categoryId: obligation.categoryId,
            paymentMethodId: paymentMethodId,
            description: Value(
              '${obligation.direction == ObligationDirection.payable ? 'Abono' : 'Cobro'} · ${obligation.title}',
            ),
            dateEpochDay: dateToEpochDay(date),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    await (_database.update(
      _database.obligationPayments,
    )..where((row) => row.id.equals(paymentId))).write(
      ObligationPaymentsCompanion(transactionId: Value(transactionId)),
    );
    await (_database.update(_database.obligations)
          ..where((row) => row.id.equals(obligationId)))
        .write(ObligationsCompanion(updatedAt: Value(now)));
    return paymentId;
  });

  @override
  Future<void> deletePayment(int paymentId) => _database.transaction(() async {
    final payment = await (_database.select(
      _database.obligationPayments,
    )..where((row) => row.id.equals(paymentId))).getSingleOrNull();
    if (payment == null) {
      throw const ObligationException('El abono ya no existe.');
    }
    final transactionId = payment.transactionId;
    if (transactionId != null) {
      await (_database.update(_database.obligationPayments)
            ..where((row) => row.id.equals(paymentId)))
          .write(const ObligationPaymentsCompanion(transactionId: Value(null)));
      await (_database.delete(
        _database.transactions,
      )..where((row) => row.id.equals(transactionId))).go();
    }
    await (_database.delete(
      _database.obligationPayments,
    )..where((row) => row.id.equals(paymentId))).go();
    await (_database.update(_database.obligations)
          ..where((row) => row.id.equals(payment.obligationId)))
        .write(ObligationsCompanion(updatedAt: Value(DateTime.now())));
  });

  Future<ObligationRow> _getRow(int id) async =>
      await (_database.select(
        _database.obligations,
      )..where((row) => row.id.equals(id))).getSingleOrNull() ??
      (throw const ObligationException('La obligación ya no existe.'));

  Future<void> _validateCategory(
    ObligationDirection direction,
    int categoryId,
  ) async {
    final category = await (_database.select(
      _database.categories,
    )..where((row) => row.id.equals(categoryId))).getSingleOrNull();
    final expectedType = direction == ObligationDirection.payable
        ? CategoryType.expense.name
        : CategoryType.income.name;
    if (category == null ||
        !category.isActive ||
        category.type != expectedType) {
      throw ObligationException(
        direction == ObligationDirection.payable
            ? 'Selecciona una categoría de gasto activa.'
            : 'Selecciona una categoría de ingreso activa.',
      );
    }
  }

  Future<void> _validatePaymentMethod(
    int? paymentMethodId, {
    int? allowInactiveId,
  }) async {
    if (paymentMethodId == null) return;
    final method = await (_database.select(
      _database.paymentMethods,
    )..where((row) => row.id.equals(paymentMethodId))).getSingleOrNull();
    if (method == null ||
        (!method.isActive && paymentMethodId != allowInactiveId)) {
      throw const ObligationException('Selecciona un método de pago activo.');
    }
  }

  static void _validateInput(Obligation obligation) {
    final titleError = ObligationValidator.validateTitle(obligation.title);
    if (titleError != null) throw ObligationException(titleError);
    final amountError = ObligationValidator.validateAmount(
      obligation.amountInCents,
    );
    if (amountError != null) throw ObligationException(amountError);
    final counterpartyError = ObligationValidator.validateCounterparty(
      obligation.counterparty,
    );
    if (counterpartyError != null) throw ObligationException(counterpartyError);
    final notesError = ObligationValidator.validateNotes(obligation.notes);
    if (notesError != null) throw ObligationException(notesError);
  }

  static int _paidTotal(List<ObligationPaymentRow> payments) =>
      payments.fold(0, (total, payment) => total + payment.amountInCents);

  Obligation _fromOverviewRow(QueryRow row) => Obligation(
    id: row.read<int>('id'),
    direction: ObligationDirection.values.byName(row.read<String>('direction')),
    title: row.read<String>('title'),
    counterparty: row.read<String?>('counterparty'),
    amountInCents: row.read<int>('amount_in_cents'),
    dueDate: row.read<int?>('due_date_epoch_day') == null
        ? null
        : dateFromEpochDay(row.read<int>('due_date_epoch_day')),
    categoryId: row.read<int>('category_id'),
    defaultPaymentMethodId: row.read<int?>('default_payment_method_id'),
    sourceShoppingListId: row.read<int?>('source_shopping_list_id'),
    isCancelled: row.read<bool>('is_cancelled'),
    notes: row.read<String?>('notes'),
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('created_at')),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('updated_at')),
    paidAmountInCents: row.read<int>('paid_amount_in_cents'),
  );

  Obligation _fromRow(ObligationRow row, int paidAmount) => Obligation(
    id: row.id,
    direction: ObligationDirection.values.byName(row.direction),
    title: row.title,
    counterparty: row.counterparty,
    amountInCents: row.amountInCents,
    dueDate: row.dueDateEpochDay == null
        ? null
        : dateFromEpochDay(row.dueDateEpochDay!),
    categoryId: row.categoryId,
    defaultPaymentMethodId: row.defaultPaymentMethodId,
    sourceShoppingListId: row.sourceShoppingListId,
    isCancelled: row.isCancelled,
    notes: row.notes,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    paidAmountInCents: paidAmount,
  );

  static ObligationPayment _fromPaymentRow(ObligationPaymentRow row) =>
      ObligationPayment(
        id: row.id,
        obligationId: row.obligationId,
        amountInCents: row.amountInCents,
        date: dateFromEpochDay(row.dateEpochDay),
        paymentMethodId: row.paymentMethodId,
        transactionId: row.transactionId,
        note: row.note,
        createdAt: row.createdAt,
      );

  static String? _emptyToNull(String? value) =>
      value?.trim().isEmpty == true ? null : value?.trim();
}
