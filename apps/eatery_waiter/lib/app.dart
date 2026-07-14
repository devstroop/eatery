import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';
import 'main.dart';
import 'router.dart';

class EateryWaiterApp extends ConsumerWidget {
  const EateryWaiterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(waiterRouterProvider);
    return SyncInitializer(
      child: MaterialApp.router(
        title: 'Eatery Waiter',
        theme: AppTheme.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
