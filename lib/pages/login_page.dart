import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/database/account.dart';
import 'package:eatery/pages/dashboard_page.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';

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
        title: Image.asset('assets/logo.png', height: 36,),
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
                    'Welcome back on Eatery,',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Company', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),),
                  const Spacer(),
                  DropDown(
                    //isExpanded: true,
                    initialValue: companies.isNotEmpty ? companies.first : null,
                    items: companies,
                    hint: const Text("Select Company"),
                    icon: Icon(
                      Icons.expand_more,
                      color: ColorStyle.logoColor,
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
            backgroundColor: ColorStyle.logoColor,
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              Map<String, dynamic>? account = await Account.login(selectedCompanyEmail, _controllerPin.text);
              if(account != null){
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
