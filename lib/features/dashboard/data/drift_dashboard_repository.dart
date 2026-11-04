import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../budgets/domain/budget.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/dashboard_repository.dart';
import '../domain/financial_dashboard_summary.dart';

class DriftDashboardRepository implements DashboardRepository {
  const DriftDashboardRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<FinancialDashboardSummary> watchSummary({
    required DateTime month,
    required DateRange period,
  }) {
    final monthStart = DateTime(month.year, month.month);
    final trendStart = DateTime(monthStart.year, monthStart.month - 5);
    final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 0);
    final start = trendStart.isBefore(period.start) ? trendStart : period.start;
    final end = monthEnd.isAfter(period.endInclusive)
        ? monthEnd
        : period.endInclusive;
    return _database
        .customSelect(
          '''SELECT * FROM transactions
              WHERE date_epoch_day BETWEEN ? AND ?
            UNION
            SELECT * FROM transactions
              WHERE id IN (
                SELECT id FROM transactions
                ORDER BY date_epoch_day DESC, created_at DESC, id DESC
                LIMIT 5
              )''',
          variables: [
            Variable.withInt(dateToEpochDay(start)),
            Variable.withInt(dateToEpochDay(end)),
          ],
          readsFrom: {_database.transactions},
        )
        .watch()
        .map((rows) {
          final transactions = rows
              .map((row) => _fromRow(_database.transactions.map(row.data)))
              .toList(growable: false);
          return FinancialDashboardSummary.fromTransactions(
            transactions,
            month: monthStart,
            selectedPeriod: period,
          );
        });
  }

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
