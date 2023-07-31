import 'package:eatery/references.dart';

class DetailedProductView extends StatefulWidget {
  const DetailedProductView(
      {Key? key,
      this.themeColor,
      this.onRemove,
      this.onAdd,
      required this.product})
      : super(key: key);
  final Product product;
  final Color? themeColor;
  final Function()? onRemove;
  final Function()? onAdd;

  @override
  State<DetailedProductView> createState() => _DetailedProductViewState();
}

class _DetailedProductViewState extends State<DetailedProductView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          height: MediaQuery.of(context).size.width * 4 / 7,
          decoration: BoxDecoration(
            color: ColorStyle.backgroundColorAlter,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            image: File(widget.product.image ?? '').existsSync()
                ? DecorationImage(
                    image: FileImage(File(widget.product.image!)),
                    fit: BoxFit.cover)
                : const DecorationImage(
                    image: AssetImage('assets/images/default.jpg'),
                    fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: FoodTypeBadge(
                    foodType: widget.product.foodType,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: ColorStyle.text200),
                  ),
                  Column(
                    children: [
                      Text(
                        '${Common.currency?.symbol ?? ''}${widget.product.salePrice}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: ColorStyle.text200),
                      ),
                    ],
                  ),
                ],
              ),
              widget.onAdd != null && widget.onRemove != null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: ColorStyle.primary,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(2, 1, 2, 1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Common.cart
                                    .where((element) =>
                                        element.id == widget.product.id)
                                    .isNotEmpty
                                ? InkWell(
                                    onTap: widget.onRemove,
                                    child: Icon(
                                      Icons.remove,
                                      color: ColorStyle.primary,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Common.cart
                                    .where((element) =>
                                        element.id == widget.product.id)
                                    .isNotEmpty
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 4, 0),
                                    child: Text(
                                      Common.cart
                                          .where((element) =>
                                              element.id == widget.product.id)
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            InkWell(
                              onTap: widget.onAdd,
                              child: Icon(
                                Icons.add,
                                color: ColorStyle.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Text(
            widget.product.description ?? '',
            overflow: TextOverflow.clip,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: ColorStyle.text400),
          ),
        ),
      ],
    );
  }
}
