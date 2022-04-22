import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/components/low_qty_label_widget.dart';
import 'package:restaurant_pos/database/linker.dart';
import 'package:restaurant_pos/style/color_style.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.name,
      this.description,
      required this.mrp,
      required this.salePrice,
      this.quantity,
      this.image,
      this.foodType,
      this.themeColor,
      required this.id,
      this.warningQuantity, this.onRemove, this.onAdd, this.onTap})
      : super(key: key);
  final dynamic id; // int
  final dynamic name; // String
  final dynamic description; // String?
  final dynamic mrp; // double
  final dynamic salePrice; // double?
  final dynamic quantity; // double?
  final dynamic warningQuantity; // double?
  final dynamic image; // String?
  final dynamic foodType; // FoodType? // FoodType.values.firstWhere((e) => e.toString() == product['foodType']),
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
                (230 / 181),
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
                                  Text(
                                    '${Linker.getCurrencySymbol()}${salePrice}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                                  ),
                                  onAdd != null && onRemove != null ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: themeColor!,
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(2, 1, 2, 1),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Linker.cart.where((product) => product['id'] == id).isNotEmpty
                                              ? InkWell(
                                                  onTap: onRemove,
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: themeColor,
                                                  ),
                                                )
                                              : Container(),
                                          Linker.cart.where((product) => product['id'] == id).isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                                                  child: Text(
                                                    '${Linker.cart.where((product) => product['id'] == id).length}',
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
                                              color: themeColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ) : Container()
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                /*Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(9, 0, 9, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color(0xFF727272),
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorStyle.background200,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorStyle.background100,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          description ?? '',
                                          style: TextStyle(
                                            color: ColorStyle.text200,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$price',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: themeColor!,
                                              width: 2,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                6, 4, 6, 4),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.minus,
                                                  color: themeColor,
                                                  size: 12,
                                                ),
                                                const Padding(
                                                  padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      6, 0, 6, 0),
                                                  child: Text(
                                                    '1',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                FaIcon(
                                                  FontAwesomeIcons.plus,
                                                  color: themeColor,
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: LowQtyLabelWidget(
                      qty: 0,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.74, -0.87),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: FoodTypeBadge(foodType: foodType,),
                    ),
                  ),*/
              ],
            ),
          ),
          Positioned(
            top: 12.0,
            left: 0.0,
            child: quantity  != null && warningQuantity != null
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
