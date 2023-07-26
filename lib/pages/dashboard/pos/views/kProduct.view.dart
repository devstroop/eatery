import 'package:eatery/references.dart';

class KProductView extends StatelessWidget {
  const KProductView(
      {super.key, required this.product, this.onEdit, this.onDelete, this.onAddToCart});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToCart;

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppBar(
        title: Text(product.name),
        backgroundColor: Colors.transparent,
        foregroundColor: ColorStyle.text200,
      ),
      Divider(
        height: 0.5,
        color: Colors.grey[300],
      ),
      Container(
        height: 200,
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: ColorStyle.text400.withOpacity(0.36),
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: LibraryImage(product.image).image,
              fit: product.type == ProductType.inventoryItem
                  ? BoxFit.contain
                  : BoxFit.cover,
            )),
        child: Stack(
          children: [
            Positioned(
              top: 12.0,
              right: 12.0,
              child: FoodTypeBadge(
                foodType: product.foodType,
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'MRP',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: ColorStyle.text200),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '${GlobalVariables.currency?.symbol ?? ''}${product.mrpPrice}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: ColorStyle.text200),
                ),
              ],
            ),
            SizedBox(
              width: 12,
              child: Text(
                ' | ',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: ColorStyle.text200),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sale Price',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: ColorStyle.text200),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '${GlobalVariables.currency?.symbol ?? ''}${product.salePrice}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: ColorStyle.success),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: ColorStyle.text200),
            ),
            Text(
              product.description ?? '',
              style: TextStyle(color: ColorStyle.text300, fontSize: 12),
            ),
          ],
        ),
      ),
      const Spacer(),
      if (onEdit != null || onDelete != null)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          height: 0.5,
          color: Colors.grey[300],
        ),
      if (onEdit != null || onDelete != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onEdit,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: ColorStyle.warning.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorStyle.warning,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: ColorStyle.warning,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: InkWell(
                  onTap: onDelete,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: ColorStyle.error.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorStyle.error,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: ColorStyle.error,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      if (onEdit != null || onDelete != null)
        const SizedBox(
          height: 12,
        ),
      if (onAddToCart != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: InkWell(
            onTap: onAddToCart,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: ColorStyle.success.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorStyle.success,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: ColorStyle.success,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      const SizedBox(
        height: 24,
      ),
    ]);
  }
}
