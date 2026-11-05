import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_obligation_repository.dart';
import '../domain/obligation.dart';
import '../domain/obligation_repository.dart';

final obligationRepositoryProvider = Provider<ObligationRepository>(
  (ref) => DriftObligationRepository(ref.watch(appDatabaseProvider)),
);

final obligationsProvider = StreamProvider.autoDispose<List<Obligation>>(
  (ref) => ref.watch(obligationRepositoryProvider).watchAll(),
);

final obligationReminderCandidatesProvider =
    StreamProvider.autoDispose<List<Obligation>>(
      (ref) =>
          ref.watch(obligationRepositoryProvider).watchReminderCandidates(),
    );

typedef ObligationListRequest = ({
  ObligationListFilter filter,
  DateTime? dueFrom,
  DateTime? dueThrough,
  int limit,
});

final obligationListProvider = StreamProvider.autoDispose
    .family<List<Obligation>, ObligationListRequest>(
      (ref, request) => ref
          .watch(obligationRepositoryProvider)
          .watchList(
            filter: request.filter,
            dueFrom: request.dueFrom,
            dueThrough: request.dueThrough,
            limit: request.limit,
          ),
    );

final obligationOverviewProvider =
    StreamProvider.autoDispose<ObligationOverview>(
      (ref) => ref.watch(obligationRepositoryProvider).watchOverview(),
    );

final obligationDetailsProvider = StreamProvider.autoDispose
    .family<ObligationDetails?, int>(
      (ref, id) => ref.watch(obligationRepositoryProvider).watchDetails(id),
    );
