import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/budgets/presentation/budgets_providers.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/categories/presentation/categories_providers.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';
import 'package:mony_multiplatform/features/statistics/presentation/statistics_page.dart';
import 'package:mony_multiplatform/features/statistics/domain/financial_statistics.dart';
import 'package:mony_multiplatform/features/statistics/domain/statistics_aggregate_snapshot.dart';
import 'package:mony_multiplatform/features/statistics/presentation/statistics_aggregate_providers.dart';

class _MemoryPreferencesRepository implements PreferencesRepository {
  @override
  Future<AppPreferences> load() async => AppPreferences.defaults;

  @override
  Future<void> save(AppPreferences preferences) async {}
}

void main() {
  testWidgets('shows totals, category distribution and cycle limit warnings', (
    tester,
  ) async {
    final now = DateTime.now();
    final food = Category(
      id: 6,
      name: 'Alimentación',
      type: CategoryType.expense,
      icon: 'restaurant',
      colorArgb: 0xFF008577,
      isActive: true,
      createdAt: now,
      budgetLimitInCents: 10000,
    );
    final salary = Category(
      id: 1,
      name: 'Salario',
      type: CategoryType.income,
      icon: 'payments',
      colorArgb: 0xFF008577,
      isActive: true,
      createdAt: now,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesProvider.overrideWith(
            (ref) => Stream.value([food, salary]),
          ),
          budgetConfigProvider.overrideWith((ref) => Stream.value(null)),
          budgetHistoryProvider.overrideWith((ref) => Stream.value(const [])),
          statisticsPeriodsProvider.overrideWith((ref, _) {
            final current = FinancialStatistics(
              incomeInCents: 100000,
              expenseInCents: 8000,
              transactionCount: 2,
              averageExpenseInCents: 8000,
              expenseByCategory: [
                CategoryStatistics(category: food, amountInCents: 8000),
              ],
            );
            return Stream.value(
              StatisticsAggregateSnapshot(
                statistics: current,
                previous: null,
                limitInsights: [
                  BudgetLimitInsight(
                    category: food,
                    limitInCents: 10000,
                    spentInCents: 8000,
                  ),
                ],
                evolution: [
                  for (var index = 0; index < 6; index++)
                    MonthlyStatistics(
                      month: DateTime(now.year, now.month - 5 + index),
                      incomeInCents: 100000,
                      expenseInCents: 8000,
                    ),
                ],
              ),
            );
          }),
          preferencesRepositoryProvider.overrideWithValue(
            _MemoryPreferencesRepository(),
          ),
        ],
        child: const MaterialApp(home: StatisticsPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Estadísticas'), findsOneWidget);
    expect(find.text('BALANCE DEL PERÍODO'), findsOneWidget);
    expect(find.text('INGRESOS Y GASTOS'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('EVOLUCIÓN'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('EVOLUCIÓN'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Límites del ciclo actual'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('Cerca del límite'), findsOneWidget);
  });
}
