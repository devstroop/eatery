import 'dart:io';

import 'package:flutter/material.dart';
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, this.account}) : super(key: key);
  final dynamic account;
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<Map<String, dynamic>> ordersData = [];

  void loadWaiters() async {
    List<Map<String, dynamic>> ordersData = await Order.getAll();
    setState(() {
      this.ordersData = ordersData;
    });
  }

  @override
  void initState() {
    super.initState();
    loadWaiters();
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('History'),
    );

    final ordersPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        for (var order in ordersData)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailedHistoryPage(order: order, account: widget.account,
                      orderType: order['orderType'] == 'dineIn'
                          ? OrderType.dineIn
                          : order['orderType'] == 'delivery'
                          ? OrderType.delivery
                          : order['orderType'] == 'takeAway'
                          ? OrderType.takeAway
                          : null,)),
              ).then((_) {
                setState((){});
              });
            },
            child: Container(
              color: ColorStyle.background100,
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(
                              order['orderType'] == 'dineIn'
                                  ? OrderType.dineIn.icon
                                  : order['orderType'] == 'delivery'
                                      ? OrderType.delivery.icon
                                      : order['orderType'] == 'takeAway'
                                          ? OrderType.takeAway.icon
                                          : Icons.block,
                              color: order['orderType'] == 'dineIn'
                                  ? OrderType.dineIn.color
                                  : order['orderType'] == 'delivery'
                                      ? OrderType.delivery.color
                                      : order['orderType'] == 'takeAway'
                                          ? OrderType.takeAway.color
                                          : ColorStyle.text200,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['customerName'] ?? 'NA',
                                style:
                                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                              ),
                              Text(
                                DateTime.fromMicrosecondsSinceEpoch(order['timestamp']  ?? 0).toString(),
                                style:
                                    TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: ColorStyle.text400),
                              )
                            ],
                          )
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                      child: Text('${widget.account['currencySymbol'] ?? ''}${order['finalTotal']}', style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),)),
                ],
              ),
            ),
          )
      ]),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: ordersPanel),
        ],
      ),
    );
  }
}
