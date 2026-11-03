import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../core/money/money_formatter.dart';
import '../../../core/theme/mony_tokens.dart';
import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import '../../../core/widgets/mony_settings_action.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../preferences/domain/app_preferences.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/presentation/transactions_providers.dart';
import '../domain/budget.dart';
import '../domain/budget_repository.dart';
import '../domain/budget_validator.dart';
import 'budgets_providers.dart';

class BudgetsPage extends ConsumerStatefulWidget {
  const BudgetsPage({super.key});

  @override
  ConsumerState<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends ConsumerState<BudgetsPage> {
  BudgetPeriodView _view = BudgetPeriodView.current;
  bool _saving = false;
  bool _closing = false;

  Future<void> _editBudget(BudgetConfig? current) async {
    var amount = current == null
        ? ''
        : MoneyFormatter.toDopInput(current.amountInCents);
    var period = current?.period ?? BudgetPeriod.fortnightly;
    final formKey = GlobalKey<FormState>();
    var saving = false;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            current == null ? 'Configurar presupuesto' : 'Editar presupuesto',
          ),
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
                    labelText: 'Monto disponible por período',
                    prefixText: 'RD\$ ',
                  ),
                  validator: (value) => BudgetValidator.validateAmount(
                    MoneyFormatter.parseDopMinorUnits(value ?? ''),
                  ),
                ),
                const SizedBox(height: 16),
                SegmentedButton<BudgetPeriod>(
                  segments: const [
                    ButtonSegment(
                      value: BudgetPeriod.fortnightly,
                      label: Text('Quincenal'),
                    ),
                    ButtonSegment(
                      value: BudgetPeriod.monthly,
                      label: Text('Mensual'),
                    ),
                  ],
                  selected: {period},
                  onSelectionChanged: saving
                      ? null
                      : (selected) =>
                            setDialogState(() => period = selected.first),
                ),
                const SizedBox(height: 8),
                Text(
                  period == BudgetPeriod.monthly
                      ? 'Un ciclo del día 1 al último día de cada mes.'
                      : 'Dos ciclos: días 1–15 y 16–fin de mes.',
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
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      setDialogState(() => saving = true);
                      try {
                        await ref
                            .read(budgetRepositoryProvider)
                            .saveConfig(
                              amountInCents: MoneyFormatter.parseDopMinorUnits(
                                amount,
                              )!,
                              period: period,
                              now: DateTime.now(),
                            );
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } on BudgetRepositoryException catch (error) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() => saving = false);
                        MonyFeedback.error(dialogContext, error.message);
                      } catch (_) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() => saving = false);
                        MonyFeedback.error(
                          dialogContext,
                          'No se pudo guardar el presupuesto.',
                        );
                      }
                    },
              child: Text(saving ? 'Guardando…' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && mounted) _notify('Presupuesto guardado.');
  }

  Future<void> _toggleAutoClose(BudgetConfig config, bool enabled) async {
    setState(() => _saving = true);
    try {
      await ref
          .read(budgetRepositoryProvider)
          .setAutomaticClose(
            enabled: enabled,
            minuteOfDay: config.autoCloseMinuteOfDay,
          );
      if (mounted) {
        _notify(
          enabled
              ? 'Cierre automático activado.'
              : 'Cierre automático desactivado.',
        );
      }
    } on BudgetRepositoryException catch (error) {
      if (mounted) _notify(error.message);
    } catch (_) {
      if (mounted) _notify('No se pudo guardar la preferencia de cierre.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickCloseTime(BudgetConfig config) async {
    final initialTime = TimeOfDay(
      hour: config.autoCloseMinuteOfDay ~/ 60,
      minute: config.autoCloseMinuteOfDay % 60,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked == null || !mounted) return;
    try {
      await ref
          .read(budgetRepositoryProvider)
          .setAutomaticClose(
            enabled: config.autoCloseEnabled,
            minuteOfDay: picked.hour * 60 + picked.minute,
          );
      if (mounted) _notify('Hora de cierre actualizada.');
    } on BudgetRepositoryException catch (error) {
      if (mounted) _notify(error.message);
    } catch (_) {
      if (mounted) _notify('No se pudo cambiar la hora de cierre.');
    }
  }

  Future<void> _editCycleSchedules(BudgetConfig config) async {
    var cycles = config.cycleSchedules
        .map(
          (schedule) => (
            opening: schedule.openingDay.toString(),
            closing: schedule.closingDay.toString(),
          ),
        )
        .toList();
    var saving = false;
    String? errorMessage;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Días de los ciclos'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Define los días inclusivos de apertura y cierre. Si la apertura es mayor que el cierre, el ciclo termina el mes siguiente.',
                  ),
                  const SizedBox(height: 16),
                  for (var index = 0; index < cycles.length; index++) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('cycle-$index-open'),
                            initialValue: cycles[index].opening,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            decoration: InputDecoration(
                              labelText: 'Ciclo ${index + 1} · apertura',
                            ),
                            onChanged: (value) => setDialogState(() {
                              final digits = value.replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              cycles[index] = (
                                opening: digits.length > 2
                                    ? digits.substring(0, 2)
                                    : digits,
                                closing: cycles[index].closing,
                              );
                              errorMessage = null;
                            }),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('cycle-$index-close'),
                            initialValue: cycles[index].closing,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            decoration: InputDecoration(
                              labelText: 'Ciclo ${index + 1} · cierre',
                            ),
                            onChanged: (value) => setDialogState(() {
                              final digits = value.replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              cycles[index] = (
                                opening: cycles[index].opening,
                                closing: digits.length > 2
                                    ? digits.substring(0, 2)
                                    : digits,
                              );
                              errorMessage = null;
                            }),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Quitar ciclo ${index + 1}',
                          onPressed: saving || cycles.length == 1
                              ? null
                              : () => setDialogState(() {
                                  cycles = [...cycles]..removeAt(index);
                                  errorMessage = null;
                                }),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                      ],
                    ),
                  ],
                  TextButton.icon(
                    onPressed: saving
                        ? null
                        : () => setDialogState(() {
                            cycles = [...cycles, (opening: '', closing: '')];
                          }),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar ciclo'),
                  ),
                  if (errorMessage != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
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
                      final schedules = cycles
                          .map(
                            (cycle) => BudgetCycleSchedule(
                              openingDay: int.tryParse(cycle.opening) ?? 0,
                              closingDay: int.tryParse(cycle.closing) ?? 0,
                            ),
                          )
                          .toList(growable: false);
                      final validationError = BudgetValidator.validateSchedules(
                        schedules,
                      );
                      if (validationError != null) {
                        setDialogState(() => errorMessage = validationError);
                        return;
                      }
                      setDialogState(() => saving = true);
                      try {
                        await ref
                            .read(budgetRepositoryProvider)
                            .updateCycleSchedules(schedules);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } on BudgetRepositoryException catch (error) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() {
                          saving = false;
                          errorMessage = error.message;
                        });
                      } catch (_) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() {
                          saving = false;
                          errorMessage = 'No se pudieron guardar los ciclos.';
                        });
                      }
                    },
              child: Text(saving ? 'Guardando…' : 'Guardar ciclos'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && mounted) _notify('Días del ciclo actualizados.');
  }

  Future<void> _editCategoryLimit(Category category) async {
    var amount = category.budgetLimitInCents == null
        ? ''
        : MoneyFormatter.toDopInput(category.budgetLimitInCents!);
    final formKey = GlobalKey<FormState>();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Límite · ${category.name}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              initialValue: amount,
              onChanged: (value) => amount = value,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Límite por ciclo (opcional)',
                prefixText: 'RD\$ ',
                helperText: 'Déjalo vacío para quitar el límite.',
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                return BudgetValidator.validateAmount(
                  MoneyFormatter.parseDopMinorUnits(text),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;
                setDialogState(() {});
                try {
                  await ref
                      .read(categoriesRepositoryProvider)
                      .update(
                        id: category.id,
                        name: category.name,
                        icon: category.icon,
                        colorArgb: category.colorArgb,
                        budgetLimitInCents: amount.trim().isEmpty
                            ? null
                            : MoneyFormatter.parseDopMinorUnits(amount),
                      );
                  if (dialogContext.mounted) Navigator.pop(dialogContext, true);
                } catch (_) {
                  if (!dialogContext.mounted) return;
                  MonyFeedback.error(
                    dialogContext,
                    'No se pudo guardar el límite.',
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    if (saved == true && mounted) _notify('Límite por categoría actualizado.');
  }

  Future<void> _closeCycle(BudgetConfig config, DateTime now) async {
    final period = budgetPeriodToClose(config, now);
    final next = nextBudgetPeriod(config, period.endInclusive);
    final confirmed = await MonyConfirmDialog.show(
      context,
      title: 'Cerrar ciclo',
      message:
          'Se guardará el período ${_formatDate(period.start)} – ${_formatDate(period.endInclusive)} en el historial y comenzará el ${_formatDate(next.start)}. Los movimientos permanecerán en tu historial.',
      confirmLabel: 'Cerrar ciclo',
    );
    if (confirmed != true || !mounted) return;
    setState(() => _closing = true);
    try {
      final closed = await ref
          .read(budgetRepositoryProvider)
          .closeNextCycle(now: now, automatic: false);
      if (mounted) {
        _notify(
          closed
              ? 'Ciclo cerrado y guardado en el historial.'
              : 'Este ciclo todavía no se puede cerrar.',
        );
      }
    } on BudgetRepositoryException catch (error) {
      if (mounted) _notify(error.message);
    } catch (_) {
      if (mounted) _notify('No se pudo cerrar el ciclo.');
    } finally {
      if (mounted) setState(() => _closing = false);
    }
  }

  Future<void> _openHistory() async {
    await showMaterialModalBottomSheet<void>(
      context: context,
      duration: MonyMotion.durationFor(context, MonyMotion.standard),
      builder: (context) => const _BudgetHistorySheet(),
    );
  }

  void _notify(String message) {
    MonyFeedback.info(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(budgetConfigProvider);
    final categories = ref.watch(categoriesProvider);
    final transactions = ref.watch(transactionsProvider);
    final currencyStyle =
        ref.watch(appPreferencesProvider).value?.currencyFormatStyle ??
        AppPreferences.defaults.currencyFormatStyle;
    final configuredBudget = config.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan de ciclo'),
        actions: [
          const MonySettingsAction(),
          IconButton(
            tooltip: 'Historial de ciclos',
            onPressed: _openHistory,
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      floatingActionButton: configuredBudget == null
          ? FloatingActionButton.extended(
              onPressed: _saving ? null : () => _editBudget(null),
              icon: const Icon(Icons.add),
              label: const Text('Configurar presupuesto'),
            )
          : FloatingActionButton.extended(
              onPressed: _saving ? null : () => _editBudget(configuredBudget),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar presupuesto'),
            ),
      body: config.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            _BudgetsError(onRetry: () => ref.invalidate(budgetConfigProvider)),
        data: (budget) => categories.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              _BudgetsError(onRetry: () => ref.invalidate(categoriesProvider)),
          data: (allCategories) => transactions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _BudgetsError(
              onRetry: () => ref.invalidate(transactionsProvider),
            ),
            data: (allTransactions) => _buildContent(
              budget: budget,
              categories: allCategories,
              transactions: allTransactions,
              currencyStyle: currencyStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BudgetConfig? budget,
    required List<Category> categories,
    required List<FinanceTransaction> transactions,
    required CurrencyFormatStyle currencyStyle,
  }) {
    final now = DateTime.now();
    final currentPeriod = activeBudgetPeriod(budget, now);
    final period = budgetPeriodForView(budget, _view, now);
    final summary = summarizeBudgetPeriod(
      period,
      transactions.map(
        (item) => (
          amountInCents: item.amountInCents,
          type: item.type.name,
          date: item.date,
        ),
      ),
    );
    final expenseCategories = categories
        .where(
          (category) =>
              category.type == CategoryType.expense &&
              (category.isActive || category.budgetLimitInCents != null),
        )
        .toList(growable: false);
    final spendsByCategory = <int, int>{};
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.expense &&
          period.contains(transaction.date)) {
        spendsByCategory.update(
          transaction.categoryId,
          (total) => total + transaction.amountInCents,
          ifAbsent: () => transaction.amountInCents,
        );
      }
    }
    final dateFormat =
        '${_formatDate(period.start)} – ${_formatDate(period.endInclusive)}';
    final usage = budget == null
        ? 0
        : summary.usagePercent(budget.amountInCents);
    final canClose = budget != null && canManuallyCloseBudgetCycle(budget, now);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 820 ? 820.0 : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
              children: [
                Text(
                  'Planifica tu período y revisa cuánto has usado.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                SegmentedButton<BudgetPeriodView>(
                  segments: const [
                    ButtonSegment(
                      value: BudgetPeriodView.current,
                      label: Text('Actual'),
                    ),
                    ButtonSegment(
                      value: BudgetPeriodView.next,
                      label: Text('Próximo'),
                    ),
                  ],
                  selected: {_view},
                  onSelectionChanged: (selection) =>
                      setState(() => _view = selection.first),
                ),
                const SizedBox(height: 8),
                Text(dateFormat, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 14),
                if (budget == null)
                  _UnconfiguredBudget(onConfigure: () => _editBudget(null))
                else
                  _BudgetSummaryCard(
                    budget: budget,
                    summary: summary,
                    usagePercent: usage,
                    currencyStyle: currencyStyle,
                  ),
                if (budget != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_month_outlined),
                      title: const Text('Días del ciclo'),
                      subtitle: Text(
                        '${budget.cycleSchedules.length} ${budget.cycleSchedules.length == 1 ? 'ciclo' : 'ciclos'} · apertura y cierre inclusivos',
                      ),
                      trailing: TextButton(
                        onPressed: () => _editCycleSchedules(budget),
                        child: const Text('Editar'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          value: budget.autoCloseEnabled,
                          onChanged: _saving
                              ? null
                              : (value) => _toggleAutoClose(budget, value),
                          title: const Text('Cierre automático'),
                          subtitle: Text(
                            budget.autoCloseEnabled
                                ? 'Se cerrará al terminar el período, cuando la app esté activa.'
                                : 'Puedes cerrar el período manualmente cuando llegue su fecha final.',
                          ),
                        ),
                        if (budget.autoCloseEnabled)
                          ListTile(
                            leading: const Icon(Icons.schedule),
                            title: const Text('Hora de cierre'),
                            subtitle: const Text(
                              'El cierre se ejecuta al usar la app si estuvo en segundo plano.',
                            ),
                            trailing: TextButton(
                              onPressed: () => _pickCloseTime(budget),
                              child: Text(
                                _formatTime(budget.autoCloseMinuteOfDay),
                              ),
                            ),
                          )
                        else
                          ListTile(
                            leading: Icon(
                              canClose
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                            ),
                            title: Text(
                              canClose
                                  ? 'Ciclo listo para cerrar'
                                  : 'Cierre manual',
                            ),
                            subtitle: Text(
                              canClose
                                  ? 'Guarda este ciclo y comienza uno nuevo.'
                                  : 'Disponible al finalizar el período ${_formatDate(currentPeriod.endInclusive)}.',
                            ),
                            trailing: FilledButton.tonal(
                              onPressed: canClose && !_closing
                                  ? () => _closeCycle(budget, now)
                                  : null,
                              child: Text(_closing ? 'Cerrando…' : 'Cerrar'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Asignaciones por categoría',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.pushNamed('settingsCategories'),
                      icon: const Icon(Icons.tune, size: 18),
                      label: const Text('Categorías'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (expenseCategories.isEmpty)
                  const _EmptyCategories()
                else
                  ...expenseCategories.map(
                    (category) => _CategoryBudgetTile(
                      category: category,
                      spentInCents: spendsByCategory[category.id] ?? 0,
                      period: period,
                      currencyStyle: currencyStyle,
                      onEdit: () => _editCategoryLimit(category),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'El consumo se calcula por fecha del movimiento. Los gastos de ahorro también forman parte del presupuesto del período.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  const _BudgetSummaryCard({
    required this.budget,
    required this.summary,
    required this.usagePercent,
    required this.currencyStyle,
  });

  final BudgetConfig budget;
  final BudgetPeriodSummary summary;
  final int usagePercent;
  final CurrencyFormatStyle currencyStyle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final available = summary.availableInCents(budget.amountInCents);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LÍMITE DEL PERÍODO',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Text(
              MoneyFormatter.formatDopMinorUnits(
                budget.amountInCents,
                style: currencyStyle,
              ),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _BudgetMetric(
                  title: 'Ingresos',
                  value: summary.incomeInCents,
                  currencyStyle: currencyStyle,
                ),
                _BudgetMetric(
                  title: 'Gastado',
                  value: summary.expenseInCents,
                  currencyStyle: currencyStyle,
                  color: colors.error,
                ),
                _BudgetMetric(
                  title: 'Disponible',
                  value: available,
                  currencyStyle: currencyStyle,
                  color: available < 0 ? colors.error : colors.primary,
                ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: (usagePercent.clamp(0, 100)) / 100,
              minHeight: 9,
              borderRadius: BorderRadius.circular(9),
              color: usagePercent >= 100 ? colors.error : colors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              usagePercent >= 100
                  ? 'Presupuesto excedido · $usagePercent% utilizado'
                  : usagePercent >= 75
                  ? 'Queda poco disponible · $usagePercent% utilizado'
                  : '$usagePercent% del presupuesto utilizado',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: usagePercent >= 75
                    ? colors.error
                    : colors.onSurfaceVariant,
                fontWeight: usagePercent >= 75 ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetMetric extends StatelessWidget {
  const _BudgetMetric({
    required this.title,
    required this.value,
    required this.currencyStyle,
    this.color,
  });

  final String title;
  final int value;
  final CurrencyFormatStyle currencyStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 3),
        Text(
          MoneyFormatter.formatDopMinorUnits(value, style: currencyStyle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _CategoryBudgetTile extends StatelessWidget {
  const _CategoryBudgetTile({
    required this.category,
    required this.spentInCents,
    required this.period,
    required this.currencyStyle,
    required this.onEdit,
  });

  final Category category;
  final int spentInCents;
  final DateRange period;
  final CurrencyFormatStyle currencyStyle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final limit = category.budgetLimitInCents;
    final percent = limit == null ? 0 : budgetUsagePercent(spentInCents, limit);
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(
                    category.colorArgb,
                  ).withValues(alpha: 0.14),
                  child: Icon(
                    _categoryIcon(category.icon),
                    size: 17,
                    color: Color(category.colorArgb),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: limit == null
                      ? 'Asignar límite a ${category.name}'
                      : 'Editar límite de ${category.name}',
                  onPressed: onEdit,
                  icon: Icon(
                    limit == null
                        ? Icons.add_circle_outline
                        : Icons.edit_outlined,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 42, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          limit == null
                              ? 'Gastado: ${MoneyFormatter.formatDopMinorUnits(spentInCents, style: currencyStyle)}'
                              : '${MoneyFormatter.formatDopMinorUnits(spentInCents, style: currencyStyle)} de ${MoneyFormatter.formatDopMinorUnits(limit, style: currencyStyle)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      if (limit != null)
                        Text(
                          '$percent%',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: percent >= 100
                                    ? colors.error
                                    : colors.onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                  if (limit != null) ...[
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: (percent.clamp(0, 100)) / 100,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(6),
                      color: percent >= 100
                          ? colors.error
                          : Color(category.colorArgb),
                    ),
                  ] else
                    Text(
                      'Sin límite asignado para este ciclo.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetHistorySheet extends ConsumerWidget {
  const _BudgetHistorySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(budgetHistoryProvider);
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
              child: Text(
                'Historial de ciclos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: history.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const Center(
                  child: Text('No pudimos cargar el historial.'),
                ),
                data: (cycles) => cycles.isEmpty
                    ? const Center(
                        child: Text('Los ciclos cerrados aparecerán aquí.'),
                      )
                    : ListView.separated(
                        controller: ModalScrollController.of(context),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: cycles.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final cycle = cycles[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                '${_formatDate(cycle.startDate)} – ${_formatDate(cycle.endDate)}',
                              ),
                              subtitle: Text(
                                'Presupuesto ${MoneyFormatter.formatDopMinorUnits(cycle.budgetAmountInCents, style: style)} · Gastos ${MoneyFormatter.formatDopMinorUnits(cycle.expenseInCents, style: style)}',
                              ),
                              trailing: Text(
                                MoneyFormatter.formatDopMinorUnits(
                                  cycle.remainingInCents,
                                  style: style,
                                ),
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: cycle.remainingInCents < 0
                                          ? Theme.of(context).colorScheme.error
                                          : null,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnconfiguredBudget extends StatelessWidget {
  const _UnconfiguredBudget({required this.onConfigure});
  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 32),
          const SizedBox(height: 10),
          Text(
            'Configura tu primer presupuesto',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          const Text(
            'Elige un límite mensual o quincenal. Podrás revisar cuánto llevas gastado y cuánto queda disponible.',
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onConfigure,
            icon: const Icon(Icons.add),
            label: const Text('Configurar presupuesto'),
          ),
        ],
      ),
    ),
  );
}

class _EmptyCategories extends StatelessWidget {
  const _EmptyCategories();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(18),
      child: Text('No hay categorías de gasto activas para asignar límites.'),
    ),
  );
}

class _BudgetsError extends StatelessWidget {
  const _BudgetsError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar los presupuestos.'),
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

String _formatDate(DateTime date) {
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _formatTime(int minuteOfDay) {
  final hour = minuteOfDay ~/ 60;
  final minute = minuteOfDay % 60;
  final suffix = hour >= 12 ? 'p. m.' : 'a. m.';
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  return '$hour12:${minute.toString().padLeft(2, '0')} $suffix';
}

IconData _categoryIcon(String icon) => switch (icon) {
  'restaurant' => Icons.restaurant_outlined,
  'directions_car' => Icons.directions_car_outlined,
  'home' => Icons.home_outlined,
  'receipt_long' => Icons.receipt_long_outlined,
  'wifi' => Icons.wifi_outlined,
  'phone_android' => Icons.phone_android_outlined,
  'medical_services' => Icons.medical_services_outlined,
  'school' => Icons.school_outlined,
  'movie' => Icons.movie_outlined,
  'shopping_cart' => Icons.shopping_cart_outlined,
  'credit_card' => Icons.credit_card_outlined,
  'subscriptions' => Icons.subscriptions_outlined,
  'savings' => Icons.savings_outlined,
  _ => Icons.category_outlined,
};
