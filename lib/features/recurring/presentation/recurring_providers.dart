import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database_provider.dart';
import '../data/drift_recurring_repository.dart';
import '../domain/recurring_repository.dart';
import '../domain/recurring_entry.dart';

final recurringRepositoryProvider = Provider<RecurringRepository>(
  (ref) => DriftRecurringRepository(ref.watch(appDatabaseProvider)),
);
final recurringEntriesProvider = StreamProvider<List<RecurringEntry>>(
  (ref) => ref.watch(recurringRepositoryProvider).watchAll(),
);
