import 'package:flutter/material.dart';
import 'package:eatery_core/eatery_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Eatery Waiter',
      showBack: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: AppColors.primary),
            AppSpacing.gapLg,
            Text('Eatery Waiter', style: AppTypography.headlineMedium),
            AppSpacing.gapSm,
            Text('Floor staff order management',
                style: AppTypography.bodyMedium),
            AppSpacing.gapLg,
            AppButton.primary(
              label: 'Take Order',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
