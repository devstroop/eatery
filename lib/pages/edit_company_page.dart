import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/menu_tile.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/components/secondary_button.dart';
import 'package:eatery/components/upload_button.dart';
import 'package:eatery/components/waiter_card.dart';
import 'package:eatery/database/account.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/database/order.dart';
import 'package:eatery/database/waiter.dart';
import 'package:eatery/extensions/app_file_system.dart';
import 'package:eatery/models/order_type.dart';
import 'package:eatery/pages/add_waiter_page.dart';
import 'package:eatery/pages/detailed_history_page.dart';
import 'package:eatery/pages/edit_waiter_page.dart';
import 'package:eatery/pages/printer_settings_page.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';

class EditCompanyPage extends StatefulWidget {
  const EditCompanyPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  String? pickedImagePath;
  final TextEditingController _controllerRestaurantName = TextEditingController();
  final TextEditingController _controllerEmailAddress = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerFssai = TextEditingController();
  final TextEditingController _controllerGstin = TextEditingController();
  final TextEditingController _controllerCurrencySymbol = TextEditingController();
  late String selectedTaxName = 'GST';

  late Map<String, dynamic> company;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCompany());
  }

  Future<void> loadCompany() async{
    Map<String, dynamic>? company =await Account.get(widget.account['id']);
    if(company != null){
      setState((){
        this.company = company;
        pickedImagePath = this.company['logo'];
        _controllerRestaurantName.text = this.company['name'];
        _controllerEmailAddress.text = this.company['email'];
        _controllerPhoneNumber.text = this.company['phone'];
        _controllerAddress.text = this.company['address'];
        _controllerFssai.text = this.company['foodLicenseNo'];
        _controllerGstin.text = this.company['taxNo'];
        selectedTaxName = this.company['taxName'];
        _controllerCurrencySymbol.text = this.company['currencySymbol'];
      });
    }
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  SizedBox options(){
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        InkWell(
          child: UploadButton(
            title: '+ Upload Picture',
            subTitle: 'Restaurant Logo',
            primaryColor: getThemeColor(),
            secondaryColor: ColorStyle.text200,
            pickedImagePath: pickedImagePath,
            onCloseTap: () {
              setState(() {
                pickedImagePath = null;
              });
            },
          ),
          onTap: () async {
            String? path = await AppFileSystem.pickImage();
            setState(() {
              pickedImagePath = path;
            });
          },
        ),
        const SizedBox(
          height: 6.0,
        ),
        Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Restaurant Name',
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
            controller: _controllerRestaurantName,
            labelText: 'eg. Food Plaza',
            obscureText: false,
          ),
        ]),
        const SizedBox(
          height: 6.0,
        ),
        Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Email Address',
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
            keyboardType: TextInputType.emailAddress,
            controller: _controllerEmailAddress,
            labelText: 'eg. delhi@foodplaza.in',
            obscureText: false,
          ),
        ]),
        const SizedBox(
          height: 6.0,
        ),
        Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Phone Number',
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
            keyboardType: TextInputType.phone,
            controller: _controllerPhoneNumber,
            labelText: 'eg. +919999999999',
            obscureText: false,
          ),
        ]),
        const SizedBox(
          height: 6.0,
        ),
        Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Address',
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
            keyboardType: TextInputType.streetAddress,
            controller: _controllerAddress,
            labelText: 'Where are we?',
            obscureText: false,
          ),
        ]),
        const SizedBox(
          height: 6.0,
        ),
        Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Tax Number',
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
            keyboardType: TextInputType.streetAddress,
            controller: _controllerGstin,
            labelText: 'eg. 22ASAAA0990A1Z5',
            obscureText: false,
          ),
        ]),
        const SizedBox(
          height: 6.0,
        ),
        Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Food License Number',
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
            keyboardType: TextInputType.streetAddress,
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
            'Currency symbol',
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
            keyboardType: TextInputType.text,
            controller: _controllerCurrencySymbol,
            labelText: 'eg. \$/₹',
            obscureText: false,
          ),
        ]),

        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Taxation',
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
              // activeToggleColor: Color(0xFF6E40C9),
              // inactiveToggleColor: Color(0xFF2F363D),
              // activeColor: getThemeColor(),
              // inactiveColor: Colors.white,
              // activeTextColor: Colors.black,
              // inactiveTextColor: Colors.white,


              onToggle: (value){
                setState((){
                  if(selectedTaxName == 'GST'){
                    selectedTaxName = 'VAT';
                  }
                  else{
                    selectedTaxName = 'GST';
                  }
                });
              },
            )
          ],
        ),

        const SizedBox(
          height: 12.0,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Edit Company'),
    );


    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(top: 12.0, left: 12.0, right: 12.0, bottom: 0, child: options()),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.background100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                text: 'Continue',
                backgroundColor: getThemeColor(),
                color: ColorStyle.background100,
                height: 50.0,
                onTap: () async {
                  Map<String, dynamic> company = this.company;
                  company['name'] = _controllerRestaurantName.text;
                  company['logo'] = pickedImagePath;
                  company['email'] = _controllerEmailAddress.text;
                  company['phone'] = _controllerPhoneNumber.text;
                  company['address'] = _controllerAddress.text;
                  company['foodLicenseNo'] = _controllerFssai.text;
                  company['taxNo'] = _controllerGstin.text;
                  company['taxName'] = selectedTaxName;
                  company['currencySymbol'] = _controllerCurrencySymbol.text;
                  bool response = await Account.update(company);
                  if(response){
                    showSnackBar(context, 'Successfully updated');
                    Navigator.pop(context);
                  }else{
                    showSnackBar(context, 'Failed to updated');
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
