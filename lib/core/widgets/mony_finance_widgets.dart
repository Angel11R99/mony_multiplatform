import 'package:flutter/material.dart';

import '../theme/mony_finance_colors.dart';
import '../theme/mony_tokens.dart';
import '../theme/sumi_visuals.dart';
import '../theme/coquette_visuals.dart';
import 'mony_layout.dart';

enum AmountEmphasis { neutral, income, expense }

class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    this.emphasis = AmountEmphasis.neutral,
    this.style,
    this.maxLines = 1,
    super.key,
  });

  final String amount;
  final AmountEmphasis emphasis;
  final TextStyle? style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final finance = MonyFinanceColors.of(context);
    final color = switch (emphasis) {
      AmountEmphasis.neutral => null,
      AmountEmphasis.income => finance.income,
      AmountEmphasis.expense => finance.expense,
    };
    return Text(
      amount,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: (style ?? const TextStyle()).copyWith(
        color: color ?? style?.color ?? Theme.of(context).colorScheme.onSurface,
        backgroundColor: Colors.transparent,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    required this.amount,
    required this.label,
    required this.supportingText,
    super.key,
  });

  final String amount;
  final String label;
  final String supportingText;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final japanese = SumiThemeColors.maybeOf(context) != null;
    final coquette = CoquetteThemeColors.maybeOf(context) != null;
    final sumiPaper = SumiThemeColors.defaults.paper;
    final content = Padding(
      padding: const EdgeInsets.all(MonySpace.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: japanese ? sumiPaper : null,
            ),
          ),
          const SizedBox(height: MonySpace.x2),
          AmountText(
            amount,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: japanese ? sumiPaper : null,
            ),
          ),
          const SizedBox(height: MonySpace.x1),
          Text(
            supportingText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: japanese ? SumiThemeColors.defaults.warmPaper : null,
            ),
          ),
        ],
      ),
    );
    return MonyCard(
      semanticLabel: '$label. $amount. $supportingText',
      padding: EdgeInsets.zero,
      sumiVariant: SumiSurfaceVariant.inkBlock,
      child: japanese || coquette
          ? content
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [scheme.primaryContainer, scheme.surfaceContainerLow],
                ),
                borderRadius: BorderRadius.circular(MonyRadius.medium),
              ),
              child: content,
            ),
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({
    required this.title,
    required this.value,
    required this.icon,
    this.emphasis = AmountEmphasis.neutral,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final AmountEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    final finance = MonyFinanceColors.of(context);
    final color = switch (emphasis) {
      AmountEmphasis.neutral => Theme.of(context).colorScheme.onSurfaceVariant,
      AmountEmphasis.income => finance.income,
      AmountEmphasis.expense => finance.expense,
    };
    return MonyCard(
      semanticLabel: '$title: $value',
      padding: const EdgeInsets.all(MonySpace.x3),
      sumiVariant: switch (emphasis) {
        AmountEmphasis.neutral => SumiSurfaceVariant.openFrame,
        AmountEmphasis.income => SumiSurfaceVariant.minimalJade,
        AmountEmphasis.expense => SumiSurfaceVariant.minimalVermilion,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: MonySpace.x2),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: MonySpace.x3),
          AmountText(
            value,
            emphasis: emphasis,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
