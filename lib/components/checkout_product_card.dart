import 'package:eatery/references.dart';

class CheckoutProductCard extends StatelessWidget {
  const CheckoutProductCard(
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
      this.currencySymbol,
      required this.mode,
      this.padding})
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
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 7,
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: KColors.backgroundColorAlter,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        image: File(image ?? '').existsSync()
                            ? DecorationImage(
                                image: FileImage(File(image!)),
                                fit: BoxFit.cover)
                            : const DecorationImage(
                                image: AssetImage('assets/images/default.jpg'),
                                fit: BoxFit.cover),
                      ),
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
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: KColors.text200),
                        ),
                      ),
                      description != null
                          ? Flexible(
                              child: Text(
                                description!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: KColors.text400),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              )),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Text(
                  'x ${Calculations.compressDoubleToString(cartQuantity)} ',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: KColors.text200),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Text(
                  '${currencySymbol ?? ''}$priceTotal',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: KColors.text200),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
