import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);
  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Color themeColor = AppColors.secondary2;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
        this.context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            color: Colors.redAccent,
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
