import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class DiningTableCard extends StatelessWidget {
  const DiningTableCard(
      {Key? key, required this.id, required this.name, this.currencySymbol, this.due, this.onTap, this.active})
      : super(key: key);
  final bool? active;
  final dynamic id; // int
  final dynamic name; // String
  final dynamic currencySymbol;
  final dynamic due;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final Color _localColor = id != null ? (due != null ? ColorStyle.error : ColorStyle.success) : ColorStyle.text200;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
      child: Container(
        margin: const EdgeInsets.fromLTRB(9, 0, 9, 0),
        decoration: BoxDecoration(
          /*boxShadow: const [
            BoxShadow(
              color: Color(0x2F000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: 1,
            )
          ],*/
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
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: _localColor.withOpacity(0.15),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                  color: _localColor,
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                              fontSize: 14.0, fontWeight: FontWeight.w600, color: ColorStyle.text200),
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
                          '${currencySymbol ?? ''}$due due',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w600, color: ColorStyle.error),
                        ),
                      ],
                    )
                        : Container()
                  ],
                ),
                if(active!)
                  Icon(Icons.check_circle, color: _localColor,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
