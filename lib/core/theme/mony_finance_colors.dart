import 'package:flutter/material.dart';

import 'mony_tokens.dart';
import 'coquette_visuals.dart';

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

  static MonyFinanceColors forBrightness(
    Brightness brightness, {
    bool japanese = false,
    bool coquette = false,
    bool cyberpunk = false,
  }) {
    final dark = brightness == Brightness.dark;
    if (cyberpunk) {
      const cyber = Color(0xFFB8FF3D);
      return const MonyFinanceColors(
        income: cyber,
        onIncome: Color(0xFF10131D),
        expense: Color(0xFFFF2DA6),
        onExpense: Color(0xFF160812),
        warning: Color(0xFFFFC857),
        onWarning: Color(0xFF211A0D),
      );
    }
    if (coquette) {
      const bloom = CoquetteThemeColors.defaults;
      const atelierDark = CoquetteSurfaceTokens.dark;
      return MonyFinanceColors(
        income: dark ? atelierDark.incomeAccent : bloom.income,
        onIncome: dark ? atelierDark.page : Colors.white,
        expense: dark ? atelierDark.expenseAccent : const Color(0xFF9B3E57),
        onExpense: dark ? atelierDark.page : Colors.white,
        warning: dark ? atelierDark.warningAccent : const Color(0xFF80613C),
        onWarning: dark ? atelierDark.page : Colors.white,
      );
    }
    if (japanese) {
      return MonyFinanceColors(
        income: dark ? const Color(0xFF8EAC91) : const Color(0xFF496B50),
        onIncome: dark ? const Color(0xFF151311) : Colors.white,
        expense: dark ? const Color(0xFFD67B68) : const Color(0xFF8F2C22),
        onExpense: dark ? const Color(0xFF241512) : Colors.white,
        warning: dark ? const Color(0xFFB5955D) : const Color(0xFF806443),
        onWarning: dark ? const Color(0xFF211A0D) : Colors.white,
      );
    }
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
