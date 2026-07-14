import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'dart:ui' as ui;

import 'package:eatery_core/extensions/double_ext.dart';
import 'package:eatery/functions/order.function.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrderPrintPage extends ConsumerStatefulWidget {
  const OrderPrintPage({
    super.key,
    required this.order,
    required this.currentCart,
    this.printKOT = false,
    this.printInvoice = false,
  });

  final Order order;
  final List<Product> currentCart;
  final bool printKOT;
  final bool printInvoice;

  @override
  ConsumerState<OrderPrintPage> createState() => _OrderPrintPageState();
}

class _OrderPrintPageState extends ConsumerState<OrderPrintPage> {
  final GlobalKey invKey = GlobalKey();
  final GlobalKey kotKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Print Preview',
      showBack: false,
      child: ListView(
        children: [
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed('dashboard');
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (widget.printKOT)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'KOT Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.print, size: 16),
                          SizedBox(width: 3),
                          Text('Print'),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        share(context, kotKey);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.share, size: 16),
                          SizedBox(width: 3),
                          Text('Share'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                kotPreview(context),
                const SizedBox(height: 24),
              ],
            ),
          if (widget.printInvoice)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Invoice Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.print, size: 16),
                          SizedBox(width: 3),
                          Text('Print'),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        share(context, invKey);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.share, size: 16),
                          SizedBox(width: 3),
                          Text('Share'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                invoicePreview(context),
                const SizedBox(height: 24),
              ],
            ),
        ],
      ),
    );
  }

  invoicePreview(BuildContext context) {
    final currency = ref.read(companyProvider.notifier).currency?.symbol ?? '';
    final company = ref.read(companyProvider);
    final customer = ref
        .read(customerRepositoryProvider)
        .getCustomerByPhone(widget.order.customerPhone ?? '');
    final orderPhone = customer?.phone ?? '';
    final orderName = customer?.name ?? '';
    final orderAddress = customer?.address ?? '';
    List<OrderProduct> products = ref
        .read(orderRepositoryProvider)
        .getOrderProducts(widget.order.id!);
    return RepaintBoundary(
      key: invKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: const Color(0xFFFFFFFF),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${company?.name ?? ''} (Invoice)',
                  style: AppTypography.titleLarge,
                ),
                Text(
                  company?.address ?? '',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  [company?.email ?? '', company?.phone ?? ''].join(', '),
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12.0, child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order: #${widget.order.id}',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  'Date: ${DateFormat('dd/MM/yyyy').format(widget.order.createdAt)}',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12.0, child: Divider()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderName,
                      style: AppTypography.labelLarge,
                    ),
                    Text(
                      orderPhone,
                      style: AppTypography.labelLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Address: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      orderAddress ?? '',
                      style: AppTypography.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0, child: Divider()),
            ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];

                return Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        product.productName,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'x ${product.quantity}',
                        style: AppTypography.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${product.price.toPrecision(2)}/-',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${currency}${product.subTotal.toPrecision(2)}',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12.0, child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Text(
                  '${currency}${widget.order.subTotal.toPrecision(2)}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tax',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Text(
                  '${currency}${(widget.order.taxTotal ?? 0).toPrecision(2)}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Text(
                  '${currency}${widget.order.finalTotal.toPrecision(2)}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12.0, child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Round off (+/-)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Text(
                  '${widget.order.roundOff > 0 ? '+' : '-'} ${currency}${widget.order.roundOff.toPrecision(2).abs()}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  '${currency}${widget.order.grandTotal.toPrecision(2)}',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  kotPreview(BuildContext context) {
    final company = ref.read(companyProvider);
    final customer = ref
        .read(customerRepositoryProvider)
        .getCustomerByPhone(widget.order.customerPhone ?? '');
    final orderName = customer?.name ?? '';
    final orderPhone = customer?.phone ?? '';
    final orderAddress = customer?.address ?? '';
    return RepaintBoundary(
      key: kotKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: const Color(0xFFFFFFFF),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${company?.name ?? ''} (KOT)',
                  style: AppTypography.titleLarge,
                ),
                Text(
                  company?.address ?? '',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12.0, child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order: #${widget.order.id}',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  'Date: ${DateFormat('dd/MM/yyyy').format(widget.order.createdAt)}',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12.0, child: Divider()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderName,
                      style: AppTypography.labelLarge,
                    ),
                    Text(
                      orderPhone,
                      style: AppTypography.labelLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Address: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      orderAddress ?? '',
                      style: AppTypography.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0, child: Divider()),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.currentCart.map((obj) => obj.id).toSet().length,
              itemBuilder: (context, index) {
                var productId = widget.currentCart
                    .map((obj) => obj.id)
                    .toSet()
                    .toList()[index];

                // Use firstWhere instead of singleWhere
                var product = widget.currentCart.firstWhere(
                  (element) => element.id == productId,
                );

                return Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        product.name,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'x ${widget.currentCart.where((element) => element.id == product.id).length}',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12.0, child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Qty',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  '${widget.currentCart.length}',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> capturePng(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      debugPrint(bs64.length.toString());
      setState(() {});
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  share(BuildContext context, GlobalKey key) async {
    final dir = await getTemporaryDirectory();
    final path =
        '$dir/${getRandomString(5) + getRandomString(5) + getRandomString(5)}.png';
    await File(path).writeAsBytes(await capturePng(key));
    await shareFile(
      path,
      'Invoice #${widget.order.id}',
      'Autogenerated by Eatery',
    );
    //await File(path).delete();
  }
}
