enum CategoryType { income, expense }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.colorArgb,
    required this.isActive,
    required this.createdAt,
    this.budgetLimitInCents,
  });

  final int id;
  final String name;
  final CategoryType type;
  final String icon;
  final int colorArgb;
  final bool isActive;
  final DateTime createdAt;
  final int? budgetLimitInCents;
}
