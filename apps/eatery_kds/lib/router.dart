import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/ticket_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'tickets',
      builder: (context, state) => const TicketPage(),
    ),
  ],
);

final kdsRouterProvider = Provider<GoRouter>((ref) => _router);
