import 'package:eatery/data/models/eatery_db.dart';

/// Injectable database wrapper around Hive boxes.
///
/// Replaces the old [EateryDB] singleton. Injected via Riverpod.
/// The old [EateryDB.instance] shim delegates to this class until all
/// consumers are migrated to the repository pattern.
class EateryDatabase {
  EateryDatabase({required this.dataDir});

  final String dataDir;

  /// True after [init] completes successfully.
  bool isInitialized = false;

  /// True when [init] completed and a company exists.
  bool get hasCompany =>
      isInitialized && _companyBox != null && _companyBox!.values.isNotEmpty;

  // Lazy-loaded boxes — accessed via getters so they work after init()
  Box<Company>? _companyBox;
  Box<KCurrency>? _currencyBox;
  Box<AutoPrint>? _autoPrintBox;
  Box<Customer>? _customerBox;
  Box<DiningTable>? _diningTableBox;
  Box<DiningTableCategory>? _diningTableCategoryBox;
  Box<Order>? _orderBox;
  Box<OrderProduct>? _orderProductBox;
  Box<Printer>? _printerBox;
  Box<Product>? _productBox;
  Box<ProductCategory>? _productCategoryBox;
  Box<Subscription>? _subscriptionBox;
  Box<TaxSlab>? _taxSlabBox;
  Box<Staff>? _staffBox;
  Box<StaffType>? _staffTypeBox;
  Box<TaxType>? _taxTypeBox;
  Box<ProductType>? _productTypeBox;
  Box<FoodType>? _foodTypeBox;
  Box<SubscriptionType>? _subscriptionTypeBox;
  Box<Taxation>? _taxationBox;
  Box<OrderType>? _orderTypeBox;
  Box<PrinterType>? _printerTypeBox;
  Box<Payment>? _paymentBox;
  Box<PaymentMode>? _paymentModeBox;

  // Box getters — mirrors EateryDB.boxName! pattern for compatibility
  Box<Company> get companyBox => _companyBox!;
  Box<KCurrency> get currencyBox => _currencyBox!;
  Box<AutoPrint> get autoPrintBox => _autoPrintBox!;
  Box<Customer> get customerBox => _customerBox!;
  Box<DiningTable> get diningTableBox => _diningTableBox!;
  Box<DiningTableCategory> get diningTableCategoryBox =>
      _diningTableCategoryBox!;
  Box<Order> get orderBox => _orderBox!;
  Box<OrderProduct> get orderProductBox => _orderProductBox!;
  Box<Printer> get printerBox => _printerBox!;
  Box<Product> get productBox => _productBox!;
  Box<ProductCategory> get productCategoryBox => _productCategoryBox!;
  Box<Subscription> get subscriptionBox => _subscriptionBox!;
  Box<TaxSlab> get taxSlabBox => _taxSlabBox!;
  Box<Staff> get staffBox => _staffBox!;
  Box<StaffType> get staffTypeBox => _staffTypeBox!;
  Box<TaxType> get taxTypeBox => _taxTypeBox!;
  Box<ProductType> get productTypeBox => _productTypeBox!;
  Box<FoodType> get foodTypeBox => _foodTypeBox!;
  Box<SubscriptionType> get subscriptionTypeBox => _subscriptionTypeBox!;
  Box<Taxation> get taxationBox => _taxationBox!;
  Box<OrderType> get orderTypeBox => _orderTypeBox!;
  Box<PrinterType> get printerTypeBox => _printerTypeBox!;
  Box<Payment> get paymentBox => _paymentBox!;
  Box<PaymentMode> get paymentModeBox => _paymentModeBox!;

