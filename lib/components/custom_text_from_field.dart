import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:uicons/uicons.dart';

class CustomTextFromField extends StatefulWidget {
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
    this.prefix,
    this.suffix,
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
  final Widget? prefix;
  final Widget? suffix;
  final String? title;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  State<CustomTextFromField> createState() => _CustomTextFromFieldState();
}

class _CustomTextFromFieldState extends State<CustomTextFromField> {
  bool? obscureText;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        obscureText = widget.obscureText;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.focusNode != null) {
          FocusScope.of(context).requestFocus(widget.focusNode);
        }
      },
      child: Column(
      mainAxisSize: MainAxisSize.min,
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
          obscureText: obscureText ?? false,
          minLines: widget.minLines ?? 1,
          maxLines: widget.maxLines ?? 1,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix != null
                ? widget.suffix!
                : widget.isPassword
                    ? IconButton(
                        onPressed: () => setState(() {
                          obscureText = !(obscureText ?? false);
                        }),
                        icon: obscureText ?? false
                            ? Icon(UIcons.regularStraight.eye)
                            : Icon(UIcons.regularStraight.crossed_eye),
                        color: ColorStyle.text400,
                      )
                    : null,
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
            fillColor: widget.enabled != null
                ? (widget.enabled!
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
