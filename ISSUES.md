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

---

## Audit 2026-07-16 — Remaining Gaps

### Repository Coverage

17 SQL tables have repos. 9 do not:

| Table | Status | Notes |
|---|---|---|
| `kds_station` | ❌ No repo | KDS reads stations via `SqlitePreferenceStore` — not a standard repository. |
| `void_log_entry` | ❌ No repo | Used in order void flow but accessed ad-hoc through `eateryStore` raw queries. |
| `auto_print` | ❌ No repo | Frozen singleton config table. No CRUD interface. |
| `compliance_report` | ❌ No repo | Generated/read via dashboard — no formal repository layer. |
| `business_hours` | ❌ No repo | Exists in schema with no Dart access code. Purely dormant. |
| `holiday_hours` | ❌ No repo | Same — schema exists, no code reads or writes it. |
| `expense_category` | ❌ No repo | No pages, no repository. Purely dormant. |
| `expense` | ❌ No repo | No pages, no repository. Purely dormant. |
| `op_log` | ❌ No repo | Sync internals — intentional. |

### Naming Residues — Staff→Employee After E01-E03

| Location | Issue | Fix |
|---|---|---|
| `app_router.dart:594,627` | Variable `authStaff` still uses old naming | → `authEmployee` |
| `app_router.dart:626` | Comment "Staff roles (admin, waiter)" | → "Employee roles" |
| `app_router.dart:590` | Comment "auth for staff roles" | → "auth for employee roles" |
| `add.employee.page.dart:191` | Label "Select Staff Type" | → "Select Role" or "Employee Role" |
| `role_picker.page.dart:10` | Label "I'm Staff" | → "I'm an Employee" (or "Restaurant Staff" as domain-appropriate) |
| `AppColors.menuStaff` | Token name uses old naming | → `menuEmployees` or keep (just a color name) |
| `schema_migrator.dart:115,216,321` | Comments say "Staff" in migration descriptions | → "Employee" for consistency |

### Edition → Taxation Gap (N01-N04)

Still unresolved — see prior audit section. The file `edition.dart` contains enum `Taxation`. The SQL column is `edition` but Dart field is `taxation`. The `toMap()` hack bridges them at runtime.

| # | What | File |
|---|------|------|
| N01 | Rename SQL column `edition` → `taxation` | `schema.sql` + migration |
| N02 | Rename file `edition.dart` → `taxation.dart` | Dart model + `eatery_db.dart` |
| N03 | Rename `FoodType.EditionExtension` → `FoodType.FoodTypeExtension` | `food_type.dart` |
| N04 | Remove `toMap()` hack after column rename | `company.dart:52-56` |

### Schema Audit — Remaining (S11-S16, S21-S28)

| # | Severity | Issue |
|---|----------|-------|
| S11 | 🟠 P2 | No FK from `orders` to `customer` — relationship by phone convention only. |
| S12 | 🟠 P2 | Inconsistent FK patterns — implicit INTEGER, explicit CASCADE, explicit no-CASCADE coexist. |
| S13 | 🟠 P2 | `compliance_report` stores JSON blobs — can't query inside them. |
| S14 | 🔵 P3 | `auto_print` frozen singleton — no timestamps, no FK to printer. |
| S15 | 🔵 P3 | `shift` has no recurrence — can't say "Rajesh works morning Mon-Sat." |
| S16 | 🔵 P3 | `order_product.stationName` triple-denormalized with `product.stationId` + `product.stationName`. |
| S21 | 🟡 P1 | `orders.employeeId` + `orders.companyId` needed after rename. |
| S22 | 🟠 P2 | Missing company identity columns: `legalName`, `displayName`, `businessType`, `pan`, `website`. |
| S23 | 🟠 P2 | Missing structured address: `line1`, `city`, `state`, `pincode`. Flat `address` is GST-noncompliant. |
| S24 | 🟠 P2 | Missing invoice config: `invoicePrefix`, `nextInvoiceNo`, `invoiceTerms`, `invoiceFooter`. |
| S25 | 🟠 P2 | Missing ops config: `timezone`, `defaultLanguage`, `defaultOrderType`. |
| S26 | 🔵 P3 | Missing multi-outlet: `parentCompanyId`, `outletCode`, `outletType`, `isHeadOffice`. |
| S27 | 🔵 P3 | Missing soft-delete: `isActive`, `deletedAt` on `company`. |
| S28 | 🔵 P3 | `company.password` still in schema — plaintext anti-pattern (C02). |

### Employee Table Audit

| Gap | Detail |
|---|---|
| `employee.email` | Exists in SQL; MISSING from Dart `Employee` model (E04). |
| `employee.pinUpdatedAt` | Exists in SQL; MISSING from Dart model — needed for PIN expiry (E05). |
| `employee.lastLoginAt` | Exists in SQL; MISSING from Dart model — needed for audit (E05). `authenticateEmployee()` never updates it. |
| `employee.type` column name | Should be `role` to match `EmployeeRole` enum. Deferred — `ALTER TABLE RENAME COLUMN` would need migration v12. |

### Summary — Open Issues by Priority

```
P0 (3):  N01-N02 (edition→taxation column+file), router authStaff residue
P1 (7):  E04-E05 (employee model fields), S19 (company timestamps), 
         S20 (20 tables lack companyId), S21 (orders FK), S11 (no FK orders→customer)
P2 (10): N03-N04, S12-S13, S22-S25, C07-C09, employee type→role column
P3 (9):  S14-S16, S26-S28, C10-C12, C14
```
