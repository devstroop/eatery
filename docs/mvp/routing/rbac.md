# Routing & RBAC

Single `GoRouter` in `lib/core/router/app_router.dart`. ~50 routes across 4 roles.

## Role Dispatch

On first launch, `device_role` is null → shown `RolePickerPage`. Once set, persisted in SQLite.

## RBAC Permission Map

```dart
const _rolePermissions = {
  'admin':   {'*'},                                          // all routes
  'waiter':  {'tables', 'menu', 'cart', 'waiterOrders',
              'orders', 'viewOrder', 'orderConfirmation',
              'orderPrint', 'customers', 'viewCustomer',
              'login', 'logout'},
  'kds':     {'kds', 'viewOrder', 'orderConfirmation'},
  'display': {'display', 'viewOrder'},
};
```

## Redirect Logic

```
1. No role → /role-picker
2. Kiosk (kds/display) → no auth, block unpermitted → redirect to role home
3. Staff (admin/waiter) → must be authenticated → /login if not
4. Admin wildcard '*' → allow all
5. Others → check permissions → redirect to role home if blocked
```

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

| Name | Path | Page |
|------|------|------|
| `tables` | `/tables` | `TablePage` |
| `menu` | `/menu` | `MenuPage` |
| `cart` | `/cart` | `CartPage` (waiter) |
| `waiterOrders` | `/waiter-orders` | `WaiterOrdersPage` |

### Kiosk

| Name | Path | Page |
|------|------|------|
| `kds` | `/kds` | `TicketPage` (KDS) |
| `display` | `/display` | `DisplayPage` |

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
