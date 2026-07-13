import 'package:eatery_core/theme/app_typography.dart';
import 'package:intl/intl.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/product_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../functions/order.function.dart';

class OrderConfirmationPage extends ConsumerStatefulWidget {
  const OrderConfirmationPage({Key? key, required this.order})
    : super(key: key);
  final Order order;

  @override
  ConsumerState<OrderConfirmationPage> createState() =>
      _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends ConsumerState<OrderConfirmationPage> {
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
      color: AppColors.white,
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
      //height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /*const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ref.read(customerRepositoryProvider).getCustomerByPhone(widget.order.customerPhone ?? '')?.name ?? 'Unnamed',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ref.read(customerRepositoryProvider).getCustomerByPhone(widget.order.customerPhone ?? '')?.phone ?? 'No Phone',
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
              Divider(
                color: AppColors.white900,
              ),
              const SizedBox(
                height: 12.0,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  final product = widget.order.products[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              color: AppColors.black,
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '${widget.order.products.where((element) => element.id == product.id).length} x ${OrderFunction.calculateProductPriceWithoutTax(product)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                    ],
                  );
                },
              ),*/
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receipt Preview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Customer copy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 24),
            previewWidget(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: AppButton.primary(
                onPressed: () {
                  GoRouter.of(context).goNamed('dashboard');
                },
                label: '< Back',
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 1,
              child: AppButton.primary(
                label: 'Print',
                icon: Icons.print,
                onPressed: () async {
                  // PrintInvoice.printReceipt(
                  //         order: widget.order, account: widget.account)
                  //     .then((String message) {
                  //       showMessageDialog(context, message, MessageType.info);
                  // }).onError((error, stackTrace) {
                  //   showMessageDialog(context, error.toString(), MessageType.error);
                  // });
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 1,
              child: AppButton.primary(
                label: 'Share',
                icon: Icons.share,
                onPressed: () async {
                  // final temp = await AppFileSystem.getShareDir();
                  // final path = '$temp/${getRandomString(8)}.png';
                  // await File(path).writeAsBytes(await _capturePng());
                  // await shareFile(path, 'Invoice #${widget.order['id']}',
                  //     'Autogenerated by RestaurantPOS');
                  // //await File(path).delete();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
