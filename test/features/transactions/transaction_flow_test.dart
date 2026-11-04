import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toastification/toastification.dart';
import 'package:mony_multiplatform/core/database/app_database_provider.dart';
import 'package:mony_multiplatform/core/routing/app_router.dart';
import 'package:mony_multiplatform/features/transactions/presentation/transactions_page.dart';
import '../../support/test_database.dart';

void main() {
  testWidgets('creates an income and returns to the persisted movement list', (
    tester,
  ) async {
    final database = createTestDatabase();
    final router = createAppRouter(initialLocation: '/transactions/new');
    addTearDown(() async {
      toastification.dismissAll(delayForAnimation: false);
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
      await database.close();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ingreso'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '1234,50');
    await tester.tap(find.text('Categoría'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salario').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'Pago de nómina');
    await tester.tap(find.text('Guardar movimiento'));
    await tester.pumpAndSettle();

    expect(find.byType(TransactionsPage), findsOneWidget);
    expect(find.text('Pago de nómina'), findsOneWidget);
    expect(find.textContaining('+RD\$1,234.50'), findsOneWidget);

    await tester.tap(find.text('Pago de nómina'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle del movimiento'), findsOneWidget);
    expect(find.text('Efectivo'), findsOneWidget);
    toastification.dismissAll(delayForAnimation: false);
    await tester.pump(const Duration(milliseconds: 250));
  });
}
