import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restaurant_pos/components/menu_tile.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/components/waiter_card.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/database/order.dart';
import 'package:restaurant_pos/database/waiter.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/pages/add_waiter_page.dart';
import 'package:restaurant_pos/pages/detailed_history_page.dart';
import 'package:restaurant_pos/pages/edit_waiter_page.dart';
import 'package:restaurant_pos/style/color_style.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {


  @override
  void initState() {
    super.initState();
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
          onTap: () { },
          child: MenuTile(
            prefixIcon: Icons.backup, title: 'Backup', subtitle: 'Backup your company data', postfixIcon: Icons.arrow_forward_ios_sharp, color: getThemeColor(),
            onTap: () async {
              
              final ProgressDialog pr = ProgressDialog(context);
              pr.style(
                  message: 'Downloading file...',
                  borderRadius: 10.0,
                  backgroundColor: Colors.white,
                  progressWidget: const CircularProgressIndicator(),
                  elevation: 10.0,
                  insetAnimCurve: Curves.easeInOut,
                  progress: 0.0,
                  maxProgress: 100.0,
                  progressTextStyle: const TextStyle(
                      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                  messageTextStyle: const TextStyle(
                      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
              );
              await pr.show();
            },
          ),
        ),
        InkWell(
          onTap: () { },
          child: MenuTile(
            prefixIcon: Icons.restore, title: 'Restore', subtitle: 'Restore your company data', postfixIcon: Icons.arrow_forward_ios_sharp, color: getThemeColor(),
            onTap: (){

            },
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Backup / Restore'),
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
