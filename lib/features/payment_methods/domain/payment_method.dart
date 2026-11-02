class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorArgb,
    required this.isActive,
    required this.isDefault,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String icon;
  final int colorArgb;
  final bool isActive;
  final bool isDefault;
  final DateTime createdAt;

  PaymentMethod copyWith({
    String? name,
    String? icon,
    int? colorArgb,
    bool? isActive,
    bool? isDefault,
  }) => PaymentMethod(
    id: id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorArgb: colorArgb ?? this.colorArgb,
    isActive: isActive ?? this.isActive,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt,
  );
}
