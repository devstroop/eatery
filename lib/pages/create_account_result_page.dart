import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/selectable_card.dart';
import 'package:restaurant_pos/pages/login_page.dart';
import 'package:restaurant_pos/style/color_style.dart';

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
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  'assets/images/success.gif',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
          backgroundColor: ColorStyle.primary,
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
