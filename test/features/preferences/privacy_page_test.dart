import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/preferences/presentation/privacy_page.dart';

void main() {
  testWidgets(
    'explains local processing and exposes backup controls to assistive tech',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PrivacyPage()));
      final semantics = tester.ensureSemantics();
      expect(find.text('Privacidad y datos'), findsOneWidget);
      expect(find.textContaining('base local de la app'), findsOneWidget);
      expect(find.textContaining('Open Food Facts'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Administrar copia cifrada'),
        250,
        scrollable: find.byType(Scrollable),
      );
      expect(
        find.bySemanticsLabel('Administrar copia cifrada'),
        findsOneWidget,
      );
      semantics.dispose();
    },
  );
}
