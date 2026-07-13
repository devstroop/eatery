import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';
import 'router.dart';

class EateryKdsApp extends ConsumerWidget {
  const EateryKdsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(kdsRouterProvider);
    return MaterialApp.router(
      title: 'Eatery KDS',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
