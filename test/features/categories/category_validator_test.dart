import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/categories/domain/category_validator.dart';

void main() {
  Category category(
    int id,
    String name,
    CategoryType type, {
    bool active = true,
  }) => Category(
    id: id,
    name: name,
    type: type,
    icon: 'category',
    colorArgb: 0xFF7C3AED,
    isActive: active,
    createdAt: DateTime(2026),
  );

  test('requires a non-empty name up to 40 characters', () {
    expect(
      CategoryValidator.validateName('  ', CategoryType.expense, const []),
      'Escribe el nombre de la categoría',
    );
    expect(
      CategoryValidator.validateName('x' * 41, CategoryType.expense, const []),
      'El nombre no puede tener más de 40 caracteres',
    );
    expect(
      CategoryValidator.validateName(
        'Mascotas',
        CategoryType.expense,
        const [],
      ),
      isNull,
    );
  });

  test('detects case-insensitive duplicates including archived categories', () {
    final existing = [
      category(1, 'Alimentación', CategoryType.expense, active: false),
    ];
    expect(
      CategoryValidator.validateName(
        '  alimentación ',
        CategoryType.expense,
        existing,
      ),
      'Ya existe una categoría con ese nombre',
    );
    expect(
      CategoryValidator.validateName(
        'ALIMENTACIÓN',
        CategoryType.expense,
        existing,
        excludeId: 1,
      ),
      isNull,
    );
    expect(
      CategoryValidator.validateName(
        'Alimentación',
        CategoryType.income,
        existing,
      ),
      isNull,
    );
  });

  test('requires at least one active income category', () {
    final salary = category(1, 'Salario', CategoryType.income);
    expect(
      CategoryValidator.lastActiveIncomeError(salary, [salary]),
      'Debe existir al menos una categoría de ingresos activa',
    );
    expect(
      CategoryValidator.lastActiveIncomeError(salary, [
        salary,
        category(2, 'Freelance', CategoryType.income),
      ]),
      isNull,
    );
    expect(
      CategoryValidator.lastActiveIncomeError(
        category(3, 'Otros', CategoryType.expense),
        [category(3, 'Otros', CategoryType.expense)],
      ),
      isNull,
    );
  });
}
