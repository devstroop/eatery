import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A menu tile used in settings grids and navigation lists.
///
/// ```dart
/// AppMenuTile(
///   title: 'Categories',
///   subtitle: 'Manage product categories',
///   leading: Icons.category,
///   onTap: () {},
///   color: AppColors.menuCategories,
/// )
/// ```
class AppMenuTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData leading;
  final IconData trailing;
  final Color? color;
  final VoidCallback? onTap;

  const AppMenuTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    this.trailing = Icons.chevron_right,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.menuTileFg;

    return ListTile(
      onTap: onTap,
      leading: Icon(leading, color: tileColor),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: tileColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.menuTileSubtitleFg,
              ),
            )
          : null,
      trailing: Icon(trailing, color: AppColors.menuTileTrailingFg),
    );
  }
}
