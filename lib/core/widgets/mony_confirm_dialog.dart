import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

abstract final class MonyConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Cancelar',
    bool destructive = false,
    bool barrierDismissible = true,
  }) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: confirmLabel,
      cancelLabel: cancelLabel,
      defaultType: OkCancelAlertDefaultType.cancel,
      isDestructiveAction: destructive,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
    );
    return result == OkCancelResult.ok;
  }
}
