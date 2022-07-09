import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eatery/components/bottom_view_grip.dart';
import 'package:eatery/components/custom_dialog_box.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/menu_tile.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/components/waiter_card.dart';
import 'package:eatery/database/account.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/database/order.dart';
import 'package:eatery/database/printer.dart';
import 'package:eatery/database/product.dart';
import 'package:eatery/database/product_category.dart';
import 'package:eatery/database/waiter.dart';
import 'package:eatery/extensions/app_file_system.dart';
import 'package:eatery/models/order_type.dart';
import 'package:eatery/pages/add_waiter_page.dart';
import 'package:eatery/pages/detailed_history_page.dart';
import 'package:eatery/pages/edit_company_page.dart';
import 'package:eatery/pages/edit_waiter_page.dart';
import 'package:eatery/pages/printer_settings_page.dart';
import 'package:eatery/style/color_style.dart';
import 'package:sn_progress_dialog/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Widget buildHelpBottomSheet() => StatefulBuilder(builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                      Text('Help', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Text('Get support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                    ],
                  ),
                  IconButton(onPressed: () async {
                    const url = "https://devstroop.com";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw "Could not launch $url";
                    }
                  }, icon: Icon(Icons.link, color: ColorStyle.logoColor))
                ],
              ),
              const SizedBox(height: 16.0,),
              Row(
                children: [
                  Icon(Icons.phone, size: 24, color: ColorStyle.logoColor,),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text('+91 950 100 5734', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Icon(Icons.email, size: 24, color: ColorStyle.logoColor,),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text('help@devstroop.com', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
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
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.logoColor;
  }

  SizedBox options() {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.business,
            title: 'Profile',
            subtitle: 'Manage Business Profile',
            postfixIcon: Icons.arrow_forward_ios_sharp,
            color: getThemeColor(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditCompanyPage(
                          account: widget.account,
                        )),
              ).then((_) => setState(() {}));
            },
          ),
        ),
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.print,
            title: 'Printer Settings',
            subtitle: 'Manage Printing Devices',
            postfixIcon: Icons.arrow_forward_ios_sharp,
            color: getThemeColor(),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrinterSettingsPage(account: widget.account)),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.delete,
            title: 'Delete company',
            subtitle: 'Destroy all invoices/products etc',
            postfixIcon: Icons.arrow_forward_ios_sharp,
            color: getThemeColor(),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController _controllerPassword = TextEditingController();
                  String? _message;
                  return CustomDialogBox(
                    title: 'Are you sure?',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('You\'re about to destroy company'),
                        Column(children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          CustomTextFromField(
                            keyboardType: TextInputType.number,
                            controller: _controllerPassword,
                            labelText: 'Enter PIN',
                            obscureText: true,
                          ),
                          _message != null
                              ? Text(
                                  _message,
                                  style: TextStyle(color: ColorStyle.error),
                                )
                              : Container()
                        ])
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () async {
                            if (widget.account['pin'] == _controllerPassword.text) {
                              Navigator.pop(context);
                              ProgressDialog pd = ProgressDialog(context: context);
                              pd.show(
                                max: 100,
                                msg: 'Clearing data',
                                progressBgColor: Colors.transparent,
                                completed: Completed(),
                              );
                              pd.update(value: 10, msg: 'Clearing orders');
                              await Order.clear();
                              pd.update(value: 20, msg: 'Clearing product categories');
                              await ProductCategory.clear();
                              pd.update(value: 30, msg: 'Clearing products');
                              await Product.clear();
                              pd.update(value: 40, msg: 'Clearing dining table categories');
                              await DiningTableCategory.clear();
                              pd.update(value: 50, msg: 'Clearing dining tables');
                              await DiningTable.clear();
                              pd.update(value: 60, msg: 'Clearing waiters');
                              await Waiter.clear();
                              pd.update(value: 70, msg: 'Clearing printers');
                              await Printer.clear();
                              pd.update(value: 80, msg: 'Clearing account');
                              await Account.clear();
                              pd.update(value: 90, msg: 'Clearing images');
                              await Directory(await AppFileSystem.getResourcesDir()).delete(recursive: true);
                              pd.update(value: 100, msg: 'Cleared all data');

                              try{
                                pd.close();
                              }catch(_){}

                              exit(0);
                            } else {
                              setState(() {
                                _message = 'Invalid PIN';
                              });
                            }
                          },
                          child: const Text('Destroy'))
                    ],
                  );
                },
              );
            },
          ),
        ),
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.help,
            title: 'Help',
            subtitle: 'Get support',
            postfixIcon: Icons.arrow_forward_ios_sharp,
            color: getThemeColor(),
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
                builder: (context) => buildHelpBottomSheet()),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Settings'),
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: options()),
        ],
      ),
    );
  }
}
