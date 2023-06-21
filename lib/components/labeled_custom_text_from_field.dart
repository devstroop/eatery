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
      this.hint = '',
      this.focusNode,
      this.textInputAction = TextInputAction.done,
      this.validator,
      this.onFieldSubmitted,
      this.keyboardType});
  final String label;
  final String hint;
  final Color foregroundColor;
  final Color backgroundColor;
  final TextEditingController controller;
  final bool multiline;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final String? Function(dynamic value)? validator;
  final Function(dynamic v)? onFieldSubmitted;
  final TextInputType? keyboardType;

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
            hint: hint,
            obscureText: obscureText,
            themeColor: backgroundColor,
            maxLines: multiline ? 4 : null,
            minLines: multiline ? 2 : null,
            focusNode: focusNode,
            textInputAction: textInputAction,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ]);
  }
}
