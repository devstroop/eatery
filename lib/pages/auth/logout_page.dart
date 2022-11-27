
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
    Future.delayed(const Duration(milliseconds: 1000),() {
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
      body: LoadingScreen(),
    );
  }
}
