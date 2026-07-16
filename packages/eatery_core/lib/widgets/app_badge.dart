import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_component.dart';
import '../theme/app_typography.dart';

/// A small badge/label used for status indicators, stock warnings, etc.
///
/// All visual properties derive from [AppComponentStyle] + design tokens.
///
/// ```dart
/// AppBadge(
///   label: '5 in stock',
///   variant: AppVariant.filled,
///   semantic: AppSemantic.warning,
///   size: AppSize.sm,
/// )
/// ```
class AppBadge extends StatelessWidget {
  final String label;
  final AppVariant variant;
  final AppSemantic semantic;
  final AppSize size;
  final AppComponentStyle style;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppVariant.filled,
    this.semantic = AppSemantic.warning,
    this.size = AppSize.sm,
    AppComponentStyle? style,
  }) : style = style ?? const AppComponentStyle();

  @override
  Widget build(BuildContext context) {
    final bg = style.bg(variant, semantic);
    final fg = style.fg(variant, semantic);

    return Container(
      padding: AppSpacing.badgePadding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.selectCardRadius),
      ),
      child: Text(label, style: AppTypography.badgeLabel.copyWith(color: fg)),
    );
  }
}
