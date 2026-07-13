import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Consistent button widget used across the entire app.
///
/// ```dart
/// AppButton.primary(label: 'Next', onPressed: () {})
/// AppButton.secondary(label: 'Cancel', onPressed: () {})
/// AppButton.ghost(label: 'Skip', onPressed: () {})
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final double? width;
  final double height;
  final bool loading;
  final IconData? icon;

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 48,
    this.loading = false,
    this.icon,
  }) : style = AppButtonStyle.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 48,
    this.loading = false,
    this.icon,
  }) : style = AppButtonStyle.secondary;

  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 48,
    this.loading = false,
    this.icon,
  }) : style = AppButtonStyle.destructive;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 48,
    this.loading = false,
    this.icon,
  }) : style = AppButtonStyle.ghost;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsForStyle();

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.bg,
          foregroundColor: colors.fg,
          disabledBackgroundColor: colors.bg.withOpacity(0.5),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:
                style == AppButtonStyle.ghost ||
                    style == AppButtonStyle.secondary
                ? const BorderSide(color: AppColors.grey300)
                : BorderSide.none,
          ),
          textStyle: AppTypography.labelLarge.copyWith(color: colors.fg),
        ),
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.fg),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }

  _ButtonColors _colorsForStyle() {
    switch (style) {
      case AppButtonStyle.primary:
        return const _ButtonColors(bg: AppColors.primary, fg: AppColors.white);
      case AppButtonStyle.secondary:
        return const _ButtonColors(bg: AppColors.white, fg: AppColors.primary);
      case AppButtonStyle.destructive:
        return const _ButtonColors(bg: AppColors.error, fg: AppColors.white);
      case AppButtonStyle.ghost:
        return const _ButtonColors(bg: AppColors.white, fg: AppColors.grey700);
    }
  }
}

enum AppButtonStyle { primary, secondary, destructive, ghost }

class _ButtonColors {
  final Color bg;
  final Color fg;
  const _ButtonColors({required this.bg, required this.fg});
}
