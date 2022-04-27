import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/food_type_badge.dart';
import 'package:restaurant_pos/database/cart.dart';
import 'package:restaurant_pos/style/color_style.dart';

class DetailedProductView extends StatefulWidget {
  const DetailedProductView({Key? key,
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
    this.onAdd})
      : super(key: key);
  final dynamic id; // int
  final dynamic name; // String
  final dynamic description; // String?
  final dynamic mrp; // double
  final dynamic salePrice; // double?
  final dynamic quantity; // double?
  final dynamic warningQuantity;
  final dynamic image; // String?
  final dynamic foodType; // FoodType? // FoodType.values.firstWhere((e) => e.toString() == product['foodType']),
  final dynamic currencySymbol;
  final Color? themeColor;
  final Function()? onRemove;
  final Function()? onAdd;

  @override
  State<DetailedProductView> createState() => _DetailedProductViewState();
}

class _DetailedProductViewState extends State<DetailedProductView> {

  @override
  Widget build(BuildContext context) {
    final cartQuantity = Cart.cart.where((element) => element['id'] == widget.id).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          height: MediaQuery.of(context).size.width * 4/7,
          decoration: BoxDecoration(
            color: ColorStyle.background200,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            image: File(widget.image ?? '').existsSync()
                ? DecorationImage(image: FileImage(File(widget.image!)), fit: BoxFit.cover)
                : const DecorationImage(image: AssetImage('assets/images/no-image.jpg'), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: FoodTypeBadge(foodType: widget.foodType,)
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                  ),
                  widget.mrp != null && widget.mrp != '' && widget.salePrice != null && widget.salePrice != ''
                      ? Row(
                    children: [
                      double.parse(widget.mrp) > double.parse(widget.salePrice)
                          ? Container(
                        margin: const EdgeInsets.only(right: 6.0),
                            child: Text(
                        '${widget.currencySymbol ?? ''}${widget.mrp}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: ColorStyle.text400,
                              decorationColor: ColorStyle.text300,
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationThickness: 3.0),
                      ),
                          )
                          : Container(),
                      double.parse(widget.mrp) > double.parse(widget.salePrice)
                          ? Text(
                        '${widget.currencySymbol ?? ''}${widget.salePrice}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: ColorStyle.information),
                      )
                          : Container(),
                    ],
                  )
                      : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  (widget.mrp == null || widget.mrp == '') && widget.salePrice != null && widget.salePrice != ''
                      ? Column(
                    children: [
                      Text(
                        '${widget.currencySymbol ?? ''}${widget.salePrice}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: ColorStyle.text200),
                      ),
                    ],
                  )
                      : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  (widget.salePrice == null || widget.salePrice == '') && widget.mrp != null && widget.mrp != ''
                      ? Column(
                    children: [
                      Text(
                        '${widget.currencySymbol ?? ''}${widget.mrp}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: ColorStyle.text200),
                      ),
                    ],
                  )
                      : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ],
              ),
              widget.onAdd != null && widget.onRemove != null && cartQuantity != null
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: widget.themeColor!,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(2, 1, 2, 1),
                  child: cartQuantity != null
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cartQuantity > 0
                          ? InkWell(
                        onTap: widget.onRemove,
                        child: Icon(
                          Icons.remove,
                          color: widget.themeColor,
                        ),
                      )
                          : Container(),
                      cartQuantity > 0
                          ? Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                        child: Text(
                          '$cartQuantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                          : Container(),
                      InkWell(
                        onTap: widget.onAdd,
                        child: Icon(
                          Icons.add,
                          color: widget.themeColor,
                        ),
                      ),
                    ],
                  )
                      : Container(),
                ),
              )
                  : Container()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Text(
            widget.description ?? '',
            overflow: TextOverflow.clip,
            style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.w400, color: ColorStyle.text400),
          ),
        ),
      ],
    );
  }
}
