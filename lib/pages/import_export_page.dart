import 'dart:io';

import 'package:flutter/material.dart';
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

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {


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
            prefixIcon: Icons.input, title: 'Import', subtitle: 'Import invoices and vouchers', postfixIcon: Icons.arrow_forward_ios_sharp, color: getThemeColor(),
            onTap: (){

            },
          ),
        ),
        InkWell(
          onTap: () { },
          child: MenuTile(
            prefixIcon: Icons.output, title: 'Export', subtitle: 'Export invoices and vouchers', postfixIcon: Icons.arrow_forward_ios_sharp, color: getThemeColor(),
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
      title: const Text('Import / Export'),
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
