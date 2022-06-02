import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/pages/create_account_3_page.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class CreateAccount2Page extends StatefulWidget {
  const CreateAccount2Page({Key? key, this.image, required this.name, required this.phone, required this.address, required this.email})
      : super(key: key);
  final String? image;
  final String name;
  final String phone;
  final String email;
  final String address;

  @override
  State<CreateAccount2Page> createState() => _CreateAccount2State();
}

class _CreateAccount2State extends State<CreateAccount2Page> {
  String? pickedImagePath;
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.background200,
      appBar: AppBar(
        backgroundColor: ColorStyle.background100,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: ColorStyle.text200,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: Center(
                child: Text(
              'Step 2/4',
              style: TextStyle(color: ColorStyle.text200, fontWeight: FontWeight.w500),
            )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 12.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Setup PIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Setup PIN to secure your account',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'PIN',
                  style: TextStyle(
                    color: ColorStyle.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                CustomTextFromField(
                  keyboardType: TextInputType.number,
                  controller: _controllerPassword,
                  labelText: 'PIN',
                  obscureText: true,
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Confirm PIN',
                  style: TextStyle(
                    color: ColorStyle.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                CustomTextFromField(
                  keyboardType: TextInputType.number,
                  controller: _controllerConfirmPassword,
                  labelText: 'Confirm PIN',
                  obscureText: true,
                ),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.background100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            text: 'Continue',
            backgroundColor: ColorStyle.primary,
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () {
              if (_controllerPassword.text == _controllerConfirmPassword.text) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAccount3Page(
                          address: widget.address,
                          phone: widget.phone,
                          password: _controllerPassword.text,
                          name: widget.name,
                          image: widget.image, email: widget.email,)),
                );
              } else {
                showSnackBar(context, '*Confirm PIN didn\'t match');
              }
            },
          ),
        ),
      ),
    );
  }
}
