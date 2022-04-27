import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/selectable_card.dart';
import 'package:restaurant_pos/database/account.dart';

import 'package:restaurant_pos/pages/create_account_result_page.dart';
import 'package:restaurant_pos/services/utility/encryption.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class CreateAccount4Page extends StatefulWidget {
  const CreateAccount4Page(
      {Key? key,
      this.image,
      required this.name,
      required this.phone,
      required this.address,
      required this.password,
      required this.fssai,
      required this.gstin,
      required this.email})
      : super(key: key);
  final String? image;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String password;
  final String fssai;
  final String gstin;

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
                  highlight: '100 Invoices Only',
                  footer: 'get limited access',
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
                  highlight: 'Unlimited',
                  footer: 'get unlocked to all premium features',
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
          child: PrimaryButton(
            text: 'Finish',
            backgroundColor: ColorStyle.primary,
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              if (selectedIndex == 1 && controllerPurchaseCode.text != '') {
                String? raw = Encryption.decrypt(controllerPurchaseCode.text);
                if (raw != null) {
                  List<String> data = Encryption.decrypt(controllerPurchaseCode.text)!.split(';');
                  if (data.isNotEmpty) {
                    if (data[0].trim() == deviceSerial!.trim()) {
                      int validFrom = int.parse(data[1]);
                      int validTill = int.parse(data[2]);
                      DateTime _validFrom = DateTime.fromMicrosecondsSinceEpoch(validFrom);
                      DateTime _validTill = DateTime.fromMicrosecondsSinceEpoch(validTill);

                      if (validFrom < DateTime.now().microsecondsSinceEpoch ||
                          validTill >= DateTime.now().microsecondsSinceEpoch) {
                        String purchaseCode = controllerPurchaseCode.text;
                        Map<String, dynamic>? accountData = {
                          'name': widget.name,
                          'image': widget.image,
                          'email': widget.email,
                          'phone': widget.phone,
                          'address': widget.address,
                          'password': widget.password,
                          'fssai': widget.fssai,
                          'gstin': widget.gstin,
                          'currencySymbol': '₹',
                          'purchaseCode': purchaseCode,
                          'validFrom': _validFrom.microsecondsSinceEpoch,
                          'validTill': _validTill.microsecondsSinceEpoch,
                          'lowBatteryLevel': 20
                        };
                        var id = await Account.add(accountData);
                        if(id != null){
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateAccountResultPage(createAccountStatus: true)),
                                (Route<dynamic> route) => false,
                          );
                        }else{
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateAccountResultPage(createAccountStatus: false)),
                                (Route<dynamic> route) => false,
                          );
                        }
                      } else {
                        showSnackBar(context, '*Purchase code has expired');
                      }
                    } else {
                      showSnackBar(context, '*Purchase code is not valid');
                    }
                  } else {
                    showSnackBar(context, '*Purchase code is not valid');
                  }
                } else {
                  showSnackBar(context, '*Purchase code is not valid');
                }
              } else {
                Map<String, dynamic>? accountData = {
                  'name': widget.name,
                  'image': widget.image,
                  'email': widget.email,
                  'phone': widget.phone,
                  'address': widget.address,
                  'password': widget.password,
                  'fssai': widget.fssai,
                  'gstin': widget.gstin,
                  'currencySymbol': '₹',
                  'purchaseCode': null,
                  'validFrom': null,
                  'validTill': null,
                  'lowBatteryLevel': 20
                };

                var id = await Account.add(accountData);
                if(id != null){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccountResultPage(createAccountStatus: true)),
                        (Route<dynamic> route) => false,
                  );
                }else{
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccountResultPage(createAccountStatus: false)),
                        (Route<dynamic> route) => false,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
