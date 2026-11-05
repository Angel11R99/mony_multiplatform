import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/categories/data/drift_categories_repository.dart';
import 'package:mony_multiplatform/features/statistics/data/drift_statistics_repository.dart';
import 'package:mony_multiplatform/features/statistics/domain/financial_statistics.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_history_filter.dart';

void main() {
  test('profiles history and statistics queries with 50000 rows', () async {
    final database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(database.close);

    final today = DateTime.now();
    final todayDay = dateToEpochDay(today);
    final rows = List.generate(50000, (index) {
      final income = index % 4 == 0;
      final date = todayDay - index % 1825;
      return TransactionsCompanion.insert(
        amountInCents: 1000 + index % 500000,
        type: income ? 'income' : 'expense',
        categoryId: income ? 1 : 6 + index % 16,
        paymentMethodId: 1,
        description: Value('Synthetic transaction $index'),
        dateEpochDay: date,
        createdAt: Value(DateTime.fromMillisecondsSinceEpoch(date * 86400000)),
        updatedAt: Value(DateTime.fromMillisecondsSinceEpoch(date * 86400000)),
      );
    });
    final insertWatch = Stopwatch()..start();
    await database.batch(
      (batch) => batch.insertAll(database.transactions, rows),
    );
    insertWatch.stop();

    final transactions = DriftTransactionRepository(database);
    final stats = DriftStatisticsRepository(database);
    final categories = await DriftCategoriesRepository(
      database,
    ).watchAll().first;
    final categoryMap = {
      for (final category in categories) category.id: category,
    };
    final currentStart = today.subtract(const Duration(days: 29));
    final previousStart = today.subtract(const Duration(days: 59));
    final previousEnd = today.subtract(const Duration(days: 30));
    final budgetStart = today.subtract(const Duration(days: 13));
    final periodSamples = <int>[];
    final allTimeSamples = <int>[];
    final historyPageSamples = <int>[];
    final historySummarySamples = <int>[];
    final fullMaterializationSamples = <int>[];

    Future<int> measure(Future<void> Function() operation) async {
      final watch = Stopwatch()..start();
      await operation();
      watch.stop();
      return watch.elapsedMicroseconds;
    }

    for (var sample = 0; sample < 6; sample++) {
      periodSamples.add(
        await measure(() async {
          final snapshot = await stats
              .watchPeriods(
                categories: categoryMap,
                limitCategories: categories,
                currentPeriod: StatisticsPeriod(
                  start: currentStart,
                  endInclusive: today,
                ),
                previousPeriod: StatisticsPeriod(
                  start: previousStart,
                  endInclusive: previousEnd,
                ),
                budgetPeriod: StatisticsPeriod(
                  start: budgetStart,
                  endInclusive: today,
                ),
                through: today,
              )
              .first;
          expect(snapshot.statistics.transactionCount, greaterThan(0));
        }),
      );
      allTimeSamples.add(
        await measure(() async {
          final snapshot = await stats
              .watchAllTime(
                categories: categoryMap,
                limitCategories: categories,
                budgetPeriod: StatisticsPeriod(
                  start: budgetStart,
                  endInclusive: today,
                ),
                through: today,
              )
              .first;
          expect(snapshot.statistics.transactionCount, rows.length);
        }),
      );
      historyPageSamples.add(
        await measure(() async {
          final page = await transactions
              .watchFiltered(const TransactionHistoryFilter(), limit: 21)
              .first;
          expect(page, hasLength(21));
        }),
      );
      historySummarySamples.add(
        await measure(() async {
          final summary = await transactions
              .watchFilteredSummary(const TransactionHistoryFilter())
              .first;
          expect(summary.totalCount, rows.length);
        }),
      );
      fullMaterializationSamples.add(
        await measure(() async {
          expect(await transactions.watchAll().first, hasLength(rows.length));
        }),
      );
    }

    int median(List<int> values) {
      final sorted = [...values]..sort();
      final middle = sorted.length ~/ 2;
      return sorted.length.isOdd
          ? sorted[middle]
          : (sorted[middle - 1] + sorted[middle]) ~/ 2;
    }

    // Exclude the first sample as warm-up to limit compilation/cache effects.
    int measuredMedian(List<int> values) => median(values.skip(1).toList());
    // ignore: avoid_print
    print(
      '50000 synthetic SQLite rows; seed=${insertWatch.elapsedMilliseconds}ms; '
      'periodStats=${measuredMedian(periodSamples)}us; '
      'allTimeStats=${measuredMedian(allTimeSamples)}us; '
      'historyPage21=${measuredMedian(historyPageSamples)}us; '
      'historySummary=${measuredMedian(historySummarySamples)}us; '
      'watchAllMaterialization=${measuredMedian(fullMaterializationSamples)}us',
    );
  });
}
