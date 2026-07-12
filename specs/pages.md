# Page Directory

> Every screen in the app, its state management approach, and its data dependencies.

---

## Onboarding & Authentication (3 pages)

| Page | File | State | Deps |
|------|------|-------|------|
| **MainScreen** (onboarding) | `pages/main.screen.dart` | `StatefulWidget` | None (no login required) |
| **LoginPage** | `pages/authentication/login.page.dart` | `ConsumerStatefulWidget` | `companyRepositoryProvider`, `companyProvider`, `appDatabaseProvider` |
| **ResetPinScreen** | `pages/authentication/reset-pin.dart` | `StatefulWidget` | — |

**Flow:**
```
App starts → hasCompany? → Yes → LoginPage → DashboardPage
                         → No  → MainScreen → CreateCompanyPage → Result → LoginPage
```

---

## Dashboard (1 page)

| Page | File | State | Deps |
|------|------|-------|------|
| **DashboardPage** | `pages/dashboard/dashboard.page.dart` | `ConsumerStatefulWidget` | `companyProvider`, `cartProvider` |

Hub-and-spoke layout with menu tiles. Each tile navigates to a sub-page via `Navigator.push`. Desktop uses a responsive `Wrap` grid with calculated card widths.

---

## Products (10 pages)

| Page | State | Repository |
|------|-------|-----------|
| `product/category/product.categories.page` | `ConsumerStatefulWidget` | `ProductRepository` |
| `product/category/add.product.category.page` | `ConsumerStatefulWidget` | `ProductRepository` |
| `product/category/edit.product.category.page` | `ConsumerStatefulWidget` | `ProductRepository` |
| `product/inventory_item/inventory_items.page` | `ConsumerStatefulWidget` | `ProductRepository`, `CompanyProvider` |
| `product/inventory_item/add.inventory_item.page` | `ConsumerStatefulWidget` | `ProductRepository`, `TaxRepository` |
| `product/inventory_item/edit.inventory_item.page` | `ConsumerStatefulWidget` | `ProductRepository`, `TaxRepository` |
| `product/kitchen_dishes/kitchen_dishes.page` | `ConsumerStatefulWidget` | `ProductRepository`, `CompanyProvider` |
| `product/kitchen_dishes/add.kitchen_dish.page` | `ConsumerStatefulWidget` | `ProductRepository`, `TaxRepository` |
| `product/kitchen_dishes/edit.kitchen_dish.page` | `ConsumerStatefulWidget` | `ProductRepository`, `TaxRepository` |
| `product/search_product.delegate.dart` | `SearchDelegate` | (products passed in constructor) |

---

## POS / Orders (10 pages)

| Page | State | Repositories |
|------|-------|-------------|
| `pos/pos.page` | `ConsumerStatefulWidget` | Product, DiningTable, Customer, CartProvider, Company |
| `pos/cart.page` | `ConsumerStatefulWidget` | CartProvider, Company, Order, Customer |
| `pos/order_confirmation.page` | `ConsumerStatefulWidget` | Order, Customer, Company |
| `pos/views/kProduct.view` | `ConsumerStatefulWidget` | Company |
| `order/orders.page` | `ConsumerStatefulWidget` | Order, Company |
| `order/view.order.page` | `ConsumerStatefulWidget` | Order, Customer |
| `order/edit.order.page` | `StatefulWidget` | — |
| `order/search.order.delegate` | `SearchDelegate` | (orders + currency passed in) |
| `utility/order_print.page` | `ConsumerStatefulWidget` | Order, Customer, Company |
| `utility/image_library.page` | `StatefulWidget` | LibraryImageProvider |

---

## Customers (4 pages)

| Page | State | Repositories |
|------|-------|-------------|
| `customer/customers.page` | `ConsumerStatefulWidget` | Customer, Company |
| `customer/add.customer.page` | `ConsumerStatefulWidget` | Customer |
| `customer/edit.customer.page` | `ConsumerStatefulWidget` | Customer |
| `customer/view.customer.page` | `ConsumerStatefulWidget` | Customer, Order, Payment, Company |

---

## Payments (4 pages)

