import 'package:flutter/material.dart';
import 'package:eatery_core/eatery_core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eatery Display')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tv, size: 64, color: AppColors.primary),
            const SizedBox(height: 24),
            Text('Eatery Display', style: AppTypography.headlineMedium),
            const SizedBox(height: 8),
            Text('Customer-facing order display',
                style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
