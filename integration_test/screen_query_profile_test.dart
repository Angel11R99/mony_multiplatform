import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/categories/data/drift_categories_repository.dart';
import 'package:mony_multiplatform/features/obligations/data/drift_obligation_repository.dart';
import 'package:mony_multiplatform/features/recurring/data/drift_recurring_repository.dart';
import 'package:mony_multiplatform/features/statistics/data/drift_statistics_repository.dart';
import 'package:mony_multiplatform/features/statistics/domain/financial_statistics.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_history_filter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('profiles database screens with 50000 synthetic movements', (
    tester,
  ) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final databaseName =
        'screen_profile_${DateTime.now().microsecondsSinceEpoch}';
    final databaseFile = File(
      '${temporaryDirectory.path}/$databaseName.sqlite',
    );
    final database = AppDatabase(
      driftDatabase(
        name: databaseName,
        native: DriftNativeOptions(
          databaseDirectory: () async => temporaryDirectory.path,
        ),
      ),
    );
    addTearDown(() async {
      await database.close();
      for (final suffix in ['', '-wal', '-shm']) {
        final file = File('${databaseFile.path}$suffix');
        if (await file.exists()) await file.delete();
      }
    });
    final today = DateTime.now();
    final todayEpochDay = dateToEpochDay(today);
    final syntheticRows = List.generate(50000, (index) {
      final income = index % 4 == 0;
      final epochDay = todayEpochDay - index % 1825;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        epochDay * Duration.secondsPerDay * Duration.millisecondsPerSecond,
      );
      return TransactionsCompanion.insert(
        amountInCents: 1000 + index % 500000,
        type: income ? 'income' : 'expense',
        categoryId: income ? 1 : 6 + index % 16,
        paymentMethodId: 1,
        description: Value('Synthetic transaction $index'),
        dateEpochDay: epochDay,
        createdAt: Value(timestamp),
        updatedAt: Value(timestamp),
      );
    });
    final insertWatch = Stopwatch()..start();
    await database.batch(
      (batch) => batch.insertAll(database.transactions, syntheticRows),
    );
    insertWatch.stop();

    final transactionRepository = DriftTransactionRepository(database);
    final statisticsRepository = DriftStatisticsRepository(database);
    final categoryRows = await DriftCategoriesRepository(
      database,
    ).watchAll().first;
    final categories = {
      for (final category in categoryRows) category.id: category,
    };
    final currentStart = today.subtract(const Duration(days: 29));
    final previousStart = today.subtract(const Duration(days: 59));
    final previousEnd = today.subtract(const Duration(days: 30));
    final budgetStart = today.subtract(const Duration(days: 13));
    final timings = <String, List<int>>{
      'period statistics': [],
      'budget period summary': [],
      'previous budget full history': [],
      'all time statistics': [],
      'previous all time SQL': [],
      'history first page': [],
      'previous history page SQL': [],
      'history summary': [],
      'previous history summary SQL': [],
    };

    Future<int> measure(Future<void> Function() action) async {
      final watch = Stopwatch()..start();
      await action();
      watch.stop();
      return watch.elapsedMicroseconds;
    }

    for (var sample = 0; sample < 6; sample++) {
      TransactionPeriodSummary? budgetSummary;
      timings['budget period summary']!.add(
        await measure(() async {
          budgetSummary = await transactionRepository
              .watchPeriodSummary(start: budgetStart, endInclusive: today)
              .first;
          expect(budgetSummary!.expenseByCategory, isNotEmpty);
        }),
      );
      timings['previous budget full history']!.add(
        await measure(() async {
          final rows = await transactionRepository.watchAll().first;
          var income = 0;
          var expense = 0;
          final expensesByCategory = <int, int>{};
          final budgetStartEpochDay = dateToEpochDay(budgetStart);
          for (final row in rows) {
            final rowEpochDay = dateToEpochDay(row.date);
            if (rowEpochDay < budgetStartEpochDay ||
                rowEpochDay > todayEpochDay) {
              continue;
            }
            if (row.type == TransactionType.income) {
              income += row.amountInCents;
            } else if (row.type == TransactionType.expense) {
              expense += row.amountInCents;
              expensesByCategory.update(
                row.categoryId,
                (current) => current + row.amountInCents,
                ifAbsent: () => row.amountInCents,
              );
            }
          }
          expect(income, budgetSummary!.incomeInCents);
          expect(expense, budgetSummary!.expenseInCents);
          expect(expensesByCategory, budgetSummary!.expenseByCategory);
        }),
      );
      timings['period statistics']!.add(
        await measure(() async {
          final result = await statisticsRepository
              .watchPeriods(
                categories: categories,
                limitCategories: categoryRows,
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
          expect(result.statistics.transactionCount, greaterThan(0));
        }),
      );
      timings['all time statistics']!.add(
        await measure(() async {
          final result = await statisticsRepository
              .watchAllTime(
                categories: categories,
                limitCategories: categoryRows,
                budgetPeriod: StatisticsPeriod(
                  start: budgetStart,
                  endInclusive: today,
                ),
                through: today,
              )
              .first;
          expect(result.statistics.transactionCount, syntheticRows.length);
        }),
      );
      timings['previous all time SQL']!.add(
        await measure(() async {
          final rows = await database
              .customSelect(
                '''WITH selected AS (
                  SELECT category_id, type, amount_in_cents, date_epoch_day
                  FROM transactions
                )
                SELECT 'total' AS kind, type AS label,
                  SUM(amount_in_cents) AS value, COUNT(*) AS auxiliary
                FROM selected GROUP BY type
                UNION ALL
                SELECT 'category', CAST(category_id AS TEXT),
                  SUM(amount_in_cents), 0
                FROM selected WHERE type = 'expense' GROUP BY category_id
                UNION ALL
                SELECT 'limit', CAST(category_id AS TEXT),
                  SUM(amount_in_cents), 0
                FROM selected WHERE type = 'expense'
                  AND date_epoch_day BETWEEN ? AND ? GROUP BY category_id
                UNION ALL
                SELECT 'month', strftime('%Y-%m', date_epoch_day * 86400, 'unixepoch'),
                  SUM(CASE WHEN type = 'income' THEN amount_in_cents ELSE 0 END),
                  SUM(CASE WHEN type = 'expense' THEN amount_in_cents ELSE 0 END)
                FROM selected WHERE date_epoch_day BETWEEN ? AND ?
                GROUP BY strftime('%Y-%m', date_epoch_day * 86400, 'unixepoch')''',
                variables: [
                  Variable.withInt(dateToEpochDay(budgetStart)),
                  Variable.withInt(todayEpochDay),
                  Variable.withInt(
                    dateToEpochDay(DateTime(today.year, today.month - 5, 1)),
                  ),
                  Variable.withInt(todayEpochDay),
                ],
                readsFrom: {database.transactions},
              )
              .get();
          final totals = {
            for (final row in rows)
              if (row.read<String>('kind') == 'total')
                row.read<String>('label'): row.read<int>('value'),
          };
          expect(totals['income'], greaterThan(0));
          expect(totals['expense'], greaterThan(0));
          expect(rows, isNotEmpty);
        }),
      );
      timings['history first page']!.add(
        await measure(() async {
          final result = await transactionRepository
              .watchFiltered(const TransactionHistoryFilter(), limit: 21)
              .first;
          expect(result, hasLength(21));
        }),
      );
      timings['previous history page SQL']!.add(
        await measure(() async {
          final result = await database
              .customSelect(
                '''SELECT t.* FROM transactions t
                  INNER JOIN categories c ON c.id = t.category_id
                  INNER JOIN payment_methods m ON m.id = t.payment_method_id
                  ORDER BY t.date_epoch_day DESC, t.created_at DESC, t.id DESC
                  LIMIT 21''',
                readsFrom: {
                  database.transactions,
                  database.categories,
                  database.paymentMethods,
                },
              )
              .get();
          expect(result, hasLength(21));
        }),
      );
      timings['history summary']!.add(
        await measure(() async {
          final result = await transactionRepository
              .watchFilteredSummary(const TransactionHistoryFilter())
              .first;
          expect(result.totalCount, syntheticRows.length);
        }),
      );
      timings['previous history summary SQL']!.add(
        await measure(() async {
          final result = await database
              .customSelect(
                '''SELECT COUNT(*) AS total_count,
                    COALESCE(SUM(CASE WHEN t.type = 'income'
                      THEN t.amount_in_cents ELSE 0 END), 0) AS income_in_cents,
                    COALESCE(SUM(CASE WHEN t.type = 'expense'
                      THEN t.amount_in_cents ELSE 0 END), 0) AS expense_in_cents
                  FROM transactions t
                  INNER JOIN categories c ON c.id = t.category_id
                  INNER JOIN payment_methods m ON m.id = t.payment_method_id''',
                readsFrom: {
                  database.transactions,
                  database.categories,
                  database.paymentMethods,
                },
              )
              .getSingle();
          expect(result.read<int>('total_count'), syntheticRows.length);
        }),
      );
    }

    final report = <String, int>{};
    for (final entry in timings.entries) {
      final sorted = entry.value.skip(1).toList()..sort();
      report[entry.key] = sorted[sorted.length ~/ 2];
    }
    final recurringRepository = DriftRecurringRepository(database);
    final recurrenceTimings = <int>[];
    final recurrenceStart = todayEpochDay - 179;
    for (var sample = 0; sample < 6; sample++) {
      await database.batch((batch) {
        batch.insertAll(database.recurringEntries, [
          for (var series = 0; series < 50; series++)
            RecurringEntriesCompanion.insert(
              title: 'Profile daily $sample-$series',
              amountInCents: 1000 + series,
              type: 'expense',
              categoryId: 6,
              paymentMethodId: 1,
              frequency: 'daily',
              startDateEpochDay: recurrenceStart,
              nextDateEpochDay: recurrenceStart,
            ),
        ]);
      });
      recurrenceTimings.add(
        await measure(() async {
          expect(await recurringRepository.processDue(now: today), 9000);
        }),
      );
    }
    final recurrenceSamples = recurrenceTimings.skip(1).toList()..sort();
    report['50 recurring series x 180 days'] =
        recurrenceSamples[recurrenceSamples.length ~/ 2];

    await database.batch((batch) {
      batch.insertAll(database.obligations, [
        for (var index = 0; index < 10000; index++)
          ObligationsCompanion.insert(
            direction: 'payable',
            title: 'Profile obligation $index',
            amountInCents: 10000,
            dueDateEpochDay: Value(todayEpochDay),
            categoryId: 6,
            defaultPaymentMethodId: const Value(1),
            isCancelled: Value(index < 1000),
          ),
      ]);
    });
    await database.batch((batch) {
      batch.insertAll(database.obligationPayments, [
        for (var index = 1000; index < 6000; index++)
          ObligationPaymentsCompanion.insert(
            obligationId: index + 1,
            amountInCents: index < 3000 ? 10000 : 5000,
            dateEpochDay: todayEpochDay,
            paymentMethodId: 1,
          ),
      ]);
    });
    final obligationRepository = DriftObligationRepository(database);
    final reminderQueryTimings = <int>[];
    final previousReminderTimings = <int>[];
    Set<int>? reminderCandidateIds;
    for (var sample = 0; sample < 6; sample++) {
      reminderQueryTimings.add(
        await measure(() async {
          final candidates = await obligationRepository.getReminderCandidates();
          expect(candidates, hasLength(7000));
          reminderCandidateIds = candidates.map((item) => item.id).toSet();
        }),
      );
      previousReminderTimings.add(
        await measure(() async {
          final obligations = await obligationRepository.watchAll().first;
          final candidates = obligations
              .where(
                (item) =>
                    !item.isCancelled &&
                    item.dueDate != null &&
                    item.remainingAmountInCents > 0,
              )
              .map((item) => item.id)
              .toSet();
          expect(candidates, reminderCandidateIds);
        }),
      );
    }
    final sortedReminderQueryTimings = reminderQueryTimings.skip(1).toList()
      ..sort();
    final sortedPreviousReminderTimings =
        previousReminderTimings.skip(1).toList()..sort();
    report['reminder candidate query (10k obligations)'] =
        sortedReminderQueryTimings[sortedReminderQueryTimings.length ~/ 2];
    report['previous all reminder obligations'] =
        sortedPreviousReminderTimings[sortedPreviousReminderTimings.length ~/
            2];

    // ignore: avoid_print
    print(
      'Android SQLite profile: seed=${insertWatch.elapsedMilliseconds}ms; '
      '${report.entries.map((entry) => '${entry.key}=${entry.value}us').join('; ')}',
    );
  });
}
