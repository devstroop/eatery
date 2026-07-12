import 'package:eatery/data/models/eatery_db.dart';

import '../database/eatery_database.dart';

/// Legacy shim — delegates to the injectable [EateryDatabase].
///
/// Will be removed once all consumers migrate to repositories.
class EateryDB {
  EateryDB._();

  static final EateryDB instance = EateryDB._();

  EateryDatabase? _db;

  /// Called once to bind this shim to the real database after initialization.
  static void bind(EateryDatabase db) {
    instance._db = db;
  }

  /// Throws a descriptive error if the shim was used before [bind] was called.
  void _ensureBound() {
    if (_db == null) {
      throw StateError(
        'EateryDB.instance accessed before EateryDB.bind() was called in main.dart. '
        'The app must initialize the database before accessing any box.',
      );
    }
  }

  /// Initializes the underlying database. Called from main.dart.
  Future<void> init([String? _]) {
    _ensureBound();
    return instance._db!.init();
  }

  // --- Instance-level box getters (delegate to _db) ---

  Box<Company>? get companyBox => _db?.companyBox;
  Box<KCurrency>? get currencyBox => _db?.currencyBox;
  Box<AutoPrint>? get autoPrintBox => _db?.autoPrintBox;
  Box<Customer>? get customerBox => _db?.customerBox;
  Box<DiningTable>? get diningTableBox => _db?.diningTableBox;
  Box<DiningTableCategory>? get diningTableCategoryBox =>
      _db?.diningTableCategoryBox;
  Box<Order>? get orderBox => _db?.orderBox;
  Box<OrderProduct>? get orderProductBox => _db?.orderProductBox;
  Box<Printer>? get printerBox => _db?.printerBox;
  Box<Product>? get productBox => _db?.productBox;
  Box<ProductCategory>? get productCategoryBox => _db?.productCategoryBox;
  Box<Subscription>? get subscriptionBox => _db?.subscriptionBox;
  Box<TaxSlab>? get taxSlabBox => _db?.taxSlabBox;
  Box<Staff>? get staffBox => _db?.staffBox;
  Box<StaffType>? get staffTypeBox => _db?.staffTypeBox;
  Box<TaxType>? get taxTypeBox => _db?.taxTypeBox;
  Box<ProductType>? get productTypeBox => _db?.productTypeBox;
  Box<FoodType>? get foodTypeBox => _db?.foodTypeBox;
  Box<SubscriptionType>? get subscriptionTypeBox => _db?.subscriptionTypeBox;
  Box<Edition>? get editionBox => _db?.editionBox;
  Box<OrderType>? get orderTypeBox => _db?.orderTypeBox;
  Box<PrinterType>? get printerTypeBox => _db?.printerTypeBox;
  Box<Payment>? get paymentBox => _db?.paymentBox;
  Box<PaymentMode>? get paymentModeBox => _db?.paymentModeBox;

  /// Clears all boxes from disk.
  Future<void> deleteAll() => _db?.deleteAll() ?? Future.value();

  /// Closes Hive.
  Future<void> dispose() => _db?.dispose() ?? Future.value();
}
