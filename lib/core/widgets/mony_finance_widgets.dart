import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../theme/mony_finance_colors.dart';
import '../theme/mony_tokens.dart';
import 'mony_layout.dart';

enum AmountEmphasis { neutral, income, expense }

class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    this.emphasis = AmountEmphasis.neutral,
    this.style,
    this.maxLines = 1,
    this.animateChanges = false,
    super.key,
  });

  final String amount;
  final AmountEmphasis emphasis;
  final TextStyle? style;
  final int maxLines;
  final bool animateChanges;

  @override
  Widget build(BuildContext context) {
    final finance = MonyFinanceColors.of(context);
    final color = switch (emphasis) {
      AmountEmphasis.neutral => null,
      AmountEmphasis.income => finance.income,
      AmountEmphasis.expense => finance.expense,
    };
    final text = Text(
      amount,
      key: ValueKey(amount),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style:
          style?.copyWith(
            color: color,
            backgroundColor: Colors.transparent,
            fontFeatures: const [FontFeature.tabularFigures()],
          ) ??
          TextStyle(
            color: color,
            backgroundColor: Colors.transparent,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
    );
    final content = animateChanges
        ? PageTransitionSwitcher(
            duration: MonyMotion.durationFor(context, MonyMotion.quick),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                ),
            child: text,
          )
        : text;
    return Semantics(
      label: amount,
      child: ExcludeSemantics(child: content),
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
    return MonyCard(
      semanticLabel: '$label. $amount. $supportingText',
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [scheme.primaryContainer, scheme.surfaceContainerLow],
          ),
          borderRadius: BorderRadius.circular(MonyRadius.medium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(MonySpace.x6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: MonySpace.x2),
              AmountText(
                amount,
                animateChanges: true,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: MonySpace.x1),
              Text(
                supportingText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
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
            animateChanges: true,
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
