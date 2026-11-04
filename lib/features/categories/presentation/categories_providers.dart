import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_categories_repository.dart';
import '../domain/categories_repository.dart';
import '../domain/category.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>(
  (ref) => DriftCategoriesRepository(ref.watch(appDatabaseProvider)),
);

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(categoriesRepositoryProvider).watchAll(),
);

final activeCategoriesProvider = StreamProvider.autoDispose
    .family<List<Category>, CategoryType>(
      (ref, type) => ref.watch(categoriesRepositoryProvider).watchActive(type),
    );
