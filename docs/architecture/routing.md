# Routing

## GoRouter Setup

Defined in `lib/core/router/app_router.dart`:

```dart
GoRouter createAppRouter(EateryDatabase db, {EateryStore? store}) {
  // Determine initial route based on company existence and password
  final router = GoRouter(
    initialLocation: db.hasCompany
        ? (password != null ? '/login' : '/dashboard')
        : '/',
    routes: [...],
    redirect: (context, state) {
      final authStaff = container.read(authSessionProvider);
      final isPublic = _publicRoutes.contains(state.name) || location == '/';
      if (authStaff == null && !isPublic) return '/login';
      if (authStaff != null && isPublic && location == '/login') return '/dashboard';
      return null;
    },
  );
  return router;
}
```

## Route Table

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
