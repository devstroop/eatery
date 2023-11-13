import 'package:eatery/references.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key, required this.order});

  final Order order;

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  final GlobalKey genKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          const SizedBox(
            height: 60,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Print Preview',
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
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(color: const Color(0xFFF0F0F0), width: 1)),
              child: const Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #123',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '12:00 PM',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Table #1',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '12/12/2021',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Customer Phone',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ]),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Quantity',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Price',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Quantity',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Price',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Quantity',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Price',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ]))
        ],
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
                    Navigator.pushAndRemoveUntil(
                      this.context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                          (Route<dynamic> route) => false,
                    );
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
