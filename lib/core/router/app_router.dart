import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/database/eatery_database.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/providers/auth_session.dart';
import 'package:eatery_core/providers/role_provider.dart';
import 'package:eatery/pages/authentication/login.page.dart';
import 'package:eatery/pages/dashboard/pos/views/kProduct.view.dart';
import 'package:eatery/pages/main.screen.dart';
import 'package:eatery/pages/create_company/create_company.page.dart';
import 'package:eatery/pages/dashboard/dashboard.page.dart';
import 'package:eatery/pages/dashboard/pos/pos.page.dart';
import 'package:eatery/pages/dashboard/pos/order_confirmation.page.dart';
import 'package:eatery/pages/dashboard/utility/order_print.page.dart';
import 'package:eatery/pages/dashboard/order/orders.page.dart';
import 'package:eatery/pages/dashboard/order/view.order.page.dart';
import 'package:eatery/pages/dashboard/order/edit.order.page.dart';
import 'package:eatery/pages/dashboard/payment/payments.page.dart';
import 'package:eatery/pages/dashboard/payment/add.payment.page.dart';
import 'package:eatery/pages/dashboard/payment/view.payment.page.dart';
import 'package:eatery/pages/dashboard/payment/edit.payment.page.dart';
import 'package:eatery/pages/dashboard/customer/customers.page.dart';
import 'package:eatery/pages/dashboard/customer/add.customer.page.dart';
import 'package:eatery/pages/dashboard/customer/view.customer.page.dart';
import 'package:eatery/pages/dashboard/customer/edit.customer.page.dart';
import 'package:eatery/pages/dashboard/dining_table/dining_tables.page.dart';
import 'package:eatery/pages/dashboard/dining_table/add.dining_table.page.dart';
import 'package:eatery/pages/dashboard/dining_table/view.dining_table.page.dart';
import 'package:eatery/pages/dashboard/dining_table/edit.dining_table.page.dart';
import 'package:eatery/pages/dashboard/dining_table/category/dining_table.categories.page.dart';
import 'package:eatery/pages/dashboard/dining_table/category/add.dining_table.category.page.dart';
import 'package:eatery/pages/dashboard/dining_table/category/edit.dining_table.category.page.dart';
import 'package:eatery/pages/dashboard/product/kitchen_dishes/kitchen_dishes.page.dart';
import 'package:eatery/pages/dashboard/product/kitchen_dishes/add.kitchen_dish.page.dart';
import 'package:eatery/pages/dashboard/product/kitchen_dishes/edit.kitchen_dish.page.dart';
import 'package:eatery/pages/dashboard/product/inventory_item/inventory_items.page.dart';
import 'package:eatery/pages/dashboard/product/inventory_item/add.inventory_item.page.dart';
import 'package:eatery/pages/dashboard/product/inventory_item/edit.inventory_item.page.dart';
import 'package:eatery/pages/dashboard/product/category/product.categories.page.dart';
import 'package:eatery/pages/dashboard/product/category/add.product.category.page.dart';
import 'package:eatery/pages/dashboard/product/category/edit.product.category.page.dart';
import 'package:eatery/pages/dashboard/settings/settings.page.dart';
import 'package:eatery/pages/dashboard/settings/company/view.company.page.dart';
import 'package:eatery/pages/dashboard/settings/company/edit.company.page.dart';
import 'package:eatery/pages/dashboard/settings/printer/printer.setting.page.dart';
import 'package:eatery/pages/dashboard/settings/tax_slab/tax_slabs.page.dart';
import 'package:eatery/pages/dashboard/settings/tax_slab/add.tax_slab.page.dart';
import 'package:eatery/pages/dashboard/settings/tax_slab/edit.tax_slab.page.dart';
import 'package:eatery/pages/dashboard/settings/currency_region/view.currency_region.page.dart';
import 'package:eatery/pages/dashboard/employees/employees.page.dart';
import 'package:eatery/pages/dashboard/employees/add.employee.page.dart';
import 'package:eatery/pages/dashboard/employees/edit.employee.page.dart';
import 'package:eatery/pages/setup/setup.page.dart';
import 'package:eatery/pages/dashboard/help/help.page.dart';
import 'package:eatery/pages/dashboard/reports/reports.page.dart';
import 'package:eatery/pages/dashboard/reservations/reservations.page.dart';
import 'package:eatery/pages/dashboard/reservations/add_reservation.page.dart';
import 'package:eatery/pages/dashboard/inventory/suppliers.page.dart';
import 'package:eatery/pages/dashboard/inventory/add_supplier.page.dart';
import 'package:eatery/pages/dashboard/inventory/purchase_orders.page.dart';
import 'package:eatery/pages/dashboard/settings/discount/discounts.page.dart';
import 'package:eatery/pages/dashboard/settings/discount/add_discount.page.dart';
import 'package:eatery/pages/dashboard/settings/modifier/modifier_groups.page.dart';
import 'package:eatery/pages/dashboard/settings/modifier/add_modifier_group.page.dart';
import 'package:eatery/pages/dashboard/settings/modifier/edit_modifier_group.page.dart';
import 'package:eatery/pages/dashboard/data/data_management.page.dart';
import 'package:eatery/pages/dashboard/data/export.page.dart';
import 'package:eatery/pages/dashboard/data/import.page.dart';
import 'package:eatery/pages/activation/upgrade.page.dart';
import 'package:eatery/pages/authentication/reset-pin.dart';
import 'package:eatery/pages/authentication/logout.page.dart';
import 'package:eatery/pages/waiter/orders_page.dart' as waiter_orders;
import 'package:eatery/pages/waiter/table_page.dart';
import 'package:eatery/pages/waiter/menu_page.dart';
import 'package:eatery/pages/waiter/cart_page.dart' as waiter_cart;
import 'package:eatery/pages/dashboard/pos/cart.page.dart' as admin_cart;
import 'package:eatery/pages/kds/ticket_page.dart';
import 'package:eatery/pages/display/display_page.dart';
import 'package:eatery/pages/role_picker.page.dart';
import 'package:eatery/dev/database_inspector.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:go_router/go_router.dart';

