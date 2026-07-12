import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:eatery/core/utils/responsive.dart';
import 'package:eatery/core/extensions/double_ext.dart';
import 'package:eatery/core/widgets/app_dialog.dart';
import 'package:eatery/pages/dashboard/customer/view.customer.page.dart';
import 'package:eatery/presentation/providers/product_provider.dart';
import 'package:eatery/presentation/providers/company_provider.dart';
import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/presentation/providers/cart_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/data/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utility/order_print.page.dart';
import 'cart.page.dart';

class PointOfSalePage extends ConsumerStatefulWidget {
  const PointOfSalePage({Key? key}) : super(key: key);

  @override
  ConsumerState<PointOfSalePage> createState() => _PointOfSalePageState();
}

class _PointOfSalePageState extends ConsumerState<PointOfSalePage> {
  ProductCategory? selectedProductCategory;

  final ScrollController _scrollControllerCategories = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();

  Future<OrderType?> initOrderType() async {
    OrderType? orderType;
    if (ref.read(cartProvider).activeOrderType == null) {
      orderType = await _showOrderTypeSelection();
    }
    return orderType ?? ref.read(cartProvider).activeOrderType;
  }

  Future<DiningTable?> initDiningTableIfDine() async {
    DiningTable? diningTable;
    if (ref.read(cartProvider).activeOrderType == OrderType.dine &&
        ref.read(cartProvider).activeDiningTable == null) {
      await showSearch(
        context: this.context,
        delegate: SearchDiningTableDelegate(
          ref.read(diningTableRepositoryProvider).getAllTables(),
          (table) async {
            diningTable = table;
          },
          currencySymbol:
              ref.read(companyProvider.notifier).currency?.symbol ?? '',
          orders: ref.read(orderRepositoryProvider).getAllOrders(),
        ),
      );
    }
    return diningTable ?? ref.read(cartProvider).activeDiningTable;
  }

