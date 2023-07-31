import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context, String title,
    String message, Function onConfirm, Function onCancel) {
  return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onCancel();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: const Text('Confirm')),
            ],
          ));
}
