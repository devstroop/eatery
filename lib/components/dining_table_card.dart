import 'package:eatery/references.dart';

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
                    ? KColors.green.withOpacity(0.15)
                    : KColors.red.withOpacity(0.15),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  color: diningTable.isActive
                      ? KColors.green                     : KColors.red,
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
                              color: KColors.text200),
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
                                '${Common.currency?.symbol ?? ''}${order?.finalTotal} due',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: KColors.red),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
                if (diningTable.isActive)
                  Icon(
                    Icons.check,
                    color: KColors.green              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
