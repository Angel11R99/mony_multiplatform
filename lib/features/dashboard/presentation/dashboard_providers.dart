import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../transactions/presentation/transactions_providers.dart';
import '../domain/financial_dashboard_summary.dart';

final dashboardSummaryProvider =
    Provider.family<AsyncValue<FinancialDashboardSummary>, DateTime>(
      (ref, month) => ref
          .watch(transactionsProvider)
          .whenData(
            (transactions) => FinancialDashboardSummary.fromTransactions(
              transactions,
              month: month,
            ),
          ),
    );
