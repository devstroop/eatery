import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_component.dart';
import '../theme/app_typography.dart';

/// Consistent button widget used across the entire app.
///
/// All visual properties derive from [AppComponentStyle] + design tokens.
/// No raw `Color`, `EdgeInsets`, or `double` values.
///
/// ```dart
/// AppButton.primary(label: 'Next', onPressed: () {})
/// AppButton.secondary(label: 'Cancel', onPressed: () {})
/// AppButton.destructive(label: 'Delete', onPressed: () {})
/// AppButton.ghost(label: 'Skip', onPressed: () {})
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppVariant variant;
  final AppSemantic semantic;
  final AppSize size;
  final double? width;
  final bool loading;
  final IconData? icon;
  final Widget? trailingIcon;
  final double? height;
  final AppComponentStyle style;

  /// Primary filled button.
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height,
    this.size = AppSize.md,
    this.loading = false,
    this.icon,
    AppComponentStyle? style,
  }) : variant = AppVariant.filled,
       semantic = AppSemantic.primary,
       trailingIcon = null,
       style = style ?? const AppComponentStyle();

  /// Outlined secondary button.
  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height,
    this.size = AppSize.md,
    this.loading = false,
    this.icon,
    AppComponentStyle? style,
  }) : variant = AppVariant.outlined,
       semantic = AppSemantic.secondary,
       trailingIcon = null,
       style = style ?? const AppComponentStyle();

  /// Destructive filled button.
  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height,
    this.size = AppSize.md,
    this.loading = false,
    this.icon,
    AppComponentStyle? style,
  }) : variant = AppVariant.filled,
       semantic = AppSemantic.danger,
       trailingIcon = null,
       style = style ?? const AppComponentStyle();

  /// Ghost (text-only) button.
  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height,
    this.size = AppSize.md,
    this.loading = false,
    this.icon,
    Widget? trailingIcon,
    AppComponentStyle? style,
  }) : variant = AppVariant.ghost,
       semantic = AppSemantic.secondary,
       trailingIcon = trailingIcon,
       style = style ?? const AppComponentStyle();

  /// Full custom configuration.
  const AppButton.custom({
    super.key,
    required this.label,
    this.onPressed,
    required this.variant,
    required this.semantic,
    this.size = AppSize.md,
    this.width,
    this.height,
    this.loading = false,
    this.icon,
    this.trailingIcon,
    AppComponentStyle? style,
  }) : style = style ?? const AppComponentStyle();

  @override
  Widget build(BuildContext context) {
    final bg = style.bg(variant, semantic);
    final fg = style.fg(variant, semantic);
    final borderColor = style.border(variant, semantic);
    final btnHeight = height ?? style.height(size);
    final btnPadding = style.padding(size);
    final iconSz = style.iconSize(size);

    return SizedBox(
      width: width ?? double.infinity,
      height: btnHeight,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withOpacity(
            AppColors.buttonDisabledOpacity,
          ),
          elevation: 0,
          padding: btnPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            side: borderColor == Colors.transparent
                ? BorderSide.none
                : BorderSide(color: borderColor),
          ),
          textStyle: AppTypography.labelLarge.copyWith(color: fg),
        ),
        child: loading
            ? SizedBox(
                height: iconSz,
                width: iconSz,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSz),
                    SizedBox(width: AppSpacing.iconGapSm),
                  ],
                  Text(label),
                  if (trailingIcon != null) ...[
                    SizedBox(width: AppSpacing.iconGapSm),
                    trailingIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
