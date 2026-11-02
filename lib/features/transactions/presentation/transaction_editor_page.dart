import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../categories/presentation/category_picker.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_method_picker.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../domain/transaction.dart';
import '../domain/transaction_repository.dart';
import '../domain/transaction_validator.dart';
import 'transactions_providers.dart';

class TransactionEditorPage extends ConsumerWidget {
  const TransactionEditorPage({
    this.transactionId,
    this.initialType = TransactionType.expense,
    super.key,
  });

  final int? transactionId;
  final TransactionType initialType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = transactionId;
    if (id == null) {
      return _TransactionForm(
        key: const ValueKey('new_transaction'),
        initialType: initialType,
      );
    }
    return ref
        .watch(transactionByIdProvider(id))
        .when(
          loading: () => Scaffold(
            appBar: AppBar(title: Text('Editar movimiento')),
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => _TransactionNotFound(
            onBack: () => context.goNamed('transactions'),
          ),
          data: (transaction) => transaction == null
              ? _TransactionNotFound(
                  onBack: () => context.goNamed('transactions'),
                )
              : _TransactionForm(
                  key: ValueKey('edit_transaction_$id'),
                  existing: transaction,
                ),
        );
  }
}

class _TransactionForm extends ConsumerStatefulWidget {
  const _TransactionForm({
    this.existing,
    this.initialType = TransactionType.expense,
    super.key,
  });
  final FinanceTransaction? existing;
  final TransactionType initialType;

