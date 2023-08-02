import 'package:eatery/references.dart';

class ViewOrderPage extends StatefulWidget {
  const ViewOrderPage(
      {Key? key,
      required this.account,
      required this.order,
      required this.orderType})
      : super(key: key);
  final Map<String, dynamic> order;
  final dynamic account;
  final OrderType? orderType;

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageColor = Color(widget.orderType!.color!);
    final appBar = AppBar(
      backgroundColor: pageColor,
      title: const Text('Order Details'),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogBox(
                    title: 'Delete',
                    message: 'Are you sure?',
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () async {
                            // if ((await Order.delete(widget.order['id']))) {
                            //   showSnackBar(context, 'Deleted successfully');
                            // } else {
                            //   showSnackBar(context, 'Failed to delete');
                            // }
                            // Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                          child: const Text('OK'))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete))
      ],
    );
    return Scaffold(
      backgroundColor: KColors.white,
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
              color: KColors.white,
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
                        color: KColors.black600),
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
                              widget.orderType == OrderType.dine
                                  ? Icons.dinner_dining
                                  : widget.orderType == OrderType.delivery ? Icons.delivery_dining : Icons.takeout_dining,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 6, 0),
                            child: Text(
                              widget.orderType!.name!,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: KColors.black600,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              color: KColors.white,
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
                            color: KColors.black600),
                      ),
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
                          color: KColors.black500,
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
                                  color: KColors.black500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                widget.order['customerName'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: KColors.black600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  widget.order['customerPhone'] != null
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  widget.order['customerPhone'] != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Icon(
                                Icons.call,
                                color: KColors.black500,
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
                                        color: KColors.black500,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '${widget.order['customerPhone']!}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: KColors.black600,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : Container(),
                  widget.order['customerAddress'] != null
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  widget.order['customerAddress'] != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Icon(
                                Icons.pin_drop,
                                color: KColors.black500,
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
                                        color: KColors.black500,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      widget.order['customerAddress']!,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: KColors.black600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.clip),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      : Container(),
                  widget.order['tableName'] != null
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  widget.order['tableName'] != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Icon(
                                Icons.chair_sharp,
                                color: KColors.black500,
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
                                        color: KColors.black500,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      widget.order['tableName']!,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: KColors.black600,
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
              color: KColors.white,
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
                            color: KColors.black600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  for (var id in widget.order['cart'].keys)
                    CheckoutProductCard(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      id: id,
                      name: widget.order['cart'][id]['name'],
                      description: widget.order['cart'][id]['description'],
                      priceTotal: widget.order['cart'][id]['price'] *
                          widget.order['cart'][id]['quantity'],
                      image: widget.order['cart'][id]['image'],
                      cartQuantity: widget.order['cart'][id]['quantity'],
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
                    color: KColors.white,
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
                              color: KColors.black600),
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
                                    color: KColors.black500,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 6, 0),
                                  child: Text(
                                    widget.order['waiter'] ?? 'Not assigned',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: KColors.black500,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
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
              color: KColors.white,
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
                        color: KColors.black600),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          'Taxable',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: KColors.black500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          '${widget.account['currencySymbol']}${widget.order['taxableTotal']}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: KColors.black600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.order['taxTotal'] > 0
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  widget.order['taxTotal'] > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Row(
                                children: [
                                  Text(
                                    widget.account['taxName'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: KColors.black500,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    widget.order['taxSlabs'] != null
                                        ? '(${widget.order['taxSlabs']})'
                                        : "",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: KColors.black600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.clip),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Text(
                                '${widget.account['currencySymbol']}${widget.order['taxTotal']}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: KColors.black600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  widget.order['roundOff'] != 0
                      ? const SizedBox(
                          height: 8.0,
                        )
                      : Container(),
                  widget.order['roundOff'] != 0
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
                                      color: KColors.black500,
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
                                      color: KColors.black600,
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
                                widget.order['roundOff'] < 0
                                    ? '- ${widget.account['currencySymbol']}${widget.order['roundOff'].abs()}'
                                    : '${widget.account['currencySymbol']}${widget.order['roundOff']}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: KColors.black600,
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
                            color: KColors.black600,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          '${widget.account['currencySymbol']}${(widget.order['finalTotal'])}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: KColors.black600,
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
        color: KColors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            color: pageColor,
            onPressed: () async {
              try {
                await PrintInvoice.printReceipt(
                    order: widget.order, account: widget.account);
              } catch (_) {
                showMessageDialog(context, 'Unable to print receipt', MessageType.error);
              }
            },
            child: const Text('Print copy'),
          ),
        ),
      ),
    );
  }
}
