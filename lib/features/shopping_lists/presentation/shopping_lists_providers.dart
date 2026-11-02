import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_shopping_list_repository.dart';
import '../domain/shopping_list.dart';
import '../domain/shopping_list_repository.dart';

final shoppingListRepositoryProvider = Provider<ShoppingListRepository>(
  (ref) => DriftShoppingListRepository(ref.watch(appDatabaseProvider)),
);

final shoppingListOverviewsProvider =
    StreamProvider<List<ShoppingListOverview>>(
      (ref) => ref.watch(shoppingListRepositoryProvider).watchOverviews(),
    );

final shoppingListDetailsProvider =
    StreamProvider.family<ShoppingListDetails?, int>(
      (ref, listId) =>
          ref.watch(shoppingListRepositoryProvider).watchDetails(listId),
    );
