import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

final _greetingProvider = Provider<String>((ref) => 'Kitchen Display');

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(_greetingProvider);
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
            Text(greeting, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
