import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';
import 'package:eatery/components/eatery_core_widgets/widgets.dart';

class DisplayHomePage extends ConsumerWidget {
  const DisplayHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageShell(
      title: 'Eatery Display',
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
            Icon(Icons.tv, size: 64, color: AppColors.primary),
            AppSpacing.gapLg,
            Text('Eatery Display', style: AppTypography.headlineMedium),
            AppSpacing.gapSm,
            Text('Customer Display System', style: AppTypography.bodyLarge),
          ],
        ),
      ),
    );
  }
}