| Page | State | Repositories |
|------|-------|-------------|
| `payment/payments.page` | `ConsumerStatefulWidget` | Payment, Order, Company |
| `payment/add.payment.page` | `ConsumerStatefulWidget` | Payment, Order, DiningTable, Company |
| `payment/edit.payment.page` | `ConsumerStatefulWidget` | Payment, Order |
| `payment/view.payment.page` | `ConsumerStatefulWidget` | (reads from widget.payment) |

---

## Dining Tables (7 pages)

| Page | State | Repositories |
|------|-------|-------------|
| `dining_table/dining_tables.page` | `ConsumerStatefulWidget` | DiningTable, Order, appDatabase |
| `dining_table/add.dining_table.page` | `ConsumerStatefulWidget` | DiningTable, appDatabase |
| `dining_table/edit.dining_table.page` | `ConsumerStatefulWidget` | DiningTable, appDatabase |
| `dining_table/view.dining_table.page` | `ConsumerStatefulWidget` | Customer, Order, appDatabase |
| `dining_table/search.dining_table.delegate` | `SearchDelegate` | (tables + currency passed in) |
| `dining_table/category/dining_table.categories.page` | `ConsumerStatefulWidget` | appDatabase |
| `dining_table/category/add.category.page` | `ConsumerStatefulWidget` | appDatabase |
| `dining_table/category/edit.category.page` | `ConsumerStatefulWidget` | appDatabase |

---

## Staff (3 pages)

| Page | State | Repositories |
|------|-------|-------------|
| `staff/staffs.page` | `ConsumerStatefulWidget` | appDatabase |
| `staff/add.staff.page` | `ConsumerStatefulWidget` | appDatabase |
| `staff/edit.staff.page` | `ConsumerStatefulWidget` | appDatabase |

---

## Settings (10 pages)

| Page | State | Repositories |
|------|-------|-------------|
| `settings/settings.page` | `ConsumerStatefulWidget` | appDatabase |
| `settings/company/edit.company.page` | `ConsumerStatefulWidget` | appDatabase, Company |
| `settings/company/view.company.page` | `ConsumerStatefulWidget` | appDatabase, Company |
| `settings/currency_region/page` | `ConsumerStatefulWidget` | appDatabase, Company |
| `settings/tax_slab/tax_slabs.page` | `ConsumerStatefulWidget` | Tax |
| `settings/tax_slab/add.tax_slab.page` | `ConsumerStatefulWidget` | Tax |
| `settings/tax_slab/edit.tax_slab.page` | `ConsumerStatefulWidget` | (reads from widget) |
| `settings/printer/printer.setting.page` | `ConsumerStatefulWidget` | Printer, SharedPreferences |
| `data/data_management.page` | `ConsumerStatefulWidget` | appDatabase |
| `data/export.page` | `StatefulWidget` | — |
| `data/import.page` | `StatelessWidget` | — |

---

## Create Company (1 page + sub-components)

| Page | State | Deps |
|------|-------|------|
| `create_company/create_company.page` | `ConsumerStatefulWidget` | appDatabase |
| (Body1–Body6 sub-components) | Mixed | Passed via constructors |

Multi-step form wizard with 6 steps. Each step is a `Body{N}` widget. Tracks state via a `viewIndex` and `List<GlobalKey<FormState>>`.

---

## Backup / Restore (1 page)

| Page | State | Deps |
|------|-------|------|
| `backup_restore/backup_restore.page` | `ConsumerStatefulWidget` | appDatabase, GoogleDrive |

---

## Page Migration Status

| Pattern | Count | Status |
|---------|-------|--------|
| `ConsumerStatefulWidget` + `AppPageShell` | ~15 pages | ✅ Migrated |
| `ConsumerStatefulWidget` (raw Scaffold) | ~35 pages | 🟡 Uses Riverpod, not AppPageShell |
| `ConsumerStatefulWidget` + `SearchDelegate` | ~3 pages | ✅ Riverpod data passed via constructor |
| `StatefulWidget` (not migrated) | ~8 pages | 🔴 Still uses `setState` + direct box access |
| `StatelessWidget` helper components | ~12 | ✅ No state needed |

---

## Related Specs

- [Navigation & Responsive Design](responsive-design.md)
- [State Management](state-management.md)
