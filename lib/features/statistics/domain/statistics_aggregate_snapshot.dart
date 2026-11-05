import 'financial_statistics.dart';

class StatisticsAggregateSnapshot {
  const StatisticsAggregateSnapshot({
    required this.statistics,
    required this.previous,
    required this.limitInsights,
    required this.evolution,
  });

  final FinancialStatistics statistics;
  final FinancialStatistics? previous;
  final List<BudgetLimitInsight> limitInsights;
  final List<MonthlyStatistics> evolution;
}
