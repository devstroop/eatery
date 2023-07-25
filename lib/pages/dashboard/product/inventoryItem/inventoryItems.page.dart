import 'package:eatery/pages/dashboard/product/searchProduct.delegate.dart';
import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.alternate;

class InventoryItemsPage extends StatefulWidget {
  const InventoryItemsPage({Key? key}) : super(key: key);

  @override
  State<InventoryItemsPage> createState() => _InventoryItemsPageState();
}

class _InventoryItemsPageState extends State<InventoryItemsPage> {
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

  final ScrollController _scrollControllerCategories = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Product> products = EateryDB.instance.productBox!.values
        .where((element) => element.type == ProductType.inventoryItem)
        .toList();
    // double crossAxisCount;
    // double spacing;
    // if (MediaQuery.of(context).size.width < 600) {
    //   crossAxisCount = 2;
    //   spacing = 12;
    // } else if (MediaQuery.of(context).size.width < 900) {
    //   crossAxisCount = 3;
    //   spacing = 16;
    // } else {
    //   crossAxisCount = 4;
    //   spacing = 24;
    // }
    /*return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          title: const Text('Inventory'),
          backgroundColor: _pageColor,
          foregroundColor: Colors.white,

          flexibleSpace: Container(
            margin: const EdgeInsets.only(top: 102, left: 12, right: 12),
            width: double.maxFinite,
            child: SearchTextField(
              controller: _controllerSearch,
              onChanged: (value) {
                setState(() {});
              },
              themeColor: _pageColor,
              hintText: 'Search an item...',
            ),
          ),
        ),
      ),
      body:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: ListView(
              controller: _scrollControllerCategories,
              padding: const EdgeInsets.all(6.0),
              children: [
                CircularCategoryPOSWidget(
                  margin: const EdgeInsets.only(bottom: 6),
                  image: const AssetImage('assets/icons/all.png'),
                  themeColor: _pageColor,
                  selected: selectedCategory?.id == null,
                  onTap: () {
                    setState(() {
                      selectedCategory = null;
                    });
                  },
                  label: 'All',
                ),
                ...EateryDB.instance.productCategoryBox!.values.map((each) {
                  return CircularCategoryPOSWidget(
                    margin: const EdgeInsets.only(bottom: 6),
                    image: LibraryImage(each.image).image,
                    themeColor: _pageColor,
                    selected: selectedCategory?.id == each.id,
                    onTap: () {
                      setState(() {
                        selectedCategory = each;
                      });
                    },
                    label: each.name,
                  );
                })
              ],
            ),
          ),
          Container(
            width: 1,
            height: MediaQuery.of(context).size.height - 215,
            color: Colors.grey[200],
          ),
          Flexible(
              flex: 8,
              child: products.isNotEmpty
                  ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollControllerProducts,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ...products.map((each) {
                      final width = ((MediaQuery.of(context).size.width * 0.8 - 1).abs() - (crossAxisCount + 1) * spacing) / crossAxisCount;
                      final height = width * 4/3;
                      return ProductCard(product: each, width: width,height: height,themeColor: _pageColor, onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditInventoryItemPage(product: each)),
                        ).then((_) => setState(() {}));
                      },);
                    })
                  ],
                ),
              )
                  : Center(
                child: Opacity(
                  opacity: 0.50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty-folder.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'No dish found',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Add a dish to get started',
                        style: TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                    ],
                  ),
                ),
              )),
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
    );*/
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
                                      showSnackBar(context,
                                          'Item deleted successfully.');
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
                              '${GlobalVariables.currency?.symbol ?? ''}${each.mrpPrice}',
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
                              '${GlobalVariables.currency?.symbol ?? ''}${each.salePrice}',
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
                                        showSnackBar(context,
                                            'Item deleted successfully.');
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
