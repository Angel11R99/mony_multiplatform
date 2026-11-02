import 'dart:convert';
import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../categories/domain/category.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../transactions/domain/transaction.dart';

enum ExportFormat { csv, xlsx, pdf }

class ExportSelection {
  const ExportSelection({
    this.transactions = true,
    this.categories = true,
    this.paymentMethods = true,
  });

  final bool transactions;
  final bool categories;
  final bool paymentMethods;

  bool get hasAny => transactions || categories || paymentMethods;
}

class ExportDocument {
  const ExportDocument({
    required this.from,
    required this.to,
    required this.selection,
    required this.transactions,
    required this.categories,
    required this.paymentMethods,
  });

  final DateTime from;
  final DateTime to;
  final ExportSelection selection;
  final List<FinanceTransaction> transactions;
  final List<Category> categories;
  final List<PaymentMethod> paymentMethods;

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
    return rows;
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

String _iso(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
