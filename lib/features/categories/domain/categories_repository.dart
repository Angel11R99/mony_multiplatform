import 'category.dart';

abstract interface class CategoriesRepository {
  Stream<List<Category>> watchAll();
  Stream<List<Category>> watchActive(CategoryType type);
  Future<void> create({
    required String name,
    required CategoryType type,
    required String icon,
    required int colorArgb,
    int? budgetLimitInCents,
  });
  Future<void> update({
    required int id,
    required String name,
    required String icon,
    required int colorArgb,
    int? budgetLimitInCents,
  });
  Future<void> setActive(int id, bool isActive);
}

final class InvalidCategoryException implements Exception {
  const InvalidCategoryException(this.message);
  final String message;
}

final class CategoryUnavailableException implements Exception {
  const CategoryUnavailableException();
}

final class LastActiveIncomeCategoryException implements Exception {
  const LastActiveIncomeCategoryException();
}
