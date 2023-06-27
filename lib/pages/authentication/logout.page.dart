import 'package:eatery/references.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);
  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Color themeColor = ColorStyle.brandColor;
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
                  color: ColorStyle.brandColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ));
  }
}
