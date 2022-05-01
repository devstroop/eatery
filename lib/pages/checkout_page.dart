import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/bottom_view_grip.dart';
import 'package:restaurant_pos/components/cart_product_card.dart';
import 'package:restaurant_pos/components/checkout_product_card.dart';
import 'package:restaurant_pos/components/custom_button.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/upload_button.dart';
import 'package:restaurant_pos/database/cart.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/extensions/calculations.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key, required this.orderType, required this.cart, this.diningTable, this.diningTableName, this.account})
      : super(key: key);
  final OrderType orderType;
  final Map<String, Map<String, dynamic>> cart;
  final String? diningTable;
  final String? diningTableName;
  final dynamic account;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {



  Widget buildWaiterSelectionViewBottomSheet() => StatefulBuilder(builder: (context, state) {
    return ListView(shrinkWrap: true, children: [
      const Center(
        child: BottomViewGrip(),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Text(
          'Select Waiter',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
    ]);
  });

  Widget buildCustomerDetailsFormBottomSheet() => StatefulBuilder(builder: (context, state) {
    return ListView(shrinkWrap: true, children: [
      const Center(
        child: BottomViewGrip(),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Text(
          'Customer details',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
    ]);
  });
  @override
  Widget build(BuildContext context) {
    final double total = Calculations.calculateTotal(cart: widget.cart);
    final double discountTotal = Calculations.calculateDiscountTotal(cart: widget.cart);
    final double additionalDiscountTotal = Calculations.calculateAdditionalDiscountTotal(cart: widget.cart);
    final double taxableTotal = Calculations.calculateTaxableTotal(cart: widget.cart);
    final double taxTotal = Calculations.calculateTaxTotal(cart: widget.cart);
    final double finalTotal = Calculations.calculateFinalTotal(cart: widget.cart);
    final String? taxSlabs = Calculations.getAllTaxSlabsApplied(cart: widget.cart);
    final int finalTotalAfterRoundOff = Calculations.calculateRoundOff(finalTotal: finalTotal);
    final double roundOff = double.parse((finalTotalAfterRoundOff - finalTotal).toStringAsFixed(2));

    final appBar = AppBar(
      backgroundColor: widget.orderType.color,
      title: const Text('Checkout'),
    );
    return Scaffold(
      backgroundColor: ColorStyle.background200,
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
              color: ColorStyle.background100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Order type',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                  ),
                  const SizedBox(height: 8.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                            child: Icon(widget.orderType.icon, color: widget.orderType.color,),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                            child: Text(
                              widget.orderType.text!,
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
                        padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                        child: TextButton(
                          onPressed: (){
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
              color: ColorStyle.background100,
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
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                      ),
                      CustomButton(
                        text: 'Edit',
                        onTap: ()=> showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            context: context,
                            builder: (context) => buildCustomerDetailsFormBottomSheet()),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Icon(Icons.person, color: ColorStyle.text300,),
                      ),
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                                'Cash',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text200,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Icon(Icons.call, color: ColorStyle.text300,),
                      ),
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                                'Not available',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text200,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0,),
                  widget.diningTableName != null ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Icon(Icons.chair_sharp, color: ColorStyle.text300,),
                      ),
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ) : Container(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              color: ColorStyle.background100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order details',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                      ),
                      CustomButton(
                        text: 'Edit',
                        onTap: (){
                          Navigator.pop(context, "cartUpdate");
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0,),
                  for (var id in widget.cart.keys)
                    CheckoutProductCard(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      id: id,
                      name: widget.cart[id]!['name'],
                      description: widget.cart[id]!['description'],
                      priceTotal: widget.cart[id]!['billingPrice'] * widget.cart[id]!['quantity'],
                      customizationPriceTotal:
                      Calculations.calculateCustomizationsTotal(widget.cart[id]!['customizations']) ?? 0,
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

            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              color: ColorStyle.background100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Waiter assigned',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                  ),
                  const SizedBox(height: 8.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                            child: Icon(Icons.person, color: ColorStyle.text300,),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                            child: Text(
                              'Not available',
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
                        padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
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
                              builder: (context) => buildWaiterSelectionViewBottomSheet()),
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
              color: ColorStyle.background100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total summary',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                  ),
                  const SizedBox(height: 8.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          'Total',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.text300,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          '${widget.account['currencySymbol']}$total',
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
                  discountTotal > 0 ? const SizedBox(height: 8.0,) : Container(),
                  discountTotal > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          'Discount',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.information,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          '- ${widget.account['currencySymbol']}$discountTotal',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.information,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                  additionalDiscountTotal > 0 ? const SizedBox(height: 8.0,) : Container(),
                  additionalDiscountTotal > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          'Additional discount',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.information,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          '- ${widget.account['currencySymbol']}$additionalDiscountTotal',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.information,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                  const SizedBox(height: 8.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                  taxTotal > 0 ? const SizedBox(height: 8.0,) : Container(),
                  taxTotal > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Row(
                          children: [
                            Text(
                              "GST",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: ColorStyle.text300,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              taxSlabs != null ? '($taxSlabs)' : "",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: ColorStyle.text200,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.clip
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                  ) : Container(),
                  roundOff != 0 ? const SizedBox(height: 8.0,) : Container(),
                  roundOff != 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                        child: Text(
                          roundOff < 0 ? '- ${widget.account['currencySymbol']}${roundOff.abs()}' : '${widget.account['currencySymbol']}$roundOff',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorStyle.text200,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                  const SizedBox(height: 12.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
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
        color: ColorStyle.background100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            text: 'Place Order',
            backgroundColor: widget.orderType.color ?? ColorStyle.primary,
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
