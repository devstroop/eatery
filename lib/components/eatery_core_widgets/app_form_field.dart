import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// A form field molecule that composes [Text] label + [AppTextField] + spacing.
///
/// Replaces every usage of [LabeledCustomTextFormField]. All visual properties
/// derive from design tokens — no raw colors, spacings, or text styles.
///
/// ```dart
/// AppFormField(
///   label: 'Customer Name',
///   hint: 'Enter full name',
///   controller: _controllerName,
///   focusNext: _focusNodes[1],
///   validator: (v) => v!.isEmpty ? 'Required' : null,
/// )
/// ```
class AppFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? focusNext;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final bool multiline;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;

  const AppFormField({
    super.key,
    required this.label,
    this.hint = '',
    required this.controller,
    this.focusNode,
    this.focusNext,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.multiline = false,
    this.obscureText = false,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.fieldLabel.copyWith(color: AppColors.fieldLabel),
        ),
        SizedBox(height: AppSpacing.fieldLabelGap),
        _AppTextField(
          controller: controller,
          hint: hint,
          focusNode: focusNode,
          textInputAction: textInputAction ?? TextInputAction.next,
          validator: validator,
          onFieldSubmitted: (v) {
            onFieldSubmitted?.call(v);
            if (focusNext != null) {
              FocusScope.of(context).requestFocus(focusNext);
            }
          },
          keyboardType: keyboardType,
          multiline: multiline,
          obscureText: obscureText,
          prefix: prefix,
          suffix: suffix,
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

/// Internal text field that consumes design tokens.
class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final bool multiline;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;

  const _AppTextField({
    required this.controller,
    required this.hint,
    this.focusNode,
    required this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.multiline = false,
    this.obscureText = false,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: multiline ? 3 : 1,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTypography.fieldValue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.fieldHint),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: AppSpacing.fieldPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          borderSide: BorderSide(color: AppColors.fieldFocusBorder, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          borderSide: BorderSide(color: AppColors.fieldErrorBorder),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          borderSide: BorderSide(color: AppColors.fieldErrorBorder, width: 2),
        ),
      ),
    );
  }
}
