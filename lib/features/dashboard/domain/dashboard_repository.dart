import '../../budgets/domain/budget.dart';
import 'financial_dashboard_summary.dart';

abstract interface class DashboardRepository {
  Stream<FinancialDashboardSummary> watchSummary({
    required DateTime month,
    required DateRange period,
  });
}
