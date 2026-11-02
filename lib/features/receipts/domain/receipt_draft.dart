import '../../../core/money/money_formatter.dart';
import '../../transactions/domain/transaction.dart';

class ReceiptLineItem {
  const ReceiptLineItem({required this.name, this.amountInCents});
  final String name;
  final int? amountInCents;
}

class ReceiptDraft {
  const ReceiptDraft({
    required this.merchant,
    required this.date,
    required this.totalInCents,
    required this.items,
    required this.rawText,
  });

  final String merchant;
  final DateTime? date;
  final int? totalInCents;
  final List<ReceiptLineItem> items;
  final String rawText;

  String get itemSummary => items.map((item) => item.name).join(', ');
}

abstract final class ReceiptParser {
  static ReceiptDraft parse(String rawText) {
    final lines = rawText
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
    final date = _date(lines);
    final merchant = _merchant(lines);
    final items = _items(lines);
    final total = _total(lines) ?? _sum(items);
    return ReceiptDraft(
      merchant: merchant,
      date: date,
      totalInCents: total,
      items: items,
      rawText: rawText,
    );
  }

  static List<FinanceTransaction> potentialDuplicates({
    required int amountInCents,
    required DateTime date,
    required String merchant,
    required Iterable<FinanceTransaction> transactions,
  }) {
    final merchantKey = _normalize(merchant);
    return transactions
        .where((transaction) {
          if (transaction.type != TransactionType.expense ||
              transaction.amountInCents != amountInCents ||
              !_sameDay(transaction.date, date)) {
            return false;
          }
          if (merchantKey.isEmpty) return true;
          return _normalize(
            transaction.description ?? '',
          ).contains(merchantKey);
        })
        .toList(growable: false);
  }

  static DateTime? _date(List<String> lines) {
    final patterns = [
      RegExp(r'\b(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{2}|\d{4})\b'),
      RegExp(r'\b(20\d{2})-(\d{1,2})-(\d{1,2})\b'),
    ];
    for (final line in lines) {
      for (
        var patternIndex = 0;
        patternIndex < patterns.length;
        patternIndex++
      ) {
        final match = patterns[patternIndex].firstMatch(line);
        if (match == null) continue;
        final first = int.tryParse(match.group(1) ?? '');
        final second = int.tryParse(match.group(2) ?? '');
        final third = int.tryParse(match.group(3) ?? '');
        if (first == null || second == null || third == null) continue;
        final year = patternIndex == 0
            ? (third < 100 ? 2000 + third : third)
            : first;
        final month = patternIndex == 0 ? second : second;
        final day = patternIndex == 0 ? first : third;
        if (year < 2000 || year > 2100 || month < 1 || month > 12) continue;
        final result = DateTime(year, month, day);
        if (result.year == year && result.month == month && result.day == day) {
          return result;
        }
      }
    }
    return null;
  }

  static String _merchant(List<String> lines) {
    for (final line in lines.take(6)) {
      final normalized = line.toLowerCase();
      if (_date([line]) != null ||
          !_hasLetters(line) ||
          RegExp(
            r'\b(rnc|tel|telefono|factura|ticket|cajero|cliente|ncf)\b',
          ).hasMatch(normalized) ||
          _amountTokens(line).isNotEmpty) {
        continue;
      }
      if (line.length >= 3) return line;
    }
    return '';
  }

  static List<ReceiptLineItem> _items(List<String> lines) {
    final result = <ReceiptLineItem>[];
    for (final line in lines) {
      final normalized = line.toLowerCase();
      if (_date([line]) != null ||
          RegExp(
            r'\b(total|subtotal|itbis|iva|rnc|tel|telefono|factura|ncf|efectivo|tarjeta|cambio|descuento)\b',
          ).hasMatch(normalized)) {
        continue;
      }
      final tokens = _amountTokens(line);
      if (tokens.isEmpty) continue;
      final token = tokens.last;
      final name = line
          .replaceRange(token.start, token.end, '')
          .replaceAll(RegExp(r'^[\s\-:|·]+|[\s\-:|·]+$'), '')
          .trim();
      if (!_hasLetters(name) || name.length < 2) continue;
      result.add(ReceiptLineItem(name: name, amountInCents: token.cents));
    }
    return result;
  }

  static int? _total(List<String> lines) {
    for (var index = lines.length - 1; index >= 0; index--) {
      final line = lines[index];
      final normalized = line.toLowerCase();
      if (RegExp(r'\b(subtotal|itbis|iva)\b').hasMatch(normalized)) continue;
      if (!RegExp(
        r'\b(total|a pagar|importe|monto pagado)\b',
      ).hasMatch(normalized)) {
        continue;
      }
      final tokens = _amountTokens(line);
      if (tokens.isNotEmpty) return tokens.last.cents;
      if (index + 1 < lines.length) {
        final following = _amountTokens(lines[index + 1]);
        if (following.isNotEmpty) return following.last.cents;
      }
    }
    return null;
  }

  static int? _sum(List<ReceiptLineItem> items) {
    final amounts = items.map((item) => item.amountInCents).toList();
    if (amounts.isEmpty || amounts.any((amount) => amount == null)) return null;
    return amounts.fold<int>(0, (sum, amount) => sum + amount!);
  }

  static List<_AmountToken> _amountTokens(String line) {
    final regex = RegExp(
      r'(?<!\d)\d{1,3}(?:[,. ]\d{3})+(?:[,.]\d{1,2})?(?!\d)|(?<!\d)\d+(?:[,.]\d{1,2})(?!\d)|(?<!\d)\d+(?!\d)',
    );
    return [
      for (final match in regex.allMatches(line))
        if (_parseAmount(match.group(0) ?? '') case final cents?)
          _AmountToken(match.start, match.end, cents),
    ];
  }

  static int? _parseAmount(String token) {
    var value = token.replaceAll(' ', '');
    final comma = value.lastIndexOf(',');
    final dot = value.lastIndexOf('.');
    if (comma >= 0 && dot >= 0) {
      if (comma > dot) {
        value = value.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        value = value.replaceAll(',', '');
      }
    } else if (comma >= 0) {
      final digitsAfter = value.length - comma - 1;
      value = digitsAfter == 1 || digitsAfter == 2
          ? value.replaceFirst(',', '.')
          : value.replaceAll(',', '');
    } else if (dot >= 0 && value.length - dot - 1 == 3) {
      value = value.replaceAll('.', '');
    }
    return MoneyFormatter.parseDopMinorUnits(value);
  }

  static bool _hasLetters(String value) =>
      RegExp(r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]').hasMatch(value);

  static String _normalize(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9áéíóúüñ]'), '');

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _AmountToken {
  const _AmountToken(this.start, this.end, this.cents);
  final int start;
  final int end;
  final int cents;
}
