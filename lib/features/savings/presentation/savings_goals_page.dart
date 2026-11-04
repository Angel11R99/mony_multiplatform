import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/money/money_formatter.dart';
import '../../../core/theme/sumi_visuals.dart';
import '../../../core/theme/mony_tokens.dart';
import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import '../../../core/widgets/mony_settings_action.dart';
import '../../../core/widgets/mony_states.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../domain/savings_goal.dart';
import '../domain/savings_goal_validator.dart';
import '../domain/savings_repository.dart';
import 'savings_providers.dart';

class SavingsGoalsPage extends ConsumerStatefulWidget {
  const SavingsGoalsPage({super.key});

  @override
  ConsumerState<SavingsGoalsPage> createState() => _SavingsGoalsPageState();
}

class _SavingsGoalsPageState extends ConsumerState<SavingsGoalsPage> {
  bool _showCompleted = false;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _editGoal({SavingsGoalProgress? goal}) async {
    var name = goal?.goal.name ?? '';
    var target = goal == null
        ? ''
        : MoneyFormatter.toDopInput(goal.goal.targetAmountInCents);
    final formKey = GlobalKey<FormState>();
    var saving = false;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(goal == null ? 'Nueva meta' : 'Editar meta'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  onChanged: (value) => name = value,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la meta',
                    hintText: 'Por ejemplo, fondo de emergencia',
                  ),
                  validator: (value) =>
                      SavingsGoalValidator.validateName(value ?? ''),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: target,
                  onChanged: (value) => target = value,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Objetivo',
                    prefixText: 'RD\$ ',
                  ),
                  validator: (value) => SavingsGoalValidator.validateTarget(
                    MoneyFormatter.parseDopMinorUnits(value ?? ''),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving
                  ? null
                  : () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      setDialogState(() => saving = true);
                      try {
                        final repository = ref.read(savingsRepositoryProvider);
                        final amount = MoneyFormatter.parseDopMinorUnits(
                          target,
                        )!;
                        if (goal == null) {
                          await repository.create(
                            name: name,
                            targetAmountInCents: amount,
                          );
                        } else {
                          await repository.update(
                            id: goal.goal.id,
                            name: name,
                            targetAmountInCents: amount,
                          );
                        }
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } on InvalidSavingsGoalException catch (error) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() => saving = false);
                        MonyFeedback.error(dialogContext, error.message);
                      } catch (_) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() => saving = false);
                        MonyFeedback.error(
                          dialogContext,
                          'No se pudo guardar la meta.',
                        );
                      }
                    },
              child: Text(saving ? 'Guardando…' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && mounted) {
      _notify(
        goal == null ? 'Meta creada correctamente.' : 'Meta actualizada.',
      );
    }
  }

  Future<void> _addContribution(SavingsGoalProgress goal) async {
    var amount = '';
    var note = '';
    final formKey = GlobalKey<FormState>();
    var saving = false;
    final done = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Aportar a ${goal.goal.name}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: amount,
                  onChanged: (value) => amount = value,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Monto del aporte',
                    prefixText: 'RD\$ ',
                  ),
                  validator: (value) =>
                      SavingsGoalValidator.validateContribution(
                        MoneyFormatter.parseDopMinorUnits(value ?? ''),
                      ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: note,
                  onChanged: (value) => note = value,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nota (opcional)',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Se registrará como gasto en la categoría Ahorro y contará una sola vez en tus finanzas.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving
                  ? null
                  : () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      setDialogState(() => saving = true);
                      try {
                        await ref
                            .read(savingsRepositoryProvider)
                            .addContribution(
                              goalId: goal.goal.id,
                              amountInCents: MoneyFormatter.parseDopMinorUnits(
                                amount,
                              )!,
                              note: note,
                            );
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } on InvalidSavingsGoalException catch (error) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() => saving = false);
                        MonyFeedback.error(dialogContext, error.message);
                      } catch (_) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() => saving = false);
                        MonyFeedback.error(
                          dialogContext,
                          'No se pudo registrar el aporte.',
                        );
                      }
                    },
              child: Text(saving ? 'Registrando…' : 'Aportar'),
            ),
          ],
        ),
      ),
    );
    if (done == true && mounted) _notify('Aporte registrado.');
  }

  Future<void> _confirmAction(
    SavingsGoalProgress goal,
    String title,
    String message,
    String confirmText,
    Future<void> Function() action,
    String successMessage,
  ) async {
    final confirmed = await MonyConfirmDialog.show(
      context,
      title: title,
      message: message,
      confirmLabel: confirmText,
      destructive: true,
    );
    if (confirmed != true || !mounted) return;
    try {
      await action();
      if (mounted) _notify(successMessage);
    } on InvalidSavingsGoalException catch (error) {
      if (mounted) _notify(error.message);
    } catch (_) {
      if (mounted) _notify('No se pudo completar la acción.');
    }
  }

  void _openContributions(SavingsGoalProgress goal) {
    showMaterialModalBottomSheet<void>(
      context: context,
      duration: MonyMotion.durationFor(context, MonyMotion.standard),
      builder: (context) => _ContributionHistorySheet(goal: goal),
    );
  }

  void _notify(String message) {
    MonyFeedback.info(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(savingsGoalsProvider);
    final currencyStyle =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        AppPreferences.defaults.currencyFormatStyle;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas de ahorro'),
        actions: [
          IconButton(
            tooltip: 'Ver historial de movimientos',
            onPressed: () => context.goNamed('transactions'),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
          const MonySettingsAction(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editGoal(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva meta'),
      ),
      body: goals.when(
        loading: () => const LoadingPlaceholder(message: 'Cargando tus metas'),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No pudimos cargar tus metas.'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(savingsGoalsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (items) {
          final active = items.where((item) => item.isActive).toList();
          final completed = items.where((item) => !item.isActive).toList();
          final visible = (_showCompleted ? completed : active)
              .where(
                (item) => item.goal.name.toLowerCase().contains(
                  _search.text.trim().toLowerCase(),
                ),
              )
              .toList(growable: false);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  children: [
                    Text(
                      'Separa dinero para lo que quieres lograr. Cada aporte se registra como un gasto de ahorro.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('Activas')),
                        ButtonSegment(value: true, label: Text('Completadas')),
                      ],
                      selected: {_showCompleted},
                      onSelectionChanged: (selection) =>
                          setState(() => _showCompleted = selection.first),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Buscar metas por nombre',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _search.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Limpiar búsqueda',
                                onPressed: () {
                                  _search.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                              ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${visible.length} ${visible.length == 1 ? 'meta' : 'metas'}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? _SavingsEmpty(
                        completed: _showCompleted,
                        filtered: _search.text.trim().isNotEmpty,
                        onClear: () {
                          _search.clear();
                          setState(() {});
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 104),
                        itemCount: visible.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) => _SavingsGoalCard(
                          progress: visible[index],
                          currencyStyle: currencyStyle,
                          onEdit: () => _editGoal(goal: visible[index]),
                          onContribute: () => _addContribution(visible[index]),
                          onHistory: () => _openContributions(visible[index]),
                          onComplete: () => _confirmAction(
                            visible[index],
                            '¿Completar esta meta?',
                            'Al marcarla completada dejará de aparecer entre las metas en curso.',
                            'Completar',
                            () => ref
                                .read(savingsRepositoryProvider)
                                .complete(visible[index].goal.id),
                            'Meta completada.',
                          ),
                          onReopen: () => _confirmAction(
                            visible[index],
                            '¿Reabrir esta meta?',
                            'Volverá a aparecer entre las metas en curso.',
                            'Reabrir',
                            () => ref
                                .read(savingsRepositoryProvider)
                                .reopen(visible[index].goal.id),
                            'Meta reabierta.',
                          ),
                          onDelete: () => _confirmAction(
                            visible[index],
                            '¿Eliminar meta?',
                            '${visible[index].goal.name} se eliminará. Los aportes permanecerán en el historial como gastos normales.',
                            'Eliminar',
                            () => ref
                                .read(savingsRepositoryProvider)
                                .delete(visible[index].goal.id),
                            'Meta eliminada. Sus aportes siguen en el historial.',
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SavingsGoalCard extends StatelessWidget {
  const _SavingsGoalCard({
    required this.progress,
    required this.currencyStyle,
    required this.onEdit,
    required this.onContribute,
    required this.onHistory,
    required this.onComplete,
    required this.onReopen,
    required this.onDelete,
  });

  final SavingsGoalProgress progress;
  final CurrencyFormatStyle currencyStyle;
  final VoidCallback onEdit;
  final VoidCallback onContribute;
  final VoidCallback onHistory;
  final VoidCallback onComplete;
  final VoidCallback onReopen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final goal = progress.goal;
    final isManuallyCompleted = goal.completedAt != null;
    final percent = progress.percent;
    final colors = Theme.of(context).colorScheme;
    return SumiSurface(
      variant: SumiSurfaceVariant.minimalJade,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Acciones para ${goal.name}',
                onSelected: (action) {
                  switch (action) {
                    case 'edit':
                      onEdit();
                    case 'complete':
                      onComplete();
                    case 'reopen':
                      onReopen();
                    case 'history':
                      onHistory();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  if (!isManuallyCompleted)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Editar meta'),
                    ),
                  if (progress.canComplete)
                    const PopupMenuItem(
                      value: 'complete',
                      child: Text('Completar meta'),
                    ),
                  if (isManuallyCompleted)
                    const PopupMenuItem(
                      value: 'reopen',
                      child: Text('Reabrir meta'),
                    ),
                  const PopupMenuItem(
                    value: 'history',
                    child: Text('Ver aportes'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar meta'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${MoneyFormatter.formatDopMinorUnits(progress.savedInCents, style: currencyStyle)} de ${MoneyFormatter.formatDopMinorUnits(goal.targetAmountInCents, style: currencyStyle)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: (percent.clamp(0, 100)) / 100),
            duration: MonyMotion.durationFor(context, MonyMotion.emphasis),
            curve: MonyMotion.curveFor(context, Curves.easeOutCubic),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  progress.excessInCents > 0
                      ? 'Objetivo superado · ${MoneyFormatter.formatDopMinorUnits(progress.excessInCents, style: currencyStyle)} extra'
                      : progress.isCompleted
                      ? 'Meta alcanzada · $percent%'
                      : 'Falta ${MoneyFormatter.formatDopMinorUnits(progress.remainingInCents, style: currencyStyle)} · $percent%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: progress.isCompleted
                        ? colors.primary
                        : colors.onSurfaceVariant,
                    fontWeight: progress.isCompleted ? FontWeight.w600 : null,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onHistory,
                icon: const Icon(Icons.history, size: 18),
                label: const Text('Aportes'),
              ),
            ],
          ),
          if (!isManuallyCompleted) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onContribute,
                icon: const Icon(Icons.add),
                label: const Text('Aportar'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContributionHistorySheet extends ConsumerWidget {
  const _ContributionHistorySheet({required this.goal});
  final SavingsGoalProgress goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributions = ref.watch(savingsContributionsProvider(goal.goal.id));
    final style =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        AppPreferences.defaults.currencyFormatStyle;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(top: MonySpace.x2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(MonyRadius.small),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aportes · ${goal.goal.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${MoneyFormatter.formatDopMinorUnits(goal.savedInCents, style: style)} de ${MoneyFormatter.formatDopMinorUnits(goal.goal.targetAmountInCents, style: style)}',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: contributions.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    const Center(child: Text('No pudimos cargar los aportes.')),
                data: (items) => items.isEmpty
                    ? const Center(
                        child: Text('Todavía no hay aportes para esta meta.'),
                      )
                    : ListView.separated(
                        controller: ModalScrollController.of(context),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              child: Icon(
                                Icons.savings_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            title: Text(item.description ?? 'Aporte a la meta'),
                            subtitle: Text(_dateLabel(item.date)),
                            trailing: Text(
                              MoneyFormatter.formatDopMinorUnits(
                                item.amountInCents,
                                style: style,
                              ),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          );
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavingsEmpty extends StatelessWidget {
  const _SavingsEmpty({
    required this.completed,
    this.filtered = false,
    this.onClear,
  });
  final bool completed;
  final bool filtered;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            filtered
                ? Icons.search_off
                : completed
                ? Icons.emoji_events_outlined
                : Icons.savings_outlined,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            filtered
                ? 'No hay metas con ese nombre.'
                : completed
                ? 'No tienes metas completadas aún.'
                : 'Todavía no tienes metas de ahorro.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            filtered
                ? 'Prueba con otro nombre o limpia la búsqueda.'
                : completed
                ? 'Cuando alcances un objetivo, complétalo para encontrarlo aquí.'
                : 'Crea una meta y registra aportes. Cada aporte se guarda como un gasto en la categoría “Ahorro”.',
            textAlign: TextAlign.center,
          ),
          if (filtered && onClear != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.close),
              label: const Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    ),
  );
}

String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);
