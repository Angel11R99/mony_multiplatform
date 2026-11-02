import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/money_formatter.dart';
import '../../../core/theme/finance_color_names.dart';
import '../domain/categories_repository.dart';
import '../domain/category.dart';
import '../domain/category_validator.dart';
import 'categories_providers.dart';
import 'category_icons.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  CategoryType _type = CategoryType.expense;
  bool _showArchived = false;
  bool _saving = false;

  Future<void> _edit(List<Category> all, [Category? category]) async {
    final draft = await showDialog<_CategoryDraft>(
      context: context,
      builder: (_) => _CategoryEditor(category: category, initialType: _type),
    );
    if (draft == null || !mounted) return;

    final validationError = CategoryValidator.validateName(
      draft.name,
      draft.type,
      all,
      excludeId: category?.id,
    );
    if (validationError != null) {
      _message(validationError);
      return;
    }

    setState(() => _saving = true);
    try {
      final repository = ref.read(categoriesRepositoryProvider);
      if (category == null) {
        await repository.create(
          name: draft.name,
          type: draft.type,
          icon: draft.icon,
          colorArgb: draft.colorArgb,
          budgetLimitInCents: draft.budgetLimitInCents,
        );
        _message('Categoría creada correctamente.');
      } else {
        await repository.update(
          id: category.id,
          name: draft.name,
          icon: draft.icon,
          colorArgb: draft.colorArgb,
          budgetLimitInCents: draft.budgetLimitInCents,
        );
        _message('Categoría actualizada.');
      }
    } on InvalidCategoryException catch (error) {
      _message(error.message);
    } catch (_) {
      _message('No se pudo guardar la categoría. Inténtalo de nuevo.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggle(Category category, List<Category> all) async {
    if (category.isActive) {
      final validationError = CategoryValidator.lastActiveIncomeError(
        category,
        all,
      );
      if (validationError != null) {
        _message(validationError);
        return;
      }
    }
    try {
      final repository = ref.read(categoriesRepositoryProvider);
      await repository.setActive(category.id, !category.isActive);
      if (category.isActive && mounted) {
        MonyFeedback.undo(
          context,
          'Categoría archivada. Se conserva el historial y no estará disponible en movimientos nuevos.',
          onUndo: () => repository.setActive(category.id, true),
        );
      } else {
        _message('Categoría restaurada.');
      }
    } on LastActiveIncomeCategoryException {
      _message('Debe existir al menos una categoría de ingresos activa.');
    } on CategoryUnavailableException {
      _message(
        'No encontramos la categoría. Actualiza la lista e inténtalo de nuevo.',
      );
    } catch (_) {
      _message('No se pudo actualizar la categoría.');
    }
  }

  void _message(String value) {
    if (!mounted) return;
    MonyFeedback.info(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving
            ? null
            : () => categories.whenData((items) => _edit(items)),
        icon: const Icon(Icons.add),
        label: const Text('Nueva categoría'),
      ),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            _CategoriesError(onRetry: () => ref.invalidate(categoriesProvider)),
        data: (all) {
          final visible = all
              .where(
                (item) => item.type == _type && item.isActive != _showArchived,
              )
              .toList(growable: false);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: SegmentedButton<CategoryType>(
                  segments: const [
                    ButtonSegment(
                      value: CategoryType.expense,
                      label: Text('Gastos'),
                      icon: Icon(Icons.south_west),
                    ),
                    ButtonSegment(
                      value: CategoryType.income,
                      label: Text('Ingresos'),
                      icon: Icon(Icons.north_east),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selection) =>
                      setState(() => _type = selection.first),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _showArchived
                            ? 'Las archivadas conservan su historial.'
                            : 'Administra las categorías disponibles.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          setState(() => _showArchived = !_showArchived),
                      icon: Icon(
                        _showArchived
                            ? Icons.visibility_outlined
                            : Icons.archive_outlined,
                      ),
                      label: Text(_showArchived ? 'Activas' : 'Archivadas'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? _CategoriesEmpty(
                        archived: _showArchived,
                        onAdd: () => _edit(all),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final category = visible[index];
                          return _CategoryTile(
                            category: category,
                            onEdit: () => _edit(all, category),
                            onToggle: () => _toggle(category, all),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({
    required this.category,
    required this.onEdit,
    required this.onToggle,
  });
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(category.colorArgb);
    final currencyStyle =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        CurrencyFormatStyle.symbol;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(
            categoryIcons[category.icon] ?? Icons.label_outline,
            color: color,
          ),
        ),
        title: Text(category.name),
        subtitle: Text(
          category.budgetLimitInCents == null
              ? (category.isActive ? 'Activa' : 'Archivada')
              : '${category.isActive ? 'Límite' : 'Archivada · límite'}: ${MoneyFormatter.formatDopMinorUnits(category.budgetLimitInCents!, style: currencyStyle)}',
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Acciones para ${category.name}',
          onSelected: (value) => value == 'edit' ? onEdit() : onToggle(),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Editar'),
              ),
            ),
            PopupMenuItem(
              value: 'toggle',
              child: ListTile(
                leading: Icon(
                  category.isActive
                      ? Icons.archive_outlined
                      : Icons.unarchive_outlined,
                ),
                title: Text(category.isActive ? 'Archivar' : 'Restaurar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesEmpty extends StatelessWidget {
  const _CategoriesEmpty({required this.archived, required this.onAdd});
  final bool archived;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            archived ? Icons.archive_outlined : Icons.category_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            archived
                ? 'No hay categorías archivadas.'
                : 'Aún no hay categorías aquí.',
            textAlign: TextAlign.center,
          ),
          if (!archived) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Crear categoría'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _CategoriesError extends StatelessWidget {
  const _CategoriesError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar las categorías.'),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
        ),
      ],
    ),
  );
}

class _CategoryDraft {
  const _CategoryDraft({
    required this.name,
    required this.type,
    required this.icon,
    required this.colorArgb,
    this.budgetLimitInCents,
  });
  final String name;
  final CategoryType type;
  final String icon;
  final int colorArgb;
  final int? budgetLimitInCents;
}

class _CategoryEditor extends StatefulWidget {
  const _CategoryEditor({required this.category, required this.initialType});
  final Category? category;
  final CategoryType initialType;

  @override
  State<_CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<_CategoryEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _limit;
  late CategoryType _type;
  late String _icon;
  late int _color;

  static const _colors = <int>[
    0xFFEF4444,
    0xFFEC4899,
    0xFF9333EA,
    0xFF7C3AED,
    0xFF3B82F6,
    0xFF0891B2,
    0xFF0D9488,
    0xFF16A34A,
    0xFFEAB308,
    0xFFD97706,
    0xFFEA580C,
    0xFF71717A,
  ];

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _name = TextEditingController(text: category?.name ?? '');
    _limit = TextEditingController(
      text: _limitString(category?.budgetLimitInCents),
    );
    _type = category?.type ?? widget.initialType;
    _icon = category?.icon ?? 'category';
    _color = category?.colorArgb ?? _colors[3];
  }

  @override
  void dispose() {
    _name.dispose();
    _limit.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final cents = _parseLimit(_limit.text);
    if (cents == null && _limit.text.trim().isNotEmpty) return;
    Navigator.pop(
      context,
      _CategoryDraft(
        name: _name.text.trim(),
        type: _type,
        icon: _icon,
        colorArgb: _color,
        budgetLimitInCents: cents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.category == null ? 'Nueva categoría' : 'Editar categoría',
    ),
    content: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.category == null) ...[
              SegmentedButton<CategoryType>(
                segments: const [
                  ButtonSegment(
                    value: CategoryType.expense,
                    label: Text('Gasto'),
                  ),
                  ButtonSegment(
                    value: CategoryType.income,
                    label: Text('Ingreso'),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (selection) =>
                    setState(() => _type = selection.first),
              ),
              const SizedBox(height: 14),
            ],
            TextFormField(
              controller: _name,
              autofocus: true,
              maxLength: CategoryValidator.maxNameLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej. Transporte',
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) return 'Escribe el nombre de la categoría';
                return name.length > CategoryValidator.maxNameLength
                    ? 'Máximo 40 caracteres'
                    : null;
              },
            ),
            const SizedBox(height: 10),
            Text('Icono', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoryIcons.entries
                  .map(
                    (entry) => Semantics(
                      selected: _icon == entry.key,
                      child: IconButton.filledTonal(
                        tooltip: 'Icono ${entry.key}',
                        onPressed: () => setState(() => _icon = entry.key),
                        style: IconButton.styleFrom(
                          backgroundColor: _icon == entry.key
                              ? Color(_color).withValues(alpha: 0.28)
                              : null,
                        ),
                        icon: Icon(
                          entry.value,
                          color: _icon == entry.key ? Color(_color) : null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 14),
            Text('Color', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: _colors
                  .map(
                    (color) => Semantics(
                      button: true,
                      selected: _color == color,
                      label: 'Color ${financeColorName(color)}',
                      child: Tooltip(
                        message: 'Seleccionar color ${financeColorName(color)}',
                        child: InkWell(
                          onTap: () => setState(() => _color = color),
                          customBorder: const CircleBorder(),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(color),
                            child: _color == color
                                ? const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _limit,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Límite de presupuesto (opcional)',
                prefixText: 'DOP ',
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                return text.isEmpty || _parseLimit(text) != null
                    ? null
                    : 'Introduce un importe válido y positivo';
              },
            ),
            const SizedBox(height: 4),
            Text(
              'El límite se guarda en centavos y puede dejarse vacío.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _save, child: const Text('Guardar')),
    ],
  );
}

int? _parseLimit(String raw) {
  final normalized = raw.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return null;
  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(normalized)) return null;
  final parts = normalized.split('.');
  final whole = int.tryParse(parts.first);
  if (whole == null) return null;
  final fraction = parts.length == 1
      ? 0
      : int.parse(parts.last.padRight(2, '0'));
  return whole * 100 + fraction;
}

String _limitString(int? cents) => cents == null
    ? ''
    : '${cents ~/ 100}.${(cents % 100).toString().padLeft(2, '0')}';
