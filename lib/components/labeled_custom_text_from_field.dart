import 'package:eatery/components/custom_text_from_field.dart';
import 'package:flutter/material.dart';

class LabeledCustomTextFromField extends StatelessWidget {
  const LabeledCustomTextFromField(
      {super.key,
      required this.label,
      required this.foregroundColor,
      required this.backgroundColor,
      required this.controller,
      this.multiline = false,
      this.obscureText = false,
      this.description = ''});
  final String label;
  final String description;
  final Color foregroundColor;
  final Color backgroundColor;
  final TextEditingController controller;
  final bool multiline;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          CustomTextFromField(
            controller: controller,
            hint: description,
            obscureText: obscureText,
            themeColor: backgroundColor,
            maxLines: multiline ? 4 : null,
            minLines: multiline ? 2 : null,
          ),
        ]);
  }
}
