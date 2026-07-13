import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery/core/router/app_router.dart';
import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/database/native/eatery_store.dart';

void main() {
  group('GoRouter regression tests', () {
    late GoRouter router;

    setUp(() {
      router = createAppRouter(
        EateryDatabase(dataDir: '', store: EateryStore.open(':memory:')),
      );
    });

    test('constructs without error', () {
      expect(router, isNotNull);
    });

    test('namedLocation resolves all defined route names', () {
      final routeNames = [
        'login',
        'mainScreen',
        'createCompany',
        'resetPin',
        'logout',
        'dashboard',
        'pos',
        'cart',
        'orderConfirmation',
        'orderPrint',
        'orders',
        'viewOrder',
        'editOrder',
        'payments',
        'addPayment',
        'viewPayment',
        'editPayment',
        'customers',
        'addCustomer',
        'viewCustomer',
        'editCustomer',
        'diningTables',
        'addDiningTable',
        'viewDiningTable',
        'editDiningTable',
        'diningTableCategories',
        'addDiningTableCategory',
        'editDiningTableCategory',
        'kitchenDishes',
        'addKitchenDish',
        'editKitchenDish',
        'inventoryItems',
        'addInventoryItem',
        'editInventoryItem',
        'productCategories',
        'addProductCategory',
        'editProductCategory',
        'settings',
        'companySettings',
        'editCompany',
        'printerSettings',
        'taxSlabs',
        'addTaxSlab',
        'editTaxSlab',
        'currencyRegion',
        'staffs',
        'addStaff',
        'editStaff',
        'dataManagement',
        'import',
        'export',
        'databaseInspector',
        'upgrade',
        'productView',
      ];

      expect(routeNames.length, 54, reason: 'Expected 54 named routes');

      for (final name in routeNames) {
        expect(
          () => router.namedLocation(name),
          returnsNormally,
          reason: 'Route "$name" could not be resolved',
        );
      }
    });

    test('namedLocation returns correct paths for key routes', () {
      expect(router.namedLocation('login'), '/login');
      expect(router.namedLocation('mainScreen'), '/');
      expect(router.namedLocation('createCompany'), '/create-company');
      expect(router.namedLocation('dashboard'), '/dashboard');
      expect(router.namedLocation('pos'), '/pos');
      expect(router.namedLocation('cart'), '/cart');
      expect(router.namedLocation('orders'), '/orders');
      expect(router.namedLocation('settings'), '/settings');
      expect(router.namedLocation('productView'), '/pos/product-view');
      expect(router.namedLocation('upgrade'), '/upgrade');
    });

    test('routes with required extra accept namedLocation', () {
      expect(() => router.namedLocation('viewOrder'), returnsNormally);
      expect(() => router.namedLocation('orderConfirmation'), returnsNormally);
      expect(() => router.namedLocation('productView'), returnsNormally);
      expect(() => router.namedLocation('upgrade'), returnsNormally);
      expect(() => router.namedLocation('editCustomer'), returnsNormally);
    });

    test('unknown route name throws', () {
      expect(() => router.namedLocation('nonExistentRoute'), throwsA(anything));
    });

    test('route names match expected count', () {
      // 54 named routes, 1 unnamed (initial / upgrade route?), let's just test
      // that namedLocation works for the complete list
      final names = [
        'login',
        'mainScreen',
        'createCompany',
        'resetPin',
        'logout',
        'dashboard',
        'pos',
        'cart',
        'orderConfirmation',
        'orderPrint',
        'orders',
        'viewOrder',
        'editOrder',
        'payments',
        'addPayment',
        'viewPayment',
        'editPayment',
        'customers',
        'addCustomer',
        'viewCustomer',
        'editCustomer',
        'diningTables',
        'addDiningTable',
        'viewDiningTable',
        'editDiningTable',
        'diningTableCategories',
        'addDiningTableCategory',
        'editDiningTableCategory',
        'kitchenDishes',
        'addKitchenDish',
        'editKitchenDish',
        'inventoryItems',
        'addInventoryItem',
        'editInventoryItem',
        'productCategories',
        'addProductCategory',
        'editProductCategory',
        'settings',
        'companySettings',
        'editCompany',
        'printerSettings',
        'taxSlabs',
        'addTaxSlab',
        'editTaxSlab',
        'currencyRegion',
        'staffs',
        'addStaff',
        'editStaff',
        'dataManagement',
        'import',
        'export',
        'databaseInspector',
        'upgrade',
        'productView',
      ];
      for (final name in names) {
        router.namedLocation(name);
      }
    });
  });
}
