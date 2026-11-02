import 'barcode_product.dart';

abstract interface class BarcodeProductRepository {
  Future<BarcodeLookupResult?> lookup(
    String barcode, {
    required bool allowNetwork,
  });
}

abstract interface class BarcodeProductCache {
  Future<BarcodeProduct?> read(String barcode);
  Future<void> write(BarcodeProduct product);
}

abstract interface class BarcodeProductCatalog {
  Future<BarcodeProduct?> fetch(String barcode);
}
