import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/product_provider.dart';
import 'package:eatery/presentation/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';

Color _pageColor = AppColors.menuInventory;

class InventoryItemsPage extends ConsumerStatefulWidget {
  const InventoryItemsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryItemsPage> createState() => _InventoryItemsPageState();
}

class _InventoryItemsPageState extends ConsumerState<InventoryItemsPage> {
  ProductCategory? selectedCategory;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedCategory = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(productRepositoryProvider);
    final companyNotifier = ref.read(companyProvider.notifier);
    final currency = companyNotifier.currency;
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: _pageColor,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: SearchProductDelegate(
                  repo.getProductsByType(ProductType.inventoryItem),
                  (product) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditInventoryItemPage(product: product),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...repo.getAllCategories().map(
                  (e) => InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = e;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: selectedCategory?.id == e.id
                            ? _pageColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedCategory?.id == e.id
                              ? _pageColor
                              : AppColors.grey300!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (e.image != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Image(
                                errorBuilder: (context, error, stackTrace) {
                                  print(error);
                                  return const Icon(Icons.error_outline);
                                },
                                image: LibraryImage(e.image ?? '').image,
                                height: 28,
                                width: 28,
                              ),
                            ),
                          Text(
                            e.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: selectedCategory?.id == e.id
                                  ? const Color(0xFFF5F5F5)
                                  : AppColors.grey700!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                if (repo.getProductsByType(ProductType.inventoryItem).isEmpty)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.no_food_outlined,
                          size: 128,
                          color: AppColors.grey500,
                        ),
                        AppSpacing.gapLg,
                        Text(
                          'Oops!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey500,
                          ),
                        ),
                        Text(
                          'No items found in inventory',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ...repo
                    .getProductsByType(ProductType.inventoryItem)
                    .where(
                      (element) => selectedCategory != null
                          ? element.categoryId == selectedCategory?.id
                          : true,
                    )
                    .map((each) {
                      return ListTile(
                        leading: InkWell(
                          onTap: () {
                            // Show detailed bottom sheet
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              context: this.context,
                              builder: (context) => KProductView(
                                product: each,
                                onDelete: () {
                                  Navigator.pop(context);
                                  showConfirmationDialog(
                                    context,
                                    'Are you sure?',
                                    'Do you want to delete this item?',
                                    () async {
                                      await repo.deleteProduct(each);
                                      showMessageDialog(
                                        context,
                                        'Item has been deleted',
                                        MessageType.success,
                                        () {
                                          Navigator.pop(context);
                                        },
                                      );
                                      setState(() {});
                                    },
                                    () {
                                      // Do nothing
                                    },
                                  );
                                },
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditInventoryItemPage(product: each),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                              ),
                            );
                          },
                          child: Image(
                            image: LibraryImage(each.image).image,
                            fit: BoxFit.contain,
                            height: 48,
                            width: 48,
                          ),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              each.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (each.foodType != null)
                              FoodTypeBadge(
                                size: 16,
                                foodType: each.foodType,
                                backgroundColor: AppColors.white,
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (each.description != null)
                              Text(
                                each.description!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey700,
                                ),
                              ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'MRP',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${currency?.symbol ?? ''}${each.mrpPrice}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sale Price',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${currency?.symbol ?? ''}${each.salePrice}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // Show the menu
                                showMenu(
                                  context: context,
                                  color: const Color(0xEFEFEFEF),
                                  position: const RelativeRect.fromLTRB(
                                    100,
                                    100,
                                    0,
                                    100,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text('Edit'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditInventoryItemPage(
                                                    product: each,
                                                  ),
                                            ),
                                          ).then((_) => setState(() {}));
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Delete'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showConfirmationDialog(
                                            context,
                                            'Are you sure?',
                                            'Do you want to delete this item?',
                                            () async {
                                              await repo.deleteProduct(each);
                                              showMessageDialog(
                                                context,
                                                'Item has been deleted',
                                                MessageType.success,
                                                () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                              setState(() {});
                                            },
                                            () {
                                              // Do nothing
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Inventory Item'),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddInventoryItem()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
