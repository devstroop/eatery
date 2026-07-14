# Audit 10 — Missing Features

## Critical for Multi-App Vision

| # | Feature | Blocks |
|---|---------|--------|
| MF1 | **Per-staff PIN login** | Cannot distinguish which staff performed which action. Blocks Waiter app, reporting, accountability. |
| MF2 | **Order status lifecycle** (pending → preparing → ready → served) | Kitchen cannot acknowledge orders. Blocks KDS app entirely. |
| MF3 | **Staff ID on orders** | Cannot filter orders by waiter. Blocks waiter productivity reporting. |
| MF4 | **WebSocket transport** (SyncService._sendMessage) | No data flows between devices. Blocks all multi-app scenarios. |
| MF5 | **OpLog integration in repositories** | Sync layer exists but has no data to replicate. Blocks all multi-app scenarios. |
| MF6 | **Dining table floor plan** | Waiters need a visual table layout to work efficiently. Blocks Waiter app adoption. |

## Critical for Admin App Production Readiness

| # | Feature | Impact |
|---|---------|--------|
| MF7 | **Order edit page** | Currently a stub with empty labels. Cannot edit orders at all. |
| MF8 | **Order confirmation page** | Currently dead code with non-functional print/share buttons. |
| MF9 | **View order shows complete data** | Missing table name, order status, order items. |
| MF10 | **Pagination on all list pages** | `getAll*()` loads entire tables into memory. Performance degrades with scale. |

## Important for Restaurant Operations

| # | Feature | Impact |
|---|---------|--------|
| MF11 | **Sales reports** (Z-report, X-report) | Required for tax compliance. No way to close the day. |
| MF12 | **Inventory tracking** | No stock levels, no low-stock alerts, no purchase orders. |
| MF13 | **Dashboard charts** | No revenue visualization, no trends, no order volume data. |
| MF14 | **Dining table category display** | `DiningTable.category` is always null in SQLite repo. Table groups don't display. |
| MF15 | **Table capacity enforcement** | No check that party size fits table capacity. |

## Nice to Have

| # | Feature | Impact |
|---|---------|--------|
| MF16 | **Split payments** | Can't split bill across payment modes (cash + card). |
| MF17 | **Online ordering integration** | No API for accepting orders from online platforms. |
| MF18 | **Multi-location support** | No concept of multiple restaurant locations. |
| MF19 | **Customer loyalty/rewards** | No points, visits tracking, or rewards system. |
| MF20 | **Menu management** (bulk import, PDF menu) | Products must be added one by one. |
