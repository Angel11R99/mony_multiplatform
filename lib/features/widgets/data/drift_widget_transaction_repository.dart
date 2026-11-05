import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../transactions/domain/transaction.dart';

class DriftWidgetTransactionRepository {
  const DriftWidgetTransactionRepository(this._database);

  final AppDatabase _database;

  Stream<List<FinanceTransaction>> watchRelevant({
    required DateTime currentStart,
    required DateTime currentEnd,
    required DateTime previousStart,
    required DateTime previousEnd,
  }) => _database
      .customSelect(
        '''SELECT * FROM transactions
                WHERE date_epoch_day BETWEEN ? AND ?
                   OR date_epoch_day BETWEEN ? AND ?
              UNION
              SELECT * FROM transactions
                WHERE id IN (
                  SELECT id FROM transactions
                  ORDER BY date_epoch_day DESC, created_at DESC, id DESC
                  LIMIT 5
                )''',
        variables: [
          Variable.withInt(dateToEpochDay(currentStart)),
          Variable.withInt(dateToEpochDay(currentEnd)),
          Variable.withInt(dateToEpochDay(previousStart)),
          Variable.withInt(dateToEpochDay(previousEnd)),
        ],
        readsFrom: {_database.transactions},
      )
      .watch()
      .map(
        (rows) => rows
            .map((row) => _fromRow(_database.transactions.map(row.data)))
            .toList(growable: false),
      );

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
