import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/core/database/app_database_provider.dart';
import 'package:mony_multiplatform/features/budgets/presentation/budgets_page.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

class _MemoryPreferencesRepository implements PreferencesRepository {
  @override
  Future<AppPreferences> load() async => AppPreferences.defaults;

  @override
  Future<void> save(AppPreferences preferences) async {}
}

void main() {
  testWidgets(
    'configures a period, assigns category limits and updates usage',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            preferencesRepositoryProvider.overrideWithValue(
              _MemoryPreferencesRepository(),
            ),
          ],
          child: const MaterialApp(home: BudgetsPage()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Configurar presupuesto').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '75.00');
      await tester.tap(find.text('Mensual'));
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.text('RD\$75.00'), findsWidgets);
      await tester.scrollUntilVisible(
        find.text('Alimentación'),
        280,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Asignar límite a Alimentación'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '50.00');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.text('RD\$0.00 de RD\$50.00'), findsOneWidget);

      final now = DateTime.now();
      await DriftTransactionRepository(database).create(
        FinanceTransaction(
          amountInCents: 12000,
          type: TransactionType.expense,
          categoryId: 6,
          paymentMethodId: 1,
          description: 'Compra de prueba',
          date: now,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('RD\$120.00 de RD\$50.00'), findsOneWidget);
      expect(find.text('240%'), findsOneWidget);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 1000));
      await tester.pumpAndSettle();
      expect(
        find.text('Presupuesto excedido · 160% utilizado'),
        findsOneWidget,
      );

      await tester.tap(find.text('Próximo'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Alimentación'),
        280,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('RD\$0.00 de RD\$50.00'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await database.close();
    },
  );
}
