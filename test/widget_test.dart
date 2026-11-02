import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/app/app.dart';

void main() {
  testWidgets('starts on home and navigates to the about screen', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MonyApp()));

    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
    await tester.tap(find.text('Explorar la app'));
    await tester.pumpAndSettle();

    expect(find.text('Acerca de Mony'), findsOneWidget);
    await tester.tap(find.text('Volver al inicio'));
    await tester.pumpAndSettle();

    expect(find.text('Tus finanzas, en un solo lugar'), findsOneWidget);
  });
}
