# Routing

## GoRouter Setup (Target: Single-App with RBAC)

> **Status:** The current router in `lib/core/router/app_router.dart` is admin-only with simple auth redirect. The RBAC guard and merged routes are planned — see [ISSUES.md](../../ISSUES.md).

A single unified `GoRouter` handles all four roles. The router is created by `createAppRouter()` in `lib/core/router/app_router.dart` and includes:

- ~50 routes covering Admin, Waiter, KDS, and Display UIs
- Role-based access control via `_rolePermissions` map
- First-launch redirect to `RolePicker` when no `device_role` is set
- Auth bypass for kiosk roles (`kds`, `display`)

### RBAC Redirect Guard

```dart
const _rolePermissions = {
  'admin':   {'*'},
  'waiter':  {'tables', 'menu', 'cart', 'orders', 'viewOrder',
              'orderConfirmation', 'orderPrint', 'customers', 'viewCustomer'},
  'kds':     {'kds', 'viewOrder', 'orderConfirmation'},
  'display': {'display', 'viewOrder'},
};

GoRouter(
  routes: [...],
  redirect: (context, state) {
    final role = container.read(roleProvider);
    final authStaff = container.read(authSessionProvider);
    final routeName = state.name;

    // 1. No role set → picker
    if (role == null) return '/role-picker';

    // 2. Kiosk roles (display/kds) — no auth, permission check only
    if (role == 'kds' || role == 'display') {
      if (!_rolePermissions[role]!.contains(routeName)) return '/$role';
      return null; // allow
    }

    // 3. Staff roles — must be authenticated
    if (authStaff == null) return '/login';

    // 4. Admin wildcard — allow all
    if (_rolePermissions[role]!.contains('*')) return null;

    // 5. Check specific permissions
    if (!_rolePermissions[role]!.contains(routeName)) {
      // Show toast & redirect to role home
      return _roleHome[role];
    }
    return null; // allow
  },
);
```

### Role Home Routes

| Role | Home Route |
|------|-----------|
| `admin` | `/dashboard` (`/login` if unauthenticated) |
| `waiter` | `/tables` |
| `kds` | `/kds` |
| `display` | `/display` |
| `null` | `/role-picker` |

### Current Route Table (Admin)

The existing admin router has the following routes. In the unified router, routes from waiter/KDS/display sub-apps are absorbed (see [ISSUES.md](../../ISSUES.md) issues 07-09).

