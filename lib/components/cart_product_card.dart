import 'dart:io';
import 'package:flutter/material.dart';
import 'package:eatery/extensions/calculations.dart';
import 'package:eatery/style/color_style.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard(
      {Key? key,
      required this.id,
      required this.name,
      this.description,
      this.image,
      required this.cartQuantity,
      this.onRemove,
      this.onAdd,
      this.onDeleteAll,
      required this.priceTotal,
      this.currencySymbol, required this.mode})
      : super(key: key);
  final String id;
  final String name;
  final String? description;
  final String? image;
  final double priceTotal;
  final double cartQuantity;
  final String? currencySymbol;
  final Function()? onRemove;
  final Function()? onAdd;
  final Function()? onDeleteAll;
  final int mode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 6,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorStyle.background200,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    image: File(image ?? '').existsSync()
                        ? DecorationImage(image: FileImage(File(image!)), fit: BoxFit.cover)
                        : const DecorationImage(image: AssetImage('assets/images/no-image.jpg'), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                    ),
                    Row(
                      children: [
                        Text(
                          (currencySymbol ?? '') + '$priceTotal',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: ColorStyle.text400),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )),
        Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                onAdd != null && onRemove != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: ColorStyle.primary /*themeColor!*/,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(2, 1, 2, 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              cartQuantity > 0
                                  ? InkWell(
                                onTap: onRemove,
                                child: Icon(
                                  Icons.remove,
                                  color: ColorStyle.primary,
                                ),
                              )
                                  : Container(),
                              cartQuantity > 0
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
                          ),
                        ),
                      )
                    : Container(),
                onDeleteAll != null ? InkWell(
                  child: Icon(
                    Icons.delete_outline,
                    color: ColorStyle.error,
                  ),
                  onTap: onDeleteAll,
                ) : Container()
              ],
            )),
      ],
    );
  }
}
