import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:eatery_db/models/order/order_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:eatery/components/custom_dialog_box.dart';
import 'package:eatery/constants/utils/app_file_system.dart';
import 'package:eatery/services/utility/generate.dart';
import 'package:eatery/services/utility/share.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key, required this.company}) : super(key: key);
  final Company company;
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final GlobalKey genKey = GlobalKey();
  late List<Map<String, dynamic>> orders = [];
  DateTime? filterFrom;
  DateTime? filterTill;

  void loadOrders() async {
    // List<Map<String, dynamic>> orders = await Order.getAll();
    // orders.sort(
    //     (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
    // setState(() {
    //   this.orders = orders;
    // });
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Color getThemeColor() {
    return ColorStyle.brandColor;
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          genKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      debugPrint(bs64.length.toString());
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
      if (DateTime.fromMicrosecondsSinceEpoch(order['timestamp'])
              .isAfter(from) &&
          DateTime.fromMicrosecondsSinceEpoch(order['timestamp'])
              .isBefore(till)) {
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
      if (DateTime.fromMicrosecondsSinceEpoch(order['timestamp'])
              .isAfter(from) &&
          DateTime.fromMicrosecondsSinceEpoch(order['timestamp'])
              .isBefore(till)) {
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
      if (DateTime.fromMicrosecondsSinceEpoch(order['timestamp'])
              .isAfter(from) &&
          DateTime.fromMicrosecondsSinceEpoch(order['timestamp'])
              .isBefore(till)) {
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
        color: ColorStyle.backgroundColorAlter,
        child: ordersPanel,
      ));
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Reports'),
      actions: [
        IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: 'Filter',
                    actions: [
                      TextButton(
                          onPressed: () async {
                            // Order.getAll()
                            //     .then((List<Map<String, dynamic>> orders) {
                            //   setState(() {
                            //     this.orders = orders;
                            //     filterFrom = null;
                            //     filterTill = null;
                            //   });
                            //   Navigator.pop(context);
                            // });
                          },
                          child: const Text('Clear')),
                      TextButton(
                          onPressed: () async {
                            if (filterFrom != null && filterTill != null) {
                              // Order.getAll()
                              //     .then((List<Map<String, dynamic>> orders) {
                              //   orders = orders
                              //       .where((order) =>
                              //           DateTime.fromMicrosecondsSinceEpoch(
                              //                   order['timestamp'])
                              //               .isAfter(filterFrom!) &&
                              //           DateTime.fromMicrosecondsSinceEpoch(
                              //                   order['timestamp'])
                              //               .isBefore(filterTill!
                              //                   .add(const Duration(days: 1))))
                              //       .toList();
                              //   setState(() {
                              //     this.orders = orders;
                              //   });
                              // });
                            } else {
                              showSnackBar(
                                  context, "Select date range to filter");
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Filter'))
                    ],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select date range to filter'),
                        Column(children: [
                          DateTimePicker(
                            cursorColor: getThemeColor(),
                            initialValue: filterFrom != null
                                ? DateFormat("yyyy-MM-dd").format(filterFrom!)
                                : '',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'From',
                            onChanged: (val) {
                              setState(() {
                                filterFrom =
                                    DateFormat("yyyy-MM-dd").parse(val);
                              });
                            },
                            validator: (val) {
                              return null;
                            },
                            onSaved: (val) => debugPrint(val),
                          ),
                          DateTimePicker(
                            cursorColor: getThemeColor(),
                            initialValue: filterTill != null
                                ? DateFormat("yyyy-MM-dd").format(filterTill!)
                                : '',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'Till',
                            onChanged: (val) {
                              setState(() {
                                filterTill =
                                    DateFormat("yyyy-MM-dd").parse(val);
                              });
                            },
                            onSaved: (val) => debugPrint(val),
                          )
                        ])
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt)),
        IconButton(
            onPressed: () async {
              try {
                /*String message = await PrintReport.printReceipt(orders: orders, account: widget.account, from: filterFrom, till: filterTill);
                showSnackBar(context, message);*/
              } catch (_) {
                showSnackBar(context, 'Print error');
                return;
              }
            },
            icon: const Icon(Icons.print)),
        IconButton(
            onPressed: () async {
              final temp = await AppFileSystem.getShareDir();
              final path = '$temp/${getRandomString(8)}.png';
              await File(path).writeAsBytes(await _capturePng());
              await shareFile(
                  path, 'Sales Report', 'Autogenerated by RestaurantPOS');
            },
            icon: const Icon(Icons.share))
      ],
    );

    final ordersView = ListView.separated(
      itemCount: orders.length,
      shrinkWrap: false,
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: true,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) => ListTile(
        isThreeLine: false,
        dense: false,
        leading: Icon(
          orders[index]['orderType'] == 'dineIn'
              ? OrderType.dine.icon
              : orders[index]['orderType'] == 'delivery'
                  ? OrderType.delivery.icon
                  : orders[index]['orderType'] == 'takeAway'
                      ? OrderType.takeout.icon
                      : Icons.block,
          color: orders[index]['orderType'] == 'dineIn'
              ? OrderType.dine.color
              : orders[index]['orderType'] == 'delivery'
                  ? OrderType.delivery.color
                  : orders[index]['orderType'] == 'takeAway'
                      ? OrderType.takeout.color
                      : ColorStyle.text200,
        ),
        title: Text(orders[index]['customerName']),
        subtitle: Text(
          '#${orders[index]['id']} on ${DateFormat().format(DateTime.fromMicrosecondsSinceEpoch(orders[index]['timestamp'] ?? 0))}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /*Text(
              '${widget.account['currencySymbol']}${orders[index]['finalTotal']}',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
            ),
            Text(
              'Taxable : ${widget.account['currencySymbol']}${orders[index]['taxableTotal']}',
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
            ),
            Text(
              'Tax : ${widget.account['currencySymbol']}${orders[index]['taxTotal']}',
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
            ),*/
          ],
        ),
        onTap: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedHistoryPage(
                  order: orders[index],
                  account: widget.account,
                  orderType: orders[index]['orderType'] == 'dineIn'
                      ? OrderType.dineIn
                      : orders[index]['orderType'] == 'delivery'
                      ? OrderType.delivery
                      : orders[index]['orderType'] == 'takeAway'
                      ? OrderType.takeAway
                      : null,
                )),
          ).then((_) async {
            List<Map<String, dynamic>> orders = await Order.getAll();
            setState(() {
              this.orders = orders;
            });
          });*/
        },
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: bodyWidget(context, ordersView),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: getThemeColor(),
        icon: const Icon(Icons.qr_code),
        onPressed: () async {
          String? id = await scanner.scan();
          if (id != null) {
            // Order.get(id).then((order) {
            //   if (order != null) {
            //     /*Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DetailedHistoryPage(
            //           order: order,
            //           account: widget.account,
            //           orderType: order['orderType'] == 'dineIn'
            //               ? OrderType.dineIn
            //               : order['orderType'] == 'delivery'
            //               ? OrderType.delivery
            //               : order['orderType'] == 'takeAway'
            //               ? OrderType.takeAway
            //               : null,
            //         )),
            //   ).then((_) async {
            //     List<Map<String, dynamic>> orders = await Order.getAll();
            //     setState(() {
            //       this.orders = orders;
            //     });
            //   });*/
            //   } else {
            //     showSnackBar(context, 'Not found');
            //   }
            // });
          }
        },
        label: const Text("Scan"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            color: ColorStyle.backgroundColorAlter,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                filterFrom == null && filterTill == null
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Sale',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              /*Text(
                          '${widget.account['currencySymbol']}${calculateTodayTaxableTotal(orders)} + ${widget.account['currencySymbol']}${calculateTodayTaxTotal(orders)}',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${widget.account['currencySymbol']}${calculateTodayFinalTotal(orders)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),*/
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
                filterFrom == null && filterTill == null
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Sale',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              /*Text(
                          '${widget.account['currencySymbol']}${calculateAllTaxableTotal(orders)} + ${widget.account['currencySymbol']}${calculateAllTaxTotal(orders)}',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${widget.account['currencySymbol']}${calculateAllFinalTotal(orders)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )*/
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
                filterFrom != null && filterTill != null
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sale',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              /*Text(
                          '${widget.account['currencySymbol']}${calculateAllTaxableTotal(orders)} + ${widget.account['currencySymbol']}${calculateAllTaxTotal(orders)}',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: ColorStyle.text400),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${widget.account['currencySymbol']}${calculateAllFinalTotal(orders)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )*/
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            )),
      ),
    );
  }
}
