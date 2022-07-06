import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/selectable_card.dart';
import 'package:restaurant_pos/database/account.dart';

import 'package:restaurant_pos/pages/create_account_result_page.dart';
import 'package:restaurant_pos/services/utility/encryption.dart';
import 'package:restaurant_pos/services/utility/license.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class ActivateLicensePage extends StatefulWidget {
  const ActivateLicensePage({Key? key, required this.account}) : super(key: key);
  final dynamic account;
  @override
  State<ActivateLicensePage> createState() => _ActivateLicensePageState();
}

class _ActivateLicensePageState extends State<ActivateLicensePage> {
  int selectedIndex = 1;
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
    Color getThemeColor() {
      return ColorStyle.primary;
    }
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Activate License'),
    );
    return Scaffold(
      backgroundColor: ColorStyle.background200,
      appBar: appBar,
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
            text: 'Activate',
            backgroundColor: getThemeColor(),
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              if (selectedIndex == 1 && controllerPurchaseCode.text != '') {
                LicenseData licData = License.validate(controllerPurchaseCode.text);
                if(licData.status){
                  Map<String, dynamic> account = widget.account;
                  account['purchaseCode'] = licData.purchaseCode;
                  var status = await Account.update(account);
                  if(status){
                    showSnackBar(context, "Activated successfully");
                    Navigator.pop(context);
                  }else{
                    showSnackBar(context, "Activation failed");
                  }
                }
                else{
                  showSnackBar(context, licData.message);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
