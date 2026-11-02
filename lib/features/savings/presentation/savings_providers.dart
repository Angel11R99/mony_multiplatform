import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_savings_repository.dart';
import '../domain/savings_goal.dart';
import '../domain/savings_repository.dart';

final savingsRepositoryProvider = Provider<SavingsRepository>(
  (ref) => DriftSavingsRepository(ref.watch(appDatabaseProvider)),
);

final savingsGoalsProvider = StreamProvider<List<SavingsGoalProgress>>(
  (ref) => ref.watch(savingsRepositoryProvider).watchAll(),
);

final savingsGoalProvider = FutureProvider.family<SavingsGoalProgress?, int>(
  (ref, id) => ref.watch(savingsRepositoryProvider).get(id),
);

final savingsContributionsProvider =
    StreamProvider.family<List<SavingsContribution>, int>(
      (ref, id) => ref.watch(savingsRepositoryProvider).watchContributions(id),
    );
