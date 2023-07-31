import 'package:eatery/references.dart';

class PointOfSalePage extends StatefulWidget {
  const PointOfSalePage({Key? key}) : super(key: key);

  @override
  State<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends State<PointOfSalePage> {
  ProductCategory? selectedProductCategory;

  final ScrollController _scrollControllerCategories = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();

  @override
  void initState() {
    super.initState();
    // POS Entry
    Future.delayed(Duration.zero, () {
      if (GlobalVariables.activeOrderType == null) {
        _showOrderTypeSelection().then((value) {
          if (value != null) {
            setState(() => GlobalVariables.activeOrderType = value);
          } else {
            Navigator.pop(this.context);
            return;
          }
          if (GlobalVariables.activeCustomer == null) {
            showSearch(
                context: this.context,
                delegate: SearchCustomerDelegate(
                    EateryDB.instance.customerBox!.values.toList(), (customer) {
                  setState(() {
                    GlobalVariables.activeCustomer = customer;
                  });
                })).then((value) {
              if (value == null) {
                Navigator.pop(this.context);
                return;
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color pageColor = Color(
        GlobalVariables.activeOrderType?.color ?? ColorStyle.primary.value);
    List<Product> products =
    EateryDB.instance.productBox!.values.where((element) {
      // TODO: implement build
      return true;
    }).toList();
    double crossAxisCount;
    double spacing;
    if (MediaQuery
        .of(context)
        .size
        .width < 600) {
      crossAxisCount = 2;
      spacing = 12;
    } else if (MediaQuery
        .of(context)
        .size
        .width < 900) {
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
        // Add bottom: container with short height, displays customer name, phone number and previous balance
        bottom: GlobalVariables.activeCustomer?.id != null ? PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: pageColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Shrink the size of the balance text to fit the screen
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              GlobalVariables.activeCustomer = null;
                            });
                          },
                          icon: const Icon(Icons.clear, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                      const Text(
                        'Outstanding\nBalance',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '₹${GlobalVariables.activeCustomer?.outstandingAmount ?? 0}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.white,),),
                  ],
                )
              ],
            ),
          ),
        ) : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchProductDelegate(
                      EateryDB.instance.productBox!.values.toList(),
                          (product) =>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      KProductView(product: product)))));
            },
          ),
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show the menu
              showMenu(
                context: context,
                color: const Color(0xEFEFEFEF),
                position: const RelativeRect.fromLTRB(100, 100, 0, 100),
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.cancel),
                      title: const Text('Discard'),
                      onTap: () {
                        Navigator.pop(context);
                        // Ask before discard
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Discard Order?'),
                              content: const Text(
                                  'Are you sure you want to discard this order?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Discard'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      GlobalVariables.activeOrderType = null;
                                      GlobalVariables.activeCustomer = null;
                                      GlobalVariables.activeDiningTable = null;
                                      GlobalVariables.cart.clear();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )
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
                          ((MediaQuery
                              .of(context)
                              .size
                              .width * 0.8 - 1)
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
              icon: Icon(
                GlobalVariables.activeOrderType == OrderType.dine
                    ? Icons.dinner_dining
                    : GlobalVariables.activeOrderType == OrderType.delivery
                    ? Icons.delivery_dining
                    : Icons.takeout_dining,
                color: Color(GlobalVariables.activeOrderType?.color ??
                    ColorStyle.text200.value),
              ),
              themeColor: pageColor,
              text:
              GlobalVariables.activeOrderType?.name ?? 'Select order type',
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: pageColor,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.person)],
              ),
            ),
            if (GlobalVariables.activeOrderType ==
                OrderType.dine) // dining table selection
              IconButton(
                  onPressed: _pickDiningTable,
                  icon: Icon(
                    Icons.table_restaurant,
                    color: pageColor,
                  )),
            if (GlobalVariables.activeOrderType ==
                OrderType.dine) // waiter selection
              IconButton(
                  onPressed: _pickWaiter,
                  icon: Icon(
                    Icons.man,
                    color: pageColor,
                  )),
            if (GlobalVariables.activeOrderType == OrderType.delivery)
              IconButton(
                  onPressed: _pickDeliveryLocation,
                  icon: Icon(
                    Icons.pin_drop,
                    color: pageColor,
                  )),
            if (GlobalVariables.activeOrderType == OrderType.delivery)
              IconButton(
                  onPressed: _pickDeliveryStaff,
                  icon: Icon(
                    Icons.directions_bike,
                    color: pageColor,
                  )),
            if (GlobalVariables.activeOrderType == OrderType.takeout)
              IconButton(
                  onPressed: _pickDeliveryStaff,
                  icon: Icon(
                    Icons.person,
                    color: pageColor,
                  )),
            IconButton(
                onPressed: _cartView,
                icon: Container(
                  padding: const EdgeInsets.all(12.0),
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

  void _pickDeliveryLocation() {}

  void _expressCheckout() {}

  void _cartView() {
    if (GlobalVariables.activeOrderType == null) {
      Fluttertoast.showToast(
          msg: "Please select an order type",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ColorStyle.error,
          textColor: Colors.white,
          fontSize: 12.0);
      return;
    }
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
            CartView(
              themeColor: Color(GlobalVariables.activeOrderType?.color ??
                  ColorStyle.text200.value),
              orderType: GlobalVariables.activeOrderType!,
              setParentState: () {
                setState(() {});
              },
            ));
  }

  void _showProductDetails(Product product) =>
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
              KProductView(
                product: product,
                onAddToCart: () {
                  setState(() {
                    GlobalVariables.cart.add(product);
                  });
                  Fluttertoast.showToast(
                      msg: "Added to cart",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: ColorStyle.success,
                      textColor: Colors.white,
                      fontSize: 12.0);
                  Navigator.of(context).pop();
                },
              ));

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

  Future<OrderType?> _showOrderTypeSelection() =>
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
              ListView(
                shrinkWrap: true,
                children: [
                  const Center(
                    child: BottomViewGrip(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
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
                        icon: Icon(
                            orderType == OrderType.dine
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
                            // this.orderType = orderType;
                            Navigator.of(context).pop(orderType);
                          });
                        },
                      ),
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ));

  void _pickDeliveryStaff() {}
}
