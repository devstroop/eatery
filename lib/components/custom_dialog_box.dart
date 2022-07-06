import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({Key? key, this.title, required this.child, this.actions}) : super(key: key);
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? ''),
      content: child,
      actions: actions,
    );
  }
}