  Future<Customer?> initCustomerIfNull() async {
    Customer? customer;
    if (ref.read(cartProvider).activeCustomer == null) {
      await showSearch(
        context: this.context,
        delegate: SearchCustomerDelegate(
          ref.read(customerRepositoryProvider).getAllCustomers(),
          (customer) {
            setState(() {
              ref.read(cartProvider.notifier).setCustomer(customer);
            });
          },
        ),
      ).then((value) {
        customer = value;
      });
    }
    return customer ?? ref.read(cartProvider).activeCustomer;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initOrderType().then((orderType) {
        if (orderType == null) {
          Navigator.pop(this.context);
          return;
        }
        setState(() {
          ref.read(cartProvider.notifier).setOrderType(orderType);
        });
        initDiningTableIfDine().then((diningTable) {
          if (ref.read(cartProvider).activeOrderType == OrderType.dine &&
              diningTable == null) {
            Navigator.pop(this.context);
            return;
          }
          setState(() {
            if (diningTable != null) {
              ref.read(cartProvider.notifier).setDiningTable(diningTable);
              if (diningTable.status == DiningTableStatus.reserved) {
                final reservedCustomer = ref
                    .read(customerRepositoryProvider)
                    .getCustomerByPhone(diningTable.customerPhone ?? '');
                if (reservedCustomer != null) {
                  ref.read(cartProvider.notifier).setCustomer(reservedCustomer);
                }
              } else if (diningTable.status == DiningTableStatus.occupied) {
                final existingOrder = ref
                    .read(orderRepositoryProvider)
                    .getOrderById(diningTable.orderId!);
                if (existingOrder != null) {
                  ref.read(cartProvider.notifier).setActiveOrder(existingOrder);
                  final occupiedCustomer = ref
                      .read(customerRepositoryProvider)
                      .getCustomerByPhone(existingOrder.customerPhone ?? '');
                  if (occupiedCustomer != null) {
                    ref
                        .read(cartProvider.notifier)
                        .setCustomer(occupiedCustomer);
                  }
                }
              }
            }
          });
          initCustomerIfNull().then((customer) {
            // if(customer == null){
            //   Navigator.pop(this.context);
            //   return;
            // }
            setState(() {
              if (customer != null) {
                ref.read(cartProvider.notifier).setCustomer(customer);
              }
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(cartProvider);
    final productsRepo = ref.read(productRepositoryProvider);
    Color pageColor = Color(
      session.activeOrderType?.color ?? AppColors.primary.value,
    );
    List<Product> products = productsRepo.getAllProducts().where((element) {
      if (selectedProductCategory == null) {
        return true;
      }
      if (element.categoryId == selectedProductCategory?.id) {
        return true;
      }
      return false;
    }).toList();
    final crossAxisCount = Responsive.gridColumns(context);
    final spacing = Responsive.spacing(context);
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        title: const Text('Point of Sale'),
        backgroundColor: pageColor,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchProductDelegate(
                  productsRepo.getAllProducts(),
                  (product) {
                    // TODO: GoRouter
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KProductView(product: product),
                      ),
                    );
                  },
                ),
              );
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
                  // Close this order
                  if (session.activeOrderType == OrderType.dine &&
                      session.activeOrder != null)
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.close),
                        title: const Text('Close Order'),
                        onTap: () {
                          Navigator.pop(context);
                          // Ask before close
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Close Order?'),
                                content: const Text(
                                  'Are you sure you want to close this order?',
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      if (session.cart.isNotEmpty) {
                                        AppDialog.showMessage(
                                          context,
                                          message: 'Please clear cart before closing order',
                                          type: MessageType.warning,
                                        );
                                        return;
                                      }


                                      var order = session.activeOrder!;
                                      var diningTableRepo = ref.read(
                                        diningTableRepositoryProvider,
                                      );
                                      var diningTable = diningTableRepo
                                          .getTableById(
                                            session.activeDiningTable?.id ?? 0,
                                          );
                                      if (diningTable != null) {
                                        diningTable.status =
                                            DiningTableStatus.available;
                                        diningTable.orderId = null;
                                        await diningTable.save();
                                      }

                                      var printKOT = false;
                                      var printInvoice = true;
                                      ref
                                          .read(cartProvider.notifier)
                                          .clearCart();

                                      GoRouter.of(context).goNamed('orderPrint', extra: {
                                        'order': order,
                                        'currentCart': const <Product>[],
                                        'printKOT': printKOT,
                                        'printInvoice': printInvoice,
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
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
                                'Are you sure you want to discard this order?',
                              ),
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
                                      ref
                                          .read(cartProvider.notifier)
                                          .clearCart();
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
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: pageColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (session.activeCustomer == null) {
                      showSearch(
                        context: this.context,
                        delegate: SearchCustomerDelegate(
                          ref
                              .read(customerRepositoryProvider)
                              .getAllCustomers(),
                          (customer) {
                            setState(() {
                              ref
                                  .read(cartProvider.notifier)
                                  .setCustomer(customer);
                            });
                          },
                        ),
                      ).then((value) => setState(() {}));
                    } else {
                      GoRouter.of(context).pushNamed('viewCustomer', extra: session.activeCustomer!).then((value) => setState(() {}));
                    }
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.white,
                        child: Icon(
                          Icons.person,
                          color: AppColors.grey400,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (session.activeCustomer?.phone != null)
                            Text(
                              session.activeCustomer?.phone ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: AppColors.white,
                              ),
                            ),
                          if (session.activeCustomer?.name != null)
                            Text(
                              session.activeCustomer?.name ?? 'NA',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          if (session.activeCustomer == null)
                            const Text(
                              'Select Customer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (session.activeOrderType == OrderType.dine)
                  InkWell(
                    onTap: () {
                      if (session.activeDiningTable?.orderId == null) {
                        AppDialog.showMessage(
                          this.context,
                          message: 'No active order for this table',
                          type: MessageType.warning,
                        );
                        return;
                      }
                      final tableOrder = ref
                          .read(orderRepositoryProvider)
                          .getOrderById(session.activeDiningTable!.orderId!);
                      if (tableOrder != null) {
                        GoRouter.of(context).pushNamed('viewOrder', extra: tableOrder).then((value) => setState(() {}));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Outstanding',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${session.activeOrder?.grandTotal.toPrecision(2) ?? '0.00'}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (session.activeOrderType == OrderType.dine)
                  InkWell(
                    onTap: () {
                      if (session.activeDiningTable == null) {
                        showSearch(
                          context: this.context,
                          delegate: SearchDiningTableDelegate(
                            ref
                                .read(diningTableRepositoryProvider)
                                .getAllTables(),
                            (table) {
                              setState(() {
                                ref
                                    .read(cartProvider.notifier)
                                    .setDiningTable(table);
                              });
                            },
                            currencySymbol:
                                ref
                                    .read(companyProvider.notifier)
                                    .currency
                                    ?.symbol ??
                                '',
                            orders: ref
                                .read(orderRepositoryProvider)
                                .getAllOrders(),
                          ),
                        ).then((value) => setState(() {}));
                      } else {
                        GoRouter.of(context).pushNamed('viewDiningTable', extra: session.activeDiningTable!).then((value) => setState(() {}));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Dining Table',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          session.activeDiningTable?.name ?? '~',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Responsive.isMobile(context)
          ? _buildMobileBody(context, pageColor, productsRepo, products, crossAxisCount, spacing)
          : _buildDesktopBody(context, pageColor, productsRepo, products, crossAxisCount, spacing),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PosOrderTypeSelectionButton(
              onTap: () {
                _showOrderTypeSelection().then((value) {
                  // TODO: When only new order, else postpone
                  if (value != null) {
                    setState(
                      () => ref.read(cartProvider.notifier).setOrderType(value),
                    );
                  }
                });
              },
              icon: Icon(
                session.activeOrderType == OrderType.dine
                    ? Icons.dinner_dining
                    : session.activeOrderType == OrderType.delivery
                    ? Icons.delivery_dining
                    : Icons.takeout_dining,
                color: Color(
                  session.activeOrderType?.color ?? AppColors.black600.value,
                ),
              ),
              themeColor: pageColor,
              text: session.activeOrderType?.name ?? 'Select order type',
            ),
            // Cart Information with total price
            if (session.activeCustomer != null)
              PosCartInformation(
                onTap: () {
                  GoRouter.of(context).pushNamed('cart');
                },
                themeColor: pageColor,
                cart: session.cart,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSidebar(
    BuildContext context,
    Color pageColor,
    ProductRepository productsRepo,
  ) {
    return ListView(
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
        ...productsRepo.getAllCategories().map((each) {
          return CircularCategoryPOSWidget(
            margin: const EdgeInsets.only(bottom: 6),
            image: LibraryImage(
              each.image,
              defaultImage: 'assets/images/category.png',
            ).image,
            themeColor: pageColor,
            selected: selectedProductCategory?.id == each.id,
            onTap: () {
              setState(() {
                selectedProductCategory = each;
              });
            },
            label: each.name,
          );
        }),
      ],
    );
  }

  Widget _buildCategoriesHorizontalBar(
    BuildContext context,
    Color pageColor,
    ProductRepository productsRepo,
  ) {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: productsRepo.getAllCategories().length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return CircularCategoryPOSWidget(
              margin: const EdgeInsets.only(right: 6),
              image: const AssetImage('assets/icons/all.png'),
              themeColor: pageColor,
              selected: selectedProductCategory?.id == null,
              onTap: () {
                setState(() {
                  selectedProductCategory = null;
                });
              },
              label: 'All',
            );
          }
          final each = productsRepo.getAllCategories()[index - 1];
          return CircularCategoryPOSWidget(
            margin: const EdgeInsets.only(right: 6),
            image: LibraryImage(
              each.image,
              defaultImage: 'assets/images/category.png',
            ).image,
            themeColor: pageColor,
            selected: selectedProductCategory?.id == each.id,
            onTap: () {
              setState(() {
                selectedProductCategory = each;
              });
            },
            label: each.name,
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(
    BuildContext context,
    Color pageColor,
    List<Product> products,
    int crossAxisCount,
    double spacing,
  ) {
    if (products.isEmpty) {
      return Center(
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
              AppSpacing.gapLg,
              const Text(
                'No dish found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Add a dish to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollControllerProducts,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          ...products.map((product) {
            final width =
                ((MediaQuery.of(context).size.width * 0.8 - 1).abs() -
                    (crossAxisCount + 1) * spacing) /
                crossAxisCount;
            final height = width * 4 / 3;
            return ProductCard(
              product: product,
              width: width,
              height: height,
              themeColor: pageColor,
              currencySymbol:
                  ref.read(companyProvider.notifier).currency?.symbol ?? '',
              onAdd: () {
                setState(() {
                  ref.read(cartProvider.notifier).addToCart(product);
                });
              },
              onRemove: () {
                setState(() {
                  ref.read(cartProvider.notifier).removeFromCart(product);
                });
              },
              onTap: () => _showProductDetails(product),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMobileBody(
    BuildContext context,
    Color pageColor,
    ProductRepository productsRepo,
    List<Product> products,
    int crossAxisCount,
    double spacing,
  ) {
    return Column(
      children: [
        _buildCategoriesHorizontalBar(context, pageColor, productsRepo),
        Expanded(child: _buildProductGrid(context, pageColor, products, crossAxisCount, spacing)),
      ],
    );
  }

  Widget _buildDesktopBody(
    BuildContext context,
    Color pageColor,
    ProductRepository productsRepo,
    List<Product> products,
    int crossAxisCount,
    double spacing,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: _buildCategoriesSidebar(context, pageColor, productsRepo),
        ),
        Expanded(
          flex: 8,
          child: _buildProductGrid(context, pageColor, products, crossAxisCount, spacing),
        ),
      ],
    );
  }

  void _showProductDetails(Product product) => showModalBottomSheet(
    showDragHandle: true,
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
          ref.read(cartProvider.notifier).addToCart(product);
        });
        Fluttertoast.showToast(
          msg: "Added to cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.green,
          textColor: AppColors.white,
          fontSize: 12.0,
        );
        Navigator.of(context).pop();
      },
    ),
  );

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
        const Center(child: BottomViewGrip()),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          child: Text(
            'Select an order type',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: AppColors.black600,
            ),
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
                color: AppColors.white,
              ),
              text: orderType.name!,
              color: Color(orderType.color!),
              foreColor: AppColors.white,
              onTap: () {
                setState(() {
                  // this.orderType = orderType;
                  Navigator.of(context).pop(orderType);
                });
              },
            ),
          ),
        const SizedBox(height: 20.0),
      ],
    ),
  );
}

class PosCartInformation extends StatelessWidget {
  final VoidCallback onTap;
  final Color themeColor;
  final List<Product> cart;

  const PosCartInformation({
    Key? key,
    required this.onTap,
    required this.themeColor,
    required this.cart,
  }) : super(key: key);

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
            topRight: Radius.circular(32),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, color: AppColors.white),
            const SizedBox(width: 8),
            const Text(
              'Cart',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: AppColors.white,
                // Border Animation on set state
                border: Border.all(color: AppColors.grey200!, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  cart.length.toString(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
