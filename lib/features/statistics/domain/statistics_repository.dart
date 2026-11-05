import '../../categories/domain/category.dart';
import 'financial_statistics.dart';
import 'statistics_aggregate_snapshot.dart';

abstract interface class StatisticsRepository {
  Stream<StatisticsAggregateSnapshot> watchAllTime({
    required Map<int, Category> categories,
    required Iterable<Category> limitCategories,
    required StatisticsPeriod budgetPeriod,
    required DateTime through,
    int? categoryId,
  });

  Stream<StatisticsAggregateSnapshot> watchPeriods({
    required Map<int, Category> categories,
    required Iterable<Category> limitCategories,
    required StatisticsPeriod currentPeriod,
    required StatisticsPeriod? previousPeriod,
    required StatisticsPeriod budgetPeriod,
    required DateTime through,
    int? categoryId,
  });
}
