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
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/transactions/presentation/transactions_providers.dart';

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
    FinanceTransaction transaction(
      int amount,
      TransactionType type,
      int category,
    ) => FinanceTransaction(
      amountInCents: amount,
      type: type,
      categoryId: category,
      paymentMethodId: 1,
      description: 'Movimiento de prueba',
      date: now,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsProvider.overrideWith(
            (ref) => Stream.value([
              transaction(100000, TransactionType.income, salary.id),
              transaction(8000, TransactionType.expense, food.id),
            ]),
          ),
          categoriesProvider.overrideWith(
            (ref) => Stream.value([food, salary]),
          ),
          budgetConfigProvider.overrideWith((ref) => Stream.value(null)),
          preferencesRepositoryProvider.overrideWithValue(
            _MemoryPreferencesRepository(),
          ),
        ],
        child: const MaterialApp(home: StatisticsPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Estadísticas'), findsOneWidget);
    expect(find.text('BALANCE DEL PERÍODO'), findsOneWidget);
    expect(find.text('INGRESOS Y GASTOS'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('EVOLUCIÓN'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.textContaining('EVOLUCIÓN'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Límites del ciclo actual'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('Cerca del límite'), findsOneWidget);
  });
}
