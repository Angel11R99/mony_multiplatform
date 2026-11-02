import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/barcodes/domain/barcode_product.dart';
import 'package:mony_multiplatform/features/barcodes/domain/barcode_product_repository.dart';
import 'package:mony_multiplatform/features/barcodes/presentation/barcode_providers.dart';
import 'package:mony_multiplatform/features/barcodes/presentation/barcode_scanner_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
  });
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  testWidgets('offers manual entry when the platform has no camera support', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          barcodeProductRepositoryProvider.overrideWith(
            (ref) async => _FakeRepository(),
          ),
        ],
        child: const MaterialApp(home: BarcodeScannerPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text(
        'La cámara no está disponible en esta plataforma. Usa la entrada manual.',
      ),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('manual barcode lookup shows cached product details', (
    tester,
  ) async {
    final repository = _FakeRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          barcodeProductRepositoryProvider.overrideWith(
            (ref) async => repository,
          ),
        ],
        child: const MaterialApp(home: BarcodeScannerPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '1234567890123');
    await tester.tap(find.byTooltip('Consultar código'));
    await tester.pumpAndSettle();

    expect(repository.lookedUpCode, '1234567890123');
    expect(find.text('Arroz'), findsOneWidget);
    expect(
      find.text('Resultado guardado en este dispositivo.'),
      findsOneWidget,
    );
    debugDefaultTargetPlatformOverride = null;
  });
}

class _FakeRepository implements BarcodeProductRepository {
  String? lookedUpCode;

  @override
  Future<BarcodeLookupResult?> lookup(
    String barcode, {
    required bool allowNetwork,
  }) async {
    lookedUpCode = barcode;
    return BarcodeLookupResult(
      product: BarcodeProduct(
        barcode: barcode,
        name: 'Arroz',
        updatedAt: DateTime.now(),
      ),
      fromCache: true,
    );
  }
}
