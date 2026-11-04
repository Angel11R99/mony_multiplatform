import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../../categories/presentation/categories_providers.dart';
import '../data/drift_statistics_repository.dart';
import '../domain/financial_statistics.dart';
import '../domain/statistics_aggregate_snapshot.dart';
import '../domain/statistics_repository.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) => DriftStatisticsRepository(ref.watch(appDatabaseProvider)),
);

typedef AllTimeStatisticsRequest = ({
  DateTime budgetStart,
  DateTime budgetEnd,
  DateTime through,
  int? categoryId,
});

typedef StatisticsPeriodsRequest = ({
  DateTime currentStart,
  DateTime currentEnd,
  DateTime? previousStart,
  DateTime? previousEnd,
  DateTime budgetStart,
  DateTime budgetEnd,
  DateTime through,
  int? categoryId,
});

final allTimeStatisticsProvider = StreamProvider.autoDispose
    .family<StatisticsAggregateSnapshot, AllTimeStatisticsRequest>((
      ref,
      request,
    ) {
      final categories = ref.watch(categoriesProvider).value ?? const [];
      return ref
          .watch(statisticsRepositoryProvider)
          .watchAllTime(
            categories: {
              for (final category in categories) category.id: category,
            },
            limitCategories: categories
                .where(
                  (category) =>
                      request.categoryId == null ||
                      category.id == request.categoryId,
                )
                .toList(growable: false),
            budgetPeriod: StatisticsPeriod(
              start: request.budgetStart,
              endInclusive: request.budgetEnd,
            ),
            through: request.through,
            categoryId: request.categoryId,
          );
    });

final statisticsPeriodsProvider = StreamProvider.autoDispose
    .family<StatisticsAggregateSnapshot, StatisticsPeriodsRequest>((
      ref,
      request,
    ) {
      final categories = ref.watch(categoriesProvider).value ?? const [];
      return ref
          .watch(statisticsRepositoryProvider)
          .watchPeriods(
            categories: {
              for (final category in categories) category.id: category,
            },
            limitCategories: categories.where(
              (category) =>
                  request.categoryId == null ||
                  category.id == request.categoryId,
            ),
            currentPeriod: StatisticsPeriod(
              start: request.currentStart,
              endInclusive: request.currentEnd,
            ),
            previousPeriod:
                request.previousStart == null || request.previousEnd == null
                ? null
                : StatisticsPeriod(
                    start: request.previousStart,
                    endInclusive: request.previousEnd,
                  ),
            budgetPeriod: StatisticsPeriod(
              start: request.budgetStart,
              endInclusive: request.budgetEnd,
            ),
            through: request.through,
            categoryId: request.categoryId,
          );
    });
