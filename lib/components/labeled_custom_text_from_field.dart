import 'package:eatery/references.dart';

class LabeledCustomTextFromField extends StatelessWidget {
  const LabeledCustomTextFromField(
      {super.key,
      required this.label,
      required this.foregroundColor,
      required this.themeColor,
      required this.controller,
      this.multiline = false,
      this.obscureText = false,
      this.hint = '',
      this.focusNode,
      this.textInputAction = TextInputAction.done,
      this.validator,
      this.onFieldSubmitted,
      this.keyboardType, this.prefix, this.suffix});
  final String label;
  final String hint;
  final Color foregroundColor;
  final Color themeColor;
  final TextEditingController controller;
  final bool multiline;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final String? Function(dynamic value)? validator;
  final Function(dynamic v)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;

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
            prefix: prefix,
            suffix: suffix,
            controller: controller,
            hint: hint,
            obscureText: obscureText,
            themeColor: themeColor,
            maxLines: multiline ? 4 : null,
            minLines: multiline ? 2 : null,
            focusNode: focusNode,
            textInputAction: textInputAction,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: keyboardType,
          ),
        ]);
  }
}
