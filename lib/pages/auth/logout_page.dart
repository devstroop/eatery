import 'package:eatery_db/models/company/company.dart';
import 'package:flutter/material.dart';
import 'package:eatery/pages/auth/login_page.dart';
import 'package:eatery/constants/style/color_style.dart';

import 'package:eatery/components/loaders/loading_screen.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key, required this.company}) : super(key: key);
  final Company company;
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
        context,
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
