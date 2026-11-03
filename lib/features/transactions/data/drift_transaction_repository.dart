import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/transaction.dart';
import '../domain/transaction_history_filter.dart';
import '../domain/transaction_repository.dart';
import '../domain/transaction_validator.dart';

class DriftTransactionRepository implements TransactionRepository {
  const DriftTransactionRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<FinanceTransaction>> watchAll() =>
      (_database.select(_database.transactions)..orderBy([
            (row) => OrderingTerm.desc(row.dateEpochDay),
            (row) => OrderingTerm.desc(row.createdAt),
          ]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList(growable: false));

  @override
  Stream<List<FinanceTransaction>> watchFiltered(
    TransactionHistoryFilter filter,
  ) {
    final transactions = _database.transactions;
    final categories = _database.categories;
    final methods = _database.paymentMethods;
    final query = _database.select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(methods, methods.id.equalsExp(transactions.paymentMethodId)),
    ]);
    final predicates = <Expression<bool>>[];
    if (filter.type != null) {
      predicates.add(transactions.type.equals(filter.type!.name));
    }
    final categoryIds = filter.categoryIds.isNotEmpty
        ? filter.categoryIds
        : filter.categoryId == null
        ? const <int>{}
        : {filter.categoryId!};
    if (categoryIds.isNotEmpty) {
      predicates.add(transactions.categoryId.isIn(categoryIds));
    }
    if (filter.paymentMethodIds.isNotEmpty) {
      predicates.add(
        transactions.paymentMethodId.isIn(filter.paymentMethodIds),
      );
    }
    if (filter.minimumAmountInCents != null) {
      predicates.add(
        transactions.amountInCents.isBiggerOrEqualValue(
          filter.minimumAmountInCents!,
        ),
      );
    }
    if (filter.maximumAmountInCents != null) {
      predicates.add(
        transactions.amountInCents.isSmallerOrEqualValue(
          filter.maximumAmountInCents!,
        ),
      );
    }
    if (filter.startDate != null) {
      predicates.add(
        transactions.dateEpochDay.isBiggerOrEqualValue(
          dateToEpochDay(filter.startDate!),
        ),
      );
    }
    if (filter.endDate != null) {
      predicates.add(
        transactions.dateEpochDay.isSmallerOrEqualValue(
          dateToEpochDay(filter.endDate!),
        ),
      );
    }
    final normalizedQuery = filter.query.trim().toLowerCase();
    if (normalizedQuery.isNotEmpty) {
      final escaped = normalizedQuery
          .replaceAll(r'\', r'\\')
          .replaceAll('%', r'\%')
          .replaceAll('_', r'\_');
      final pattern = '%$escaped%';
      predicates.add(
        transactions.description.like(pattern, escapeChar: r'\') |
            categories.name.like(pattern, escapeChar: r'\') |
            methods.name.like(pattern, escapeChar: r'\'),
      );
    }
    if (predicates.isNotEmpty) query.where(predicates.reduce((a, b) => a & b));
    final byNewest = [
      OrderingTerm.desc(transactions.dateEpochDay),
      OrderingTerm.desc(transactions.createdAt),
      OrderingTerm.desc(transactions.id),
    ];
    query.orderBy(switch (filter.sortOrder) {
      TransactionSortOrder.newest => byNewest,
      TransactionSortOrder.oldest => [
        OrderingTerm.asc(transactions.dateEpochDay),
        OrderingTerm.asc(transactions.createdAt),
        OrderingTerm.asc(transactions.id),
      ],
      TransactionSortOrder.amountHighToLow => [
        OrderingTerm.desc(transactions.amountInCents),
        ...byNewest,
      ],
      TransactionSortOrder.amountLowToHigh => [
        OrderingTerm.asc(transactions.amountInCents),
        ...byNewest,
      ],
      TransactionSortOrder.categoryAscending => [
        OrderingTerm.asc(categories.name),
        ...byNewest,
      ],
      TransactionSortOrder.categoryDescending => [
        OrderingTerm.desc(categories.name),
        ...byNewest,
      ],
    });
    return query.watch().map(
      (rows) => rows
          .map((row) => _fromRow(row.readTable(transactions)))
          .toList(growable: false),
    );
  }

  @override
  Future<FinanceTransaction?> get(int id) async => _fromNullable(
    await (_database.select(
      _database.transactions,
    )..where((row) => row.id.equals(id))).getSingleOrNull(),
  );

  @override
  Future<int> create(FinanceTransaction transaction) =>
      _database.transaction(() async {
        final normalized = TransactionValidator.normalize(transaction);
        _validateAmount(normalized);
        await _validateReferences(normalized);
        return _database
            .into(_database.transactions)
            .insert(_toCompanion(normalized));
      });

  @override
  Future<void> update(
    FinanceTransaction transaction,
  ) => _database.transaction(() async {
    if (transaction.id <= 0) {
      throw const InvalidTransactionException('No encontramos el movimiento.');
    }
    final existing = await (_database.select(
      _database.transactions,
    )..where((row) => row.id.equals(transaction.id))).getSingleOrNull();
    if (existing == null) {
      throw const InvalidTransactionException('No encontramos el movimiento.');
    }
    if (await _isObligationPayment(transaction.id)) {
      throw const InvalidTransactionException(
        'Este movimiento pertenece a un abono. Edítalo desde la obligación.',
      );
    }
    if (existing.fixedEntryId != null) {
      throw const InvalidTransactionException(
        'Este movimiento pertenece a una serie recurrente. Edítalo desde la serie.',
      );
    }
    final normalized = TransactionValidator.normalize(transaction);
    if (existing.savingsGoalId != null &&
        normalized.type != TransactionType.expense) {
      throw const InvalidTransactionException(
        'Un aporte de ahorro debe mantenerse como gasto.',
      );
    }
    _validateAmount(normalized);
    await _validateReferences(normalized);
    await (_database.update(
      _database.transactions,
    )..where((row) => row.id.equals(normalized.id))).write(
      TransactionsCompanion(
        amountInCents: Value(normalized.amountInCents),
        type: Value(normalized.type.name),
        categoryId: Value(normalized.categoryId),
        paymentMethodId: Value(normalized.paymentMethodId),
        description: Value(normalized.description),
        dateEpochDay: Value(dateToEpochDay(normalized.date)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  });

  @override
  Future<int?> duplicate(int id) => _database.transaction(() async {
    final original = await (_database.select(
      _database.transactions,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (original == null) return null;
    if (await _isObligationPayment(id)) {
      throw const InvalidTransactionException(
        'Este movimiento pertenece a un abono y no se puede duplicar por separado.',
      );
    }
    if (original.fixedEntryId != null) {
      throw const InvalidTransactionException(
        'Este movimiento pertenece a una serie recurrente y no se puede duplicar por separado.',
      );
    }
    final now = DateTime.now();
    final originalModel = _fromRow(original);
    final duplicate = FinanceTransaction(
      amountInCents: originalModel.amountInCents,
      type: originalModel.type,
      categoryId: originalModel.categoryId,
      paymentMethodId: originalModel.paymentMethodId,
      description: originalModel.description,
      date: DateTime(now.year, now.month, now.day),
      createdAt: now,
      updatedAt: now,
    );
    return _database
        .into(_database.transactions)
        .insert(_toCompanion(duplicate));
  });

  @override
  Future<void> delete(int id) async {
    if (await _isObligationPayment(id)) {
      throw const InvalidTransactionException(
        'Elimina el abono desde su obligación para revertir este movimiento.',
      );
    }
    final row = await (_database.select(
      _database.transactions,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row?.fixedEntryId != null) {
      throw const InvalidTransactionException(
        'Este movimiento pertenece a una serie recurrente. Elimínalo desde la serie.',
      );
    }
    await (_database.delete(
      _database.transactions,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<bool> _isObligationPayment(int transactionId) async =>
      await (_database.select(_database.obligationPayments)
            ..where((payment) => payment.transactionId.equals(transactionId)))
          .getSingleOrNull() !=
      null;

  void _validateAmount(FinanceTransaction transaction) {
    final message = TransactionValidator.validateAmount(
      transaction.amountInCents,
    );
    if (message != null) throw InvalidTransactionException(message);
  }

  Future<void> _validateReferences(FinanceTransaction transaction) async {
    final category = await (_database.select(
      _database.categories,
    )..where((row) => row.id.equals(transaction.categoryId))).getSingleOrNull();
    if (category == null || !category.isActive) {
      throw const InvalidTransactionException(
        'Selecciona una categoría activa.',
      );
    }
    if (category.type != transaction.type.name) {
      throw const InvalidTransactionException(
        'La categoría no corresponde al tipo de movimiento.',
      );
    }

    final paymentMethod =
        await (_database.select(_database.paymentMethods)
              ..where((row) => row.id.equals(transaction.paymentMethodId)))
            .getSingleOrNull();
    if (paymentMethod == null || !paymentMethod.isActive) {
      throw const InvalidTransactionException(
        'Selecciona un método de pago activo.',
      );
    }
  }

  TransactionsCompanion _toCompanion(FinanceTransaction transaction) =>
      TransactionsCompanion.insert(
        amountInCents: transaction.amountInCents,
        type: transaction.type.name,
        categoryId: transaction.categoryId,
        paymentMethodId: transaction.paymentMethodId,
        description: Value(transaction.description),
        dateEpochDay: dateToEpochDay(transaction.date),
        createdAt: Value(transaction.createdAt),
        updatedAt: Value(transaction.updatedAt),
        fixedEntryId: Value(transaction.fixedEntryId),
        savingsGoalId: Value(transaction.savingsGoalId),
      );

  FinanceTransaction? _fromNullable(FinanceTransactionRow? row) =>
      row == null ? null : _fromRow(row);

  FinanceTransaction _fromRow(FinanceTransactionRow row) => FinanceTransaction(
    id: row.id,
    amountInCents: row.amountInCents,
    type: TransactionType.values.byName(row.type),
    categoryId: row.categoryId,
    paymentMethodId: row.paymentMethodId,
    description: row.description,
    date: dateFromEpochDay(row.dateEpochDay),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    fixedEntryId: row.fixedEntryId,
    savingsGoalId: row.savingsGoalId,
  );
}
