import 'package:eatery/references.dart';

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
      this.currencySymbol,
      required this.mode})
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
                    color: KColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    image: File(image ?? '').existsSync()
                        ? DecorationImage(
                            image: FileImage(File(image!)), fit: BoxFit.cover)
                        : const DecorationImage(
                            image: AssetImage('assets/images/default.jpg'),
                            fit: BoxFit.cover),
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
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: KColors.black600),
                    ),
                    Row(
                      children: [
                        Text(
                          '${currencySymbol ?? ''}$priceTotal',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: KColors.white600),
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
                            color: KColors.primary /*themeColor!*/,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(2, 1, 2, 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              cartQuantity > 0
                                  ? InkWell(
                                      onTap: onRemove,
                                      child: Icon(
                                        Icons.remove,
                                        color: KColors.primary,
                                      ),
                                    )
                                  : Container(),
                              cartQuantity > 0
                                  ? Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 0, 4, 0),
                                      child: Text(
                                        Calculations.compressDoubleToString(
                                            cartQuantity),
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
                                  color: KColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                onDeleteAll != null
                    ? InkWell(
                        onTap: onDeleteAll,
                        child: Icon(
                          Icons.delete_outline,
                          color: KColors.red,
                        ),
                      )
                    : Container()
              ],
            )),
      ],
    );
  }
}
