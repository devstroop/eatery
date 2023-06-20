import 'package:eatery/constants/global_variables.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';

class DiningTableCard extends StatelessWidget {
  const DiningTableCard(
      {Key? key, required this.diningTable, this.onTap, this.order})
      : super(key: key);
  final DiningTable diningTable;
  final Order? order;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
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
        width: ((MediaQuery.of(context).size.width <
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.height) -
                48) /
            2,
        height: ((MediaQuery.of(context).size.width <
                        MediaQuery.of(context).size.height
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
                color: diningTable.isActive
                    ? ColorStyle.success.withOpacity(0.15)
                    : ColorStyle.error.withOpacity(0.15),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  color: diningTable.isActive
                      ? ColorStyle.success
                      : ColorStyle.error,
                )),
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
                          diningTable.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: ColorStyle.text200),
                        ),
                      ],
                    ),
                    order != null
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${GlobalVariables.currency?.symbol ?? ''}${order?.finalTotal} due',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: ColorStyle.error),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                if (diningTable.isActive)
                  Icon(
                    UIcons.regularStraight.check,
                    color: ColorStyle.success,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
