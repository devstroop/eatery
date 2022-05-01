import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({Key? key, this.title, required this.message, this.actions}) : super(key: key);
  final String? title;
  final String message;
  final List<Widget>? actions;

  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? ''),
      content: Text(message),
      actions: actions,
    );
  }
}
