import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:eatery/references.dart';

final Color _pageColor = KColors.secondary2;

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
                        leading: Icon(
                      order.type == OrderType.dine
                          ? Icons.restaurant
                          : order.type == OrderType.delivery
                              ? Icons.delivery_dining
                              : Icons.takeout_dining,
                    )))
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
