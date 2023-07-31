import 'package:eatery/references.dart';

Color _pageColor = KColors.alternate;

class InventoryItemsPage extends StatefulWidget {
  const InventoryItemsPage({Key? key}) : super(key: key);

  @override
  State<InventoryItemsPage> createState() => _InventoryItemsPageState();
}

class _InventoryItemsPageState extends State<InventoryItemsPage> {
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: SearchProductDelegate(
                    EateryDB.instance.productBox!.values
                        .where((element) =>
                            element.type == ProductType.inventoryItem)
                        .toList(), (product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditInventoryItemPage(
                              product: product,
                            )),
                  ).then((_) => setState(() {}));
                }),
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
                ...EateryDB.instance.productCategoryBox!.values
                    .map((e) => InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory = e;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: selectedCategory?.id == e.id
                                  ? _pageColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: selectedCategory?.id == e.id
                                      ? _pageColor
                                      : Colors.grey[300]!,
                                  width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (e.image != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Image(
                                      image: LibraryImage(e.image!).image,
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
                                          : Colors.grey[700]!),
                                ),
                              ],
                            ),
                          ),
                        )),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                ...EateryDB.instance.productBox!.values
                    .where(
                        (element) => element.type == ProductType.inventoryItem)
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
                                        'Do you want to delete this item?', () {
                                      each.delete();
                                      showMessageDialog(context, 'Item has been deleted',
                                          MessageType.success, () {
                                        Navigator.pop(context);
                                      });
                                      setState(() {});
                                    }, () {
                                      // Do nothing
                                    });
                                  },
                                  onEdit: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditInventoryItemPage(
                                                  product: each)),
                                    ).then((_) => setState(() {}));
                                  },
                                ));
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
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        if (each.foodType != null)
                          FoodTypeBadge(
                            size: 16,
                            foodType: each.foodType,
                            backgroundColor: Colors.white,
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
                              color: Colors.grey[700],
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
                                  color: Colors.grey[700]),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${each.mrpPrice}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2F2F2F)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Sale Price',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700]),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${Common.currency?.symbol ?? ''}${each.salePrice}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
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
                              position:
                                  const RelativeRect.fromLTRB(100, 100, 0, 100),
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
                                                    product: each)),
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
                                          () {
                                        each.delete();
                                        showMessageDialog(context,
                                            'Item has been deleted', MessageType.success, () {
                                          Navigator.pop(context);
                                        });
                                        setState(() {});
                                      }, () {
                                        // Do nothing
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
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
