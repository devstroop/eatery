# Issues & Backlog

## GitHub Issues (7 open)

The canonical backlog. File new issues on GitHub, track here.

| # | Priority | Title | Scope |
|---|----------|-------|-------|
| [#89](https://github.com/devstroop/eatery/issues/89) | 🔴 P0 | Hardcoded Google Drive OAuth credentials — published on public repo. Revoke + regenerate via GCP Console. | `services/cloud/google_drive.dart` |
| [#93](https://github.com/devstroop/eatery/issues/93) | 🟡 P2 | AppFileSystem duplicates Common directory logic — two systems, different path conventions. Consolidate into one. | `AppFileSystem`, `Common` class |
| [#96](https://github.com/devstroop/eatery/issues/96) | 🟡 P1 | Convert list screens (Customers, Staff, Orders, Payments) to responsive GridView — single-column ListView wastes desktop space. | 5 pages |
| [#97](https://github.com/devstroop/eatery/issues/97) | 🟠 P2 | Centralize theme via ThemeData — scaffold bg, AppBar, text styles from theme instead of per-page. | ~25 files |
| [#98](https://github.com/devstroop/eatery/issues/98) | 🟠 P2 | Desktop-friendly layouts — NavigationRail, hover states, keyboard shortcuts, window constraints. | Cross-cutting |
| [#100](https://github.com/devstroop/eatery/issues/100) | 🟠 P2 | POS product grid refactor — replace manual `Wrap` width calculation with `SliverGridDelegateWithMaxCrossAxisExtent`. | `pos.page.dart` |
| [#101](https://github.com/devstroop/eatery/issues/101) | 🟠 P2 | Login page vertical centering on desktop via `LayoutBuilder` + `Center`. | `login.page.dart` |

---

## Schema Hardening

All resolved in `schema.sql` + migration v10, 2026-07-16.

| # | Severity | Issue |
|---|----------|-------|
| **S01** | 🟢 Fixed | `DEFAULT 0` → `DEFAULT 1` in `schema.sql` + migration v10 for existing DBs. |
| **S02** | 🟢 Fixed | `CREATE INDEX idx_orders_status ON orders(status)` added to `schema.sql` + v10. |
| **S03** | 🟢 Fixed | `CREATE INDEX idx_orders_staff ON orders(staffId)` added to `schema.sql` + v10. |
| **S04** | 🟢 Fixed | `CREATE INDEX idx_orders_created ON orders(createdAt)` added to `schema.sql` + v10. |
| **S05** | 🟢 Fixed | `CREATE INDEX idx_reservation_datetime ON reservation(dateTime)` added to `schema.sql` + v10. |
| **S06** | 🟢 Fixed | `CREATE INDEX idx_reservation_table ON reservation(diningTableId)` added to `schema.sql` + v10. |
| **S07** | 🟢 Fixed | `CREATE INDEX idx_time_entry_staff ON time_entry(staffId)` added to `schema.sql` + v10. |
| **S08** | 🟢 Fixed | `CREATE INDEX idx_expense_date ON expense(expenseDate)` added to `schema.sql` + v10. |
| **S09** | 🟢 Fixed | `CREATE INDEX idx_stock_adj_product ON stock_adjustment(productId)` added to `schema.sql` + v10. |
| **S10** | 🟢 Fixed | Verified: Dart `OrderStatus` enum serializes via `.index` (0-5) → INTEGER. SQLite flexible typing accepts it in `TEXT` column. No mismatch at runtime. |
| **S17** | 🟢 Fixed | Added indices for `order_discount(orderId)`, `customer_loyalty(customerId)`, `loyalty_transaction(customerId)`, `supplier(phone)`, `purchase_order(supplierId)`, `purchase_order(status)`, `purchase_order_item(purchaseOrderId)` in `schema.sql` + v10. |

---

## Company Entity Gaps

C01-C06, C13 are resolved. Remaining:

| # | Priority | Issue |
|---|----------|-------|
| **C07** | 🟠 P2 | Address is flat text — split into `line1`, `city`, `state`, `pincode`, `country` for GST e-way compliance. |
| **C08** | 🟠 P2 | Missing `businessType`, `website`, `pan` fields — 80% ERP parity for lightweight additions. |
| **C09** | 🟠 P2 | No invoice configuration: `invoicePrefix`, `invoiceTerms`, `nextInvoiceNumber`. GST-compliant POS needs these. |
| **C10** | 🔵 P3 | No printer/hardware config — thermal printer IP, paper width, KOT count. |
| **C11** | 🔵 P3 | No business hours, timezone, default language. |
| **C12** | 🔵 P3 | No bank/UPI details for invoice print + settlement reconciliation. |
| **C14** | 🔵 P3 | Onboarding checklist post-setup — replaces 6-step wizard by deferring non-essential config. |
| **S19** | 🟡 P1 | No `createdAt`/`updatedAt` on `company` — root entity has no timestamps. |
| **S20** | 🟡 P1 | 20 tables need `companyId` FK for multi-outlet isolation. Currently 0 have it. |

---

## Staff → Employee Rename

E01-E03, E06 resolved. E04, E05, E07 remaining.

| # | Priority | Scope |
|---|----------|-------|
| **E01** | 🟢 Fixed | Schema: `staff` → `employee` table + all 6 FK `REFERENCES` clauses updated in `schema.sql`; 3 FK column renames (`staffId`→`employeeId`, `adminStaffId`→`adminEmployeeId`, `changedByStaffId`→`changedByEmployeeId`); migration v11 handles existing DBs via `ALTER TABLE RENAME` + `RENAME COLUMN`. |
| **E02** | 🟢 Fixed | Dart model: `Staff` → `Employee` across ~37 files (models, repositories, providers, widgets, pages, tests). |
| **E03** | 🟢 Fixed | Enum: `StaffType` → `EmployeeRole` with all references updated. |
| **E04** | 🟡 P1 | Add `email` to Dart model (exists in SQL, missing in Dart) |
| **E05** | 🟡 P1 | Add `pinUpdatedAt`, `lastLoginAt` to Dart model |
| **E06** | 🟢 Fixed | Pages directory: `staff/` → `employees/`, files renamed (`staffs.page`→`employees.page`, `add.staff.page`→`add.employee.page`, `edit.staff.page`→`edit.employee.page`); routes `/staffs` → `/employees`. |
| **E07** | 🟠 P2 | Add `EmployeeRole.manager` enum value |

---

## Smoke Tests

| # | Scenario | Expected |
|---|----------|----------|
| S1 | First launch — fresh install | Role picker with 3 options |
| S2 | Pick "I'm Staff" | Redirected to `/login`, role persists across restarts |
| S3 | Login as admin (phone `555-0100`, PIN `1234`) | `/dashboard` with full admin menu |
| S4 | Login as waiter (phone `555-0101`, PIN `1111`) | `/tables` with waiter view |
| S5 | Pick "Kitchen Display" | KDS ticket grid, no login |
| S6 | Pick "Customer Display" | Order status display, no login |
| S7 | `--dart-define=role=display` | Skips picker, directly to display |
| S8 | Waiter navigates to `/settings` | Redirected to `/tables` + "Access denied" |
| S9 | KDS navigates to `/pos` | Redirected to `/kds` + "Access denied" |
| S10 | Display navigates to `/customers` | Redirected to `/display` + "Access denied" |
| S11 | Admin navigates to any route | All routes accessible |
| S12 | Android build `flutter build apk --debug` | APK produced |
| S13 | iOS build `flutter build ios --no-codesign` | Build succeeds |
| S14 | macOS build `flutter build macos --debug` | Build succeeds |
