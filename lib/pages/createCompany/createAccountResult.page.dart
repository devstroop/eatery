import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:lottie/lottie.dart';

import '../authentication/login.page.dart';

class CreateAccountResultPage extends StatefulWidget {
  const CreateAccountResultPage({Key? key}) : super(key: key);
  @override
  State<CreateAccountResultPage> createState() =>
      _CreateAccountResultPageState();
}

class _CreateAccountResultPageState extends State<CreateAccountResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColorAlter,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                Lottie.asset(
                    'assets/lottie/42183-congratulation-success-batch.json'),
                // Image.asset(
                //   'assets/images/upgrade.png',
                //   height: 120.0,
                //   width: 120.0,
                // ),
                const SizedBox(height: 36),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Congratulations!',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorStyle.brandColor),
                    ),
                    SpacingStyle.defaultVerticalSpacing,
                    const Text(
                      'Company created successfully',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SpacingStyle.defaultVerticalSpacing,
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: ColorStyle.brandColor,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          },
          child: const Text('Continue to Login'),
        ),
      ),
    );
  }
}
