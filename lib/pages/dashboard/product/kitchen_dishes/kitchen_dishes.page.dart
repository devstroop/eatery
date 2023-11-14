import 'package:eatery/references.dart';

import '../search_product.delegate.dart';

Color _pageColor = KColors.secondary;

class KitchenPage extends StatefulWidget {
  const KitchenPage({Key? key}) : super(key: key);

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  ProductCategory? selectedCategory;
  final TextEditingController _controllerSearch = TextEditingController();

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
        title: const Text('Kitchen'),
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
                  element.type == ProductType.kitchenDish)
                      .toList(),
                  (Product product) {
                    Navigator.pop(context);
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
                          product: product,
                          onDelete: () {
                            Navigator.pop(context);
                            showConfirmationDialog(
                                context,
                                'Are you sure?',
                                'Do you want to delete this dish?', () {
                              product.delete();
                              showMessageDialog(context,
                                  'Dish has been deleted successfully', MessageType.success, () {
                                    setState(() {});
                                  });
                            }, () {
                                  setState(() {});
                            });
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditKitchenDishPage(
                                          product: product)),
                            ).then((_) => setState(() {}));
                          },
                        ));
                  },
                ),
              );
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
                if(EateryDB.instance.productBox!.values
                    .where(
                        (element) => element.type == ProductType.kitchenDish).isEmpty)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.no_food_outlined,
                          size: 128,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Oops!',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500]
                          ),
                        ),
                        Text(
                          'No dishes found in kitchen',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[500]
                          ),
                        ),
                      ],
                    ),
                  ),
                ...EateryDB.instance.productBox!.values
                    .where(
                        (element) => element.type == ProductType.kitchenDish && (selectedCategory != null ? element.categoryId == selectedCategory?.id : true))
                    .map((each) {
                  return InkWell(onTap: () {
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
                        showDragHandle: true,
                        builder: (context) => KProductView(
                          product: each,
                          onDelete: () {
                            Navigator.pop(context);
                            showConfirmationDialog(
                                context,
                                'Are you sure?',
                                'Do you want to delete this dish?', () {
                              each.delete();
                              showMessageDialog(context,
                                  'Dish has been deleted successfully', MessageType.success, () {
                                    setState(() {});
                                  }
                              );
                            }, () {
                              // Do nothing
                            });
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditKitchenDishPage(
                                          product: each)),
                            ).then((_) => setState(() {}));
                          },
                        ));
                  },
                    child: ListTile(
                      leading: Image(
                        image: LibraryImage(each.image).image,
                        fit: BoxFit.contain,
                        height: 48,
                        width: 48,
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
                                                  EditKitchenDishPage(
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
                                                  'Item has been deleted successfully', MessageType.success, () {
                                                setState(() {});
                                                  });
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
        label: const Text('Add Kitchen Dish'),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddKitchenDish()),
          ).then((_) => setState(() {}));
        },
      ),
    );

  }
}
