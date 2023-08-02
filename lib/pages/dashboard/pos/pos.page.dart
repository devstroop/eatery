import 'package:eatery/pages/dashboard/customer/view.customer.page.dart';
import 'package:eatery/references.dart';
import 'cart.page.dart';

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
    Future.delayed(Duration.zero, () {
      if (Common.activeOrderType == null ||
          Common.activeCustomer == null ||
          Common.activeDiningTable == null) {
        _showOrderTypeSelection().then((value) {
          if (value != null) {
            setState(() => Common.activeOrderType = value);
          } else {
            Navigator.pop(this.context);
            return;
          }
          if (Common.activeCustomer == null) {
            showSearch(
                context: this.context,
                delegate: SearchCustomerDelegate(
                    EateryDB.instance.customerBox!.values.toList(), (customer) {
                  setState(() {
                    Common.activeCustomer = customer;
                  });
                })).then((value) {
              if (value == null) {
                Navigator.pop(this.context);
                return;
              }
            });
          }
          if (Common.activeOrderType == OrderType.dine) {
            showSearch(
                context: this.context,
                delegate: SearchDiningTableDelegate(
                    EateryDB.instance.diningTableBox!.values.toList(), (table) {
                  setState(() {
                    Common.activeDiningTable = table;
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
    Color pageColor =
        Color(Common.activeOrderType?.color ?? KColors.primary.value);
    List<Product> products =
        EateryDB.instance.productBox!.values.where((element) {
      if (selectedProductCategory == null) {
        return true;
      }
      if (element.categoryId == selectedProductCategory?.id) {
        return true;
      }
      return false;
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
        // Add bottom: container with short height, displays customer name, phone number and previous balance
        bottom: PreferredSize(
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        this.context,
                        MaterialPageRoute(
                            builder: (context) => ViewCustomer(
                                  customer: Common.activeCustomer!,
                                )));
                  },
                  child: Row(
                    children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                        ),
                      const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(Common.activeCustomer?.phone != null)
                              Text(
                                Common.activeCustomer?.phone ?? '',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            if(Common.activeCustomer?.name != null)
                              Text(
                                Common.activeCustomer?.name ?? 'NA',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),

                            if(Common.activeCustomer == null)
                              const Text(
                                'Select\nCustomer',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Outstanding',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${Common.currency?.symbol ?? ''}${Common.activeCustomer?.outstandingAmount ?? '~'}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showSearch(
                        context: this.context,
                        delegate: SearchDiningTableDelegate(
                            EateryDB.instance.diningTableBox!.values
                                .toList(), (table) {
                          setState(() {
                            Common.activeDiningTable = table;
                          });
                        })).then((value) {
                      setState(() {
                        Common.activeDiningTable = null;
                      });
                      if (value == null) {
                        Navigator.pop(this.context);
                        return;
                      }
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Dining Table',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Common.activeDiningTable?.name ?? '~',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchProductDelegate(
                      EateryDB.instance.productBox!.values.toList(),
                      (product) => Navigator.push(
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
                                      Common.activeOrderType = null;
                                      Common.activeCustomer = null;
                                      Common.activeDiningTable = null;
                                      Common.cart.clear();
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
                                  Common.cart.add(product);
                                });
                              },
                              onRemove: () {
                                setState(() {
                                  Common.cart.remove(product);
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
                Common.activeOrderType == OrderType.dine
                    ? Icons.dinner_dining
                    : Common.activeOrderType == OrderType.delivery
                        ? Icons.delivery_dining
                        : Icons.takeout_dining,
                color: Color(
                    Common.activeOrderType?.color ?? KColors.black600.value),
              ),
              themeColor: pageColor,
              text: Common.activeOrderType?.name ?? 'Select order type',
            ),
            // Cart Information with total price
            PosCartInformation(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
              themeColor: pageColor,
              cart: Common.cart,
            ),
          ],
        ),
      ),
    );
  }
  void _showProductDetails(Product product) => showModalBottomSheet(
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
            onAddToCart: () {
              setState(() {
                Common.cart.add(product);
              });
              Fluttertoast.showToast(
                  msg: "Added to cart",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: KColors.green,
                  textColor: Colors.white,
                  fontSize: 12.0);
              Navigator.of(context).pop();
            },
          ));

  Future<OrderType?> _showOrderTypeSelection() => showModalBottomSheet(
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
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                child: Text(
                  'Select an order type',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: KColors.black600),
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
}

class PosCartInformation extends StatelessWidget {
  final VoidCallback onTap;
  final Color themeColor;
  final List<Product> cart;

  const PosCartInformation(
      {Key? key,
      required this.onTap,
      required this.themeColor,
      required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: themeColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
                topRight: Radius.circular(32))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Cart',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  color: Colors.white,
                  // Border Animation on set state
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                  borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  cart.length.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
