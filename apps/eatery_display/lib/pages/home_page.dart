import 'package:flutter/material.dart';
import 'package:eatery_core/eatery_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Eatery Display',
      showBack: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tv, size: 64, color: AppColors.primary),
            AppSpacing.gapLg,
            Text('Eatery Display', style: AppTypography.headlineMedium),
            AppSpacing.gapSm,
            Text('Customer-facing order display',
                style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
