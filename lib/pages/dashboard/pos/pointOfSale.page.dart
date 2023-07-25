import 'package:eatery/references.dart';

import '../product/searchProduct.delegate.dart';

class PointOfSalePage extends StatefulWidget {
  const PointOfSalePage({Key? key}) : super(key: key);

  @override
  State<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends State<PointOfSalePage> {
  OrderType orderType = OrderType.dine;
  ProductCategory? selectedProductCategory;
  DiningTable? selectedDiningTable;

  final TextEditingController _controllerSearch = TextEditingController();
  final ScrollController _scrollControllerCategories = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {

    });
  }

  @override
  Widget build(BuildContext context) {
    Color pageColor = Color(orderType.color ?? 0);
    List<ProductCategory> categories =
        EateryDB.instance.productCategoryBox!.values.toList();
    List<Product> products =
        EateryDB.instance.productBox!.values.where((element) {
      // TODO: implement build
      return true;
    }).toList();
    double crossAxisCount;
    double spacing;
    if (MediaQuery.of(context).size.width < 600) {
      crossAxisCount = 2;
      spacing = 12;
    } else if (MediaQuery.of(context).size.width < 900) {
      crossAxisCount = 3;
      spacing = 16;
    } else {
      crossAxisCount = 4;
      spacing = 24;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        backgroundColor: pageColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchProductDelegate(
                      EateryDB.instance.productBox!.values.toList(),
                      (product) {}));
            },
          ),
          IconButton(
            icon: const Icon(Icons.barcode_reader),
            onPressed: (){}
          ),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsPage()));
          }, icon: const Icon(Icons.receipt_long))
        ],
      ),
      body: Row(
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
                  themeColor: pageColor,
                  selected: selectedProductCategory?.id == null,
                  onTap: () {
                    setState(() {
                      selectedProductCategory = null;
                    });
                  },
                  label: 'All',
                ),
                ...EateryDB.instance.productCategoryBox!.values.map((each) {
                  return CircularCategoryPOSWidget(
                    margin: const EdgeInsets.only(bottom: 6),
                    image: LibraryImage(each.image).image,
                    themeColor: pageColor,
                    selected: selectedProductCategory?.id == each.id,
                    onTap: () {
                      setState(() {
                        selectedProductCategory = each;
                      });
                    },
                    label: each.name,
                  );
                })
              ],
            ),
          ),
          Expanded(
              flex: 8,
              child: products.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _scrollControllerProducts,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          ...products.map((product) {
                            final width =
                                ((MediaQuery.of(context).size.width * 0.8 - 1)
                                            .abs() -
                                        (crossAxisCount + 1) * spacing) /
                                    crossAxisCount;
                            final height = width * 4 / 3;
                            return ProductCard(
                              product: product,
                              width: width,
                              height: height,
                              themeColor: pageColor,
                              onAdd: () {
                                setState(() {
                                  GlobalVariables.cart.add(product);
                                });
                              },
                              onRemove: () {
                                setState(() {
                                  GlobalVariables.cart.remove(product);
                                });
                              },
                              onTap: () => _showProductDetails(product),
                            );
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PosOrderTypeSelectionButton(
              onTap: _showOrderTypeSelection,
              icon: Icon(orderType == OrderType.dine
                  ? Icons.dinner_dining
                  : orderType == OrderType.delivery ? Icons.delivery_dining : Icons.takeout_dining, color: Color(orderType.color ?? ColorStyle.text200.value),),
              themeColor: pageColor,
              text: orderType.name!,
            ),
            if (orderType == OrderType.dine) // dining table selection
              IconButton(
                  onPressed: _pickDiningTable,
                  icon: Icon(
                    Icons.table_restaurant,
                    color: pageColor,
                  )),
            if (orderType == OrderType.dine) // waiter selection
              IconButton(
                  onPressed: _pickWaiter,
                  icon: Icon(
                    Icons.person,
                    color: pageColor,
                  )),
            if (orderType == OrderType.delivery)
              IconButton(
                  onPressed: _pickDeliveryLocation,
                  icon: Icon(
                    Icons.pin_drop,
                    color: pageColor,
                  )),
            if (orderType == OrderType.delivery)
              IconButton(
                  onPressed: _pickDeliveryStaff,
                  icon: Icon(
                    Icons.directions_bike,
                    color: pageColor,
                  )),

            if (orderType == OrderType.takeout)
              IconButton(
                  onPressed: _pickDeliveryStaff,
                  icon: Icon(
                    Icons.person,
                    color: pageColor,
                  )),


            IconButton(
                onPressed: _cartView,
                icon: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: pageColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        ' ${GlobalVariables.cart.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )),


            if (GlobalVariables.cart.isNotEmpty && GlobalVariables.expressMode)
              IconButton(
                  onPressed: _expressCheckout,
                  icon: Icon(
                    Icons.fast_forward,
                    color: pageColor,
                  )),
            if (GlobalVariables.cart.isNotEmpty && !GlobalVariables.expressMode)
              IconButton(
                  onPressed: _checkout,
                  icon: Icon(
                    Icons.arrow_circle_right,
                    color: pageColor,
                  )),
          ],
        ),
      ),
    );
  }

  void _pickDiningTable() {
    showModalBottomSheet(
        context: this.context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        builder: (context) => const DiningTableSelectionView());
  }

  void _pickDeliveryLocation() {
  }

  void _expressCheckout() {
  }

  void _checkout() {
  }

  void _cartView() {
    showModalBottomSheet(
        context: this.context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        builder: (context) =>
        // StatefulBuilder(builder: (context, state) => const CartPage())
        const CartView()
    );
  }

  void _showProductDetails(Product product) {
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
        builder: (context) =>
            KProductView(product: product));
  }

  void _pickWaiter() {
    showModalBottomSheet(
        context: this.context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        builder: (context) => const WaiterSelectionView());
  }

  void _showOrderTypeSelection() {
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
        builder: (context) => ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: BottomViewGrip(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16.0, 12.0, 16.0, 12.0),
              child: Text(
                'Select an order type',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: ColorStyle.text200),
              ),
            ),
            for (var orderType in OrderType.values)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: SpecialButton(
                  icon: Icon(orderType == OrderType.dine
                      ? Icons.dinner_dining
                      : orderType == OrderType.delivery
                          ? Icons.delivery_dining
                          : Icons.takeout_dining,
                      color: Colors.white),
                  text: orderType.name!,
                  color: Color(orderType.color!),
                  foreColor: Colors.white,
                  onTap: () {
                    setState(() {
                      this.orderType = orderType;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }

  void _pickDeliveryStaff() {
  }
}
