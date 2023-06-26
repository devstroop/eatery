import 'package:eatery/constants/utils/calculations.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../constants/global_variables.dart';
import '../services/utility/library_image.dart';
import '../widgets/badges/foodType.badge.dart';
import 'low_qty_label_widget.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      this.qtyInCart,
      required this.themeColor,
      this.onRemove,
      this.onAdd,
      this.onTap,
      required this.product, required this.width, required this.height})
      : super(key: key);
  final Product product;

  final double? qtyInCart;
  final Color themeColor;
  final Function()? onRemove;
  final Function()? onAdd;
  final Function()? onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
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
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: onTap,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorStyle.backgroundColorAlter,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6)),
                              image: DecorationImage(
                                      image: LibraryImage(product.image ?? '').image,
                                fit: product.type==ProductType.inventoryItem ? BoxFit.contain : BoxFit.cover,),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.0,
                          right: 12.0,
                          child: FoodTypeBadge(
                            foodType: product.foodType,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                      ),
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
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: ColorStyle.text200),
                              ),
                              Text(
                                product.description ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10.0,
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
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.salePrice != null && product.salePrice != product.mrpPrice)
                                    Text(
                                      '${GlobalVariables.currency?.symbol ?? ''}${product.mrpPrice}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                          color: ColorStyle.text200,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  if (product.salePrice != null)
                                    Text(
                                      '${GlobalVariables.currency?.symbol ?? ''}${product.salePrice}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorStyle.success),
                                    ),
                                  if (product.salePrice == null)
                                    Text(
                                      '${GlobalVariables.currency?.symbol ?? ''}${product.mrpPrice}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorStyle.success),
                                    ),
                                ],
                              ),
                              onAdd != null &&
                                      onRemove != null &&
                                      qtyInCart != null
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
                                        child: qtyInCart != null
                                            ? Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  qtyInCart! > 0
                                                      ? InkWell(
                                                          onTap: onRemove,
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: ColorStyle
                                                                .primary,
                                                          ),
                                                        )
                                                      : Container(),
                                                  qtyInCart! > 0
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  4, 0, 4, 0),
                                                          child: Text(
                                                            Calculations
                                                                .compressDoubleToString(
                                                                    qtyInCart),
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
                    )
                  ],
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 12.0,
          //   left: 0.0,
          //   child: LowQtyLabelWidget(qty: 5),
          // ),
        ],
      ),
    );
  }
}
