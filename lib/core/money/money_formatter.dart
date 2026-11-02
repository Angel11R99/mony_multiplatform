import 'package:intl/intl.dart';

import '../../features/preferences/domain/app_preferences.dart';

abstract final class MoneyFormatter {
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
