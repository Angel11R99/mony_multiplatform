class BarcodeProduct {
  const BarcodeProduct({
    required this.barcode,
    required this.name,
    this.brand,
    this.quantity,
    this.imageUrl,
    required this.updatedAt,
  });

  final String barcode;
  final String name;
  final String? brand;
  final String? quantity;
  final String? imageUrl;
  final DateTime updatedAt;

  String get displayName =>
      name.trim().isEmpty ? 'Producto $barcode' : name.trim();

  Map<String, Object?> toJson() => {
    'barcode': barcode,
    'name': name,
    'brand': brand,
    'quantity': quantity,
    'imageUrl': imageUrl,
    'updatedAt': updatedAt.toIso8601String(),
  };

  static BarcodeProduct? fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final barcode = value['barcode'];
    final name = value['name'];
    final updatedAt = DateTime.tryParse(value['updatedAt'] as String? ?? '');
    if (barcode is! String || name is! String || updatedAt == null) return null;
    return BarcodeProduct(
      barcode: barcode,
      name: name,
      brand: value['brand'] is String ? value['brand'] as String : null,
      quantity: value['quantity'] is String
          ? value['quantity'] as String
          : null,
      imageUrl: value['imageUrl'] is String
          ? value['imageUrl'] as String
          : null,
      updatedAt: updatedAt,
    );
  }
}

class BarcodeLookupResult {
  const BarcodeLookupResult({required this.product, required this.fromCache});
  final BarcodeProduct product;
  final bool fromCache;
}

bool isValidProductBarcode(String value) =>
    RegExp(r'^\d{8}$|^\d{12,14}$').hasMatch(value);
