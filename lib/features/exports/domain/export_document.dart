import 'dart:convert';
import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../categories/domain/category.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../transactions/domain/transaction.dart';
import '../../budgets/domain/budget.dart';
import '../../obligations/domain/obligation.dart';
import '../../recurring/domain/recurring_entry.dart';
import '../../savings/domain/savings_goal.dart';
import '../../shopping_lists/domain/shopping_list.dart';

enum ExportFormat { csv, xlsx, pdf }

class ExportSelection {
  const ExportSelection({
    this.transactions = true,
    this.categories = true,
    this.paymentMethods = true,
    this.budgets = true,
    this.savingsGoals = true,
    this.obligations = true,
    this.shoppingLists = true,
    this.recurringEntries = true,
  });

  final bool transactions;
  final bool categories;
  final bool paymentMethods;
  final bool budgets;
  final bool savingsGoals;
  final bool obligations;
  final bool shoppingLists;
  final bool recurringEntries;

  bool get hasAny =>
      transactions ||
      categories ||
      paymentMethods ||
      budgets ||
      savingsGoals ||
      obligations ||
      shoppingLists ||
      recurringEntries;
}

class ExportDocument {
  const ExportDocument({
    required this.from,
    required this.to,
    required this.selection,
    required this.transactions,
    required this.categories,
    required this.paymentMethods,
    this.budget,
    this.budgetHistory = const [],
    this.savingsGoals = const [],
    this.obligations = const [],
    this.shoppingLists = const [],
    this.recurringEntries = const [],
  });

  final DateTime from;
  final DateTime to;
  final ExportSelection selection;
  final List<FinanceTransaction> transactions;
  final List<Category> categories;
  final List<PaymentMethod> paymentMethods;
  final BudgetConfig? budget;
  final List<BudgetCycle> budgetHistory;
  final List<SavingsGoalProgress> savingsGoals;
  final List<Obligation> obligations;
  final List<ShoppingListOverview> shoppingLists;
  final List<RecurringEntry> recurringEntries;

