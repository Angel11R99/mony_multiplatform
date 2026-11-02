import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_obligation_repository.dart';
import '../domain/obligation.dart';
import '../domain/obligation_repository.dart';

final obligationRepositoryProvider = Provider<ObligationRepository>(
  (ref) => DriftObligationRepository(ref.watch(appDatabaseProvider)),
);

final obligationsProvider = StreamProvider<List<Obligation>>(
  (ref) => ref.watch(obligationRepositoryProvider).watchAll(),
);

final obligationDetailsProvider =
    StreamProvider.family<ObligationDetails?, int>(
      (ref, id) => ref.watch(obligationRepositoryProvider).watchDetails(id),
    );
