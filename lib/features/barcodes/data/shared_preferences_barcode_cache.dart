import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/barcode_product.dart';
import '../domain/barcode_product_repository.dart';

class SharedPreferencesBarcodeProductCache implements BarcodeProductCache {
  SharedPreferencesBarcodeProductCache(this._preferences);
  final SharedPreferences _preferences;

  static const _key = 'barcode_product_cache_v1';
  static const _maxEntries = 100;
  static const _maxAge = Duration(days: 30);

  @override
  Future<BarcodeProduct?> read(String barcode) async {
    final products = _readAll();
    final product = products[barcode];
    if (product == null) return null;
    if (DateTime.now().difference(product.updatedAt) > _maxAge) {
      products.remove(barcode);
      await _writeAll(products);
      return null;
    }
    return product;
  }

  @override
  Future<void> write(BarcodeProduct product) async {
    final products = _readAll()..remove(product.barcode);
    products[product.barcode] = product;
    while (products.length > _maxEntries) {
      products.remove(products.keys.first);
    }
    await _writeAll(products);
  }

  Map<String, BarcodeProduct> _readAll() {
    final raw = _preferences.getString(_key);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return {};
      final products = <String, BarcodeProduct>{};
      for (final value in decoded) {
        final product = BarcodeProduct.fromJson(value);
        if (product != null) products[product.barcode] = product;
      }
      return products;
    } on FormatException {
      return {};
    }
  }

  Future<void> _writeAll(Map<String, BarcodeProduct> products) =>
      _preferences.setString(
        _key,
        jsonEncode(products.values.map((product) => product.toJson()).toList()),
      );
}
