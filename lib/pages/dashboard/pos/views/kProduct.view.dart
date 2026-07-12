import 'package:eatery/presentation/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KProductView extends ConsumerStatefulWidget {
  const KProductView({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onAddToCart,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToCart;

  final Product product;

  @override
  ConsumerState<KProductView> createState() => _KProductViewState();
}

class _KProductViewState extends ConsumerState<KProductView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: AppColors.white600.withOpacity(0.36),
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: LibraryImage(widget.product.image).image,
              fit: widget.product.type == ProductType.inventoryItem
                  ? BoxFit.contain
                  : BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12.0,
                right: 12.0,
                child: FoodTypeBadge(
                  foodType: widget.product.foodType,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
                      color: AppColors.black600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${widget.product.mrpPrice}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.black600,
                    ),
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
                    color: AppColors.black600,
                  ),
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
                      color: AppColors.black600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${widget.product.salePrice}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: KColors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.black600,
                ),
              ),
              Text(
                widget.product.description ?? '',
                style: TextStyle(color: AppColors.black500, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          height: 0.5,
          color: Colors.grey[300],
        ),
        if (widget.onEdit != null || widget.onDelete != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: widget.onEdit,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: KColors.yellow.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: KColors.yellow, width: 1),
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
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: widget.onDelete,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: AppColors.error,
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
        if (widget.onEdit != null || widget.onDelete != null)
          const SizedBox(height: 12),
        if (widget.onAddToCart != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: widget.onAddToCart,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: KColors.green.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: KColors.green, width: 1),
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
        const SizedBox(height: 24),
      ],
    );
  }
}
