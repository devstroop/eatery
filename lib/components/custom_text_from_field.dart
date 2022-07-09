import 'package:flutter/material.dart';
import 'package:eatery/style/color_style.dart';

class CustomTextFromField extends StatelessWidget {
  const CustomTextFromField({Key? key, required this.controller, required this.labelText, required this.obscureText, this.keyboardType, this.autoValidate, this.validator, this.themeColor, this.minLines, this.maxLines, this.enabled, this.prefixWidget, this.suffixWidget}) : super(key: key);
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool? autoValidate;
  final Function()? validator;
  final Color? themeColor;
  final int? minLines;
  final int? maxLines;
  final bool? enabled;
  final Widget? prefixWidget;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction ,
      onEditingComplete: validator,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget != null ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            suffixWidget!
          ],
        ) : null,
        hintText: labelText,
        hintStyle: TextStyle(
          color: ColorStyle.text400,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorStyle.text400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorStyle.text400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: themeColor ?? ColorStyle.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: enabled != null ? (enabled! ? Colors.white : const Color.fromRGBO(240, 240, 240, 1)) : Colors.white,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
      ),
      style: TextStyle(
        color: ColorStyle.text200,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    )
    ;
  }
}
