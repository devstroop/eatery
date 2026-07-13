import 'package:flutter/material.dart';
import 'package:eatery_core/eatery_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eatery KDS')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.kitchen, size: 64, color: AppColors.primary),
            const SizedBox(height: 24),
            Text('Eatery KDS', style: AppTypography.headlineMedium),
            const SizedBox(height: 8),
            Text('Kitchen Display System',
                style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
