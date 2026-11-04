import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../../budgets/domain/budget.dart';
import '../data/drift_dashboard_repository.dart';
import '../domain/dashboard_repository.dart';
import '../domain/financial_dashboard_summary.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DriftDashboardRepository(ref.watch(appDatabaseProvider)),
);

final dashboardSummaryProvider = StreamProvider.autoDispose
    .family<
      FinancialDashboardSummary,
      ({DateTime month, DateTime start, DateTime end})
    >(
      (ref, request) => ref
          .watch(dashboardRepositoryProvider)
          .watchSummary(
            month: request.month,
            period: DateRange(start: request.start, endInclusive: request.end),
          ),
    );
