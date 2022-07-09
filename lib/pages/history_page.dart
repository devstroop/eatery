import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:eatery/components/custom_dialog_box.dart';
import 'package:eatery/database/order.dart';
import 'package:eatery/extensions/app_file_system.dart';
import 'package:eatery/models/order_type.dart';
import 'package:eatery/pages/detailed_history_page.dart';
import 'package:eatery/pages/print_sales_report_page.dart';
import 'package:eatery/services/printing/print_report.dart';
import 'package:eatery/services/utility/generate.dart';
import 'package:eatery/services/utility/share.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final GlobalKey genKey = GlobalKey();
  late List<Map<String, dynamic>> orders = [];
  DateTime? filterFrom = DateTime.now();
  DateTime? filterTill = DateTime.now();

  void loadOrders() async {
    List<Map<String, dynamic>> orders = await Order.getAll();
    orders.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
    setState(() {
      this.orders = orders;
    });
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Color getThemeColor() {
    return ColorStyle.logoColor;
  }
  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = genKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      setState(() {});
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  double calculateTodayTaxableTotal(List<Map<String, dynamic>> orders) {
    double total = 0;
    DateTime now = DateTime.now();
    DateTime from = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime till = DateTime(now.year, now.month, now.day, 59, 59, 59);
    for (Map<String, dynamic> order in orders) {
      if (DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isAfter(from) &&
          DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isBefore(till)) {
        total += order['taxableTotal'];
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }
  double calculateTodayTaxTotal(List<Map<String, dynamic>> orders) {
    double total = 0;
    DateTime now = DateTime.now();
    DateTime from = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime till = DateTime(now.year, now.month, now.day, 59, 59, 59);
    for (Map<String, dynamic> order in orders) {
      if (DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isAfter(from) &&
          DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isBefore(till)) {
        total += order['taxTotal'];
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }
  double calculateTodayFinalTotal(List<Map<String, dynamic>> orders) {
    double total = 0;
    DateTime now = DateTime.now();
    DateTime from = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime till = DateTime(now.year, now.month, now.day, 59, 59, 59);
    for (Map<String, dynamic> order in orders) {
      if (DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isAfter(from) &&
          DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isBefore(till)) {
        total += order['finalTotal'];
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  double calculateAllFinalTotal(List<Map<String, dynamic>> orders) {
    double total = 0;
    for (Map<String, dynamic> order in orders) {
      total += order['finalTotal'];
    }
    return double.parse(total.toStringAsFixed(2));
  }
  double calculateAllTaxableTotal(List<Map<String, dynamic>> orders) {
    double total = 0;
    for (Map<String, dynamic> order in orders) {
      total += order['taxableTotal'];
    }
    return total;
  }
  double calculateAllTaxTotal(List<Map<String, dynamic>> orders) {
    double total = 0;
    for (Map<String, dynamic> order in orders) {
      total += order['taxTotal'];
    }
    return double.parse(total.toStringAsFixed(2));
  }
  bodyWidget(BuildContext context, Widget ordersPanel) => RepaintBoundary(
    key: genKey,
    child: Container(
      color: ColorStyle.background200,
      child: Stack(
        children: [
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 0, child: ordersPanel),
          /*Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  color: ColorStyle.background100,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Today\'s Sale',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              Text(
                                '${calculateTodayTaxableTotal(orders)} + ${calculateTodayTaxTotal(orders)}',
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                '${widget.account['currencySymbol']}${calculateTodayFinalTotal(orders)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Sale',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              Text(
                                '${calculateAllTaxableTotal(orders)} + ${calculateAllTaxTotal(orders)}',
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                '${widget.account['currencySymbol']}${calculateAllFinalTotal(orders)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )))*/
        ],
      ),
    )
  );
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('History'),
      actions: [
        IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: 'Filter',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select date range to filter'),
                        Column(children: [
                          DateTimePicker(
                            cursorColor: getThemeColor(),
                            initialValue: filterFrom != null ? DateFormat("yyyy-MM-dd").format(filterFrom!) : '',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'From',
                            onChanged: (val) {
                              setState((){
                                filterFrom = DateFormat("yyyy-MM-dd").parse(val);
                              });
                            },
                            validator: (val) {
                              return null;
                            },
                            onSaved: (val) => print(val),
                          ),
                          DateTimePicker(
                            cursorColor: getThemeColor(),
                            initialValue: filterTill != null ? DateFormat("yyyy-MM-dd").format(filterTill!) : '',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'Till',
                            onChanged: (val){
                              setState((){
                                filterTill = DateFormat("yyyy-MM-dd").parse(val);
                              });
                            },
                            onSaved: (val) => print(val),
                          )
                        ])
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            List<Map<String, dynamic>> orders = await Order.getAll();
                            setState((){
                              this.orders = orders;
                              filterFrom = null;
                              filterTill = null;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Clear')),
                      TextButton(
                          onPressed: () async {
                            if(filterFrom != null && filterTill != null){
                              List<Map<String, dynamic>> orders = await Order.getAll();
                              orders = orders.where((order) => DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isAfter(filterFrom!) && DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isBefore(filterTill!.add(const Duration(days: 1)))).toList();
                              setState((){
                                this.orders = orders;
                              });
                            }else{
                              showSnackBar(context, "Select date range to filter");
                            }
                            Navigator.pop(context);

                          },
                          child: const Text('Filter'))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt)),
        IconButton(
            onPressed: () async {
              try{
                String message = await PrintReport.printReceipt(orders: orders, account: widget.account, from: filterFrom, till: filterTill);
                showSnackBar(context, message);
              }catch(_){
                showSnackBar(context, 'Print error');
                return;
              }
            },
            icon: const Icon(Icons.print)),
        IconButton(
            onPressed: () async {
              final temp = await AppFileSystem.getShareDir();
              final path ='$temp/${getRandomString(8)}.png';
              await File(path).writeAsBytes(await _capturePng());
              await shareFile(path, 'Sales Report', 'Autogenerated by RestaurantPOS');
            },
            icon: const Icon(Icons.share))
      ],
    );

    final ordersPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        orders.isEmpty
            ? SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width
                            : 0.0) *
                        0.5,
                  ),
                  child: Center(
                      child: Image.asset(
                    'assets/images/2748558.png',
                    width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.height) *
                        0.5,
                  )),
                ),
              )
            : Container(),
        for (var order in orders)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailedHistoryPage(
                          order: order,
                          account: widget.account,
                          orderType: order['orderType'] == 'dineIn'
                              ? OrderType.dineIn
                              : order['orderType'] == 'delivery'
                              ? OrderType.delivery
                              : order['orderType'] == 'takeAway'
                              ? OrderType.takeAway
                              : null,
                        )),
                  ).then((_) async {
                    List<Map<String, dynamic>> orders = await Order.getAll();
                    setState(() {
                      this.orders = orders;
                    });
                  });
                },
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
                                  "#${order['id']}",
                                  style:
                                  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                                ),
                                Text(
                                  "${order["customerName"] ?? 'NA'} | ${
                                    DateFormat('MM/dd/yyyy H:m')
                                        .format(DateTime.fromMicrosecondsSinceEpoch(order['timestamp'] ?? 0))
                                  }",
                                  style:
                                  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: ColorStyle.text400),
                                )
                              ],
                            )
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                        child: Row(
                          children: [
                            Text(
                              '${order['taxableTotal']} + ${order['taxTotal']}',
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              '${widget.account['currencySymbol']}${order['finalTotal']}',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                            )
                          ],
                        )),
                  ],
                ),
              ), const Divider()
            ],
          )
      ]),
    );

    return Scaffold(
      appBar: appBar,
      body: bodyWidget(context, ordersPanel),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(

        backgroundColor: getThemeColor(),
        icon: const Icon(Icons.qr_code),
        onPressed: () async {
          String? id = await scanner.scan();
          if (id != null) {
            Map<String, dynamic>? order = await Order.get(id);
            if (order != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailedHistoryPage(
                      order: order,
                      account: widget.account,
                      orderType: order['orderType'] == 'dineIn'
                          ? OrderType.dineIn
                          : order['orderType'] == 'delivery'
                          ? OrderType.delivery
                          : order['orderType'] == 'takeAway'
                          ? OrderType.takeAway
                          : null,
                    )),
              ).then((_) async {
                List<Map<String, dynamic>> orders = await Order.getAll();
                setState(() {
                  this.orders = orders;
                });
              });
            } else {
              showSnackBar(context, 'Not found');
            }
          }
        }, label: const Text("Scan"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            color: ColorStyle.background100,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                filterFrom == null  && filterTill == null ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Sale',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          '${calculateTodayTaxableTotal(orders)} + ${calculateTodayTaxTotal(orders)}',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${widget.account['currencySymbol']}${calculateTodayFinalTotal(orders)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ) : const SizedBox.shrink(),
                filterFrom == null  && filterTill == null ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Sale',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          '${calculateAllTaxableTotal(orders)} + ${calculateAllTaxTotal(orders)}',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${widget.account['currencySymbol']}${calculateAllFinalTotal(orders)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ) : const SizedBox.shrink(),
                filterFrom != null  && filterTill != null ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sale',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          '${calculateAllTaxableTotal(orders)} + ${calculateAllTaxTotal(orders)}',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${widget.account['currencySymbol']}${calculateAllFinalTotal(orders)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ) : const SizedBox.shrink(),
              ],
            )),
      ),
    );
  }
}
