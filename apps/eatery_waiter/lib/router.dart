import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/table_page.dart';
import 'pages/menu_page.dart';
import 'pages/cart_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'tables',
      builder: (context, state) => const TablePage(),
    ),
    GoRoute(
      path: '/menu',
      name: 'menu',
      builder: (context, state) => const MenuPage(),
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartPage(),
    ),
  ],
);

final waiterRouterProvider = Provider<GoRouter>((ref) => _router);
