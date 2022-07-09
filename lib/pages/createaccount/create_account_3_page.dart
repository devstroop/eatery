import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/secondary_button.dart';
import 'package:eatery/pages/createaccount/create_account_4_page.dart';
import 'package:eatery/style/color_style.dart';

class CreateAccount3Page extends StatefulWidget {
  const CreateAccount3Page(
      {Key? key,
      this.image,
      required this.name,
      required this.phone,
      required this.address,
      required this.password,
      required this.email})
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
  final TextEditingController _controllerFoodLicenseNo = TextEditingController();
  final TextEditingController _controllerTaxNo = TextEditingController();
  final TextEditingController _controllerDefaultTaxRate = TextEditingController();
  final TextEditingController _controllerCurrencySymbol = TextEditingController();
  late String selectedTaxName = 'GST';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.background200,
      appBar: AppBar(
        backgroundColor: ColorStyle.background100,
        title: Image.asset('assets/logo.png', height: 36,),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Taxation Type',
                    style: TextStyle(
                      color: ColorStyle.text200,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  FlutterSwitch(
                    activeText: "GST",
                    inactiveText: "VAT",
                    value: selectedTaxName == 'GST',
                    valueFontSize: 14.0,
                    width: 72,
                    height: 36,
                    borderRadius: 36.0,
                    showOnOff: true,
                    activeTextFontWeight: FontWeight.w500,
                    inactiveTextFontWeight: FontWeight.w500,
                    toggleSize: 30.0,
                    activeColor: ColorStyle.logoColor,
                    inactiveColor: ColorStyle.logoColor2,
                    // activeToggleColor: Color(0xFF6E40C9),
                    // inactiveToggleColor: Color(0xFF2F363D),
                    // activeColor: getThemeColor(),
                    // inactiveColor: Colors.white,
                    // activeTextColor: Colors.black,
                    // inactiveTextColor: Colors.white,

                    onToggle: (value) {
                      setState(() {
                        if (selectedTaxName == 'GST') {
                          selectedTaxName = 'VAT';
                        } else {
                          selectedTaxName = 'GST';
                        }
                      });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Food License Number (FSSAI)',
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
                  controller: _controllerFoodLicenseNo,
                  labelText: 'eg. 12216912889355',
                  obscureText: false,
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '$selectedTaxName Number',
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
                  controller: _controllerTaxNo,
                  labelText: 'eg. 22ASAAA0990A1Z5',
                  obscureText: false,
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Default $selectedTaxName Rate',
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
                  controller: _controllerDefaultTaxRate,
                  labelText: 'eg. 5',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  suffixWidget: const Text('%'),
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Currency Symbol',
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
                  controller: _controllerCurrencySymbol,
                  labelText: 'eg. ₹, \$, £ etc.',
                  obscureText: false,
                  keyboardType: TextInputType.text,
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
                            foodLicenseNo: '',
                            taxNo: '',
                            taxName: 'Tax',
                            defaultTaxRate: double.parse('0'),
                            currencySymbol: _controllerCurrencySymbol.text)),
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              PrimaryButton(
                text: 'Continue',
                backgroundColor: ColorStyle.logoColor,
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
                            foodLicenseNo: _controllerFoodLicenseNo.text,
                            taxNo: _controllerTaxNo.text,
                            taxName: selectedTaxName,
                            defaultTaxRate: double.parse(
                                _controllerDefaultTaxRate.text != '' ? _controllerDefaultTaxRate.text : '0'),
                            currencySymbol: _controllerCurrencySymbol.text)),
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
