import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:eatery/constants/utils/calculations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/constants/utils/app_file_system.dart';
import 'package:eatery/services/printing/print_invoice.dart';
import 'package:eatery/services/utility/generate.dart';
import 'package:eatery/services/utility/share.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'dart:ui' as ui;

class OrderConfirmation extends StatefulWidget {
  const OrderConfirmation(
      {Key? key, required this.order, required this.account})
      : super(key: key);
  final Map<String, dynamic> order;
  final Map<String, dynamic> account;

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  final GlobalKey genKey = GlobalKey();
  @override
  void initState() {
    super.initState();
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

  previewWidget(BuildContext context) => RepaintBoundary(
        key: genKey,
        child: Container(
          color: ColorStyle.backgroundColorAlter,
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
                    widget.account['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.account['taxNo'] != '' ? (widget.account['taxName'] != '' ? widget.account['taxName'] : 'Tax') + ': ' : ''}${widget.account['taxNo'] != '' ? widget.account['taxNo'] + ', ' : ''}${widget.account['foodLicenseNo'] != '' ? 'FSSAI:' + widget.account['foodLicenseNo'] : ''}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.account['address'] ?? ''}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.account['phone']}, ${widget.account['email']}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Order Id: #${widget.order['id']}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.order['orderTypeText']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '${widget.order['customerName'] ?? ''}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.order['customerPhone'] ?? ''}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.order['customerAddress'] ?? ''}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Qty',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Particulars',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Price',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Amount',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              for (Map<String, dynamic> item in widget.order['cart'].values)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          Calculations.compressDoubleToString(item['quantity']),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${Calculations.calculatePriceWithoutTax(taxType: item['taxType'], price: item['price'], tax: item['tax_slab'])}/-',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${Calculations.calculatePriceWithoutTax(taxType: item['taxType'], price: item['price'], tax: item['tax_slab']) * item['quantity']}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Taxable',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.order['taxableTotal']}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "${widget.account['taxName'] != '' ? widget.account['taxName'] : 'Tax'}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.order['taxTotal']}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              widget.order['roundOff'] > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          'Round off (+/-)',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        Text(
                          '${widget.order['roundOff']}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.account['currencySymbol']}${widget.order['finalTotal']}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '${NumberToWord().convert('en-in', widget.order['finalTotal'])}only'
                        .toUpperCase(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Thank you!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MM/dd/yyyy H:m').format(DateTime.now()),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              // QrImage(
              //   data: widget.order['id'],
              //   version: QrVersions.auto,
              //   size: 80.0,
              // ),

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
      backgroundColor: ColorStyle.backgroundColorAlter,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Receipt Preview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
        color: ColorStyle.backgroundColorAlter,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  child: const Text('< Back'),
                  color: ColorStyle.tertiary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 6,
                ),
                PrimaryButton(
                  child: Icon(
                    Icons.print,
                    color: ColorStyle.backgroundColorAlter,
                  ),
                  color: ColorStyle.primary,
                  onPressed: () async {
                    try {
                      String message = await PrintInvoice.printReceipt(
                          order: widget.order, account: widget.account);
                      showSnackBar(context, message);
                    } catch (_) {
                      showSnackBar(context, 'Print error');
                      return;
                    }
                  },
                ),
                const SizedBox(
                  width: 6,
                ),
                PrimaryButton(
                  child: Icon(
                    Icons.share,
                    color: ColorStyle.backgroundColorAlter,
                  ),
                  color: ColorStyle.success,
                  onPressed: () async {
                    final temp = await AppFileSystem.getShareDir();
                    final path = '$temp/${getRandomString(8)}.png';
                    await File(path).writeAsBytes(await _capturePng());
                    await shareFile(path, 'Invoice #${widget.order['id']}',
                        'Autogenerated by RestaurantPOS');
                    //await File(path).delete();
                  },
                ),
              ],
            )),
      ),
    );
  }
}