| Name | Path | Page |
|------|------|------|
| `setup` | `/setup` | SetupPage |
| `login` | `/login` | LoginPage |
| `mainScreen` | `/` | MainScreen (onboarding) |
| `createCompany` | `/create-company` | CreateCompanyPage |
| `resetPin` | `/reset-pin` | ResetPinScreen |
| `logout` | `/logout` | LogoutPage |
| `dashboard` | `/dashboard` | DashboardPage |
| `pos` | `/pos` | PointOfSalePage |
| `cart` | `/cart` | CartPage |
| `orderConfirmation` | `/order-confirmation` | OrderConfirmationPage |
| `orderPrint` | `/order-print` | OrderPrintPage |
| `orders` | `/orders` | OrdersPage |
| `viewOrder` | `/orders/view` | ViewOrderPage |
| `editOrder` | `/orders/edit` | EditOrderPage |
| `payments` | `/payments` | PaymentsPage |
| `addPayment` | `/payments/add` | AddPaymentPage |
| `viewPayment` | `/payments/view` | ViewPaymentPage |
| `editPayment` | `/payments/edit` | EditPaymentPage |
| `customers` | `/customers` | CustomersPage |
| `addCustomer` | `/customers/add` | AddCustomerPage |
| `viewCustomer` | `/customers/view` | ViewCustomerPage |
| `editCustomer` | `/customers/edit` | EditCustomerPage |
| `diningTables` | `/dining-tables` | DiningTablesPage |
| `addDiningTable` | `/dining-tables/add` | AddDiningTablePage |
| `viewDiningTable` | `/dining-tables/view` | ViewDiningTablePage |
| `editDiningTable` | `/dining-tables/edit` | EditDiningTablePage |
| `diningTableCategories` | `/dining-table-categories` | DiningTableCategoriesPage |
| `addDiningTableCategory` | `/dining-table-categories/add` | AddDiningTableCategoryPage |
| `editDiningTableCategory` | `/dining-table-categories/edit` | EditDiningTableCategoryPage |
| `kitchenDishes` | `/kitchen-dishes` | KitchenDishesPage |
| `addKitchenDish` | `/kitchen-dishes/add` | AddKitchenDishPage |
| `editKitchenDish` | `/kitchen-dishes/edit` | EditKitchenDishPage |
| `inventoryItems` | `/inventory-items` | InventoryItemsPage |
| `addInventoryItem` | `/inventory-items/add` | AddInventoryItemPage |
| `editInventoryItem` | `/inventory-items/edit` | EditInventoryItemPage |
| `productCategories` | `/product-categories` | ProductCategoriesPage |
| `addProductCategory` | `/product-categories/add` | AddProductCategoryPage |
| `editProductCategory` | `/product-categories/edit` | EditProductCategoryPage |
| `settings` | `/settings` | SettingPage |
| `help` | `/help` | HelpPage |
| `companySettings` | `/settings/company` | ShowCompanyPage |
| `editCompany` | `/settings/company/edit` | EditCompanyPage |
| `printerSettings` | `/settings/printers` | PrinterSettingsPage |
| `taxSlabs` | `/settings/tax-slabs` | TaxSlabsSettingsPage |
| `addTaxSlab` | `/settings/tax-slabs/add` | AddTaxSlabSettingsPage |
| `editTaxSlab` | `/settings/tax-slabs/edit` | EditTaxSlabSettingsPage |
| `currencyRegion` | `/settings/currency` | ShowCurrencyRegionPage |
| `modifierGroups` | `/settings/modifier-groups` | ModifierGroupsPage |
| `addModifierGroup` | `/settings/modifier-groups/add` | AddModifierGroupPage |
| `editModifierGroup` | `/settings/modifier-groups/edit` | EditModifierGroupPage |
| `discounts` | `/settings/discounts` | DiscountsPage |
| `addDiscount` | `/settings/discounts/add` | AddDiscountPage |
| `suppliers` | `/suppliers` | SuppliersPage |
| `addSupplier` | `/suppliers/add` | AddSupplierPage |
| `editSupplier` | `/suppliers/edit` | EditSupplierPage |
| `purchaseOrders` | `/purchase-orders` | PurchaseOrdersPage |
| `reservations` | `/reservations` | ReservationsPage |
| `addReservation` | `/reservations/add` | AddReservationPage |
| `editReservation` | `/reservations/edit` | EditReservationPage |
| `staffs` | `/staffs` | StaffsPage |
| `addStaff` | `/staffs/add` | AddStaffPage |
| `editStaff` | `/staffs/edit` | EditStaffPage |
| `reports` | `/reports` | ReportsPage |
| `dataManagement` | `/data` | DataManagementPage |
| `import` | `/data/import` | ImportPage |
| `export` | `/data/export` | ExportPage |
| `databaseInspector` | `/dev/db-inspector` | (placeholder, accessed via dev menu) |
| `upgrade` | `/upgrade` | UpgradePage |
| `productView` | `/pos/product-view` | KProductView |

## Auth Redirect

The redirect is partially implemented:

```dart
const _publicRoutes = {'login', 'mainScreen', 'createCompany', 'resetPin', 'setup'};
```

- Unauthenticated users accessing non-public routes -> redirect to `/login`
- Authenticated users on `/login` -> redirect to `/dashboard`
- Permission-based routing (role matrix) is **not yet implemented** — any authenticated staff can access any route

## Migration Status

- GoRouter is set up with all routes defined
- Many pages still use raw `Navigator.push` (~81 call sites remaining)
- Migration target: replace all `Navigator.push` with named GoRouter routes via `context.goNamed('routeName')` or `context.pushNamed('routeName')`
- Pages that accept data pass entities via `state.extra`

## Dashboard Hub-and-Spoke

The dashboard uses a hub-and-spoke pattern — menu tiles push sub-pages via `Navigator.push`. Each sub-page is an `AppPageShell` with back navigation. No tab-based navigation exists yet (no `AppAdaptiveShell` usage outside of scaffolding).
