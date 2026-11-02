import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/cached_barcode_product_repository.dart';
import '../data/open_food_facts_catalog.dart';
import '../data/shared_preferences_barcode_cache.dart';
import '../domain/barcode_product_repository.dart';

final barcodeProductRepositoryProvider =
    FutureProvider<BarcodeProductRepository>((ref) async {
      final preferences = await SharedPreferences.getInstance();
      final client = http.Client();
      ref.onDispose(client.close);
      return CachedBarcodeProductRepository(
        cache: SharedPreferencesBarcodeProductCache(preferences),
        catalog: OpenFoodFactsCatalog(client),
      );
    });
