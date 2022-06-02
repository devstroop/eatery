import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/database/account.dart';

import 'package:restaurant_pos/pages/create_account_3_page.dart';
import 'package:restaurant_pos/pages/dashboard_page.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPin = TextEditingController();
  late String selectedCompanyEmail = '';
  late List<String> companies = [];
  void loadCompanies() async {
    List<Map<String, dynamic>> _companies = await Account.getAll();
    for(Map<String, dynamic> company in _companies){
      setState((){companies.add("${company['name']} (${company['email']})");});
    }
  }

  @override
  void initState() {
    super.initState();
    loadCompanies();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorStyle.background200,
      appBar: AppBar(
        backgroundColor: ColorStyle.background100,
        automaticallyImplyLeading: false,
        title: Text('Login', style: TextStyle(color: ColorStyle.text100, fontWeight: FontWeight.w600, fontSize: 20.0),),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: Center(
                child: Platform.isAndroid || Platform.isIOS ? IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: ColorStyle.text200,
                  ),
                  onPressed: () {
                    MoveToBackground.moveTaskToBack();
                  },
                ) : Container()
            ),
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
                    'Welcome',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Log in to your account',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              /*Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Email',
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
                  controller: _controllerEmail,
                  labelText: 'Email',
                  obscureText: false,
                ),
              ]),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropDown(
                    //isExpanded: true,
                    initialValue: companies.isNotEmpty ? companies.first : null,
                    items: companies,
                    hint: const Text("Select Company"),
                    icon: Icon(
                      Icons.expand_more,
                      color: ColorStyle.primary,
                    ),
                    onChanged: (value){
                      setState((){
                        selectedCompanyEmail = value.toString().split('(').last.replaceAll(')', '').trim();
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                /*Text(
                  'PIN',
                  style: TextStyle(
                    color: ColorStyle.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),*/
                CustomTextFromField(
                  keyboardType: TextInputType.number,
                  controller: _controllerPin,
                  labelText: 'PIN',
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
            text: 'Login',
            backgroundColor: ColorStyle.primary,
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              Map<String, dynamic>? account = await Account.login(selectedCompanyEmail, _controllerPin.text);
              if(account != null){
                print(account);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage(account: account)),
                      (Route<dynamic> route) => false,
                );
              }
              else{
                showSnackBar(context, '*Invalid credentials');
              }
            },
          ),
        ),
      ),
    );
  }
}
