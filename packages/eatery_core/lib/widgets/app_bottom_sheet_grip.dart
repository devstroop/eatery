import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A small drag grip at the top of bottom sheets.
///
/// Tokenized via [AppColors.bottomSheetGrip] and [AppSpacing.bottomSheetGrip*].
class AppBottomSheetGrip extends StatelessWidget {
  const AppBottomSheetGrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.bottomSheetGripMargin,
      width: AppSpacing.bottomSheetGripWidth,
      height: AppSpacing.bottomSheetGripHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.bottomSheetGripRadius),
        color: AppColors.bottomSheetGrip,
      ),
    );
  }
}
