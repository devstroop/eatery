import 'package:eatery/components/bottom_view_grip.dart';
import 'package:eatery/components/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/selectable_card.dart';
import 'package:eatery/database/account.dart';

import 'package:eatery/pages/createaccount/create_account_result_page.dart';
import 'package:eatery/services/utility/encryption.dart';
import 'package:eatery/services/utility/license.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccount4Page extends StatefulWidget {
  const CreateAccount4Page(
      {Key? key,
      this.image,
      required this.name,
      required this.phone,
      required this.address,
      required this.password,
      required this.foodLicenseNo,
      required this.taxNo,
      required this.email,
      required this.defaultTaxRate,
      required this.taxName, required this.currencySymbol})
      : super(key: key);
  final String? image;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String password;
  final String foodLicenseNo;
  final String taxNo;
  final String taxName;
  final double defaultTaxRate;
  final String currencySymbol;

  @override
  State<CreateAccount4Page> createState() => _CreateAccount4PageState();
}

class _CreateAccount4PageState extends State<CreateAccount4Page> {
  int selectedIndex = 0;
  var controllerPurchaseCode = TextEditingController();
  late String? deviceSerial = 'Fetching';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDeviceInfo();
  }

  fetchDeviceInfo() async {
    String? deviceSerial = await PlatformDeviceId.getDeviceId;
    setState(() {
      this.deviceSerial = deviceSerial;
    });
  }
  Widget buildContactSalesBottomSheet() => StatefulBuilder(builder: (context, state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Contact Sales',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Contact us to get subscription',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () async {
                    const url = "https://eatery.devstroop.com";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw "Could not launch $url";
                    }
                  },
                  icon: Icon(Icons.link, color: ColorStyle.logoColor))
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 24,
                color: ColorStyle.logoColor,
              ),
              const SizedBox(
                width: 12,
              ),
              const Text(
                '+91 950 100 5734',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Icon(
                Icons.email,
                size: 24,
                color: ColorStyle.logoColor,
              ),
              const SizedBox(
                width: 12,
              ),
              const Text(
                'help@devstroop.com',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  });

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
              'Step 4/4',
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
                    'Choose your plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Get access to whole product in one go',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              InkWell(
                child: SelectableCard(
                  header: 'EVALUATION',
                  title: 'Try It Free',
                  highlights: const ['Limited Invoices', 'Limited Products'],
                  footer: 'Enjoy with limited access',
                  active: selectedIndex == 0,
                  highlightColor: ColorStyle.information,
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              InkWell(
                child: SelectableCard(
                  header: 'PREMIUM',
                  title: 'Activate License',
                  highlights: const ['Everything Unlimited'],
                  footer: 'Get unlocked to all premium features',
                  active: selectedIndex == 1,
                  highlightColor: ColorStyle.warning,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device Id: $deviceSerial',
                        style: TextStyle(
                          color: ColorStyle.text200,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      CustomTextFromField(
                        controller: controllerPurchaseCode,
                        labelText: 'Purchase Code',
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
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
                text: 'Contact Sales',
                height: 50.0,
                onTap: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    context: context,
                    builder: (context) => buildContactSalesBottomSheet()),
              ),
              const SizedBox(
                height: 8.0,
              ),
              PrimaryButton(
                text: 'Finish',
                backgroundColor: ColorStyle.logoColor,
                color: ColorStyle.background100,
                height: 50.0,
                onTap: () async {
                  if (selectedIndex == 1 && controllerPurchaseCode.text != '') {
                    LicenseData licData = License.validate(controllerPurchaseCode.text);
                    if (licData.status) {
                      Map<String, dynamic>? accountData = {
                        'name': widget.name,
                        'logo': widget.image,
                        'email': widget.email,
                        'phone': widget.phone,
                        'address': widget.address,
                        'pin': widget.password,
                        'foodLicenseNo': widget.foodLicenseNo,
                        'taxNo': widget.taxNo,
                        'taxName': widget.taxName,
                        'defaultTaxRate': widget.defaultTaxRate,
                        'currencySymbol': widget.currencySymbol,
                        'purchaseCode': licData.purchaseCode,
                        'validFrom': licData.validFrom!.microsecondsSinceEpoch,
                        'validTill': licData.validTill!.microsecondsSinceEpoch,
                        'autoPrintOnSale': false,
                        'printerSize': "80mm",
                      };
                      var id = await Account.add(accountData);
                      if (id != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateAccountResultPage(createAccountStatus: true)),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAccountResultPage(createAccountStatus: false)),
                          (Route<dynamic> route) => false,
                        );
                      }
                    } else {
                      showSnackBar(context, licData.message);
                    }
                  } else {
                    Map<String, dynamic>? accountData = {
                      'name': widget.name,
                      'image': widget.image,
                      'email': widget.email,
                      'phone': widget.phone,
                      'address': widget.address,
                      'pin': widget.password,
                      'foodLicenseNo': widget.foodLicenseNo,
                      'taxNo': widget.taxNo,
                      'taxName': widget.taxName,
                      'defaultTaxRate': widget.defaultTaxRate,
                      'currencySymbol': widget.currencySymbol,
                      'purchaseCode': null,
                      'validFrom': null,
                      'validTill': null,
                      'autoPrintOnSale': false,
                      'printerSize': "80mm",
                    };

                    var id = await Account.add(accountData);
                    if (id != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccountResultPage(createAccountStatus: true)),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccountResultPage(createAccountStatus: false)),
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
