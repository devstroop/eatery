import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/components/low_qty_label_widget.dart';
import 'package:restaurant_pos/database/cart.dart';
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
      this.warningQuantity,
        this.currencySymbol,
        this.onRemove,
        this.onAdd,
        this.onTap})
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
  final dynamic currencySymbol;
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
                                    '${currencySymbol ?? ''}$salePrice',
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
                                          FutureBuilder(
                                            future: Cart.getAll(),
                                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                                                if(snapshot.connectionState == ConnectionState.done && snapshot.data.isNotEmpty){
                                                  return InkWell(
                                                    onTap: onRemove,
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: themeColor,
                                                    ),
                                                  );
                                                }else{
                                                  return Container();
                                                }
                                              }
                                          ),
                                          FutureBuilder(
                                              future: Cart.getAll(),
                                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                                                if(snapshot.connectionState == ConnectionState.done && snapshot.data.isNotEmpty){
                                                  return Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                                                    child: Text(
                                                      '${snapshot.data.length}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  );
                                                }else{
                                                  return Container();
                                                }
                                              }
                                          ),
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
              ],
            ),
          ),
          Positioned(
            top: 12.0,
            left: 0.0,
            child: quantity  != null && warningQuantity != null
                ? double.parse(quantity) <= double.parse(warningQuantity)
                    ? LowQtyLabelWidget(qty: double.parse(quantity))
                    : Container()
                : Container(),
          ),
        ],
      ),
    );
  }
}
