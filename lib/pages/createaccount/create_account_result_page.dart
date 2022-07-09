import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/selectable_card.dart';
import 'package:eatery/pages/login_page.dart';
import 'package:eatery/style/color_style.dart';

class CreateAccountResultPage extends StatefulWidget {
  const CreateAccountResultPage({Key? key, required this.createAccountStatus}) : super(key: key);
  final bool createAccountStatus;
  @override
  State<CreateAccountResultPage> createState() => _CreateAccountResultPageState();
}

class _CreateAccountResultPageState extends State<CreateAccountResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.background200,
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
                Image.asset('assets/logo.png', height: 72,),
                const SizedBox(height: 48),
                Image.asset(
                  'assets/images/success.gif',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Congratulations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Restaurant account created successfully',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
      color: ColorStyle.background100,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: PrimaryButton(
          text: 'Alright',
          backgroundColor: ColorStyle.logoColor,
          color: ColorStyle.background100,
          height: 50.0,
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
    ),

    );
  }
}
