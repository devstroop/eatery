import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/components/low_qty_label_widget.dart';
import 'package:restaurant_pos/extensions/calculations.dart';
import 'package:restaurant_pos/style/color_style.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
        required this.id,
      required this.name,
      this.description,
      this.price,
      this.quantity,
      this.image,
      this.foodType,
      this.themeColor,
      this.warningQuantity,
      this.currencySymbol,
      this.cartQuantity,
      this.onRemove,
      this.onAdd,
      this.onTap})
      : super(key: key);
  final String id; // int
  final String name; // String
  final String? description; // String?
  final double? price; // double
  final double? quantity; // double?
  final double? warningQuantity; // double?
  final double? cartQuantity;
  final String? image; // String?
  final String? foodType; // FoodType? // FoodType.values.firstWhere((e) => e.toString() == product['foodType']),
  final String? currencySymbol;
  final Color? themeColor;
  final Function()? onRemove;
  final Function()? onAdd;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(9, 0, 9, 0),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2F000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: 1,
                )
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            width: ((MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.height) -
                    48) /
                2,
            height: ((MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.height) -
                    48) /
                2 *
                (195 / 165),
            child: InkWell(
              onTap: onTap,
              child: Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ColorStyle.background200,
                              borderRadius:
                                  const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                              image: File(image ?? '').existsSync()
                                  ? DecorationImage(image: FileImage(File(image!)), fit: BoxFit.cover)
                                  : const DecorationImage(
                                      image: AssetImage('assets/images/no-image.jpg'), fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 12.0,
                            right: 12.0,
                            child: FoodTypeBadge(
                              foodType: foodType,
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ColorStyle.background100,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                                    ),
                                    Text(
                                      description ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14.0, fontWeight: FontWeight.w400, color: ColorStyle.text400),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '${currencySymbol ?? ''}$price',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: ColorStyle.information
                                          ),
                                        ) ,
                                      ],
                                    ),
                                    onAdd != null && onRemove != null && cartQuantity != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(
                                                color: ColorStyle.primary/*themeColor!*/,
                                                width: 2,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(2, 1, 2, 1),
                                              child: cartQuantity != null
                                                  ? Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        cartQuantity! > 0
                                                            ? InkWell(
                                                                onTap: onRemove,
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: ColorStyle.primary,
                                                                ),
                                                              )
                                                            : Container(),
                                                        cartQuantity! > 0
                                                            ? Padding(
                                                                padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                                                                child: Text(
                                                                  Calculations.compressDoubleToString(cartQuantity),
                                                                  style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        InkWell(
                                                          onTap: onAdd,
                                                          child: Icon(
                                                            Icons.add,
                                                            color: ColorStyle.primary,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ),
                                          )
                                        : Container()
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            top: 12.0,
            left: 0.0,
            child: quantity != null && warningQuantity != null
                ? quantity! <= warningQuantity!
                    ? LowQtyLabelWidget(qty: quantity!)
                    : Container()
                : Container(),
          ),
        ],
      ),
    );
  }
}