  /// Initialize all Hive boxes.
  Future<void> init() async {
    await Hive.initFlutter(dataDir);

    Hive.registerAdapter(CompanyAdapter());
    Hive.registerAdapter(KCurrencyAdapter());
    Hive.registerAdapter(AutoPrintAdapter());
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(DiningTableAdapter());
    Hive.registerAdapter(DiningTableCategoryAdapter());
    Hive.registerAdapter(DiningTableStatusAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderProductAdapter());
    Hive.registerAdapter(PrinterAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(ProductCategoryAdapter());
    Hive.registerAdapter(SubscriptionAdapter());
    Hive.registerAdapter(TaxSlabAdapter());
    Hive.registerAdapter(StaffAdapter());
    Hive.registerAdapter(StaffTypeAdapter());
    Hive.registerAdapter(TaxTypeAdapter());
    Hive.registerAdapter(ProductTypeAdapter());
    Hive.registerAdapter(FoodTypeAdapter());
    Hive.registerAdapter(SubscriptionTypeAdapter());
    Hive.registerAdapter(TaxationAdapter());
    Hive.registerAdapter(OrderTypeAdapter());
    Hive.registerAdapter(PrinterTypeAdapter());
    Hive.registerAdapter(PaymentAdapter());
    Hive.registerAdapter(PaymentModeAdapter());

    _companyBox = await Hive.openBox<Company>('company');
    _currencyBox = await Hive.openBox<KCurrency>('currency');
    _autoPrintBox = await Hive.openBox<AutoPrint>('autoPrint');
    _customerBox = await Hive.openBox<Customer>('customer');
    _diningTableBox = await Hive.openBox<DiningTable>('diningTable');
    _diningTableCategoryBox = await Hive.openBox<DiningTableCategory>(
      'diningTableCategory',
    );
    _orderBox = await Hive.openBox<Order>('order');
    _orderProductBox = await Hive.openBox<OrderProduct>('orderProduct');
    _printerBox = await Hive.openBox<Printer>('printer');
    _productBox = await Hive.openBox<Product>('product');
    _productCategoryBox = await Hive.openBox<ProductCategory>(
      'productCategory',
    );
    _subscriptionBox = await Hive.openBox<Subscription>('subscription');
    _taxSlabBox = await Hive.openBox<TaxSlab>('taxSlab');
    _staffBox = await Hive.openBox<Staff>('staff');
    _staffTypeBox = await Hive.openBox<StaffType>('staffType');
    _taxTypeBox = await Hive.openBox<TaxType>('taxType');
    _productTypeBox = await Hive.openBox<ProductType>('productType');
    _foodTypeBox = await Hive.openBox<FoodType>('foodType');
    _subscriptionTypeBox = await Hive.openBox<SubscriptionType>(
      'subscriptionType',
    );
    _taxationBox = await Hive.openBox<Taxation>('taxation');
    _orderTypeBox = await Hive.openBox<OrderType>('orderType');
    _printerTypeBox = await Hive.openBox<PrinterType>('printerType');
    _paymentBox = await Hive.openBox<Payment>('payment');
    _paymentModeBox = await Hive.openBox<PaymentMode>('paymentMode');
    isInitialized = true;
  }

  /// Deletes all boxes from disk (for data reset).
  Future<void> deleteAll() async {
    await Future.wait<void>([
      _companyBox?.deleteFromDisk() ?? Future.value(),
      _currencyBox?.deleteFromDisk() ?? Future.value(),
      _autoPrintBox?.deleteFromDisk() ?? Future.value(),
      _customerBox?.deleteFromDisk() ?? Future.value(),
      _diningTableBox?.deleteFromDisk() ?? Future.value(),
      _diningTableCategoryBox?.deleteFromDisk() ?? Future.value(),
      _orderBox?.deleteFromDisk() ?? Future.value(),
      _orderProductBox?.deleteFromDisk() ?? Future.value(),
      _productBox?.deleteFromDisk() ?? Future.value(),
      _productCategoryBox?.deleteFromDisk() ?? Future.value(),
      _printerBox?.deleteFromDisk() ?? Future.value(),
      _printerTypeBox?.deleteFromDisk() ?? Future.value(),
      _subscriptionBox?.deleteFromDisk() ?? Future.value(),
      _subscriptionTypeBox?.deleteFromDisk() ?? Future.value(),
      _taxationBox?.deleteFromDisk() ?? Future.value(),
      _foodTypeBox?.deleteFromDisk() ?? Future.value(),
      _taxSlabBox?.deleteFromDisk() ?? Future.value(),
      _taxTypeBox?.deleteFromDisk() ?? Future.value(),
      _staffBox?.deleteFromDisk() ?? Future.value(),
      _staffTypeBox?.deleteFromDisk() ?? Future.value(),
      _productTypeBox?.deleteFromDisk() ?? Future.value(),
      _orderTypeBox?.deleteFromDisk() ?? Future.value(),
      _paymentBox?.deleteFromDisk() ?? Future.value(),
      _paymentModeBox?.deleteFromDisk() ?? Future.value(),
    ]);
  }

  /// Closes Hive.
  Future<void> dispose() => Hive.close();
}
