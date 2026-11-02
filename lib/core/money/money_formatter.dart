import 'package:intl/intl.dart';

import '../../features/preferences/domain/app_preferences.dart';

abstract final class MoneyFormatter {
  /// Parses a decimal DOP amount into integer centavos without using doubles.
  static int? parseDopMinorUnits(String input) {
    final normalized = input.trim().replaceAll(',', '.');
    if (!RegExp(r'^-?\d+(\.\d{1,2})?$').hasMatch(normalized)) return null;
    final negative = normalized.startsWith('-');
    final unsigned = negative ? normalized.substring(1) : normalized;
    final parts = unsigned.split('.');
    final whole = int.tryParse(parts.first);
    if (whole == null) return null;
    final fraction = parts.length == 1
        ? 0
        : int.parse(parts.last.padRight(2, '0'));
    final amount = whole * 100 + fraction;
    return negative ? -amount : amount;
  }

  static String toDopInput(int amountInCents) {
    final negative = amountInCents < 0;
    final absolute = amountInCents.abs();
    return '${negative ? '-' : ''}${absolute ~/ 100}.${(absolute % 100).toString().padLeft(2, '0')}';
  }

  static String formatDopMinorUnits(
    int amountInCents, {
    CurrencyFormatStyle style = CurrencyFormatStyle.symbol,
  }) {
    final symbol = switch (style) {
      CurrencyFormatStyle.symbol => 'RD\$',
      CurrencyFormatStyle.code => 'DOP',
    };
    final formatter = NumberFormat.currency(
      // Match Mony's existing RD$1,234.56 convention on every device locale.
      locale: 'en_US',
      name: 'DOP',
      symbol: symbol,
      decimalDigits: 2,
    );

    return formatter.format(amountInCents / 100);
  }
}
