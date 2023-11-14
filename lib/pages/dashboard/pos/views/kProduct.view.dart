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
    return ListView(
        children: [
      Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
            color: KColors.white600.withOpacity(0.36),
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
          const SizedBox(
            height: 12,
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
                      fontSize: 16,
                      color: KColors.black600),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '${Common.currency?.symbol ?? ''}${product.mrpPrice}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: KColors.black600),
                ),
              ],
            ),
            SizedBox(
              width: 12,
              child: Text(
                ' | ',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: KColors.black600),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sale Price',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: KColors.black600),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '${Common.currency?.symbol ?? ''}${product.salePrice}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: KColors.green),
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
              product.name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: KColors.black600),
            ),
            Text(
              product.description ?? '',
              style: TextStyle(color: KColors.black500, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 12,
      ),
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
                    height: 40,
                    decoration: BoxDecoration(
                      color: KColors.yellow.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: KColors.yellow,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: KColors.yellow,
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
                    height: 40,
                    decoration: BoxDecoration(
                      color: KColors.red.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: KColors.red,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: KColors.red,
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
              height: 40,
              decoration: BoxDecoration(
                color: KColors.green.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: KColors.green,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: KColors.green,
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
