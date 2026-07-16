import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Every atomic widget derives its visual properties from these enums.
///
/// Components accept Variant × Semantic × Size, never raw Color/double/EdgeInsets.
enum AppVariant { filled, outlined, flat, ghost, elevated }

/// Semantic role that maps to token colors.
enum AppSemantic { primary, secondary, danger, warning }

/// Component size preset.
enum AppSize { sm, md, lg }

/// Lookup table that maps (variant, semantic, size) → design tokens.
///
/// Components never compute their own colors. They query this class,
/// which reads from [AppColors] and [AppSpacing]. Adding a dark theme
/// means swapping token values — no component code changes.
class AppComponentStyle {
  const AppComponentStyle();

  Color bg(AppVariant variant, AppSemantic semantic) {
    switch (variant) {
      case AppVariant.filled:
        switch (semantic) {
          case AppSemantic.primary:
            return AppColors.buttonFilledPrimaryBg;
          case AppSemantic.secondary:
            return AppColors.buttonFilledSecondaryBg;
          case AppSemantic.danger:
            return AppColors.buttonFilledDestructiveBg;
          case AppSemantic.warning:
            return AppColors.warning;
        }
      case AppVariant.outlined:
        return Colors.transparent;
      case AppVariant.flat:
        return AppColors.grey100;
      case AppVariant.ghost:
        return AppColors.buttonGhostBg;
      case AppVariant.elevated:
        return AppColors.cardBg;
    }
  }

  Color fg(AppVariant variant, AppSemantic semantic) {
    switch (variant) {
      case AppVariant.filled:
        switch (semantic) {
          case AppSemantic.primary:
            return AppColors.buttonFilledPrimaryFg;
          case AppSemantic.secondary:
            return AppColors.buttonFilledSecondaryFg;
          case AppSemantic.danger:
            return AppColors.buttonFilledDestructiveFg;
          case AppSemantic.warning:
            return AppColors.white;
        }
      case AppVariant.outlined:
        switch (semantic) {
          case AppSemantic.primary:
            return AppColors.buttonOutlinedPrimaryFg;
          case AppSemantic.secondary:
            return AppColors.buttonOutlinedSecondaryFg;
          case AppSemantic.danger:
            return AppColors.buttonOutlinedDestructiveFg;
          case AppSemantic.warning:
            return AppColors.warning;
        }
      case AppVariant.flat:
        return AppColors.grey700;
      case AppVariant.ghost:
        return AppColors.buttonGhostFg;
      case AppVariant.elevated:
        return AppColors.foreground;
    }
  }

  Color border(AppVariant variant, AppSemantic semantic) {
    switch (variant) {
      case AppVariant.filled:
      case AppVariant.flat:
      case AppVariant.ghost:
      case AppVariant.elevated:
        return Colors.transparent;
      case AppVariant.outlined:
        switch (semantic) {
          case AppSemantic.primary:
            return AppColors.buttonOutlinedPrimaryBorder;
          case AppSemantic.secondary:
            return AppColors.buttonOutlinedSecondaryBorder;
          case AppSemantic.danger:
            return AppColors.buttonOutlinedDestructiveBorder;
          case AppSemantic.warning:
            return AppColors.warning;
        }
    }
  }

  EdgeInsets padding(AppSize size) {
    switch (size) {
      case AppSize.sm:
        return AppSpacing.buttonPaddingSm;
      case AppSize.md:
        return AppSpacing.buttonPadding;
      case AppSize.lg:
        return AppSpacing.buttonPaddingLg;
    }
  }

  double height(AppSize size) {
    switch (size) {
      case AppSize.sm:
        return AppSpacing.buttonHeightSm;
      case AppSize.md:
        return AppSpacing.buttonHeightMd;
      case AppSize.lg:
        return AppSpacing.buttonHeightLg;
    }
  }

  double iconSize(AppSize size) {
    switch (size) {
      case AppSize.sm:
        return AppSpacing.iconSizeSm;
      case AppSize.md:
        return AppSpacing.iconSizeMd;
      case AppSize.lg:
        return AppSpacing.iconSizeLg;
    }
  }
}
