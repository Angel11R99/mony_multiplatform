import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theme/mony_tokens.dart';

enum MonyFeedbackKind { success, info, warning, error }

abstract final class MonyFeedback {
  static void success(BuildContext context, String message) =>
      show(context, message, kind: MonyFeedbackKind.success);

  static void info(BuildContext context, String message) =>
      show(context, message, kind: MonyFeedbackKind.info);

  static void warning(BuildContext context, String message) =>
      show(context, message, kind: MonyFeedbackKind.warning);

  static void error(BuildContext context, String message) =>
      show(context, message, kind: MonyFeedbackKind.error);

  static void show(
    BuildContext context,
    String message, {
    MonyFeedbackKind kind = MonyFeedbackKind.info,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final (toastType, icon, color) = switch (kind) {
      MonyFeedbackKind.success => (
        ToastificationType.success,
        Icons.check_circle_outline,
        scheme.primary,
      ),
      MonyFeedbackKind.info => (
        ToastificationType.info,
        Icons.info_outline,
        scheme.primary,
      ),
      MonyFeedbackKind.warning => (
        ToastificationType.warning,
        Icons.warning_amber_outlined,
        scheme.tertiary,
      ),
      MonyFeedbackKind.error => (
        ToastificationType.error,
        Icons.error_outline,
        scheme.error,
      ),
    };

    toastification.show(
      context: context,
      alignment: Alignment.bottomCenter,
      type: toastType,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(icon, color: color),
      primaryColor: color,
      backgroundColor: scheme.surfaceContainerHigh,
      foregroundColor: scheme.onSurface,
      borderSide: BorderSide(color: scheme.outlineVariant),
      borderRadius: BorderRadius.circular(MonyRadius.medium),
      padding: const EdgeInsets.symmetric(
        horizontal: MonySpace.x4,
        vertical: MonySpace.x3,
      ),
      animationDuration: MonyMotion.durationFor(context, MonyMotion.quick),
      autoCloseDuration: kind == MonyFeedbackKind.error
          ? const Duration(seconds: 6)
          : const Duration(seconds: 4),
      showProgressBar: false,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
    );
  }

  static void undo(
    BuildContext context,
    String message, {
    required Future<void> Function() onUndo,
  }) {
    final scheme = Theme.of(context).colorScheme;
    toastification.showCustom(
      context: context,
      alignment: Alignment.bottomCenter,
      animationDuration: MonyMotion.durationFor(context, MonyMotion.quick),
      autoCloseDuration: const Duration(seconds: 5),
      builder: (toastContext, item) => Semantics(
        liveRegion: true,
        child: Card(
          color: scheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MonySpace.x4,
              vertical: MonySpace.x2,
            ),
            child: Row(
              children: [
                Expanded(child: Text(message)),
                TextButton(
                  onPressed: () async {
                    toastification.dismiss(item);
                    try {
                      await onUndo();
                    } catch (_) {
                      if (toastContext.mounted) {
                        error(toastContext, 'No se pudo deshacer la acción.');
                      }
                    }
                  },
                  child: const Text('Deshacer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
