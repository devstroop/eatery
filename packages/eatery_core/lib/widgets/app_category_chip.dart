import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A category chip used for filtering products in POS and dining tables.
///
/// All visual properties derive from design tokens.
///
/// ```dart
/// AppCategoryChip(
///   label: 'Beverages',
///   selected: isActive,
///   leading: SvgPicture.asset(...),
///   onTap: () {},
/// )
/// ```
class AppCategoryChip extends StatelessWidget {
  final bool selected;
  final String label;
  final Widget? leading;
  final VoidCallback? onTap;

  const AppCategoryChip({
    super.key,
    this.selected = false,
    required this.label,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.categoryChipActiveBg
        : AppColors.categoryChipInactiveBg;
    final fg = selected
        ? AppColors.categoryChipActiveFg
        : AppColors.categoryChipInactiveFg;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 12),
      child: InkWell(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.categoryChipRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(
                AppSpacing.categoryChipRadius,
              ),
              border: Border.all(color: bg, width: 1),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: AppSpacing.categoryChipPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null)
                    Padding(
                      padding: AppSpacing.categoryChipImagePadding,
                      child: leading,
                    )
                  else
                    const Padding(padding: EdgeInsets.only(right: 3)),
                  const SizedBox(width: 2),
                  Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: fg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
