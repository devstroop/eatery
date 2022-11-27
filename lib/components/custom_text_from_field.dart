import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class CustomTextFromField extends StatefulWidget {
  CustomTextFromField({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscureText,
    this.isPassword,
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
    this.autofocus,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
  }) : super(key: key);
  final TextEditingController? controller;
  final String hint;
  bool? obscureText;
  final bool? isPassword;

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
  final bool? autofocus;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  State<CustomTextFromField> createState() => _CustomTextFromFieldState();
}

class _CustomTextFromFieldState extends State<CustomTextFromField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: TextStyle(
              color: ColorStyle.text200,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (widget.title != null)
          const SizedBox(
            height: 3.0,
          ),
        TextFormField(
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: widget.onEditingComplete,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: widget.obscureText ?? false,
          minLines: widget.minLines ?? 1,
          maxLines: widget.maxLines ?? 1,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus ?? false,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            prefixIcon: widget.prefixWidget,
            suffixIcon: widget.suffixWidget != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [widget.suffixWidget!],
                  )
                : widget.isPassword ?? false ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(widget.obscureText ?? false)
                  IconButton(onPressed: (){
                    setState(() {
                      widget.obscureText = false;
                    });
                  }, icon: const Icon(Icons.visibility), color: ColorStyle.text400,)
                else
                  IconButton(onPressed: (){
                    setState(() {
                      widget.obscureText = true;
                    });
                    }, icon: const Icon(Icons.visibility_off), color: ColorStyle.text400,)
              ],
            ) : null,
            hintText: widget.hint,
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
                color: widget.themeColor ?? ColorStyle.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor:
                widget.enabled != null ? (widget.enabled! ? Colors.white : const Color.fromRGBO(240, 240, 240, 1)) : Colors.white,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
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
