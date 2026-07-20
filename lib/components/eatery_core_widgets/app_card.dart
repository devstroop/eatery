import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_component.dart';
import 'package:eatery_core/theme/app_shadows.dart';

/// Consistent card with optional tap, shadow, and padding.
///
/// All visual properties derive from design tokens. Variant controls the
/// overall appearance: [AppVariant.elevated] (bg + shadow), [AppVariant.outlined]
/// (border, no shadow), or [AppVariant.flat] (muted bg, no border, no shadow).
///
/// ```dart
/// AppCard(
///   variant: AppVariant.elevated,
///   onTap: () {},
///   child: Text('Hello'),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? shadow;
  final BorderRadius? borderRadius;
  final Border? border;
  final AppVariant variant;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.padding,
    this.margin,
    this.shadow,
    this.borderRadius,
    this.border,
    this.variant = AppVariant.elevated,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.cardBg;
    final radius = borderRadius ?? BorderRadius.circular(AppSpacing.cardRadius);
    final boxShadow =
        shadow ??
        () {
          switch (variant) {
            case AppVariant.elevated:
            case AppVariant.filled:
              return AppShadows.cardElevated;
            case AppVariant.outlined:
            case AppVariant.flat:
            case AppVariant.ghost:
              return AppShadows.none;
          }
        }();
    final boxBorder =
        border ??
        () {
          switch (variant) {
            case AppVariant.outlined:
              return Border.all(color: AppColors.cardBorder);
            case AppVariant.elevated:
            case AppVariant.filled:
            case AppVariant.flat:
            case AppVariant.ghost:
              return null;
          }
        }();

    return Container(
      width: width,
      height: height,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: variant == AppVariant.flat ? (color ?? AppColors.muted) : bg,
        borderRadius: radius,
        boxShadow: boxShadow,
        border: boxBorder,
      ),
      child: Material(
        color: Colors.transparent,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                child: Padding(
                  padding: padding ?? AppSpacing.cardPadding,
                  child: child,
                ),
              )
            : Padding(padding: padding ?? AppSpacing.cardPadding, child: child),
      ),
    );
  }
}
