import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/barcode_product.dart';
import '../domain/barcode_product_repository.dart';

class OpenFoodFactsCatalog implements BarcodeProductCatalog {
  OpenFoodFactsCatalog(this._client);
  final http.Client _client;

  @override
  Future<BarcodeProduct?> fetch(String barcode) async {
    final uri = Uri.https(
      'world.openfoodfacts.org',
      '/api/v2/product/$barcode',
      {'fields': 'code,product_name,brands,quantity,image_url'},
    );
    final response = await _client
        .get(uri, headers: const {'User-Agent': 'Mony/1.0'})
        .timeout(const Duration(seconds: 8));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw const ProductCatalogException('El catálogo no respondió.');
    }
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic> || decoded['status'] != 1) return null;
    final product = decoded['product'];
    if (product is! Map<String, dynamic>) return null;
    final name = product['product_name']?.toString().trim() ?? '';
    if (name.isEmpty) return null;
    return BarcodeProduct(
      barcode: barcode,
      name: name,
      brand: _nullableString(product['brands']),
      quantity: _nullableString(product['quantity']),
      imageUrl: _validImageUrl(product['image_url']),
      updatedAt: DateTime.now(),
    );
  }
}

String? _nullableString(Object? value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}

String? _validImageUrl(Object? value) {
  final text = _nullableString(value);
  final uri = text == null ? null : Uri.tryParse(text);
  return uri != null && uri.scheme == 'https' ? uri.toString() : null;
}

class ProductCatalogException implements Exception {
  const ProductCatalogException(this.message);
  final String message;
}
