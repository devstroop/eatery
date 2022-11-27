import 'dart:io';
import 'package:eatery/constants/utils/calculations.dart';
import 'package:eatery_db/models/product/product.dart';
import 'package:eatery_services/eatery_services.dart';
import 'package:flutter/material.dart';
import 'package:eatery_components/badges/food_type.badge.dart';
import 'package:eatery/constants/style/color_style.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      this.cartQuantity,
      this.themeColor,
      this.currencySymbol,
      this.onRemove,
      this.onAdd,
      this.onTap,
      required this.product})
      : super(key: key);
  final Product product;

  final double? cartQuantity;
  final String? currencySymbol;
  final Color? themeColor;
  final Function()? onRemove;
  final Function()? onAdd;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double base = MediaQuery.of(context).size.height - 48;
    double width = base < 360
        ? base / 1
        : base < 600
            ? base / 2
            : base < 1200
                ? base / 4
                : base / 6;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
      child: Stack(
        children: [
          Container(
            foregroundDecoration: !product.isActive
                ? const BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  )
                : null,
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
            width: width,
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: width * 2 / 3,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        FutureBuilder<String>(
                            future: FileServices.absImage(product.image ?? ''),
                            builder: (context, snapshot) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: ColorStyle.backgroundColorAlter,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      topRight: Radius.circular(6)),
                                  image: snapshot.hasData &&
                                          File(snapshot.data ?? '').existsSync()
                                      ? DecorationImage(
                                          image:
                                              FileImage(File(snapshot.data!)),
                                          fit: BoxFit.cover)
                                      : const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/default.jpg'),
                                          fit: BoxFit.cover),
                                ),
                              );
                            }),
                        Positioned(
                          top: 12.0,
                          right: 12.0,
                          child: FoodTypeBadge(
                            foodType: product.foodType,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: ColorStyle.text200),
                                ),
                                Text(
                                  product.description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: ColorStyle.text400),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (product.salePrice != null)
                                      Text(
                                        '${currencySymbol ?? ''}${product.mrpPrice}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: ColorStyle.text200,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    if (product.salePrice != null)
                                      Text(
                                        '${currencySymbol ?? ''}${product.salePrice}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: ColorStyle.success),
                                      ),

                                    if(product.salePrice == null)Text(
                                      '${currencySymbol ?? ''}${product.mrpPrice}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: ColorStyle.success),
                                    ),
                                  ],
                                ),
                                onAdd != null &&
                                        onRemove != null &&
                                        cartQuantity != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: ColorStyle
                                                .primary /*themeColor!*/,
                                            width: 2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(2, 1, 2, 1),
                                          child: cartQuantity != null
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    cartQuantity! > 0
                                                        ? InkWell(
                                                            onTap: onRemove,
                                                            child: Icon(
                                                              Icons.remove,
                                                              color: ColorStyle
                                                                  .primary,
                                                            ),
                                                          )
                                                        : Container(),
                                                    cartQuantity! > 0
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    4, 0, 4, 0),
                                                            child: Text(
                                                              Calculations
                                                                  .compressDoubleToString(
                                                                      cartQuantity),
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    InkWell(
                                                      onTap: onAdd,
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            ColorStyle.primary,
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
                        decoration: BoxDecoration(
                          color: ColorStyle.backgroundColorAlter,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          /*Positioned(
            top: 12.0,
            left: 0.0,
            child: quantity != null && warningQuantity != null
                ? quantity! <= warningQuantity!
                    ? LowQtyLabelWidget(qty: quantity!)
                    : Container()
                : Container(),
          ),*/
        ],
      ),
    );
  }
}
