import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_transaction_repository.dart';
import '../domain/transaction.dart';
import '../domain/transaction_history_filter.dart';
import '../domain/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => DriftTransactionRepository(ref.watch(appDatabaseProvider)),
);

final transactionsProvider = StreamProvider<List<FinanceTransaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchAll(),
);

final filteredTransactionsProvider =
    StreamProvider.family<List<FinanceTransaction>, TransactionHistoryFilter>(
      (ref, filter) =>
          ref.watch(transactionRepositoryProvider).watchFiltered(filter),
    );

final transactionByIdProvider = FutureProvider.family<FinanceTransaction?, int>(
  (ref, id) => ref.watch(transactionRepositoryProvider).get(id),
);
