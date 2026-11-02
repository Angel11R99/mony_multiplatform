import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/payment_method.dart';
import '../domain/payment_method_validator.dart';
import '../domain/payment_methods_repository.dart';
import 'payment_method_icons.dart';
import 'payment_methods_providers.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  bool _showArchived = false;
  bool _saving = false;

  Future<void> _edit(List<PaymentMethod> all, [PaymentMethod? method]) async {
    final draft = await showDialog<_PaymentMethodDraft>(
      context: context,
      builder: (_) => _PaymentMethodEditor(method: method),
    );
    if (draft == null || !mounted) return;
    final validationError = PaymentMethodValidator.validateName(
      draft.name,
      all,
      excludeId: method?.id,
    );
    if (validationError != null) {
      _message(validationError);
      return;
    }

    setState(() => _saving = true);
    try {
      final repository = ref.read(paymentMethodsRepositoryProvider);
      if (method == null) {
        await repository.create(
          name: draft.name,
          icon: draft.icon,
          colorArgb: draft.colorArgb,
        );
        _message('Método de pago creado.');
      } else {
        await repository.update(
          id: method.id,
          name: draft.name,
          icon: draft.icon,
          colorArgb: draft.colorArgb,
        );
        _message('Método de pago actualizado.');
      }
    } catch (_) {
      _message('No se pudo guardar el método de pago. Inténtalo de nuevo.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggle(PaymentMethod method) async {
    try {
      await ref
          .read(paymentMethodsRepositoryProvider)
          .setActive(method.id, !method.isActive);
      _message(
        method.isActive
            ? method.isDefault
                  ? 'Método archivado y predeterminado reasignado.'
                  : 'Método archivado. Sus referencias se conservan.'
            : 'Método restaurado.',
      );
    } on LastActivePaymentMethodException {
      _message('Debe existir al menos un método de pago activo.');
    } catch (_) {
      _message('No se pudo actualizar el método de pago.');
    }
  }

  Future<void> _setDefault(PaymentMethod method) async {
    try {
      await ref.read(paymentMethodsRepositoryProvider).setDefault(method.id);
      _message('${method.name} ahora es el método predeterminado.');
    } on PaymentMethodUnavailableException {
      _message('Restaura el método antes de elegirlo como predeterminado.');
    } catch (_) {
      _message('No se pudo cambiar el método predeterminado.');
    }
  }

  void _message(String text) {
    if (!mounted) return;
    MonyFeedback.info(context, text);
  }

  @override
  Widget build(BuildContext context) {
    final methods = ref.watch(paymentMethodsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Métodos de pago')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving
            ? null
            : () => methods.whenData((items) => _edit(items)),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo método'),
      ),
      body: methods.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _PaymentMethodsError(
          onRetry: () => ref.invalidate(paymentMethodsProvider),
        ),
        data: (all) {
          final visible = all
              .where((item) => item.isActive != _showArchived)
              .toList(growable: false);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _showArchived
                            ? 'Los métodos archivados conservan sus referencias.'
                            : 'Elige el método inicial para nuevos movimientos.',
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
                      label: Text(_showArchived ? 'Activos' : 'Archivados'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? _PaymentMethodsEmpty(
                        archived: _showArchived,
                        onAdd: () => _edit(all),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final method = visible[index];
                          return _PaymentMethodTile(
                            method: method,
                            onEdit: () => _edit(all, method),
                            onSetDefault: () => _setDefault(method),
                            onToggle: () => _toggle(method),
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

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.onEdit,
    required this.onSetDefault,
    required this.onToggle,
  });

  final PaymentMethod method;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = Color(method.colorArgb);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(
            paymentMethodIcons[method.icon] ?? Icons.payment,
            color: color,
          ),
        ),
        title: Row(
          children: [
            Flexible(child: Text(method.name, overflow: TextOverflow.ellipsis)),
            if (method.isDefault) ...[
              const SizedBox(width: 8),
              const Icon(Icons.star, size: 17, semanticLabel: 'Predeterminado'),
            ],
          ],
        ),
        subtitle: Text(
          method.isDefault
              ? 'Predeterminado'
              : method.isActive
              ? 'Activo'
              : 'Archivado',
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Acciones para ${method.name}',
          onSelected: (action) {
            switch (action) {
              case 'default':
                onSetDefault();
                break;
              case 'edit':
                onEdit();
                break;
              case 'toggle':
                onToggle();
                break;
            }
          },
          itemBuilder: (context) => [
            if (method.isActive && !method.isDefault)
              const PopupMenuItem(
                value: 'default',
                child: ListTile(
                  leading: Icon(Icons.star_outline),
                  title: Text('Hacer predeterminado'),
                ),
              ),
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
                  method.isActive
                      ? Icons.archive_outlined
                      : Icons.unarchive_outlined,
                ),
                title: Text(method.isActive ? 'Archivar' : 'Restaurar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodsEmpty extends StatelessWidget {
  const _PaymentMethodsEmpty({required this.archived, required this.onAdd});
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
            Icons.payment_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            archived
                ? 'No hay métodos archivados.'
                : 'Todavía no hay métodos de pago.',
            textAlign: TextAlign.center,
          ),
          if (!archived) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Crear método'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _PaymentMethodsError extends StatelessWidget {
  const _PaymentMethodsError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar los métodos de pago.'),
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

class _PaymentMethodDraft {
  const _PaymentMethodDraft({
    required this.name,
    required this.icon,
    required this.colorArgb,
  });
  final String name;
  final String icon;
  final int colorArgb;
}

class _PaymentMethodEditor extends StatefulWidget {
  const _PaymentMethodEditor({required this.method});
  final PaymentMethod? method;

  @override
  State<_PaymentMethodEditor> createState() => _PaymentMethodEditorState();
}

class _PaymentMethodEditorState extends State<_PaymentMethodEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
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
    _name = TextEditingController(text: widget.method?.name ?? '');
    _icon = widget.method?.icon ?? 'cash';
    _color = widget.method?.colorArgb ?? _colors[3];
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _PaymentMethodDraft(
        name: _name.text.trim(),
        icon: _icon,
        colorArgb: _color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.method == null ? 'Nuevo método' : 'Editar método'),
    content: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _name,
              autofocus: true,
              maxLength: PaymentMethodValidator.maxNameLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej. Transferencia bancaria',
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) return 'Escribe el nombre del método de pago';
                return name.length > PaymentMethodValidator.maxNameLength
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
              children: paymentMethodIcons.entries
                  .map(
                    (entry) => IconButton.filledTonal(
                      tooltip: entry.key,
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
                    (color) => InkWell(
                      onTap: () => setState(() => _color = color),
                      customBorder: const CircleBorder(),
                      child: CircleAvatar(
                        radius: 16,
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
                  )
                  .toList(),
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
