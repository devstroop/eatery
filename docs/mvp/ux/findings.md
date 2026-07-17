# UI/UX Findings

Live inspection via Flutter DevTools MCP (2026-07-18). Three review passes.

## Status Summary

| Priority | Total | Resolved | Open |
|----------|-------|----------|------|
| P1 | 4 | 4 ✅ | 0 |
| P2 | 10 | 6 ✅ | 4 🔴 |
| P3 | 4 | 1 ✅ | 3 🔴 |

## Resolved (11 issues)

| # | Area | Fix |
|---|------|-----|
| U01 | Login loading | `LinearProgressIndicator` → `AppSkeleton` (5 skeleton widgets) |
| U02 | Waiter tokens | All 4 waiter pages tokenized (`AppColors`/`AppSpacing`/`AppTypography`) |
| U03 | Cart empty | `Text('Cart is empty')` → `AppEmptyState` |
| U04 | Login button | Conditional: in-form on desktop, `BottomAppBar` on mobile |
| U05 | KDS home | Deleted dead `KdsHomePage`; router → `TicketPage` directly |
| U06 | Floor plan | Tokenized `FloorPlanWidget` (colors, text, spacing) |
| U07 | Waiter loading | `CircularProgressIndicator` → `AppSkeleton`/`AppSkeletonList` |
| U08 | Login center | `Alignment.topCenter` → `Alignment.center` |
| U12 | Main screen | `AppButton.destructive` → `AppButton.secondary` for "Try Demo" |
| U13 | Floor plan dup | Tokenized `_FloorPlanCanvas`; dynamic canvas sizing |
| U14 | Hardcoded sizes | Resolved with U13 |

## Open (7 issues)

### 🟠 P2 — Dashboard Tokenization (4 issues)

These affect **~50 files** in `lib/pages/dashboard/`. The waiter/login pages were fixed but the admin dashboard was never tokenized.

| # | Issue | Files | Detail |
|---|-------|-------|--------|
| **U15** | Raw `Colors.green`/`Colors.red` | 12 | Use `AppColors.success`/`AppColors.error` |
| **U16** | Raw `TextStyle(fontSize: N)` | 7 | Use `AppTypography` tokens |
| **U17** | Raw `CircularProgressIndicator` | 11 | Use `AppSkeleton`/`AppSkeletonList` |
| **U18** | Raw `SizedBox`/`EdgeInsets` | 28 | Use `AppSpacing` tokens |

### 🔵 P3 — Nice-to-Have (3 issues)

| # | Issue |
|---|-------|
| U09 | No dark mode support |
| U10 | No custom page transitions or hero animations |
| U11 | POS init has 3 sequential dialogs (order type → table → customer) |

## Files Needing Tokenization (by category)

| Category | Files | Key Issues |
|----------|-------|------------|
| **POS** | `pos.page.dart`, `cart.page.dart`, `kProduct.view.dart` | Raw `TextStyle`, `Colors.green` |
| **Customers** | `view.customer.page.dart`, `search_customer.delegate.dart` | `Colors.green`, `CircularProgressIndicator` |
| **Orders** | `orders.page.dart`, `view.order.page.dart` | `CircularProgressIndicator`, raw spacing |
| **Dining Tables** | `dining_tables.page.dart`, `add.dining_table.page.dart`, `edit.dining_table.page.dart`, `search.dining_table.delegate.dart` | `Colors.green`, raw spacing |
| **Products** | `kitchen_dishes.page.dart`, `inventory_items.page.dart`, `product.categories.page.dart` | `Colors.green`, `Colors.red` |
| **Payments** | `add.payment.page.dart` | `Colors.green` |
| **Reports** | `reports.page.dart` | `CircularProgressIndicator` |
| **Settings** | `edit.company.page.dart`, `printer.setting.page.dart`, `discounts.page.dart` | `CircularProgressIndicator`, raw `TextStyle` |
| **Data** | `data_management.page.dart`, `import.page.dart` | Raw spacing |
| **Inventory** | `suppliers.page.dart`, `add_supplier.page.dart`, `purchase_orders.page.dart` | Raw spacing |
| **Reservations** | `reservations.page.dart`, `add_reservation.page.dart` | `Colors.green`, raw spacing |
| **Print** | `order_print.page.dart` | 6 raw `TextStyle` instances |
| **Other** | `create_company/components/body5.dart`, `dashboard_charts.dart` | Raw `TextStyle`, `CircularProgressIndicator` |

## Fix Pattern

For each file, replace:
```
Colors.green / Colors.red       → AppColors.success / AppColors.error
TextStyle(fontSize: N, ...)     → AppTypography.bodyMedium (or appropriate)
SizedBox(height: 16)            → AppSpacing.gapLg
EdgeInsets.all(12)              → EdgeInsets.all(AppSpacing.md)
CircularProgressIndicator()     → AppSkeletonList(count: N, itemHeight: M)
```
