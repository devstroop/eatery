import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.themeColor,
      this.onRemove,
      this.onAdd,
      this.onTap,
      required this.product,
      required this.width,
      required this.height,
      this.currencySymbol = '',
      this.cartQuantity = 0})
      : super(key: key);
  final Product product;
  final int cartQuantity;

  final Color themeColor;
  final Function()? onRemove;
  final Function()? onAdd;
  final Function()? onTap;
  final double width;
  final double height;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
      child: Stack(
        children: [
          Container(
            foregroundDecoration: !product.isActive
                ? const BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  )
                : null,
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
            width: width,
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: onTap,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6)),
                              image: DecorationImage(
                                image: LibraryImage(product.image ?? '', defaultImage: 'assets/images/no-picture.png').image,
                                fit: product.type == ProductType.inventoryItem
                                    ? BoxFit.contain
                                    : BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.0,
                          right: 12.0,
                          child: FoodTypeBadge(
                            foodType: product.foodType,
                            backgroundColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black600),
                              ),
                              Text(
                                product.description ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white600),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.salePrice != null &&
                                      product.salePrice != product.mrpPrice)
                                    Text(
                                      '$currencySymbol${product.mrpPrice}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black600,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  if (product.salePrice != null)
                                    Text(
                                      '$currencySymbol${product.salePrice}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: KColors.green),
                                    ),
                                  if (product.salePrice == null)
                                    Text(
                                      '$currencySymbol${product.mrpPrice}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: KColors.green),
                                    ),
                                ],
                              ),
                              onAdd != null && onRemove != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: themeColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(1, 0.5, 1, 0.5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            cartQuantity > 0
                                                ? InkWell(
                                                    onTap: onRemove,
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: themeColor,
                                                      size: 18,
                                                    ),
                                                  )
                                                : Container(),
                                            cartQuantity > 0
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            4, 0, 4, 0),
                                                    child: Text(
                                                      cartQuantity.toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            InkWell(
                                              onTap: onAdd,
                                              child: Icon(
                                                Icons.add,
                                                color: themeColor,
                                                size: 18,

                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 12.0,
          //   left: 0.0,
          //   child: LowQtyLabelWidget(qty: 5),
          // ),
        ],
      ),
    );
  }
}
