import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_budget_repository.dart';
import '../domain/budget.dart';
import '../domain/budget_repository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => DriftBudgetRepository(ref.watch(appDatabaseProvider)),
);

final budgetConfigProvider = StreamProvider<BudgetConfig?>(
  (ref) => ref.watch(budgetRepositoryProvider).watchConfig(),
);

final budgetHistoryProvider = StreamProvider<List<BudgetCycle>>(
  (ref) => ref.watch(budgetRepositoryProvider).watchHistory(),
);
