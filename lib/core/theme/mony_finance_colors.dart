import 'package:flutter/material.dart';

import 'mony_tokens.dart';

@immutable
class MonyFinanceColors extends ThemeExtension<MonyFinanceColors> {
  const MonyFinanceColors({
    required this.income,
    required this.onIncome,
    required this.expense,
    required this.onExpense,
    required this.warning,
    required this.onWarning,
  });

  final Color income;
  final Color onIncome;
  final Color expense;
  final Color onExpense;
  final Color warning;
  final Color onWarning;

  static MonyFinanceColors forBrightness(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return MonyFinanceColors(
      income: dark ? MonyPalette.income : MonyPalette.incomeDark,
      onIncome: dark ? const Color(0xFF10251C) : Colors.white,
      expense: dark ? MonyPalette.expense : MonyPalette.expenseDark,
      onExpense: dark ? const Color(0xFF32151A) : Colors.white,
      warning: dark ? MonyPalette.warning : MonyPalette.warningDark,
      onWarning: dark ? const Color(0xFF2A200D) : Colors.white,
    );
  }

  static MonyFinanceColors of(BuildContext context) =>
      Theme.of(context).extension<MonyFinanceColors>()!;

  @override
  MonyFinanceColors copyWith({
    Color? income,
    Color? onIncome,
    Color? expense,
    Color? onExpense,
    Color? warning,
    Color? onWarning,
  }) => MonyFinanceColors(
    income: income ?? this.income,
    onIncome: onIncome ?? this.onIncome,
    expense: expense ?? this.expense,
    onExpense: onExpense ?? this.onExpense,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
  );

  @override
  MonyFinanceColors lerp(ThemeExtension<MonyFinanceColors>? other, double t) {
    if (other is! MonyFinanceColors) return this;
    return MonyFinanceColors(
      income: Color.lerp(income, other.income, t)!,
      onIncome: Color.lerp(onIncome, other.onIncome, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      onExpense: Color.lerp(onExpense, other.onExpense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
    );
  }
}
