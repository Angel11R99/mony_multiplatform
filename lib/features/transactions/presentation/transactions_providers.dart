import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_transaction_repository.dart';
import '../domain/transaction.dart';
import '../domain/transaction_history_filter.dart';
import '../domain/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => DriftTransactionRepository(ref.watch(appDatabaseProvider)),
);

final transactionPeriodSummaryProvider = StreamProvider.autoDispose
    .family<
      TransactionPeriodSummary,
      ({DateTime start, DateTime endInclusive})
    >(
      (ref, range) => ref
          .watch(transactionRepositoryProvider)
          .watchPeriodSummary(
            start: range.start,
            endInclusive: range.endInclusive,
          ),
    );

final filteredTransactionsProvider = StreamProvider.autoDispose
    .family<List<FinanceTransaction>, (TransactionHistoryFilter, int?)>(
      (ref, request) => ref
          .watch(transactionRepositoryProvider)
          .watchFiltered(request.$1, limit: request.$2),
    );

final filteredTransactionSummaryProvider = StreamProvider.autoDispose
    .family<TransactionHistorySummary, TransactionHistoryFilter>(
      (ref, filter) =>
          ref.watch(transactionRepositoryProvider).watchFilteredSummary(filter),
    );

final transactionByIdProvider = FutureProvider.autoDispose
    .family<FinanceTransaction?, int>(
      (ref, id) => ref.watch(transactionRepositoryProvider).get(id),
    );
