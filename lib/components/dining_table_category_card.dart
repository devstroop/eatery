import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class DiningTableCategoryCard extends StatelessWidget {
  const DiningTableCategoryCard(
      {Key? key, required this.id, required this.name, this.onTap})
      : super(key: key);
  final dynamic id; // int
  final dynamic name; // String
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
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorStyle.backgroundColorAlter,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
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
                                  fontSize: 16.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
