import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

final _greetingProvider = Provider<String>((ref) => 'Ready to take orders');

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(_greetingProvider);
    return AppPageShell(
      title: 'Eatery Waiter',
      showBack: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => SyncHostSettingsSheet.show(context),
        ),
      ],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: AppColors.primary),
            AppSpacing.gapLg,
            Text('Eatery Waiter', style: AppTypography.headlineMedium),
            AppSpacing.gapSm,
            Text(greeting, style: AppTypography.bodyMedium),
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
