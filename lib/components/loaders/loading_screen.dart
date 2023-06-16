import 'package:eatery/constants/style/color_style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key}) : super(key: key);

  final Color themeColor = ColorStyle.brandColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset('assets/lottie/105511-fireworks.json')),
    );
  }
}
