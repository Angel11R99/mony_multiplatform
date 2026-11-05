import 'dart:convert';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:excel_plus/excel_plus.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/exports/domain/export_document.dart';
import 'package:mony_multiplatform/features/payment_methods/domain/payment_method.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final date = DateTime(2026, 3, 14);
  final transactions = [
    FinanceTransaction(
      id: 1,
      amountInCents: 12345,
      type: TransactionType.expense,
      categoryId: 2,
      paymentMethodId: 3,
      description: 'Café, "Central"',
      date: date,
      createdAt: date,
      updatedAt: date,
    ),
    FinanceTransaction(
      id: 2,
      amountInCents: 200,
      type: TransactionType.income,
      categoryId: 2,
      paymentMethodId: 3,
      description: 'Fuera del rango',
      date: DateTime(2026, 4, 1),
      createdAt: date,
      updatedAt: date,
    ),
  ];
  final categories = [
    Category(
      id: 2,
      name: 'Comida',
      type: CategoryType.expense,
      icon: 'restaurant',
      colorArgb: 0,
      isActive: true,
      createdAt: date,
    ),
  ];
  final methods = [
    PaymentMethod(
      id: 3,
      name: 'Débito',
      icon: 'card',
      colorArgb: 0,
      isActive: true,
      isDefault: true,
      createdAt: date,
    ),
  ];

  test(
    'el CSV incluye BOM UTF-8, escapea delimitadores y filtra extremos inclusivos',
    () {
      final document = ExportDocument(
        from: date,
        to: date,
        selection: const ExportSelection(
          categories: false,
          paymentMethods: false,
        ),
        transactions: transactions,
        categories: categories,
        paymentMethods: methods,
      );
      final bytes = document.toCsv();
      expect(bytes.take(3), [0xEF, 0xBB, 0xBF]);
      final csv = utf8.decode(bytes.sublist(3));
      expect(csv, contains('"Café, ""Central"""'));
      expect(csv, contains('123.45'));
      expect(csv, isNot(contains('Fuera del rango')));
    },
  );

  test(
    'el documento de exportación se puede procesar en otro isolate',
    () async {
      final document = ExportDocument(
        from: date,
        to: date,
        selection: const ExportSelection(
          categories: false,
          paymentMethods: false,
        ),
        transactions: transactions,
        categories: categories,
        paymentMethods: methods,
      );

      final bytes = await compute(_buildCsv, document);

      expect(bytes, document.toCsv());
    },
  );

  test('el XLSX se genera como archivo Office Open XML', () {
    final document = ExportDocument(
      from: date,
      to: date,
      selection: const ExportSelection(),
      transactions: transactions,
      categories: categories,
      paymentMethods: methods,
    );
    final bytes = document.toXlsx();
    expect(bytes, isNotEmpty);
    expect(bytes.take(2), [0x50, 0x4B]);
    final workbook = Excel.decodeBytes(bytes);
    expect(
      workbook.tables.keys,
      containsAll([
        'Movimientos',
        'Categorías',
        'Métodos de pago',
        'Presupuestos',
        'Metas de ahorro',
        'Obligaciones',
        'Listas de compras',
        'Recurrentes',
      ]),
    );
  });

  test('el PDF se genera con firma PDF', () async {
    final document = ExportDocument(
      from: date,
      to: date,
      selection: const ExportSelection(
        categories: false,
        paymentMethods: false,
      ),
      transactions: transactions,
      categories: categories,
      paymentMethods: methods,
    );
    final font = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final bytes = await document.toPdf(fontBytes: font.buffer.asUint8List());
    expect(utf8.decode(bytes.take(5).toList()), '%PDF-');
  });
}

Uint8List _buildCsv(ExportDocument document) => document.toCsv();
