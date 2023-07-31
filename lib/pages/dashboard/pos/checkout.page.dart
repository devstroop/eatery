import 'package:eatery/references.dart';

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
  final List<Product> cart;
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

  void loadWaiters() async {
    // var waitersData = await Waiter.getAll();
    // setState(() {
    //   this.waitersData = waitersData;
    // });
  }

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
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
                    themeColor: Color(widget.orderType.color ?? 0),
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
                    themeColor: Color(widget.orderType.color ?? 0),
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
                    themeColor: Color(widget.orderType.color!),
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
                  color: Color(widget.orderType.color!),
                  onPressed: () {
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
    Color _pageColor = Color(widget.orderType.color!);
    // final double taxableTotal =
    //     Calculations.calculateTaxableTotal(cart: widget.cart);
    // final double taxTotal = Calculations.calculateTaxTotal(cart: widget.cart);
    // final double finalTotal =
    //     Calculations.calculateFinalTotal(cart: widget.cart);
    // final int finalTotalAfterRoundOff =
    //     Calculations.calculateRoundOff(finalTotal: finalTotal);
    // final double roundOff =
    //     double.parse((finalTotalAfterRoundOff - finalTotal).toStringAsFixed(2));

    Future<void> placeOrderAction() async {
      setState(() {
        isProcessing = true;
      });


      setState(() {
        isProcessing = false;
      });
    }

    final appBar = AppBar(
      backgroundColor: _pageColor,
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
                            child: widget.orderType == OrderType.dine
                                ? Icon(
                                    Icons.dinner_dining,
                                    color: ColorStyle.text300,
                                  )
                                : widget.orderType == OrderType.delivery ? Icon(
                                    Icons.bike_scooter,
                                    color: ColorStyle.text300,
                                  ) : Icon(
                                    Icons.takeout_dining,
                                    color: ColorStyle.text300,
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
                              color: _pageColor,
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
                  // for (var id in widget.cart.keys)
                  //   CheckoutProductCard(
                  //     padding: const EdgeInsets.only(bottom: 8.0),
                  //     id: id,
                  //     name: widget.cart[id]!['name'],
                  //     description: widget.cart[id]!['description'],
                  //     priceTotal: Calculations.calculatePriceWithoutTax(
                  //             taxType: widget.cart[id]!['taxType'],
                  //             price: widget.cart[id]!['price'],
                  //             tax: widget.cart[id]!['tax_slab']) *
                  //         widget.cart[id]!['quantity'],
                  //     image: widget.cart[id]!['image'],
                  //     cartQuantity: widget.cart[id]!['quantity'],
                  //     currencySymbol: widget.account['currencySymbol'],
                  //     mode: 1,
                  //   ),
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
                                    color: _pageColor,
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Padding(
                  //       padding:
                  //           const EdgeInsetsDirectional.fromSTEB(0, 12, 6, 0),
                  //       child: Text(
                  //         'Taxable',
                  //         textAlign: TextAlign.start,
                  //         style: TextStyle(
                  //           color: ColorStyle.text300,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding:
                  //           const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                  //       child: Text(
                  //         '${widget.account['currencySymbol']}$taxableTotal',
                  //         textAlign: TextAlign.start,
                  //         style: TextStyle(
                  //           color: ColorStyle.text200,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // taxTotal > 0
                  //     ? const SizedBox(
                  //         height: 8.0,
                  //       )
                  //     : Container(),
                  // taxTotal > 0
                  //     ? Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsetsDirectional.fromSTEB(
                  //                 0, 0, 6, 0),
                  //             child: Row(
                  //               children: [
                  //                 Text(
                  //                   "${widget.account['taxName'] != '' ? widget.account['taxName'] : 'Tax'}",
                  //                   textAlign: TextAlign.start,
                  //                   style: TextStyle(
                  //                     color: ColorStyle.text300,
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.w400,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsetsDirectional.fromSTEB(
                  //                 0, 0, 6, 0),
                  //             child: Text(
                  //               '${widget.account['currencySymbol']}$taxTotal',
                  //               textAlign: TextAlign.start,
                  //               style: TextStyle(
                  //                 color: ColorStyle.text200,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
                  // roundOff != 0
                  //     ? const SizedBox(
                  //         height: 8.0,
                  //       )
                  //     : Container(),
                  // roundOff != 0
                  //     ? Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsetsDirectional.fromSTEB(
                  //                     0, 0, 6, 0),
                  //                 child: Text(
                  //                   'Round off',
                  //                   textAlign: TextAlign.start,
                  //                   style: TextStyle(
                  //                     color: ColorStyle.text300,
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.w400,
                  //                   ),
                  //                 ),
                  //               ),
                  //               Padding(
                  //                 padding: const EdgeInsetsDirectional.fromSTEB(
                  //                     0, 0, 6, 0),
                  //                 child: Text(
                  //                   '(+/-)',
                  //                   textAlign: TextAlign.start,
                  //                   style: TextStyle(
                  //                     color: ColorStyle.text200,
                  //                     fontSize: 12,
                  //                     fontWeight: FontWeight.w400,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsetsDirectional.fromSTEB(
                  //                 0, 0, 6, 0),
                  //             child: Text(
                  //               roundOff < 0
                  //                   ? '- ${widget.account['currencySymbol']}${roundOff.abs()}'
                  //                   : '${widget.account['currencySymbol']}$roundOff',
                  //               textAlign: TextAlign.start,
                  //               style: TextStyle(
                  //                 color: ColorStyle.text200,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
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
                      // Padding(
                      //   padding:
                      //       const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                      //   child: Text(
                      //     '${widget.account['currencySymbol']}$finalTotalAfterRoundOff',
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //       color: ColorStyle.text200,
                      //       fontSize: 24,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
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
                      color: _pageColor,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Flexible(
                      child: PrimaryButton(
                        color: _pageColor,
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
