import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_pos/style/color_style.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard(
      {Key? key,
      this.id,
      this.name,
      this.description,
      this.image,
      this.cartQuantity,
      this.onRemove,
      this.onAdd,
      this.onDeleteAll,
      this.price,
      this.customizationPrice,
      this.currencySymbol})
      : super(key: key);
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic image;
  final dynamic price;
  final dynamic customizationPrice;
  final dynamic cartQuantity;
  final dynamic currencySymbol;
  final Function()? onRemove;
  final Function()? onAdd;
  final Function()? onDeleteAll;

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
                    /*Text(
                  description ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.w400, color: ColorStyle.text400),
                ),*/
                    Text(
                      '$currencySymbol${price ?? ''} ${(' + ') + (currencySymbol ?? '') + (customizationPrice ?? '')}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: ColorStyle.text400),
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
                onAdd != null && onRemove != null && cartQuantity != null
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
                          child: cartQuantity != null
                              ? Row(
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
                                              '$cartQuantity',
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
                    : Container(),
                InkWell(
                  child: Icon(
                    Icons.delete_outline,
                    color: ColorStyle.error,
                  ),
                  onTap: () {},
                )
              ],
            )),
      ],
    );
  }
}
