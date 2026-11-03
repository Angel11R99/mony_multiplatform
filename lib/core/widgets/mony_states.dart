import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/mony_tokens.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MonySpace.x6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Icon(icon, size: 34, color: colors.primary),
                ),
              ),
            ),
            const SizedBox(height: MonySpace.x3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: MonySpace.x1),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: MonySpace.x3),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    super.key,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(MonySpace.x6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, size: 40)),
            const SizedBox(height: MonySpace.x3),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: MonySpace.x3),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    ),
  );
}

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({this.message = 'Cargando', super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    label: message,
    child: ExcludeSemantics(
      child: Skeletonizer(
        enabled: true,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(MonySpace.x6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Card(child: SizedBox(width: 260, height: 104)),
                const SizedBox(height: MonySpace.x3),
                const Card(child: SizedBox(width: 260, height: 58)),
                const SizedBox(height: MonySpace.x3),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// A restrained shared entrance for primary financial content.
class MonyEntrance extends StatelessWidget {
  const MonyEntrance({
    required this.child,
    this.delay = Duration.zero,
    super.key,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final duration = MonyMotion.durationFor(context, MonyMotion.emphasis);
    if (duration == Duration.zero) return child;
    final isRouteActive = TickerMode.valuesOf(context).enabled;
    return child
        .animate(delay: delay, autoPlay: isRouteActive)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideY(
          begin: .025,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}
