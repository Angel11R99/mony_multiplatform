import '../domain/barcode_product.dart';
import '../domain/barcode_product_repository.dart';

class CachedBarcodeProductRepository implements BarcodeProductRepository {
  const CachedBarcodeProductRepository({
    required this.cache,
    required this.catalog,
  });

  final BarcodeProductCache cache;
  final BarcodeProductCatalog catalog;

  @override
  Future<BarcodeLookupResult?> lookup(
    String barcode, {
    required bool allowNetwork,
  }) async {
    final cached = await cache.read(barcode);
    if (!allowNetwork) {
      return cached == null
          ? null
          : BarcodeLookupResult(product: cached, fromCache: true);
    }
    try {
      final remote = await catalog.fetch(barcode);
      if (remote == null) {
        return cached == null
            ? null
            : BarcodeLookupResult(product: cached, fromCache: true);
      }
      await cache.write(remote);
      return BarcodeLookupResult(product: remote, fromCache: false);
    } catch (_) {
      if (cached != null) {
        return BarcodeLookupResult(product: cached, fromCache: true);
      }
      rethrow;
    }
  }
}
