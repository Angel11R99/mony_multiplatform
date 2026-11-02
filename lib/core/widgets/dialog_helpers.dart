import 'package:flutter/material.dart';

/// Keeps dialog resources alive until its reverse transition has finished.
Future<T?> showDialogAndWaitForDismissal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  Future<void>? routeCompleted;
  final result = await showDialog<T>(
    context: context,
    builder: (dialogContext) {
      routeCompleted ??= ModalRoute.of(
        dialogContext,
      )?.completed.then<void>((_) {});
      return builder(dialogContext);
    },
  );
  await routeCompleted;
  return result;
}
