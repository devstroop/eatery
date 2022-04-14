import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/secondary_button.dart';
import 'package:restaurant_pos/pages/create_account_4_page.dart';
import 'package:restaurant_pos/style/color_style.dart';

class CreateAccount3Page extends StatefulWidget {
  const CreateAccount3Page(
      {Key? key, this.image, required this.name, required this.phone, required this.address, required this.password, required this.email})
      : super(key: key);

  final String? image;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String password;

  @override
  State<CreateAccount3Page> createState() => _CreateAccount3PageState();
}

class _CreateAccount3PageState extends State<CreateAccount3Page> {
  String? pickedImagePath;
  final TextEditingController _controllerFssai = TextEditingController();
  final TextEditingController _controllerGstin = TextEditingController();

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
              'Step 3/4',
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
                    'Registration info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Help us to know more about your business',
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
                  'FSSAI License Number',
                  style: TextStyle(
                    color: ColorStyle.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomTextFromField(
                  controller: _controllerFssai,
                  labelText: 'eg. 12216912889355',
                  obscureText: false,
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'GSTIN Number',
                  style: TextStyle(
                    color: ColorStyle.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomTextFromField(
                  controller: _controllerGstin,
                  labelText: 'eg. 22ASAAA0990A1Z5',
                  obscureText: false,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SecondaryButton(
                color: ColorStyle.text300,
                borderColor: ColorStyle.text400,
                text: 'Skip',
                height: 50.0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccount4Page(
                              address: widget.address,
                              phone: widget.phone,
                              password: widget.password,
                              name: widget.name,
                              image: widget.image,
                              email: widget.email,
                              fssai: '',
                              gstin: '',
                            )),
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              PrimaryButton(
                text: 'Continue',
                backgroundColor: ColorStyle.primary,
                color: ColorStyle.background100,
                height: 50.0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccount4Page(
                              address: widget.address,
                              phone: widget.phone,
                              email: widget.email,
                              password: widget.password,
                              name: widget.name,
                              image: widget.image,
                              fssai: _controllerFssai.text,
                              gstin: _controllerGstin.text,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
