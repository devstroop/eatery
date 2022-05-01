import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/cart_product_card.dart';
import 'package:restaurant_pos/components/checkout_product_card.dart';
import 'package:restaurant_pos/components/custom_button.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/upload_button.dart';
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
  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 8.0,),
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
                          onPressed: (){

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
                        onTap: (){

                        },
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
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                'Cash',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text300,
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
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                'NA',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text300,
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
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                widget.diningTableName!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorStyle.text300,
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
              child: ListView(
                shrinkWrap: true,
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
                      priceTotal: widget.cart[id]!['price'] * widget.cart[id]!['quantity'],
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
            )
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
