import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/category.dart';
import 'categories_providers.dart';
import 'category_icons.dart';

/// Live selector for future transaction forms. Inactive categories are
/// intentionally excluded while their IDs remain stable in the database.
class CategoryPicker extends ConsumerWidget {
  const CategoryPicker({
    required this.type,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final CategoryType type;
  final int? value;
  final ValueChanged<Category?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(activeCategoriesProvider(type));
    return categories.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stack) =>
          const Text('No se pudieron cargar las categorías.'),
      data: (items) {
        if (items.isEmpty) {
          return const Text('No hay categorías activas para este tipo.');
        }
        return DropdownButtonFormField<int>(
          initialValue: items.any((item) => item.id == value) ? value : null,
          decoration: const InputDecoration(labelText: 'Categoría'),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item.id,
                  child: Row(
                    children: [
                      Icon(
                        categoryIcons[item.icon] ?? Icons.label_outline,
                        color: Color(item.colorArgb),
                      ),
                      const SizedBox(width: 10),
                      Text(item.name),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (id) => onChanged(
            id == null ? null : items.firstWhere((item) => item.id == id),
          ),
          validator: (id) => id == null ? 'Selecciona una categoría' : null,
        );
      },
    );
  }
}
