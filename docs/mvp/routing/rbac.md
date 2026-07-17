# Routing & RBAC

Single `GoRouter` in `lib/core/router/app_router.dart`. ~76 routes across 3 device roles + 1 sub-role.

## Role Dispatch

On first launch, `device_role` is null → shown `RolePickerPage`. Once set, persisted in SQLite.

## RBAC Permission Map

Two distinct role systems exist in the codebase:

1. **Device roles** (`DeviceRole` enum in `role_picker.page.dart`): `admin`, `kds`, `display` — chosen once at first launch, determines the UI shell.
2. **RBAC roles** (`roleProvider`): `admin`, `waiter`, `kds`, `display` — used by the router guard. `waiter` is a sub-role of the `admin` device, set after PIN login.

```dart
const _rolePermissions = {
  'admin':   {'*'},                                          // all routes
  'waiter':  {'tables', 'menu', 'cart', 'waiterOrders',
              'orders', 'viewOrder', 'orderConfirmation',
              'orderPrint', 'customers', 'viewCustomer',
              'login', 'logout', 'resetPin', 'mainScreen'},
  'kds':     {'kds', 'viewOrder', 'orderConfirmation', 'rolePicker'},
  'display': {'display', 'viewOrder', 'rolePicker'},
};
```

## Redirect Logic

The `_rbacRedirect` function in `app_router.dart` applies these checks in order:

```
1. No role set -> /role-picker (except public routes below)
2. Public routes accessible to ALL roles regardless of permissions:
     rolePicker, login, mainScreen, setup, createCompany, resetPin
3. Root "/" redirects to role home
4. Kiosk (kds/display) -> no auth required, block unpermitted -> redirect to role home
5. Staff (admin/waiter) -> must be authenticated -> /login if not
6. Already authenticated on /login -> redirect to role home
7. Admin wildcard '*' -> allow all
8. Others -> check permissions -> redirect to role home if blocked
```

Public routes (`/role-picker`, `/login`, `/`, `/setup`, `/create-company`, `/reset-pin`) are always accessible — no authentication or permission check is applied.

## Role Home Routes

| Role | Home |
|------|------|
| `admin` | `/dashboard` (or `/login`) |
| `waiter` | `/tables` |
| `kds` | `/kds` |
| `display` | `/display` |
| `null` | `/role-picker` |

## Route Table

### Public / Auth

| Name | Path | Page |
|------|------|------|
| `mainScreen` | `/` | `MainScreen` |
| `setup` | `/setup` | `SetupPage` |
| `createCompany` | `/create-company` | `CreateCompanyPage` |
| `login` | `/login` | `LoginPage` |
| `resetPin` | `/reset-pin` | `ResetPinScreen` |
| `logout` | `/logout` | `LogoutPage` |
| `rolePicker` | `/role-picker` | `RolePickerPage` |

### Admin

| Name | Path | Page |
|------|------|------|
| `dashboard` | `/dashboard` | `DashboardPage` |
| `pos` | `/pos` | `PointOfSalePage` |
| `adminCart` | `/admin-cart` | `CartPage` |
| `orders` | `/orders` | `OrdersPage` |
| `viewOrder` | `/orders/:id` | `ViewOrderPage` |
| `editOrder` | `/orders/:id/edit` | `EditOrderPage` |
| `payments` | `/payments` | `PaymentsPage` |
| `addPayment` | `/payments/add` | `AddPaymentPage` |
| `customers` | `/customers` | `CustomersPage` |
| `productCategories` | `/product-categories` | `ProductCategoriesPage` |
| `kitchenDishes` | `/kitchen-dishes` | `KitchenDishesPage` |
| `inventoryItems` | `/inventory-items` | `InventoryItemsPage` |
| `diningTables` | `/dining-tables` | `DiningTablesPage` |
| `employees` | `/employees` | `EmployeesPage` |
| `settings` | `/settings` | `SettingsPage` |
| `reports` | `/reports` | `ReportsPage` |
| `reservations` | `/reservations` | `ReservationsPage` |
| `data` | `/data` | `DataManagementPage` |
| `orderConfirmation` | `/order-confirmation` | `OrderConfirmationPage` |
| `orderPrint` | `/order-print` | `OrderPrintPage` |

### Waiter (subset shared with admin)

Waiter has access to these routes via the permission map — some are shared with the admin route table.

| Name | Path | Page |
|------|------|------|
| `tables` | `/tables` | `TablePage` |
| `menu` | `/menu` | `MenuPage` |
| `cart` | `/cart` | `CartPage` (waiter) |
| `waiterOrders` | `/waiter-orders` | `WaiterOrdersPage` |
| `orders` | `/orders` | `OrdersPage` |
| `viewOrder` | `/orders/view` | `ViewOrderPage` |
| `orderConfirmation` | `/order-confirmation` | `OrderConfirmationPage` |
| `orderPrint` | `/order-print` | `OrderPrintPage` |
| `customers` | `/customers` | `CustomersPage` |
| `viewCustomer` | `/customers/view` | `ViewCustomerPage` |
| `login` | `/login` | `LoginPage` |
| `logout` | `/logout` | `LogoutPage` |
| `resetPin` | `/reset-pin` | `ResetPinScreen` |
| `mainScreen` | `/` | `MainScreen` |

### Kiosk

| Name | Path | Page |
|------|------|------|
| `kds` | `/kds` | `TicketPage` (KDS) |
| `display` | `/display` | `DisplayPage` |
| `viewOrder` | `/orders/view` | `ViewOrderPage` |
| `orderConfirmation` | `/order-confirmation` | `OrderConfirmationPage` (kds only) |
| `rolePicker` | `/role-picker` | `RolePickerPage` |

## Navigation Patterns

```dart
// Named push
context.pushNamed('pos')
GoRouter.of(context).pushNamed('viewOrder', extra: order)

// Named go (replaces stack)
context.goNamed('dashboard')
GoRouter.of(context).goNamed('login')

// After push, refresh on return
GoRouter.of(context).pushNamed('adminCart').then((_) => setState(() {}))
```

## Adding a Route

1. Create page in `lib/pages/dashboard/.../`
2. Import in `app_router.dart`
3. Add `GoRoute` entry with `name` and `path`
4. Add to `_rolePermissions` if restricted
