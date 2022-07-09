import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/product_card.dart';
import 'package:eatery/components/waiter_card.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/database/order.dart';
import 'package:eatery/database/waiter.dart';
import 'package:eatery/models/order_type.dart';
import 'package:eatery/pages/add_waiter_page.dart';
import 'package:eatery/pages/detailed_history_page.dart';
import 'package:eatery/pages/edit_waiter_page.dart';
import 'package:eatery/style/color_style.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {


  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Help'),
    );


    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: Container(color: Colors.blueAccent,)),
        ],
      ),
    );
  }
}
