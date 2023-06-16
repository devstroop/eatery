import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class CustomTextFromField extends StatelessWidget {
  const CustomTextFromField({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.isPassword = false,
    this.keyboardType,
    this.autoValidate,
    this.onEditingComplete,
    this.validator,
    this.themeColor,
    this.minLines,
    this.maxLines,
    this.enabled,
    this.prefixWidget,
    this.suffixWidget,
    this.title,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController? controller;
  final String hint;
  final bool obscureText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool? autoValidate;
  final Function()? onEditingComplete;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final Color? themeColor;
  final int? minLines;
  final int? maxLines;
  final bool? enabled;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final String? title;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              color: ColorStyle.text200,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (title != null)
          const SizedBox(
            height: 3.0,
          ),
        TextFormField(
          enabled: enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obscureText,
          minLines: minLines ?? 1,
          maxLines: maxLines ?? 1,
          textInputAction: textInputAction,
          autofocus: autofocus,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            prefixIcon: prefixWidget,
            suffixIcon: suffixWidget != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [suffixWidget!],
                  )
                : isPassword
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (obscureText)
                            IconButton(
                              onPressed: () => {},
                              icon: const Icon(Icons.visibility),
                              color: ColorStyle.text400,
                            )
                          else
                            IconButton(
                              onPressed: () => {},
                              icon: const Icon(Icons.visibility_off),
                              color: ColorStyle.text400,
                            ),
                        ],
                      )
                    : null,
            hintText: hint,
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
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorStyle.error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorStyle.error,
                width: 2,
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
            fillColor: enabled != null
                ? (enabled!
                    ? Colors.white
                    : const Color.fromRGBO(240, 240, 240, 1))
                : Colors.white,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
          ),
          style: TextStyle(
            color: ColorStyle.text200,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
