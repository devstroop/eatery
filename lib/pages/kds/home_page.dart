import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

class KdsHomePage extends ConsumerWidget {
  const KdsHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageShell(
      title: 'Eatery KDS',
      showBack: false,
      actions: [
        const SyncStatusChip(),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => SyncHostSettingsSheet.show(context),
        ),
      ],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.kitchen, size: 64, color: AppColors.primary),
            AppSpacing.gapLg,
            Text('Eatery KDS', style: AppTypography.headlineMedium),
            AppSpacing.gapSm,
            Text('Kitchen Display System', style: AppTypography.bodyLarge),
          ],
        ),
      ),
    );
  }
}
