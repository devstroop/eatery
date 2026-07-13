import 'package:flutter/material.dart';
import 'package:eatery_core/eatery_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Eatery KDS',
      showBack: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.kitchen, size: 64, color: AppColors.primary),
            AppSpacing.gapLg,
            Text('Eatery KDS', style: AppTypography.headlineMedium),
            AppSpacing.gapSm,
            Text('Kitchen Display System',
                style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
