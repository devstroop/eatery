import 'package:intl/intl.dart';
import 'package:eatery/references.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage(
      {Key? key, required this.order})
      : super(key: key);
  final Order order;

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final GlobalKey genKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  /*Future<Uint8List> _capturePng() async {
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
  }*/

  previewWidget(BuildContext context) => RepaintBoundary(
        key: genKey,
        child: Container(
          color: KColors.white,
          margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
          //height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.order.customer?.name ?? 'Unnamed',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.order.customer?.phone ?? 'No Phone',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order #${widget.order.id}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy hh:mm a')
                        .format(widget.order.timestamp),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Products',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),



            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receipt Preview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Customer copy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            previewWidget(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: KColors.white,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  color: KColors.tertiary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('< Back'),
                ),
                const SizedBox(
                  width: 6,
                ),
                PrimaryButton(
                  color: KColors.primary,
                  onPressed: () async {
                    // PrintInvoice.printReceipt(
                    //         order: widget.order, account: widget.account)
                    //     .then((String message) {
                    //       showMessageDialog(context, message, MessageType.info);
                    // }).onError((error, stackTrace) {
                    //   showMessageDialog(context, error.toString(), MessageType.error);
                    // });
                  },
                  child: Icon(
                    Icons.print,
                    color: KColors.white,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                PrimaryButton(
                  color: KColors.green,
                  onPressed: () async {
                    // final temp = await AppFileSystem.getShareDir();
                    // final path = '$temp/${getRandomString(8)}.png';
                    // await File(path).writeAsBytes(await _capturePng());
                    // await shareFile(path, 'Invoice #${widget.order['id']}',
                    //     'Autogenerated by RestaurantPOS');
                    // //await File(path).delete();
                  },
                  child: Icon(
                    Icons.share,
                    color: KColors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
