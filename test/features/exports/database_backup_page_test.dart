import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/exports/presentation/database_backup_page.dart';

void main() {
  testWidgets(
    'describes the encrypted copy and confirms before replacing data',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DatabaseBackupPage()));
      final semantics = tester.ensureSemantics();
    await tester.drag(find.byType(ListView), const Offset(0, -520));
    await tester.pumpAndSettle();
      expect(find.text('Copia de seguridad'), findsOneWidget);
      expect(find.text('Crear y guardar copia'), findsOneWidget);
      expect(find.text('Seleccionar y restaurar copia'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Contraseña (12 caracteres mínimo)'),
        findsOneWidget,
      );
      semantics.dispose();
    },
  );
}
