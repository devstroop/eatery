import 'package:eatery/constants/utils/calculations.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery_db/models/order/order_type.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/bottom_view_grip.dart';
import 'package:eatery/components/checkout_product_card.dart';
import 'package:eatery/components/custom_button.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/pos_waiter_card.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/database/cart.dart';
import 'package:eatery/database/order.dart';
import 'package:eatery/database/waiter.dart';
import 'package:eatery/services/printing/print_invoice.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import 'order_confirmation.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage(
      {Key? key,
      required this.orderType,
      required this.cart,
      this.diningTable,
      this.diningTableName,
      this.account,
      this.openOrderId,
      this.openOrderCustomerName,
      this.openOrderCustomerPhone,
      this.openOrderCustomerAddress,
      this.openOrderWaiterId,
      this.openOrderWaiterName})
      : super(key: key);
  final OrderType orderType;
  final Map<String, Map<String, dynamic>> cart;
  final String? diningTable;
  final String? diningTableName;
  final dynamic account;
  final String? openOrderId;
  final String? openOrderCustomerName;
  final String? openOrderCustomerPhone;
  final String? openOrderCustomerAddress;
  final String? openOrderWaiterId;
  final String? openOrderWaiterName;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _controllerCustomerPhone =
      TextEditingController();
  final TextEditingController _controllerCustomerAddress =
      TextEditingController();
  late String customerName;
  late String? customerPhone;
  late String? customerAddress;
  late List<Map<String, dynamic>> waitersData;
  late String? selectedWaiterId;
  late String? selectedWaiterName;
  late bool isProcessing = false;

  final themeColor = ColorStyle.brandColor;

  void loadWaiters() async {
    var waitersData = await Waiter.getAll();
    setState(() {
      this.waitersData = waitersData;
    });
  }

  @override
  initState() {
    super.initState();
    loadWaiters();
    setState(() {
      customerName = widget.openOrderCustomerName ?? "Cash";
      customerPhone = widget.openOrderCustomerPhone;
      customerAddress = widget.openOrderCustomerAddress;
      selectedWaiterId = widget.openOrderWaiterId;
      selectedWaiterName = widget.openOrderWaiterName;
      _controllerCustomerName.text = customerName;
      _controllerCustomerPhone.text = customerPhone ?? '';
      _controllerCustomerAddress.text = customerAddress ?? '';
    });
  }

  Widget buildWaiterSelectionViewBottomSheet() =>
      StatefulBuilder(builder: (context, state) {
        return ListView(shrinkWrap: true, children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Text(
              'Select Waiter',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: ColorStyle.text200),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              PosWaiterCard(
                id: null,
                name: 'None',
                image: null,
                active: selectedWaiterId == null,
                onTap: () {
                  selectedWaiterId = null;
                  selectedWaiterName = null;
                  state(() {});
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              for (var waiter in waitersData)
                PosWaiterCard(
                  id: waiter['id'],
                  name: waiter['name'],
                  image: waiter['image'],
                  active: selectedWaiterId == waiter['id'],
                  onTap: () {
                    selectedWaiterId = waiter['id'];
                    selectedWaiterName = waiter['name'];
                    state(() {});
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
        ]);
      });

  Widget buildCustomerDetailsFormBottomSheet() =>
      StatefulBuilder(builder: (context, state) {
        return ListView(shrinkWrap: true, children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Text(
              'Customer details',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: ColorStyle.text200),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer name',
                    style: TextStyle(
                      color: ColorStyle.text200,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  CustomTextFromField(
                    keyboardType: TextInputType.text,
                    controller: _controllerCustomerName,
                    themeColor: widget.orderType.color,
                    hint: '',
                    obscureText: false,
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone number',
                    style: TextStyle(
                      color: ColorStyle.text200,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  CustomTextFromField(
                    keyboardType: TextInputType.phone,
                    controller: _controllerCustomerPhone,
                    themeColor: widget.orderType.color,
                    hint: '',
                    obscureText: false,
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      color: ColorStyle.text200,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  CustomTextFromField(
                    keyboardType: TextInputType.multiline,
                    controller: _controllerCustomerAddress,
                    themeColor: widget.orderType.color,
                    hint: '',
                    obscureText: false,
                    minLines: 2,
                    maxLines: 4,
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                PrimaryButton(
                  color: widget.orderType.color!,
                  onPressed: () {
                    if (_controllerCustomerName.text.trim() == '') {
                      showSnackBar(context, '* Customer name invalid');
                      return;
                    }
                    customerName = _controllerCustomerName.text;
                    customerPhone = _controllerCustomerPhone.text != ''
                        ? _controllerCustomerPhone.text
                        : null;
                    customerAddress = _controllerCustomerAddress.text != ''
                        ? _controllerCustomerAddress.text
                        : null;
                    state(() {});
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ]);
      });

  @override
  Widget build(BuildContext context) {
    final double taxableTotal =
        Calculations.calculateTaxableTotal(cart: widget.cart);
    final double taxTotal = Calculations.calculateTaxTotal(cart: widget.cart);
    final double finalTotal =
        Calculations.calculateFinalTotal(cart: widget.cart);
    final int finalTotalAfterRoundOff =
        Calculations.calculateRoundOff(finalTotal: finalTotal);
    final double roundOff =
        double.parse((finalTotalAfterRoundOff - finalTotal).toStringAsFixed(2));

    Future<void> placeOrderAction() async {
      setState(() {
        isProcessing = true;
      });
      try {
        // bool flag = true;
        // TODO: Uncomment this code to enable license validation
        // LicenseData licData = License.validate(widget.account['purchaseCode']);
        // if(!licData.status){
        //   List<Map<String, dynamic>> ordersOfTheMonth = (await Order.getAll()).where((element){
        //     return DateTime.now().year == DateTime.fromMicrosecondsSinceEpoch(element['timestamp']).year && DateTime.now().month == DateTime.fromMicrosecondsSinceEpoch(element['timestamp']).month;
        //   }).toList();
        //   if(ordersOfTheMonth.length >= 100){
        //     flag = false;
        //   }
        // }
        // if (!flag) {
        //   Future.delayed(Duration.zero, () {
        //     showSnackBar(
        //         context, 'Please activate license to create more orders');
        //   });
        //   return;
        // }
        Map<String, dynamic> order = {
          'orderType': widget.orderType.name,
          'orderTypeText': widget.orderType.name,
          'customerName': customerName,
          'customerPhone': customerPhone,
          'customerAddress': customerAddress,
          'timestamp': DateTime.now().microsecondsSinceEpoch,
          'tableName': widget.diningTableName,
          'table': widget.diningTable,
          'cart': widget.cart,
          'waiter': selectedWaiterName,
          'taxableTotal': taxableTotal,
          'taxTotal': taxTotal,
          'roundOff': roundOff,
          'finalTotal': finalTotalAfterRoundOff,
          'open': OrderType.dine == widget.orderType ? true : false
        };

        String? id;
        if (widget.openOrderId != null) {
          order['id'] = widget.openOrderId;
          await Order.update(order);
        } else {
          id = await Order.add(order);
          order['id'] = id;
        }

        if (OrderType.dine == widget.orderType) {
          Map<String, dynamic>? diningTable =
              await DiningTable.get(widget.diningTable!);
          diningTable!['orderId'] = id;
          diningTable['due'] = finalTotalAfterRoundOff;
          await DiningTable.update(diningTable);
        }

        if (widget.account['autoPrintOnSale']) {
          PrintInvoice.printReceipt(order: order, account: widget.account)
              .then((message) {
            showSnackBar(context, message);
          }).onError((error, stackTrace) {
            showSnackBar(context, '$error ${stackTrace.toString()}');
          });
        }

        Cart.cart = {};
        await Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderConfirmation(order: order, account: widget.account)),
          ).then((_) {
            Navigator.pop(context, 'clear');
          });
        });
      } catch (_) {
        showSnackBar(context, 'Failed');
        return;
      }

      setState(() {
        isProcessing = false;
      });
    }

    final appBar = AppBar(
      backgroundColor: widget.orderType.color,
      title: const Text('Checkout'),
    );
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColorAlter,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              color: ColorStyle.backgroundColorAlter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Order type',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: ColorStyle.text200),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 6, 0),
                            child: Icon(
                              widget.orderType.icon,
                              color: widget.orderType.color,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 6, 0),
                            child: Text(
                              widget.orderType.name!,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: ColorStyle.text200,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, "changeOrderType");
                          },
                          child: Text(
                            'Change',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: widget.orderType.color,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              color: ColorStyle.backgroundColorAlter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer details',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: ColorStyle.text200),
                      ),
                      CustomButton(
                        text: 'Edit',
                        onTap: () => showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            context: context,
                            builder: (context) =>
                                buildCustomerDetailsFormBottomSheet()),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Icon(
                          Icons.person,
                          color: ColorStyle.text300,
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Name',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text300,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                customerName,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text200,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  customerPhone != null
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  customerPhone != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Icon(
                                Icons.call,
                                color: ColorStyle.text300,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 6, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: ColorStyle.text300,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      customerPhone!,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: ColorStyle.text200,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : Container(),
                  customerAddress != null
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  customerAddress != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Icon(
                                Icons.pin_drop,
                                color: ColorStyle.text300,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 6, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: ColorStyle.text300,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      customerAddress!,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: ColorStyle.text200,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.clip),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : Container(),
                  widget.diningTableName != null
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  widget.diningTableName != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Icon(
                                Icons.chair_sharp,
                                color: ColorStyle.text300,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 6, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Table No.',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: ColorStyle.text300,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      widget.diningTableName!,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: ColorStyle.text200,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              color: ColorStyle.backgroundColorAlter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order details',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: ColorStyle.text200),
                      ),
                      CustomButton(
                        text: 'Edit',
                        onTap: () {
                          Navigator.pop(context, "cartUpdate");
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  for (var id in widget.cart.keys)
                    CheckoutProductCard(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      id: id,
                      name: widget.cart[id]!['name'],
                      description: widget.cart[id]!['description'],
                      priceTotal: Calculations.calculatePriceWithoutTax(
                              taxType: widget.cart[id]!['taxType'],
                              price: widget.cart[id]!['price'],
                              tax: widget.cart[id]!['tax_slab']) *
                          widget.cart[id]!['quantity'],
                      image: widget.cart[id]!['image'],
                      cartQuantity: widget.cart[id]!['quantity'],
                      currencySymbol: widget.account['currencySymbol'],
                      mode: 1,
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            widget.orderType == OrderType.dine
                ? Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    margin: const EdgeInsets.only(bottom: 12.0),
                    color: ColorStyle.backgroundColorAlter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Waiter',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: ColorStyle.text200),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 6, 0),
                                  child: Icon(
                                    Icons.person,
                                    color: ColorStyle.text300,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 6, 0),
                                  child: Text(
                                    selectedWaiterName ?? 'Not assigned',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: ColorStyle.text300,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  6, 0, 0, 0),
                              child: TextButton(
                                onPressed: () => showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) =>
                                        buildWaiterSelectionViewBottomSheet()),
                                child: Text(
                                  'Change',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: widget.orderType.color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              color: ColorStyle.backgroundColorAlter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total summary',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: ColorStyle.text200),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 6, 0),
                        child: Text(
                          'Taxable',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.text300,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          '${widget.account['currencySymbol']}$taxableTotal',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.text200,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  taxTotal > 0
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  taxTotal > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "${widget.account['taxName'] != '' ? widget.account['taxName'] : 'Tax'}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: ColorStyle.text300,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Text(
                                '${widget.account['currencySymbol']}$taxTotal',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text200,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  roundOff != 0
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  roundOff != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 6, 0),
                                  child: Text(
                                    'Round off',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: ColorStyle.text300,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 6, 0),
                                  child: Text(
                                    '(+/-)',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: ColorStyle.text200,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Text(
                                roundOff < 0
                                    ? '- ${widget.account['currencySymbol']}${roundOff.abs()}'
                                    : '${widget.account['currencySymbol']}$roundOff',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text200,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          'Final total',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.text200,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          '${widget.account['currencySymbol']}$finalTotalAfterRoundOff',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.text200,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isProcessing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularProgressIndicator(
                      color: themeColor,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Flexible(
                      child: PrimaryButton(
                        color: widget.orderType.color ?? ColorStyle.primary,
                        onPressed: () async {
                          await placeOrderAction();
                        },
                        child: Text(
                            '${widget.openOrderId == null ? 'Place' : 'Update'} Order'),
                      ),
                    ),
                    if (widget.openOrderId != null) const SizedBox(width: 8.0),
                    if (widget.openOrderId != null)
                      Flexible(
                        child: PrimaryButton(
                          color: ColorStyle.success,
                          onPressed: () async {
                            await placeOrderAction();
                          },
                          child: const Text('Finish'),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
