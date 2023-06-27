import 'package:eatery/references.dart';

class DiningTableSelectionCard extends StatelessWidget {
  const DiningTableSelectionCard(
      {super.key, required this.diningTable, this.order, this.selected = false, this.onTap});

  final DiningTable diningTable;
  final Order? order;
  final bool selected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    bool active = diningTable.isActive;
    bool available = active && order != null ? order!.id == diningTable.orderId : true;
    Color color = active && available
        ? ColorStyle.success : active && !available ? ColorStyle.error : ColorStyle.text300;
    return Material(
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(selected ? 0.24 : 0.12),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              width: selected ? 2.0 : 1.0,
              color: color,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      available && active ? 'Available' : active ? 'Not Available' : 'Inactive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      diningTable.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if(diningTable.description != null)
                      Text(
                        diningTable.description!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              if(selected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(
                    UIcons.regularStraight.check,
                    color: color,
                    size: 18.0,
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
