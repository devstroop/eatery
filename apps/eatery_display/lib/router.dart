import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/display_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'display',
      builder: (context, state) => const DisplayPage(),
    ),
  ],
);

final displayRouterProvider = Provider<GoRouter>((ref) => _router);
