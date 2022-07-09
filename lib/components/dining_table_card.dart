import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eatery/style/color_style.dart';

class DiningTableCard extends StatelessWidget {
  const DiningTableCard(
      {Key? key, required this.id, required this.name, this.image, this.currencySymbol, this.due, this.onTap, this.active})
      : super(key: key);
  final bool? active;
  final dynamic id; // int
  final dynamic name; // String
  final dynamic image; // String?
  final dynamic currencySymbol;
  final dynamic due;
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
                (1 / 3),
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: active != null && active! ? ColorStyle.text200 : ColorStyle.background200,
                              borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                              image: File(image ?? '').existsSync()
                                  ? DecorationImage(image: FileImage(File(image!)), fit: BoxFit.cover)
                                  : const DecorationImage(
                                  image: AssetImage('assets/images/no-image.jpg'), fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 3,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: active != null && active! ? ColorStyle.text200 : ColorStyle.background200,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                          fontSize: 16.0, fontWeight: FontWeight.w600, color: active != null && active! ? ColorStyle.background200 : ColorStyle.text200),
                                    ),
                                  ],
                                ),
                                due != null
                                    ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$currencySymbol$due',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                                    ),
                                  ],
                                )
                                    : Container()
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