// ── RBAC permission map ──────────────────────────────────────────
/// Maps each device role to the set of route names it may access.
const _rolePermissions = <String, Set<String>>{
  'admin': {'*'},
  'waiter': {
    'tables',
    'menu',
    'cart',
    'waiterOrders',
    'orders',
    'viewOrder',
    'orderConfirmation',
    'orderPrint',
    'customers',
    'viewCustomer',
    'login',
    'logout',
    'resetPin',
    'mainScreen',
  },
  'kds': {'kds', 'viewOrder', 'orderConfirmation'},
  'display': {'display', 'viewOrder'},
};

/// The home route for each role (used as redirect target on unauthorized).
const _roleHome = <String, String>{
  'admin': '/dashboard',
  'waiter': '/tables',
  'kds': '/kds',
  'display': '/display',
};

GoRouter createAppRouter(EateryDatabase db, {EateryStore? store}) {
  final router = GoRouter(
    initialLocation: db.hasCompany ? '/login' : '/',
    routes: [
      // ── Public / onboarding routes ──────────────────────────────
      GoRoute(
        name: 'rolePicker',
        path: '/role-picker',
        builder: (context, state) => const RolePickerPage(),
      ),
      GoRoute(
        name: 'setup',
        path: '/setup',
        builder: (context, state) => const SetupPage(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'mainScreen',
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        name: 'createCompany',
        path: '/create-company',
        builder: (context, state) => const CreateCompanyPage(),
      ),
      GoRoute(
        name: 'resetPin',
        path: '/reset-pin',
        builder: (context, state) => const ResetPinScreen(),
      ),
      GoRoute(
        name: 'logout',
        path: '/logout',
        builder: (context, state) => const LogoutPage(),
      ),

      // ── Role-specific routes ────────────────────────────────────
      GoRoute(
        name: 'kds',
        path: '/kds',
        builder: (context, state) => const TicketPage(),
      ),
      GoRoute(
        name: 'display',
        path: '/display',
        builder: (context, state) => const DisplayPage(),
      ),
      GoRoute(
        name: 'tables',
        path: '/tables',
        builder: (context, state) => const TablePage(),
      ),
      GoRoute(
        name: 'waiterOrders',
        path: '/waiter-orders',
        builder: (context, state) => const waiter_orders.WaiterOrdersPage(),
      ),
      GoRoute(
        name: 'menu',
        path: '/menu',
        builder: (context, state) => const MenuPage(),
      ),
      GoRoute(
        name: 'cart',
        path: '/cart',
        builder: (context, state) => const waiter_cart.CartPage(),
      ),

      // ── Admin routes ────────────────────────────────────────────
      GoRoute(
        name: 'dashboard',
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        name: 'pos',
        path: '/pos',
        builder: (context, state) => const PointOfSalePage(),
      ),
      GoRoute(
        name: 'adminCart',
        path: '/admin-cart',
        builder: (context, state) => const admin_cart.CartPage(),
      ),
      GoRoute(
        name: 'orderConfirmation',
        path: '/order-confirmation',
        builder: (context, state) {
          final order = state.extra as dynamic;
          return OrderConfirmationPage(order: order);
        },
      ),
      GoRoute(
        name: 'orderPrint',
        path: '/order-print',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OrderPrintPage(
            order: extra?['order'],
            currentCart:
                (extra?['currentCart'] as List?)?.cast<Product>() ?? const [],
            printKOT: extra?['printKOT'] as bool? ?? false,
            printInvoice: extra?['printInvoice'] as bool? ?? true,
          );
        },
      ),
      GoRoute(
        name: 'orders',
        path: '/orders',
        builder: (context, state) => const OrdersPage(),
      ),
      GoRoute(
        name: 'viewOrder',
        path: '/orders/view',
        builder: (context, state) {
          final order = state.extra as dynamic;
          return ViewOrderPage(order: order);
        },
      ),
      GoRoute(
        name: 'editOrder',
        path: '/orders/edit',
        builder: (context, state) {
          final order = state.extra as dynamic;
          return EditOrderPage(order: order);
        },
      ),
      GoRoute(
        name: 'payments',
        path: '/payments',
        builder: (context, state) => const PaymentsPage(),
      ),
      GoRoute(
        name: 'addPayment',
        path: '/payments/add',
        builder: (context, state) => const AddPaymentPage(),
      ),
      GoRoute(
        name: 'viewPayment',
        path: '/payments/view',
        builder: (context, state) {
          final payment = state.extra as dynamic;
          return ViewPaymentPage(payment: payment);
        },
      ),
      GoRoute(
        name: 'editPayment',
        path: '/payments/edit',
        builder: (context, state) {
          final payment = state.extra as dynamic;
          return EditPaymentPage(payment: payment);
        },
      ),
      GoRoute(
        name: 'customers',
        path: '/customers',
        builder: (context, state) => const CustomersPage(),
      ),
      GoRoute(
        name: 'addCustomer',
        path: '/customers/add',
        builder: (context, state) => const AddCustomerPage(),
      ),
      GoRoute(
        name: 'viewCustomer',
        path: '/customers/view',
        builder: (context, state) {
          final customer = state.extra as dynamic;
          return ViewCustomer(customer: customer);
        },
      ),
      GoRoute(
        name: 'editCustomer',
        path: '/customers/edit',
        builder: (context, state) {
          final customer = state.extra as dynamic;
          return EditCustomerPage(customer: customer);
        },
      ),
      GoRoute(
        name: 'diningTables',
        path: '/dining-tables',
        builder: (context, state) => const DiningTablesPage(),
      ),
      GoRoute(
        name: 'addDiningTable',
        path: '/dining-tables/add',
        builder: (context, state) => const AddDiningTablePage(),
      ),
      GoRoute(
        name: 'viewDiningTable',
        path: '/dining-tables/view',
        builder: (context, state) {
          final diningTable = state.extra as dynamic;
          return ViewDiningTablePage(diningTable: diningTable);
        },
      ),
      GoRoute(
        name: 'editDiningTable',
        path: '/dining-tables/edit',
        builder: (context, state) {
          final diningTable = state.extra as dynamic;
          return EditDiningTablePage(diningTable: diningTable);
        },
      ),
      GoRoute(
        name: 'diningTableCategories',
        path: '/dining-table-categories',
        builder: (context, state) => const DiningTableCategoriesPage(),
      ),
      GoRoute(
        name: 'addDiningTableCategory',
        path: '/dining-table-categories/add',
        builder: (context, state) => const AddDiningTableCategoryPage(),
      ),
      GoRoute(
        name: 'editDiningTableCategory',
        path: '/dining-table-categories/edit',
        builder: (context, state) {
          final category = state.extra as dynamic;
          return EditDiningTableCategoryPage(category: category);
        },
      ),
      GoRoute(
        name: 'kitchenDishes',
        path: '/kitchen-dishes',
        builder: (context, state) => const KitchenPage(),
      ),
      GoRoute(
        name: 'addKitchenDish',
        path: '/kitchen-dishes/add',
        builder: (context, state) => const AddKitchenDish(),
      ),
      GoRoute(
        name: 'editKitchenDish',
        path: '/kitchen-dishes/edit',
        builder: (context, state) {
          final product = state.extra as dynamic;
          return EditKitchenDishPage(product: product);
        },
      ),
      GoRoute(
        name: 'inventoryItems',
        path: '/inventory-items',
        builder: (context, state) => const InventoryItemsPage(),
      ),
      GoRoute(
        name: 'addInventoryItem',
        path: '/inventory-items/add',
        builder: (context, state) => const AddInventoryItem(),
      ),
      GoRoute(
        name: 'editInventoryItem',
        path: '/inventory-items/edit',
        builder: (context, state) {
          final product = state.extra as dynamic;
          return EditInventoryItemPage(product: product);
        },
      ),
      GoRoute(
        name: 'productCategories',
        path: '/product-categories',
        builder: (context, state) => const ProductCategoriesPage(),
      ),
      GoRoute(
        name: 'addProductCategory',
        path: '/product-categories/add',
        builder: (context, state) => const AddProductCategoryPage(),
      ),
      GoRoute(
        name: 'editProductCategory',
        path: '/product-categories/edit',
        builder: (context, state) {
          final category = state.extra as dynamic;
          return EditProductCategoryPage(category: category);
        },
      ),
      GoRoute(
        name: 'settings',
        path: '/settings',
        builder: (context, state) => const SettingPage(),
      ),
      GoRoute(
        name: 'help',
        path: '/help',
        builder: (context, state) => const HelpPage(),
      ),
      GoRoute(
        name: 'companySettings',
        path: '/settings/company',
        builder: (context, state) => const ShowCompanyPage(),
      ),
      GoRoute(
        name: 'editCompany',
        path: '/settings/company/edit',
        builder: (context, state) => const EditCompanyPage(),
      ),
      GoRoute(
        name: 'printerSettings',
        path: '/settings/printers',
        builder: (context, state) => const PrinterSettingsPage(),
      ),
      GoRoute(
        name: 'taxSlabs',
        path: '/settings/tax-slabs',
        builder: (context, state) => const TaxSlabsSettingsPage(),
      ),
      GoRoute(
        name: 'addTaxSlab',
        path: '/settings/tax-slabs/add',
        builder: (context, state) => const AddTaxSlabSettingsPage(),
      ),
      GoRoute(
        name: 'editTaxSlab',
        path: '/settings/tax-slabs/edit',
        builder: (context, state) {
          final taxSlab = state.extra as dynamic;
          return EditTaxSlabSettingsPage(taxSlab: taxSlab);
        },
      ),
      GoRoute(
        name: 'currencyRegion',
        path: '/settings/currency',
        builder: (context, state) => const ShowCurrencyRegionPage(),
      ),
      GoRoute(
        name: 'modifierGroups',
        path: '/settings/modifier-groups',
        builder: (context, state) => const ModifierGroupsPage(),
      ),
      GoRoute(
        name: 'addModifierGroup',
        path: '/settings/modifier-groups/add',
        builder: (context, state) => const AddModifierGroupPage(),
      ),
      GoRoute(
        name: 'editModifierGroup',
        path: '/settings/modifier-groups/edit',
        builder: (context, state) {
          final group = state.extra as ModifierGroup;
          return EditModifierGroupPage(group: group);
        },
      ),
      GoRoute(
        name: 'discounts',
        path: '/settings/discounts',
        builder: (context, state) => const DiscountsPage(),
      ),
      GoRoute(
        name: 'addDiscount',
        path: '/settings/discounts/add',
        builder: (context, state) => const AddDiscountPage(),
      ),
      GoRoute(
        name: 'editDiscount',
        path: '/settings/discounts/edit',
        builder: (context, state) {
          final discount = state.extra as Discount;
          return AddDiscountPage(discount: discount);
        },
      ),
      GoRoute(
        name: 'suppliers',
        path: '/suppliers',
        builder: (context, state) => const SuppliersPage(),
      ),
      GoRoute(
        name: 'addSupplier',
        path: '/suppliers/add',
        builder: (context, state) => const AddSupplierPage(),
      ),
      GoRoute(
        name: 'editSupplier',
        path: '/suppliers/edit',
        builder: (context, state) {
          final supplier = state.extra as Supplier;
          return AddSupplierPage(supplier: supplier);
        },
      ),
      GoRoute(
        name: 'purchaseOrders',
        path: '/purchase-orders',
        builder: (context, state) => const PurchaseOrdersPage(),
      ),
      GoRoute(
        name: 'reservations',
        path: '/reservations',
        builder: (context, state) => const ReservationsPage(),
      ),
      GoRoute(
        name: 'addReservation',
        path: '/reservations/add',
        builder: (context, state) => const AddReservationPage(),
      ),
      GoRoute(
        name: 'editReservation',
        path: '/reservations/edit',
        builder: (context, state) {
          final reservation = state.extra as Reservation;
          return AddReservationPage(reservation: reservation);
        },
      ),
      GoRoute(
        name: 'employees',
        path: '/employees',
        builder: (context, state) => const EmployeesPage(),
      ),
      GoRoute(
        name: 'addEmployee',
        path: '/employees/add',
        builder: (context, state) => const AddEmployeePage(),
      ),
      GoRoute(
        name: 'editEmployee',
        path: '/employees/edit',
        builder: (context, state) {
          final employee = state.extra as dynamic;
          return EditEmployeePage(employee: employee);
        },
      ),
      GoRoute(
        name: 'reports',
        path: '/reports',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        name: 'dataManagement',
        path: '/data',
        builder: (context, state) => const DataManagementPage(),
      ),
      GoRoute(
        name: 'import',
        path: '/data/import',
        builder: (context, state) => const ImportPage(),
      ),
      GoRoute(
        name: 'export',
        path: '/data/export',
        builder: (context, state) => const ExportPage(),
      ),
      GoRoute(
        name: 'databaseInspector',
        path: '/dev/db-inspector',
        builder: (context, state) => const DatabaseInspectorPage(),
      ),
      GoRoute(
        name: 'upgrade',
        path: '/upgrade',
        builder: (context, state) {
          final company = state.extra as dynamic;
          return UpgradePage(company: company);
        },
      ),
      GoRoute(
        name: 'productView',
        path: '/pos/product-view',
        builder: (context, state) {
          final product = state.extra as Product;
          return KProductView(product: product);
        },
      ),
    ],
    redirect: _rbacRedirect,
  );
  return router;
}

