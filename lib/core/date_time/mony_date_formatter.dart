import 'package:intl/intl.dart';

abstract final class MonyDateFormatter {
  static String formatDate(DateTime date) => DateFormat.yMMMd().format(date);

  static String formatMonthYear(DateTime date) =>
      DateFormat.yMMMM().format(date);

  static String formatTime(DateTime value, {required bool use24HourFormat}) =>
      (use24HourFormat ? DateFormat.Hm() : DateFormat('h:mm a')).format(value);

  static String formatDateTime(
    DateTime value, {
    required bool use24HourFormat,
  }) =>
      '${formatDate(value)} ${formatTime(value, use24HourFormat: use24HourFormat)}';
}
