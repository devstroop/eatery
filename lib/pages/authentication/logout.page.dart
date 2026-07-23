import 'package:eatery_core/providers/auth_session.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Clears the auth session and redirects to login.
///
/// Rendered as a route so side effects run once in initState
/// rather than inside a builder callback.
class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({super.key});
  @override
  ConsumerState<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  @override
  void initState() {
    super.initState();
    ref.read(authSessionProvider.notifier).state = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) GoRouter.of(context).goNamed('login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
