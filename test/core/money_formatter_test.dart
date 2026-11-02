import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/money/money_formatter.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';

void main() {
  test('formats DOP minor units with the Dominican peso symbol', () {
    final formatted = MoneyFormatter.formatDopMinorUnits(2500000);

    expect(formatted, contains('RD\$'));
    expect(formatted, contains('25,000.00'));
  });

  test('can display the DOP ISO code instead of the symbol', () {
    final formatted = MoneyFormatter.formatDopMinorUnits(
      12345,
      style: CurrencyFormatStyle.code,
    );

    expect(formatted, contains('DOP'));
    expect(formatted, contains('123.45'));
  });
}
