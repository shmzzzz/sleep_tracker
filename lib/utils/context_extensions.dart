import 'package:flutter/material.dart';

extension ContextSnackBar on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> showErrorDialog({
    required String title,
    required String message,
    List<Widget> Function(BuildContext dialogContext)? actionsBuilder,
  }) {
    return showDialog<void>(
      context: this,
      builder: (dialogContext) {
        final actions = actionsBuilder?.call(dialogContext) ??
            [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('OK'),
              ),
            ];
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        );
      },
    );
  }
}
