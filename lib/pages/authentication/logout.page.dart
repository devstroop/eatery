import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);
  @override
  ConsumerState<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  Color themeColor = AppColors.secondary2;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      GoRouter.of(context as BuildContext).goNamed('login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.grey200,
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            color: AppColors.error,
          ),
        ),
        Row(
          children: [
            Text(
              'Logging out...',
              style: TextStyle(
                  color: AppColors.secondary2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ));
  }
}