  @override
  ConsumerState<_TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<_TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _description;
  late TransactionType _type;
  late DateTime _date;
  int? _categoryId;
  int? _paymentMethodId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _amount = TextEditingController(
      text: existing == null
          ? ''
          : MoneyFormatter.toDopInput(existing.amountInCents),
    );
    _description = TextEditingController(text: existing?.description ?? '');
    _type = existing?.type ?? widget.initialType;
    _date = existing?.date ?? DateTime.now();
    _categoryId = existing?.categoryId;
    _paymentMethodId = existing?.paymentMethodId;
    _amount.addListener(_onDraftChanged);
    _description.addListener(_onDraftChanged);
  }

  void _onDraftChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _amount.removeListener(_onDraftChanged);
    _description.removeListener(_onDraftChanged);
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  CategoryType get _categoryType => CategoryType.values.byName(_type.name);

  bool get _hasUnsavedChanges {
    final existing = widget.existing;
    if (existing == null) {
      return _amount.text.trim().isNotEmpty ||
          _description.text.trim().isNotEmpty ||
          _type != widget.initialType ||
          _categoryId != null ||
          _paymentMethodId != null;
    }
    return _amount.text != MoneyFormatter.toDopInput(existing.amountInCents) ||
        _description.text != (existing.description ?? '') ||
        _type != existing.type ||
        !DateUtils.isSameDay(_date, existing.date) ||
        _categoryId != existing.categoryId ||
        _paymentMethodId != existing.paymentMethodId;
  }

  Future<void> _confirmDiscard() async {
    final discard = await MonyConfirmDialog.show(
      context,
      title: 'Descartar cambios',
      message: 'Hay cambios sin guardar en este movimiento.',
      confirmLabel: 'Descartar',
      cancelLabel: 'Seguir editando',
    );
    if (discard == true && mounted) Navigator.of(context).pop();
  }

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_date.year, _date.month, _date.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _save(
    List<Category> activeCategories,
    List<PaymentMethod> activeMethods,
    PaymentMethod? defaultMethod,
  ) async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    final amountInCents = MoneyFormatter.parseDopMinorUnits(_amount.text);
    final categoryIsActive = activeCategories.any(
      (item) => item.id == _categoryId && item.type == _categoryType,
    );
    final paymentMethodId = _effectivePaymentMethodId(
      activeMethods,
      defaultMethod,
    );
    final selectionError = TransactionValidator.validateSelection(
      categoryId: categoryIsActive ? _categoryId : null,
      paymentMethodId: paymentMethodId,
    );
    if (selectionError != null) {
      _showMessage(selectionError);
      return;
    }

    final now = DateTime.now();
    final existing = widget.existing;
    final transaction = FinanceTransaction(
      id: existing?.id ?? 0,
      amountInCents: amountInCents!,
      type: _type,
      categoryId: _categoryId!,
      paymentMethodId: paymentMethodId!,
      description: _description.text,
      date: DateTime(_date.year, _date.month, _date.day),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      fixedEntryId: existing?.fixedEntryId,
      savingsGoalId: existing?.savingsGoalId,
    );

    setState(() => _saving = true);
    try {
      final repository = ref.read(transactionRepositoryProvider);
      if (existing == null) {
        await repository.create(transaction);
      } else {
        await repository.update(transaction);
      }
      if (!mounted) return;
      MonyFeedback.success(
        context,
        existing == null
            ? _type == TransactionType.income
                  ? 'Ingreso registrado.'
                  : 'Gasto registrado.'
            : 'Movimiento actualizado.',
      );
      context.goNamed('transactions');
    } on InvalidTransactionException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('No se pudo guardar el movimiento. Inténtalo de nuevo.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  int? _effectivePaymentMethodId(
    List<PaymentMethod> activeMethods,
    PaymentMethod? defaultMethod,
  ) {
    final selected = _paymentMethodId ?? widget.existing?.paymentMethodId;
    if (selected != null &&
        activeMethods.any((method) => method.id == selected)) {
      return selected;
    }
    return defaultMethod?.id;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    MonyFeedback.info(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final isSavingsContribution = widget.existing?.savingsGoalId != null;
    final categories = ref.watch(activeCategoriesProvider(_categoryType));
    final methods = ref.watch(activePaymentMethodsProvider);
    final defaultMethod = ref.watch(defaultPaymentMethodProvider).value;
    final categoryItems = categories.asData?.value;
    final methodItems = methods.asData?.value;
    final selectedMethodId = methodItems == null
        ? _paymentMethodId
        : _effectivePaymentMethodId(methodItems, defaultMethod);
    final existingCategoryIsArchived =
        widget.existing != null &&
        (categoryItems?.any((item) => item.id == widget.existing!.categoryId) ??
                false) ==
            false;
    final existingMethodIsArchived =
        widget.existing != null &&
        (methodItems?.any(
                  (item) => item.id == widget.existing!.paymentMethodId,
                ) ??
                false) ==
            false;

    return PopScope(
      canPop: !_hasUnsavedChanges && !_saving,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_saving && _hasUnsavedChanges) _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.existing == null ? 'Nuevo movimiento' : 'Editar movimiento',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
              children: [
                SegmentedButton<TransactionType>(
                  segments: [
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: const Text('Gasto'),
                      icon: const Icon(Icons.south_west),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: const Text('Ingreso'),
                      icon: const Icon(Icons.north_east),
                      enabled: !isSavingsContribution,
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selection) => setState(() {
                    _type = selection.first;
                    _categoryId = null;
                  }),
                ),
                if (isSavingsContribution) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Este movimiento es un aporte vinculado a una meta y debe conservarse como gasto.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 20),
                TextFormField(
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Importe',
                    hintText: '0.00',
                    prefixText: 'RD\$ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final amount = MoneyFormatter.parseDopMinorUnits(
                      value ?? '',
                    );
                    return TransactionValidator.validateAmount(amount);
                  },
                ),
                const SizedBox(height: 18),
                CategoryPicker(
                  type: _categoryType,
                  value:
                      categoryItems?.any((item) => item.id == _categoryId) ==
                          true
                      ? _categoryId
                      : null,
                  onChanged: (category) =>
                      setState(() => _categoryId = category?.id),
                ),
                if (existingCategoryIsArchived) ...[
                  const SizedBox(height: 6),
                  Text(
                    'La categoría original está archivada. Elige una categoría activa para guardar los cambios.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 18),
                PaymentMethodPicker(
                  value: selectedMethodId,
                  onChanged: (method) =>
                      setState(() => _paymentMethodId = method?.id),
                ),
                if (existingMethodIsArchived && defaultMethod != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'El método original está archivado. Si no eliges otro, se usará ${defaultMethod.name}.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 18),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(_dateLabel(_date))),
                      IconButton(
                        tooltip: 'Seleccionar fecha',
                        onPressed: _chooseDate,
                        icon: const Icon(Icons.calendar_month_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _description,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Nota (opcional)',
                    hintText: 'Añade un detalle para recordar este movimiento',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed:
                      _saving || categoryItems == null || methodItems == null
                      ? null
                      : () => _save(categoryItems, methodItems, defaultMethod),
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(
                    widget.existing == null
                        ? 'Guardar movimiento'
                        : 'Guardar cambios',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionNotFound extends StatelessWidget {
  const _TransactionNotFound({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Movimiento no encontrado')),
    body: Center(
      child: FilledButton.tonalIcon(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back),
        label: const Text('Volver a movimientos'),
      ),
    ),
  );
}

String _dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
