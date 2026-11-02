import 'package:flutter/services.dart';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../categories/domain/category.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/presentation/transactions_providers.dart';
import '../../budgets/domain/budget.dart';
import '../../budgets/presentation/budgets_providers.dart';
import '../../obligations/domain/obligation.dart';
import '../../obligations/presentation/obligations_providers.dart';
import '../../recurring/domain/recurring_entry.dart';
import '../../recurring/presentation/recurring_providers.dart';
import '../../savings/domain/savings_goal.dart';
import '../../savings/presentation/savings_providers.dart';
import '../../shopping_lists/domain/shopping_list.dart';
import '../../shopping_lists/presentation/shopping_lists_providers.dart';
import '../domain/export_document.dart';

class ExportsPage extends ConsumerStatefulWidget {
  const ExportsPage({super.key});

  @override
  ConsumerState<ExportsPage> createState() => _ExportsPageState();
}

class _ExportsPageState extends ConsumerState<ExportsPage> {
  late DateTime _from;
  late DateTime _to;
  ExportFormat _format = ExportFormat.xlsx;
  bool _transactions = true;
  bool _categories = true;
  bool _paymentMethods = true;
  bool _budgets = true;
  bool _savingsGoals = true;
  bool _obligations = true;
  bool _shoppingLists = true;
  bool _recurringEntries = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = DateTime(now.year, now.month + 1, 0);
  }

  ExportSelection get _selection => ExportSelection(
    transactions: _transactions,
    categories: _categories,
    paymentMethods: _paymentMethods,
    budgets: _budgets,
    savingsGoals: _savingsGoals,
    obligations: _obligations,
    shoppingLists: _shoppingLists,
    recurringEntries: _recurringEntries,
  );

  Future<void> _chooseDate({required bool start}) async {
    final value = await showDatePicker(
      context: context,
      initialDate: start ? _from : _to,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: start ? 'Inicio del período' : 'Fin del período',
    );
    if (value == null || !mounted) return;
    setState(() {
      if (start) {
        _from = value;
        if (_from.isAfter(_to)) _to = value;
      } else {
        _to = value;
        if (_to.isBefore(_from)) _from = value;
      }
    });
  }

  Future<void> _run({
    required bool share,
    required List<FinanceTransaction> transactions,
    required List<Category> categories,
    required List<PaymentMethod> methods,
    required BudgetConfig? budget,
    required List<BudgetCycle> budgetHistory,
    required List<SavingsGoalProgress> savingsGoals,
    required List<Obligation> obligations,
    required List<ShoppingListOverview> shoppingLists,
    required List<RecurringEntry> recurringEntries,
  }) async {
    if (!_selection.hasAny) return;
    setState(() => _busy = true);
    try {
      final document = ExportDocument(
        from: DateTime(_from.year, _from.month, _from.day),
        to: DateTime(_to.year, _to.month, _to.day),
        selection: _selection,
        transactions: transactions,
        categories: categories,
        paymentMethods: methods,
        budget: budget,
        budgetHistory: budgetHistory,
        savingsGoals: savingsGoals,
        obligations: obligations,
        shoppingLists: shoppingLists,
        recurringEntries: recurringEntries,
      );
      final bytes = await _bytes(document);
      final extension = _format.name;
      final mime = switch (_format) {
        ExportFormat.csv => MimeType.csv,
        ExportFormat.xlsx => MimeType.microsoftExcel,
        ExportFormat.pdf => MimeType.pdf,
      };
      if (share) {
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                bytes,
                name: '${document.fileStem}.$extension',
                mimeType: mime.type,
              ),
            ],
            subject: 'Exportación financiera de Mony',
            downloadFallbackEnabled: true,
          ),
        );
      } else {
        await FileSaver.instance.saveFile(
          name: document.fileStem,
          bytes: bytes,
          fileExtension: extension,
          mimeType: mime,
        );
      }
      if (mounted && !share) {
        MonyFeedback.success(context, 'Archivo exportado correctamente.');
      }
    } catch (_) {
      if (mounted) {
        MonyFeedback.error(
          context,
          'No se pudo generar o guardar el archivo. Inténtalo de nuevo.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<Uint8List> _bytes(ExportDocument document) => switch (_format) {
    ExportFormat.csv => Future.value(document.toCsv()),
    ExportFormat.xlsx => Future.value(document.toXlsx()),
    ExportFormat.pdf =>
      rootBundle
          .load('assets/fonts/Roboto-Regular.ttf')
          .then((font) => document.toPdf(fontBytes: font.buffer.asUint8List())),
  };

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);
    final methods = ref.watch(paymentMethodsProvider);
    final budget = ref.watch(budgetConfigProvider);
    final budgetHistory = ref.watch(budgetHistoryProvider);
    final savingsGoals = ref.watch(savingsGoalsProvider);
    final obligations = ref.watch(obligationsProvider);
    final shoppingLists = ref.watch(shoppingListOverviewsProvider);
    final recurringEntries = ref.watch(recurringEntriesProvider);
    final all = [
      transactions,
      categories,
      methods,
      budget,
      budgetHistory,
      savingsGoals,
      obligations,
      shoppingLists,
      recurringEntries,
    ];
    final loading = all.any((value) => value.isLoading);
    final error = all.any((value) => value.hasError);
    return Scaffold(
      appBar: AppBar(title: const Text('Exportar datos')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card.outlined(
                child: ListTile(
                  leading: const Icon(Icons.enhanced_encryption_outlined),
                  title: const Text('Copia cifrada y restauración'),
                  subtitle: const Text(
                    'Guarda y restaura todos los datos de Mony.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('backup'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Elige qué incluir y el período',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'El período filtra los movimientos. Catálogos, presupuestos, metas, obligaciones, compras y recurrencias se exportan completos.',
              ),
              const SizedBox(height: 18),
              Card.outlined(
                child: Column(
                  children: [
                    _DateOption(
                      title: 'Desde',
                      date: _from,
                      onTap: () => _chooseDate(start: true),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _DateOption(
                      title: 'Hasta',
                      date: _to,
                      onTap: () => _chooseDate(start: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Información',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              CheckboxListTile(
                value: _transactions,
                onChanged: (v) => setState(() => _transactions = v ?? false),
                title: const Text('Movimientos'),
                subtitle: const Text('Ingresos y gastos dentro del período'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _categories,
                onChanged: (v) => setState(() => _categories = v ?? false),
                title: const Text('Categorías'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _paymentMethods,
                onChanged: (v) => setState(() => _paymentMethods = v ?? false),
                title: const Text('Métodos de pago'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _budgets,
                onChanged: (v) => setState(() => _budgets = v ?? false),
                title: const Text('Presupuestos e historial'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _savingsGoals,
                onChanged: (v) => setState(() => _savingsGoals = v ?? false),
                title: const Text('Metas de ahorro'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _obligations,
                onChanged: (v) => setState(() => _obligations = v ?? false),
                title: const Text('Pagos y cobros pendientes'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _shoppingLists,
                onChanged: (v) => setState(() => _shoppingLists = v ?? false),
                title: const Text('Listas de compras'),
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _recurringEntries,
                onChanged: (v) =>
                    setState(() => _recurringEntries = v ?? false),
                title: const Text('Movimientos recurrentes'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<ExportFormat>(
                initialValue: _format,
                decoration: const InputDecoration(
                  labelText: 'Formato',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: ExportFormat.xlsx,
                    child: Text('Excel (.xlsx)'),
                  ),
                  DropdownMenuItem(
                    value: ExportFormat.csv,
                    child: Text('CSV (.csv)'),
                  ),
                  DropdownMenuItem(
                    value: ExportFormat.pdf,
                    child: Text('PDF (.pdf)'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _format = value ?? ExportFormat.xlsx),
              ),
              if (loading)
                const Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: LinearProgressIndicator(),
                ),
              if (error)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'No se pudieron cargar los datos. Vuelve a intentarlo.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _busy || loading || error || !_selection.hasAny
                    ? null
                    : () => _run(
                        share: false,
                        transactions: transactions.value ?? const [],
                        categories: categories.value ?? const [],
                        methods: methods.value ?? const [],
                        budget: budget.value,
                        budgetHistory: budgetHistory.value ?? const [],
                        savingsGoals: savingsGoals.value ?? const [],
                        obligations: obligations.value ?? const [],
                        shoppingLists: shoppingLists.value ?? const [],
                        recurringEntries: recurringEntries.value ?? const [],
                      ),
                icon: _busy
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
                label: const Text('Guardar archivo'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy || loading || error || !_selection.hasAny
                    ? null
                    : () => _run(
                        share: true,
                        transactions: transactions.value ?? const [],
                        categories: categories.value ?? const [],
                        methods: methods.value ?? const [],
                        budget: budget.value,
                        budgetHistory: budgetHistory.value ?? const [],
                        savingsGoals: savingsGoals.value ?? const [],
                        obligations: obligations.value ?? const [],
                        shoppingLists: shoppingLists.value ?? const [],
                        recurringEntries: recurringEntries.value ?? const [],
                      ),
                icon: const Icon(Icons.ios_share),
                label: const Text('Compartir archivo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateOption extends StatelessWidget {
  const _DateOption({
    required this.title,
    required this.date,
    required this.onTap,
  });
  final String title;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
        ),
        const SizedBox(width: 8),
        const Icon(Icons.calendar_month_outlined),
      ],
    ),
    onTap: onTap,
  );
}
