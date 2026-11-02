import 'category.dart';

abstract final class CategoryValidator {
  static const maxNameLength = 40;

  static String? validateName(
    String rawName,
    CategoryType type,
    List<Category> existing, {
    int? excludeId,
  }) {
    final name = rawName.trim();
    if (name.isEmpty) return 'Escribe el nombre de la categoría';
    if (name.length > maxNameLength) {
      return 'El nombre no puede tener más de $maxNameLength caracteres';
    }
    if (existing.any(
      (category) =>
          category.id != excludeId &&
          category.type == type &&
          category.name.toLowerCase() == name.toLowerCase(),
    )) {
      return 'Ya existe una categoría con ese nombre';
    }
    return null;
  }

  static String? lastActiveIncomeError(Category category, List<Category> all) {
    if (category.type != CategoryType.income || !category.isActive) return null;
    final otherActiveIncome = all.any(
      (item) =>
          item.id != category.id &&
          item.type == CategoryType.income &&
          item.isActive,
    );
    return otherActiveIncome
        ? null
        : 'Debe existir al menos una categoría de ingresos activa';
  }
}