  List<FinanceTransaction> get filteredTransactions =>
      transactions
          .where(
            (item) =>
                !DateTime(
                  item.date.year,
                  item.date.month,
                  item.date.day,
                ).isBefore(from) &&
                !DateTime(
                  item.date.year,
                  item.date.month,
                  item.date.day,
                ).isAfter(to),
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  String get fileStem => 'mony_${_iso(from)}_${_iso(to)}';

  List<List<String>> _transactionRows() {
    final categoryNames = {for (final item in categories) item.id: item.name};
    final methodNames = {for (final item in paymentMethods) item.id: item.name};
    return [
      [
        'Fecha',
        'Tipo',
        'Descripción',
        'Categoría',
        'Método de pago',
        'Monto (DOP)',
      ],
      for (final item in filteredTransactions)
        [
          _iso(item.date),
          item.type == TransactionType.income ? 'Ingreso' : 'Gasto',
          item.description ?? '',
          categoryNames[item.categoryId] ?? 'Categoría archivada',
          methodNames[item.paymentMethodId] ?? 'Método archivado',
          (item.amountInCents / 100).toStringAsFixed(2),
        ],
    ];
  }

  List<List<String>> get _budgetRows => [
    [
      'Tipo',
      'Desde',
      'Hasta',
      'Presupuesto (DOP)',
      'Ingresos (DOP)',
      'Gastos (DOP)',
    ],
    if (budget != null)
      [
        'Presupuesto actual',
        budget!.cycleStart == null ? '' : _iso(budget!.cycleStart!),
        '',
        _amount(budget!.amountInCents),
        '',
        '',
      ],
    for (final cycle in budgetHistory)
      [
        'Ciclo',
        _iso(cycle.startDate),
        _iso(cycle.endDate),
        _amount(cycle.budgetAmountInCents),
        _amount(cycle.incomeInCents),
        _amount(cycle.expenseInCents),
      ],
  ];

  List<List<String>> get _savingsRows => [
    ['Nombre', 'Objetivo (DOP)', 'Ahorrado (DOP)', 'Restante (DOP)', 'Estado'],
    for (final item in savingsGoals)
      [
        item.goal.name,
        _amount(item.goal.targetAmountInCents),
        _amount(item.savedInCents),
        _amount(item.remainingInCents),
        item.isCompleted ? 'Completada' : 'Activa',
      ],
  ];

  List<List<String>> get _obligationRows => [
    [
      'Título',
      'Dirección',
      'Contraparte',
      'Vencimiento',
      'Monto (DOP)',
      'Pagado (DOP)',
      'Estado',
    ],
    for (final item in obligations)
      [
        item.title,
        item.direction.name,
        item.counterparty ?? '',
        item.dueDate == null ? '' : _iso(item.dueDate!),
        _amount(item.amountInCents),
        _amount(item.paidAmountInCents),
        item.statusAt(DateTime.now()).name,
      ],
  ];

  List<List<String>> get _shoppingRows => [
    ['Nombre', 'Estado', 'Artículos', 'Total (DOP)', 'Fecha de compra'],
    for (final item in shoppingLists)
      [
        item.list.name,
        item.list.status.name,
        item.itemCount.toString(),
        _amount(item.totalInCents),
        item.list.purchaseDate == null ? '' : _iso(item.list.purchaseDate!),
      ],
  ];

  List<List<String>> get _recurringRows => [
    ['Nombre', 'Tipo', 'Monto (DOP)', 'Frecuencia', 'Próxima fecha', 'Activo'],
    for (final item in recurringEntries)
      [
        item.title,
        item.type.name,
        _amount(item.amountInCents),
        item.frequency.name,
        _iso(item.nextDate),
        item.isActive ? 'Sí' : 'No',
      ],
  ];

  List<List<String>> get csvRows {
    final rows = <List<String>>[];
    if (selection.transactions) rows.addAll(_transactionRows());
    if (selection.categories) {
      if (rows.isNotEmpty) rows.add([]);
      rows.addAll([
        ['Categorías'],
        ['Nombre', 'Tipo', 'Estado'],
        for (final item in categories)
          [
            item.name,
            item.type == CategoryType.income ? 'Ingreso' : 'Gasto',
            item.isActive ? 'Activa' : 'Archivada',
          ],
      ]);
    }
    if (selection.paymentMethods) {
      if (rows.isNotEmpty) rows.add([]);
      rows.addAll([
        ['Métodos de pago'],
        ['Nombre', 'Estado', 'Predeterminado'],
        for (final item in paymentMethods)
          [
            item.name,
            item.isActive ? 'Activo' : 'Archivado',
            item.isDefault ? 'Sí' : 'No',
          ],
      ]);
    }
    if (selection.budgets) {
      _addSection(rows, 'Presupuestos', _budgetRows);
    }
    if (selection.savingsGoals) {
      _addSection(rows, 'Metas de ahorro', _savingsRows);
    }
    if (selection.obligations) {
      _addSection(rows, 'Obligaciones', _obligationRows);
    }
    if (selection.shoppingLists) {
      _addSection(rows, 'Listas de compras', _shoppingRows);
    }
    if (selection.recurringEntries) {
      _addSection(rows, 'Movimientos recurrentes', _recurringRows);
    }
    return rows;
  }

  static void _addSection(
    List<List<String>> rows,
    String title,
    List<List<String>> data,
  ) {
    if (rows.isNotEmpty) rows.add([]);
    rows.add([title]);
    rows.addAll(data);
  }

  Uint8List toCsv() {
    final csv = csvRows
        .map((row) => row.map(_escapeCsv).join(','))
        .join('\r\n');
    return Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]);
  }

  Uint8List toXlsx() {
    final workbook = Excel.createExcel();
    final defaultSheet = workbook.getDefaultSheet();
    if (defaultSheet != null) workbook.delete(defaultSheet);
    if (selection.transactions) {
      _writeSheet(workbook, 'Movimientos', _transactionRows());
    }
    if (selection.categories) {
      _writeSheet(workbook, 'Categorías', [
        ['Nombre', 'Tipo', 'Estado'],
        for (final item in categories)
          [
            item.name,
            item.type == CategoryType.income ? 'Ingreso' : 'Gasto',
            item.isActive ? 'Activa' : 'Archivada',
          ],
      ]);
    }
    if (selection.paymentMethods) {
      _writeSheet(workbook, 'Métodos de pago', [
        ['Nombre', 'Estado', 'Predeterminado'],
        for (final item in paymentMethods)
          [
            item.name,
            item.isActive ? 'Activo' : 'Archivado',
            item.isDefault ? 'Sí' : 'No',
          ],
      ]);
    }
    if (selection.budgets) {
      _writeSheet(workbook, 'Presupuestos', _budgetRows);
    }
    if (selection.savingsGoals) {
      _writeSheet(workbook, 'Metas de ahorro', _savingsRows);
    }
    if (selection.obligations) {
      _writeSheet(workbook, 'Obligaciones', _obligationRows);
    }
    if (selection.shoppingLists) {
      _writeSheet(workbook, 'Listas de compras', _shoppingRows);
    }
    if (selection.recurringEntries) {
      _writeSheet(workbook, 'Recurrentes', _recurringRows);
    }
    return Uint8List.fromList(workbook.encode() ?? const <int>[]);
  }

  Future<Uint8List> toPdf({required Uint8List fontBytes}) async {
    final pdf = pw.Document();
    final font = pw.Font.ttf(ByteData.sublistView(fontBytes));
    final theme = pw.ThemeData.withFont(base: font, bold: font);
    final rows = selection.transactions ? _transactionRows() : <List<String>>[];
    final sections = <pw.Widget>[
      pw.Text(
        'Exportación financiera de Mony',
        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 5),
      pw.Text('Período: ${_iso(from)} a ${_iso(to)}'),
      pw.SizedBox(height: 16),
    ];
    if (selection.transactions) {
      sections.addAll([
        pw.Text(
          'Movimientos (${filteredTransactions.length})',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        if (filteredTransactions.isEmpty)
          pw.Text('No hay movimientos en este período.'),
        if (filteredTransactions.isNotEmpty)
          pw.TableHelper.fromTextArray(
            headers: rows.first,
            data: rows.skip(1).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellPadding: const pw.EdgeInsets.all(4),
          ),
        pw.SizedBox(height: 16),
      ]);
    }
    if (selection.categories) {
      sections.add(
        pw.Text(
          'Categorías: ${categories.map((item) => item.name).join(', ')}',
        ),
      );
      sections.add(pw.SizedBox(height: 8));
    }
    if (selection.paymentMethods) {
      sections.add(
        pw.Text(
          'Métodos de pago: ${paymentMethods.map((item) => item.name).join(', ')}',
        ),
      );
    }
    if (selection.budgets) {
      sections.add(
        pw.Text(
          'Presupuestos: ${budgetHistory.length} ciclos registrados${budget == null ? '' : ' · límite actual ${_amount(budget!.amountInCents)} DOP'}',
        ),
      );
    }
    if (selection.savingsGoals) {
      sections.add(
        pw.Text(
          'Metas de ahorro: ${savingsGoals.map((item) => '${item.goal.name} (${_amount(item.savedInCents)} / ${_amount(item.goal.targetAmountInCents)} DOP)').join('; ')}',
        ),
      );
    }
    if (selection.obligations) {
      sections.add(
        pw.Text(
          'Obligaciones: ${obligations.map((item) => '${item.title} (${item.direction.name}, pendiente ${_amount(item.remainingAmountInCents)} DOP)').join('; ')}',
        ),
      );
    }
    if (selection.shoppingLists) {
      sections.add(
        pw.Text(
          'Listas de compras: ${shoppingLists.map((item) => '${item.list.name} (${item.itemCount} artículos, ${_amount(item.totalInCents)} DOP)').join('; ')}',
        ),
      );
    }
    if (selection.recurringEntries) {
      sections.add(
        pw.Text(
          'Movimientos recurrentes: ${recurringEntries.map((item) => '${item.title} (${item.frequency.name}, próximo ${_iso(item.nextDate)})').join('; ')}',
        ),
      );
    }
    pdf.addPage(pw.MultiPage(theme: theme, build: (_) => sections));
    return pdf.save();
  }

  static void _writeSheet(
    Excel workbook,
    String name,
    List<List<String>> rows,
  ) {
    final sheet = workbook[name];
    for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      for (
        var columnIndex = 0;
        columnIndex < rows[rowIndex].length;
        columnIndex++
      ) {
        sheet.updateCell(
          CellIndex.indexByColumnRow(
            columnIndex: columnIndex,
            rowIndex: rowIndex,
          ),
          TextCellValue(rows[rowIndex][columnIndex]),
        );
      }
    }
  }
}

String _escapeCsv(String value) {
  if (!value.contains(RegExp('[,"\r\n]'))) return value;
  return '"${value.replaceAll('"', '""')}"';
}

String _amount(int minorUnits) => (minorUnits / 100).toStringAsFixed(2);

String _iso(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
