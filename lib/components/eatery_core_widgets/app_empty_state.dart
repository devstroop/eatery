import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// Empty state widget shown when no data is available.
///
/// ```dart
/// const AppEmptyState(
///   icon: Icons.person,
///   title: 'No Customers',
///   subtitle: 'Add a customer to get started',
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final double iconSize;
  final Widget? action;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconSize = 64,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: AppColors.grey400),
            AppSpacing.gapLg,
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.grey600,
              ),
            ),
            if (subtitle != null) ...[
              AppSpacing.gapXs,
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
            if (action != null) ...[AppSpacing.gapXl, action!],
          ],
        ),
      ),
    );
  }
}
