import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:eatery/references.dart';

final Color _pageColor = ColorStyle.brandColor;

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final GlobalKey genKey = GlobalKey();
  late List<Map<String, dynamic>> orders = [];
  DateTime? filterFrom;
  DateTime? filterTill;


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      
    });
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
        title: const Text('Transactions'),
        actions: [
          IconButton(
              onPressed: () async {
              },
              icon: const Icon(Icons.barcode_reader)),
          IconButton(
              onPressed: () async {
              },
              icon: const Icon(Icons.filter_list_alt)),
          IconButton(
              onPressed: () async {

              },
              icon: const Icon(Icons.more_vert)),
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
            )/*Text(
              DateFormat('dd MMM, yyyy').format(e.createdAt),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),*/
          ))
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
                  'No Transactions Found',
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
