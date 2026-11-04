import 'package:flutter/material.dart';

import '../theme/mony_tokens.dart';
import '../theme/sumi_visuals.dart';

class MonyCard extends StatelessWidget {
  const MonyCard({
    required this.child,
    this.padding = const EdgeInsets.all(MonySpace.x4),
    this.onTap,
    this.semanticLabel,
    this.sumiVariant = SumiSurfaceVariant.openFrame,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final SumiSurfaceVariant sumiVariant;

  @override
  Widget build(BuildContext context) {
    return SumiSurface(
      semanticLabel: semanticLabel,
      variant: sumiVariant,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    this.maxWidth = MonyBreakpoints.contentMax,
    this.padding = const EdgeInsets.symmetric(horizontal: MonySpace.x4),
    this.alignment = Alignment.topCenter,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(padding: padding, child: child),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.action, super.key});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      ?action,
    ],
  );
}
