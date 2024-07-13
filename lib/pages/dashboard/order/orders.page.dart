import 'dart:ui' as ui;
import 'package:eatery_db/eatery_db.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:eatery/references.dart';

final Color _pageColor = KColors.tertiary2;

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final GlobalKey genKey = GlobalKey();
  late List<Map<String, dynamic>> orders = [];
  DateTime? filterFrom;
  DateTime? filterTill;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {});
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

  @override
  Widget build(BuildContext context) {
    List<Order> orders = EateryDB.instance.orderBox!.values.toList();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: SearchOrderDelegate(orders, (order) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewOrderPage(order: order),
                    ),
                  );
                }),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.barcode_reader),
            onPressed: () async {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {},
          ),
        ],
      ),
      body: orders.isNotEmpty
          ? ListView(
              children: [
                ...orders.map((order) => ListTile(
                  // leading: Icon(
                  //   order.type == OrderType.dine
                  //       ? Icons.restaurant
                  //       : order.type == OrderType.delivery
                  //       ? Icons.delivery_dining
                  //       : Icons.takeout_dining,
                  // ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${Common.currency?.symbol}${order.finalTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w600)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(order.type.color!),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(order.type.description!, style: TextStyle(color: Color(order.type.color!), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${DateFormat.yMMMd().format(order.createdAt)}'),
                      Text('Customer Phone: ${order.customerPhone ?? 'N/A'}'),
                      Text('Total Quantity: ${order.totalQuantity}'),
                      Text('Sub Total: ${Common.currency?.symbol}${order.subTotal.toStringAsFixed(2)}'),
                      Text('Discount: ${Common.currency?.symbol}${order.discountTotal.toStringAsFixed(2)}'),
                      Text('Tax: ${Common.currency?.symbol}${order.taxTotal.toStringAsFixed(2)}'),
                      Text('Round Off: ${Common.currency?.symbol}${order.roundOff.toStringAsFixed(2)}'),
                      Text('Grand Total: ${Common.currency?.symbol}${order.grandTotal.toStringAsFixed(2)}'),
                      if (order.paidTotal != null)
                        Text('Paid Total: ${Common.currency?.symbol}${order.paidTotal!.toStringAsFixed(2)}'),
                    ],
                  ),
                  onTap: () {
                    // Handle tile tap
                  },
                )
                  /*ListTile(
                        leading: Icon(
                      order.type == OrderType.dine
                          ? Icons.restaurant
                          : order.type == OrderType.delivery
                              ? Icons.delivery_dining
                              : Icons.takeout_dining,
                    ),
                  title: Text(order.finalTotal.toString()),
                  subtitle: Text(DateFormat.yMMMd().format(order.createdAt)),
                )*/)
              ],
            )
          : const Center(
              child: Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No orders received yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Create a new sale to get started',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}
