import 'package:eatery_core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Reusable page title widget (migrated from eatery_components).
class PageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const PageTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
      ],
    );
  }
}