/// Role-based access control redirect guard.
///
/// Checks (1) role is set, (2) auth for employee roles, (3) route permissions.
String? _rbacRedirect(BuildContext context, GoRouterState state) {
  final container = ProviderScope.containerOf(context, listen: false);
  final role = container.read(roleProvider);
  final authEmployee = container.read(authSessionProvider);
  final routeName = state.name;
  final location = state.matchedLocation;

  // 1. No role set → show role picker, but allow setup/creation routes too.
  if (role == null) {
    if (routeName == 'rolePicker' ||
        routeName == 'login' ||
        routeName == 'mainScreen' ||
        routeName == 'setup' ||
        routeName == 'createCompany' ||
        routeName == 'resetPin') {
      return null;
    }
    return '/role-picker';
  }

  // 2. Root "/" redirects to role home.
  if (location == '/') {
    return _roleHome[role] ?? '/dashboard';
  }

  // 3. Kiosk roles (kds, display) — no auth, block unpermitted routes.
  if (role == 'kds' || role == 'display') {
    final permitted = _rolePermissions[role]!;
    // Deny unnamed routes or unpermitted named routes.
    if (routeName == null || !permitted.contains(routeName)) {
      return _roleHome[role] ?? '/$role';
    }
    return null; // allow
  }

  // 4. Employee roles (admin, waiter) — must be authenticated.
  if (authEmployee == null) {
    if (routeName == 'login' || routeName == 'mainScreen') return null;
    return '/login';
  }

  // 5. If already authenticated on login, go home.
  if (routeName == 'login') {
    return _roleHome[role] ?? '/dashboard';
  }

  // 6. Admin wildcard — allow everything.
  if (_rolePermissions[role]?.contains('*') ?? false) return null;

  // 7. Check specific permissions — deny unnamed routes.
  if (routeName == null ||
      !(_rolePermissions[role]?.contains(routeName) ?? false)) {
    return _roleHome[role] ?? '/dashboard';
  }

  return null; // allow
}
