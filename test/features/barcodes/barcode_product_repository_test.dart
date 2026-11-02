import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mony_multiplatform/features/barcodes/data/cached_barcode_product_repository.dart';
import 'package:mony_multiplatform/features/barcodes/data/open_food_facts_catalog.dart';
import 'package:mony_multiplatform/features/barcodes/data/shared_preferences_barcode_cache.dart';
import 'package:mony_multiplatform/features/barcodes/domain/barcode_product.dart';
import 'package:mony_multiplatform/features/barcodes/domain/barcode_product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('accepts common GTIN lengths and rejects malformed codes', () {
    for (final code in [
      '12345670',
      '123456789012',
      '1234567890123',
      '12345678901234',
    ]) {
      expect(isValidProductBarcode(code), isTrue);
    }
    for (final code in [
      '',
      '1234567',
      '123456789',
      '123456789012345',
      '12345ABC',
    ]) {
      expect(isValidProductBarcode(code), isFalse);
    }
  });

  test(
    'parses catalog product fields and requests only the needed fields',
    () async {
      final client = _FakeClient((request) {
        expect(request.url.host, 'world.openfoodfacts.org');
        expect(
          request.url.queryParameters['fields'],
          'code,product_name,brands,quantity,image_url',
        );
        expect(request.headers['User-Agent'], 'Mony/1.0');
        return http.Response(
          jsonEncode({
            'status': 1,
            'product': {
              'product_name': 'Leche entera',
              'brands': 'Marca',
              'quantity': '1 L',
              'image_url': 'https://images.example.test/product.jpg',
            },
          }),
          200,
        );
      });
      final product = await OpenFoodFactsCatalog(client).fetch('1234567890123');
      expect(product?.name, 'Leche entera');
      expect(product?.brand, 'Marca');
      expect(product?.quantity, '1 L');
      expect(product?.imageUrl, startsWith('https://'));
    },
  );

  test(
    'returns the cached item while offline and falls back on network errors',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final cache = SharedPreferencesBarcodeProductCache(preferences);
      final product = BarcodeProduct(
        barcode: '1234567890123',
        name: 'Arroz',
        updatedAt: DateTime.now(),
      );
      await cache.write(product);
      final repository = CachedBarcodeProductRepository(
        cache: cache,
        catalog: _ThrowingCatalog(),
      );
      final result = await repository.lookup(
        product.barcode,
        allowNetwork: false,
      );
      expect(result?.product.name, 'Arroz');
      expect(result?.fromCache, isTrue);
      final fallback = await repository.lookup(
        product.barcode,
        allowNetwork: true,
      );
      expect(fallback?.fromCache, isTrue);
    },
  );

  test('expires cached products after thirty days', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final cache = SharedPreferencesBarcodeProductCache(preferences);
    final product = BarcodeProduct(
      barcode: '1234567890123',
      name: 'Antiguo',
      updatedAt: DateTime.now().subtract(const Duration(days: 31)),
    );
    await cache.write(product);
    expect(await cache.read(product.barcode), isNull);
  });
}

class _FakeClient extends http.BaseClient {
  _FakeClient(this.respond);
  final http.Response Function(http.BaseRequest request) respond;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = respond(request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
    );
  }
}

class _ThrowingCatalog implements BarcodeProductCatalog {
  @override
  Future<BarcodeProduct?> fetch(String barcode) =>
      Future.error(http.ClientException('offline'));
}
