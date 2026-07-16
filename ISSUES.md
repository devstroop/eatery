# Issues & Technical Debt Tracker

**Global Status:** Phase 1 (28/28 ✅) | Company (3/14 ✅) | Employee Rename (0/7) | Schema Audit (1/17) | Company Table (0/11) | Edition→Taxation (0/4) | Cross-Cutting (0/40) | **Total: 32/121 ✅**

## Active Review Findings — 2026-07-16

> **Test gap:** 13 test files for 392 source files (30:1 ratio) — zero widget, migration, or integration tests
> **Security:** Plaintext company password + plaintext staff PIN comparison
> **Deps:** `gbk_codec` (Chinese encoding — dead dep?), `rxdart` (unused?), 40+ deps total
> **CI:** No iOS build, no coverage, `--no-fatal-infos` masks 300 issues
> **i18n:** Zero localization infrastructure for an Indian POS
> **Arch:** `pos.page.dart` at 1047 lines, `references.dart` barrel 154+ exports, 67 raw `Color(0x...)` remain

---

# Phase 1 — Single-App Architecture Unification (Complete)

> ✅ **All 28 issues complete.** See [Single-App Architecture](docs/architecture/single-app-architecture.md), [Routing](docs/architecture/routing.md), [Auth & Session](docs/architecture/auth-session.md). The original issue table and dependency graph are preserved in git history (`git show <pre-unification-commit>:ISSUES.md`).

> **Epic:** Merge 4 Melos sub-apps (Admin, Waiter, KDS, Display) into one Flutter binary with role-based UI dispatch, RBAC-protected routing, and unified sync initialization. Delete `apps/` entirely.
>
> ✅ **All 28 issues are completed.**

---

*Original issue table, dependency graph, architecture diagrams, and summary preserved in git history.*

---

## Smoke Test Checklist

| # | Scenario | Steps | Expected Result |
|---|----------|-------|-----------------|
| S1 | First launch | Fresh install → open app | Role picker screen appears with 3 options |
| S2 | Pick Staff role | Tap "I'm Staff" → role saved | Redirected to `/login`. Role persists across app restarts. |
| S3 | Staff login → admin | Login as admin (StaffType.admin). The login screen accepts **either** a name (`admin`) or phone (`555-0100`) plus PIN (`1234`). | Redirected to `/dashboard` with full admin menu |
| S4 | Staff login → waiter | Login as waiter (StaffType.waiter). Use name (`Waiter 1`) or phone (`555-0101`) plus PIN (`1111`). | Redirected to `/tables` with waiter view |
| S5 | Pick Kitchen Display | Tap "Kitchen Display" | Auto-starts KDS ticket grid. No login prompt. |
| S6 | Pick Customer Display | Tap "Customer Display" | Auto-starts order status display. No login prompt. |
| S7 | `--dart-define=role=display` | Launch with `flutter run --dart-define=role=display` | Skips role picker, goes directly to display |
| S8 | RBAC: waiter blocked | Login as waiter, manually navigate to `/settings` | Redirected to `/tables` with "Access denied" toast |
| S9 | RBAC: kds blocked | Launch as KDS, navigate to `/pos` | Redirected to `/kds` with "Access denied" toast |
| S10 | RBAC: display blocked | Launch as Display, navigate to `/customers` | Redirected to `/display` with "Access denied" toast |
| S11 | RBAC: admin unrestricted | Login as admin, navigate to any route | All routes accessible |
| S12 | Admin sync server | Login as admin, check sync status | `SyncService` reports `SyncRole.host`, WebSocket listening on port 9876 |
| S13 | Waiter sync client | Login as waiter on same LAN | mDNS discovers admin, connects as leaf, `SyncStatus` shows `connected` |
| S14 | KDS sync client | Launch KDS on same LAN | Connects to admin via mDNS, receives order broadcasts |
| S15 | Display sync client | Launch Display on same LAN | Connects to admin via mDNS, shows live order status |
| S16 | DB persistence | Add a product as admin, kill app, relaunch as admin | Product still present in the database |
| S17 | Role locked | After choosing display role, kill and relaunch app | Goes directly to display (no picker) |
| S18 | Reset role | Add a method or dev button to clear `device_role` | Role picker reappears on next launch |
| S19 | Android build | Run `flutter build apk --debug` | Build succeeds, APK is produced |
| S20 | iOS build (macOS host) | Run `flutter build ios --no-codesign` | Build succeeds without code signing errors |
| S21 | macOS build | Run `flutter build macos --debug` | Build succeeds, app launches on macOS |



---

# Company Entity Professionalization & Setup Flow Redesign

> **Date:** 2026-07-16
> **Background:** Audit of the Company model, creation flow, and edit UI against industry standards (Toast, TMBill, Odoo, Zoho Books). The current Company entity has 12 fields but only 6 are editable via the UI. The creation wizard collects 14+ fields in 6 steps — a 2015-era "collect everything upfront" anti-pattern. A competing `setup.page.dart` (2 fields, 30 seconds) already exists but the router still defaults to the 6-step wizard.

## Issue Table

| # | Issue | Severity | Description | Files |
|---|-------|----------|-------------|-------|
| **C01** | `adminStaffId` missing from Dart model | ✅ Fixed | Added `int? adminStaffId` to `Company` freezed factory, `fromIterable`, `toIterable`. Updated `saveCompany` INSERT and `_toCompany` mapper. `create_company.page.dart` now creates an admin staff and links via `adminStaffId`. | `company.dart`, `company_repository_sqlite.dart`, `create_company.page.dart` |
| **C02** | `company.password` is a security anti-pattern | ✅ Fixed | Removed `password` from `Company` freezed factory, `fromIterable`, `toIterable`, and `_toCompany` mapper. Removed from `saveCompany` INSERT. `create_company.page.dart` now uses the password as admin staff PIN instead of storing it on the company. `app_router.dart` changed from `password != null ? '/login' : '/dashboard'` to always go to `'/login'` when company exists. `view.company.page.dart` verifies delete PIN against staff table instead of `company.password`. *(Same issue as S28 below — C02 is the canonical entry.)* | `company.dart`, `company_repository_sqlite.dart`, `app_router.dart`, `create_company.page.dart`, `view.company.page.dart` |
| **C03** | `company.id = 1` hardcoded in saveCompany | ✅ Fixed | Replaced `VALUES (1,...)` with `VALUES (?,...)` using `company.id ?? (SELECT COALESCE(MAX(id), 0) + 1 FROM company)`. `company.copyWith(id: 1)` → `company.copyWith(id: id)`. `notifyMutation` now uses dynamic `id` instead of hardcoded `1`. | `company_repository_sqlite.dart` |
| **C04** | Logo cannot be saved after creation | 🟡 P1 | `edit.company.page.dart` has a `UploadButton` for logo and a `selectedLogo` field, but `saveCompany` via `copyWith` never includes `logo`. The `logo` field is set to `libraryImageLogo?.filename` only in `create_company._submitForm()`. After creation, the logo is permanently frozen. | `edit.company.page.dart` |
| **C05** | Taxation, currency, subscription — not editable | 🟡 P1 | The edit page shows these as read-only labels (or skips them entirely). `taxation` is an enum that can't be changed after creation. `currencyCode` has no UI element in the edit page. `subscriptionId` is never shown or editable. Users who picked "No Tax" during onboarding cannot enable GST later without deleting and recreating the company. | `edit.company.page.dart` |
| **C06** | Phone controller assigned twice in edit page | 🟡 P1 | `edit.company.page.dart` lines 35-36: `debugPrint(_controllerPhone.text = company!.phone);` appears twice. Dead code from a bad merge. | `lib/pages/dashboard/settings/company/edit.company.page.dart` |
| **C07** | Address is flat text — not structured | 🟠 P2 | `address` is a single `String`; industry standard splits into `line1`, `city`, `state`, `pincode`. This is a schema change — not urgent but blocks invoice/GST compliance in India (e-way bills require structured addresses). | `company.dart`, `schema.sql`, `edit.company.page.dart` |
| **C08** | No `businessType`, `website`, `pan` fields | 🟠 P2 | Toast and TMBill both collect business type (sole proprietorship, partnership, Pvt Ltd, LLP), PAN, and website. These are lightweight additions that provide 80% ERP parity. | `company.dart`, `schema.sql`, `edit.company.page.dart` |
| **C09** | No invoice configuration | 🟠 P2 | Missing `invoicePrefix`, `invoiceTermsAndConditions`, `nextInvoiceNumber`. GST-compliant Indian POS needs these for every bill. | `company.dart`, `schema.sql` |
| **C10** | No printer/hardware configuration | 🔵 P3 | No fields for thermal printer IP, paper width (80mm/58mm), KOT count, printer port. Currently assumes ephemeral print via BLE — not viable for real restaurants. | Schema + settings page |
| **C11** | No business hours, timezone, default language | 🔵 P3 | Toast collects business hours per location, timezone, default language. Eatery has none. Affects auto-detect of operating context and future shift management. | Schema + settings page |
| **C12** | No bank/UPI details | 🔵 P3 | Industry standard includes bank account (name, number, IFSC), UPI ID. Needed for invoice print and settlement reconciliation. | Schema + settings page |
| **C13** | Router defaults to 6-step wizard, not 2-field setup | 🟡 P1 | `app_router.dart` routes first-launch users to `MainScreen` or `createCompany`, not `setup`. The `setup.page.dart` already works and is vastly better (2 fields, 30 seconds). The 6-step wizard should be retired and the router should default to `/setup`. | `app_router.dart` |
| **C14** | No onboarding checklist post-setup | 🔵 P3 | `onboarding-redesign.md` describes a "Getting Started" checklist (2 of 8 done, menu items → tables → staff → name → tax → printer). This replaces the 6-step wizard by deferring non-essential config to a dashboard checklist. Not yet implemented. | `lib/pages/dashboard/components/setup_checklist.dart` (new) |

## Dependency Graph

```
C01 (adminStaffId in model)
 ├─ C02 (remove company.password)
 │   ├─ C13 (router → setup.page not create_company)
 │   └─ (login.page already uses staff PIN — cleanup only)
 ├─ C03 (stop hardcoding company.id=1)
 └─ C04 (save logo from edit page)
     ├─ C05 (tax/currency/subscription editable in edit page)
     └─ C06 (remove duplicate phone assignment)

C07 (structured address) → after C01-C06
C08 (businessType/website/pan) → standalone
C09 (invoice config) → standalone
C10 (printer config) → standalone
C11 (business hours/timezone) → standalone
C12 (bank details) → standalone
C14 (onboarding checklist) → after C13
```

## Recommended Fix Order

```
✅ Week 1 — Critical (P0):  C01 → C02 → C03 (all done)
Week 2 — Edit page (P1):    C04 → C05 → C06 → C13
Week 3 — ERP parity (P2):   C08 → C09 → C07
Week 4 — Polish (P3):       C14 → C10 → C11 → C12
```

## Industry Comparison Summary

| Capability | Toast | TMBill | Eatery | Gap |
|---|---|---|---|---|
| Multi-outlet | ✅ | ❌ | ❌ | C03 blocks this |
| Logo editable | ✅ | ✅ | ⚠️ broken | C04 |
| Structured address | ✅ | ✅ | ❌ | C07 |
| Business hours | ✅ | ✅ | ❌ | C11 |
| Tax config editable | ✅ | ✅ | ❌ read-only | C05 |
| Currency editable | ✅ | ✅ | ❌ | C05 |
| Staff PIN auth | ✅ | ✅ | ⚠️ mixed | C02 |
| Invoice prefix/terms | ✅ | ✅ | ❌ | C09 |
| Bank/UPI details | ✅ | ✅ | ❌ | C12 |
| Printer config | ✅ | ✅ | ❌ | C10 |
| Setup time (fields) | N/A (specialist) | 5 (2 steps) | 14+ (6 steps) | C13 |
| Demo mode | ❌ | ❌ | planned | C14 |
| adminStaffId link | ✅ | ✅ | ⚠️ SQL only | C01 |

---

# Staff → Employee Entity Rename

> **Date:** 2026-07-16
> **Rationale:** "Staff" is a generic term that subtly biases toward front-of-house (waitstaff). "Employee" is the professional industry term used by Toast, Odoo HR, and Square Teams. It correctly conveys that admins, chefs, waiters, and drivers are all **employees** of the restaurant. The rename also fixes the awkward `Staff`/`staffs` plural (→ `Employee`/`employees`).

## Schema FK Audit — `staff` table referenced by 10 tables

```
staff (current table)
  ├── orders.staffId                           — who took the order
  ├── dining_table.staffId                     — waiter assigned to table
  ├── company.adminStaffId                     — admin owner of company
  ├── order_status_history.changedByStaffId    — who changed order status
  ├── order_discount.appliedBy                 — who applied discount
  ├── time_entry.staffId                       — clock in/out (shift tracking)
  ├── expense.createdBy                        — who created expense
  ├── reservation.createdBy                    — who created reservation
  ├── purchase_order.createdBy                 — who created purchase order
  └── stock_adjustment.createdBy               — who adjusted stock
```

## Schema Gap — SQL has fields the Dart model is missing

```
SQL staff table columns:        Dart Staff model fields:
  id           INTEGER PK         int? id             ✅
  name         TEXT NOT NULL      String name         ✅
  email        TEXT               ❌ MISSING
  photo        TEXT               String? photo       ✅
  phone        TEXT               String? phone       ✅
  pin          TEXT               String? pin         ✅
  pinUpdatedAt INTEGER            ❌ MISSING (for PIN expiry/reset tracking)
  lastLoginAt  INTEGER            ❌ MISSING (for audit/activity logs)
  type         INTEGER NOT NULL   StaffType type      ✅
  isActive     INTEGER DEFAULT 1  bool isActive       ✅
```

## Issue Table

| # | Issue | Severity | Description | Files |
|---|-------|----------|-------------|-------|
| **E01** | Rename `staff` table → `employee` | 🔴 P0 | Schema: `CREATE TABLE staff` → `CREATE TABLE employee`. All 10 FK columns renamed: `staffId` → `employeeId`, `adminStaffId` → `adminEmployeeId`, `changedByStaffId` → `changedByEmployeeId`, `appliedBy` references `staff(id)` → `employee(id)`, `createdBy` references `staff(id)` → `employee(id)`. Provide a migration that renames the table and updates FKs. | `schema.sql`, `schema_migrator.dart` |
| **E02** | Rename Dart model `Staff` → `Employee` | 🔴 P0 | `staff.dart` → `employee.dart`, class `Staff` → `Employee`, ~97 references across ~27 files. All providers: `authSessionProvider` stays (auth concern, not type concern), but return type changes to `Employee?`. `staffRepositoryProvider` → `employeeRepositoryProvider`. | `staff.dart`, `auth_session.dart`, `staff_repository.dart` |
| **E03** | Rename `StaffType` → `EmployeeRole` | 🔴 P0 | `staff_type.dart` → `employee_role.dart`. Enum values: `waiter`, `chef`, `driver`, `other`, `admin`. The term "type" is too generic; "role" matches industry terminology. | `staff_type.dart` |
| **E04** | Add `email` to Dart `Employee` model | 🟡 P1 | SQL has `email TEXT`; Dart model is missing it. Low-hanging fruit — just add `String? email` to the freezed factory and regenerate. | `employee.dart` |
| **E05** | Add `pinUpdatedAt`, `lastLoginAt` to Dart model | 🟡 P1 | Both exist in SQL, neither in Dart. Needed for PIN expiry enforcement and activity audit trails. `lastLoginAt` should be updated in `authenticateEmployee()` (currently `authenticateStaff()`). | `employee.dart`, `auth_session.dart` |
| **E06** | Rename pages: `staffs.page.dart` → `employees.page.dart` | 🟡 P1 | UI labels: "Staff" → "Employees", route `/staffs` → `/employees`. Add/edit/view pages follow suit. | `staffs.page.dart`, `add.staff.page.dart`, `edit.staff.page.dart` |
| **E07** | Add `EmployeeRole.manager` enum value | 🟠 P2 | Between `admin` and `waiter`. Common restaurant role: floor manager / captain. Needs mid-level RBAC permissions (view reports, void orders, but not full settings access). ID = 5 to not conflict with existing 0-4. | `employee_role.dart`, RBAC providers |

## Files Changed (estimated)

| Category | Files | Count |
|---|---|---|
| Schema + migration | `schema.sql`, `schema_migrator.dart` | 2 |
| Dart models | `employee.dart`, `employee.freezed.dart`, `employee.g.dart`, `employee_role.dart` | 4 |
| Repository | `employee_repository.dart`, `employee_repository_sqlite.dart` | 2 |
| Providers | `auth_session.dart`, `role_provider.dart`, `company_provider.dart` | 3 |
| Pages refactored | `login.page.dart`, `reset-pin.dart`, `staffs.page.dart`, `add.staff.page.dart`, `edit.staff.page.dart`, `waiterSelection.view.dart`, `data_management.page.dart`, `reports.page.dart`, `view.company.page.dart` | ~9 |
| Pages (FK callers) | `orders.page.dart`, `ticket_page.dart`, `order_status_history`, `orders` schema, `dining_table` schema, `expense` pages, `reservation` pages, `purchase_order` pages, `stock_adjustment` pages | ~10 |
| EateryDB barrel | `eatery_db.dart` | 1 |
| References barrel | `references.dart` | 1 |
| Tests | `waiter_features_test.dart`, `staff_repository_test.dart`, seeder | ~3 |
| Docs | `auth-session.md`, `state-management.md`, `provider-hierarchy.md`, `schema-audit.md`, `onboarding-redesign.md`, `repository docs` | ~6 |
| **Total** | | **~41 files** |

## Merged Entity: Staff + Employee? No.

Decision: Employee is the **ONLY** person-entity. Do not merge with `Customer`.

| Concern | Resolution |
|---|---|
| "What about Customer?" | `Customer` stays separate — different schema, different purpose (no PIN, no role, has loyalty/orders). Restaurant customers are NOT employees. |
| "What about Supplier?" | `Supplier` stays separate — different schema, no authentication, B2B purchasing context. |
| "What about authSession?" | `authSessionProvider` keeps its name (it's about auth, not what type it returns). Return type changes from `Staff?` to `Employee?`. |
| "What about roleProvider?" | Unchanged — already role-based, not staff-named. |

## Plural Notes

| Before | After | Why |
|---|---|---|
| `staff` (singular and collective) | `employee` (singular) | Standard English |
| `staffs` (forced plural) | `employees` (natural) | Awkwardness eliminated |
| `Staff` class | `Employee` class | Professional |

## Dependency Graph

```
E01 (rename table → employee)
  └─ E02 (rename Dart model)
      ├─ E04 (add email field — low effort, high value)
      ├─ E05 (add pinUpdatedAt, lastLoginAt)
      ├─ E06 (rename pages/route)
      └─ E03 (rename enum)
          └─ E07 (add manager role — after all other renames are stable)
```

## Recommended Execution

```
Step 1: E01 (schema migration) — 1 file, ALTER TABLE RENAME + FK updates
Step 2: E02 (Dart model rename) — ~97 refs, mechanical via IDE rename
Step 3: E03 (enum rename) — mechanical
Step 4: build_runner regen + flutter analyze + flutter test (must pass)
Step 5: E04 + E05 (add missing fields) — additive, no refactoring
Step 6: E06 (page renames) — file moves + route updates
Step 7: E07 (manager role) — enum value only
```

---

# Schema Audit Issues

> **Date:** 2026-07-16
> **Source:** Full review of `assets/db/schema.sql` (49 tables, 530 lines)
> **Finding:** The schema was written in 3 distinct generations, and Phase C (15 tables: v3-v9 migrations) was never production-hardened — zero indices, inconsistent FK patterns, and a critical enum/text mismatch on `orders.status`.

## Issue Table

| # | Issue | Severity | Description |
|---|-------|----------|-------------|
| **S01** | `dining_table_category.isActive DEFAULT 0` | 🔴 P0 | Every other `isActive` column defaults to `1` (active). Only `dining_table_category` defaults to `0` (inactive). Creating a category without setting `isActive` silently hides it from the picker. Almost certainly a bug. Fix: `DEFAULT 1`. |
| **S02** | Missing index: `orders(status)` | 🟡 P1 | The KDS queries `WHERE status IN (pending, preparing)` on every refresh. No index → table scan. `orders` table grows linearly with every sale. Fix: `CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status)`. |
| **S03** | Missing index: `orders(staffId)` | 🟡 P1 | The Waiter "my orders" view queries `WHERE staffId = ?`. No index → table scan across all orders for every waiter's screen. Fix: `CREATE INDEX IF NOT EXISTS idx_orders_staff ON orders(staffId)`. |
| **S04** | Missing index: `orders(createdAt)` | 🟡 P1 | Reports filter by date range (`WHERE createdAt BETWEEN ? AND ?`). No index on the timestamp column. Fix: `CREATE INDEX IF NOT EXISTS idx_orders_created ON orders(createdAt)`. |
| **S05** | Missing index: `reservation(dateTime)` | 🟡 P1 | Today's reservations query: `WHERE dateTime BETWEEN dayStart AND dayEnd`. No index. Fix: `CREATE INDEX IF NOT EXISTS idx_reservation_datetime ON reservation(dateTime)`. |
| **S06** | Missing index: `reservation(diningTableId)` | 🟡 P1 | Table availability check: `WHERE diningTableId = ? AND status != cancelled`. No index. Fix: `CREATE INDEX IF NOT EXISTS idx_reservation_table ON reservation(diningTableId)`. |
| **S07** | Missing index: `time_entry(staffId)` | 🟡 P1 | Shift reports by employee. Fix: `CREATE INDEX IF NOT EXISTS idx_time_entry_staff ON time_entry(staffId)`. |
| **S08** | Missing index: `expense(expenseDate)` | 🟡 P1 | P&L reports by date range. Fix: `CREATE INDEX IF NOT EXISTS idx_expense_date ON expense(expenseDate)`. |
| **S09** | Missing index: `stock_adjustment(productId)` | 🟡 P1 | Inventory audit trail per product. Fix: `CREATE INDEX IF NOT EXISTS idx_stock_adj_product ON stock_adjustment(productId)`. |
| **S10** | `orders.status` is TEXT, not INTEGER | 🟢 Verified harmless | `Order.toMap()` writes `status.id` (an int, 0-5). `_statusFromJson` handles both int and string inputs. SQLite stores the int fine in a TEXT column — SQLite is loosely typed. `WHERE status = 0` works as expected. The schema declaration `TEXT` is misleading but not a runtime bug. No action needed. |
| **S11** | No FK from `orders` to `customer` | 🟠 P2 | `orders.customerPhone TEXT` references `customer.phone` by convention only — no `REFERENCES` constraint, no cascading. Deleting a customer silently orphans their orders. Fix: `REFERENCES customer(phone)` or switch to `customerId INTEGER REFERENCES customer(id)`. |
| **S12** | Inconsistent FK patterns across schema | 🟠 P2 | Three styles coexist: (A) implicit INTEGER with no REFERENCES, (B) explicit `REFERENCES tbl(id) ON DELETE CASCADE`, (C) explicit `REFERENCES tbl(id)` without CASCADE. The Staff→Employee rename touches 10 FK columns using all three styles. Standardize to style B or C after the rename. |
| **S13** | `compliance_report` stores JSON blobs | 🟠 P2 | `paymentBreakdownJson TEXT` and `taxBreakdownJson TEXT` are SQLite anti-patterns (can't query inside them). Every value is derivable from `orders + payments` at query time. If raw data changes after report generation, the report becomes stale with no invalidation flag. Consider: `compliance_report_header` + `compliance_report_line` table, or add `isStale BOOLEAN` flag. |
| **S14** | `auto_print` is a frozen singleton | 🔵 P3 | No `createdAt`/`updatedAt`, no FK to `printer`, no `companyId`. If this is a single-row config table, it should be in `app_config` (key-value). If it supports multiple printer configs, it needs timestamps and FKs. As-is, it's unclear whether `id=1` is always "the" config. |
| **S15** | `shift` has no recurrence rule | 🔵 P3 | `shift.startTime`/`endTime` are `TEXT` ("09:00") but `time_entry.clockIn`/`clockOut` are epoch millis (`INTEGER`) — same concept, two types. The `shift` table stores a floating template with no `dayOfWeek` or recurrence. You can't say "Rajesh works morning shift Mon-Sat." Fix: add `shift_schedule(shiftId, dayOfWeek)` junction table, or add `recurrenceRule TEXT` (RFC 5545 RRULE). |
| **S16** | `order_product.stationName` is triple-denormalized | 🔵 P3 | Station info exists in three places: `product.stationId` + `product.stationName` + `order_product.stationName`. The order_product copy is snapshotting (correct for audit), but `product` having both `stationId` (FK pattern) and `stationName` (denormalized string) means the name can drift from the referenced `kds_station` row. Drop `product.stationName` — derive it from the FK join. |
| **S17** | Phase C tables (15) have zero indices | 🟡 P1 | Tables added in v3-v9 (`discount`, `shift`, `time_entry`, `business_hours`, `holiday_hours`, `expense`, `reservation`, `customer_loyalty`, `loyalty_transaction`, `supplier`, `purchase_order`, `purchase_order_item`, `stock_adjustment`, `order_discount`, `product_modifier`) have **no CREATE INDEX statements**. Compare with Phase A where every major table gets an index. |

## Fix Plan

| # | What | Status |
|---|---|---|
| S01 | `isActive DEFAULT 0` → `1` | 🔴 Fix now |
| S02-S03 | Add 2 missing indices on `orders` | 🟡 P1 (performance, not correctness) |
| S04-S09 | Add 6 missing indices on other tables | 🟡 P1 (performance) |
| S10 | `orders.status TEXT` vs enum serialization | 🟢 Verified harmless |
| S11-S17 | Structural improvements | 🔵 Deferred |

## Index Summary — Before vs After

```
Before (current schema):  After (with S02-S09):
  idx_product_category       idx_product_category
  idx_product_type           idx_product_type
  idx_orders_customer        idx_orders_customer
  idx_order_product_order    idx_order_product_order
  idx_payment_order          idx_payment_order
  idx_dining_table_category  idx_dining_table_category
  idx_dining_table_status    idx_dining_table_status
  idx_osh_order              idx_osh_order
                             idx_orders_status         ← NEW
                             idx_orders_staff          ← NEW
                             idx_orders_created        ← NEW
                             idx_reservation_datetime  ← NEW
                             idx_reservation_table     ← NEW
                             idx_time_entry_staff      ← NEW
                             idx_expense_date          ← NEW
                             idx_stock_adj_product     ← NEW
```

---

# Company Table Audit — Schema vs Model vs Repository

> **Date:** 2026-07-16
> **Finding:** A full column-by-column audit of `company` table (SQL), `Company` model (Dart), and `saveCompany()` (repository) reveals a **3-way desync**. The Dart model is missing `adminStaffId` (exists in SQL). `saveCompany()` INSERT omits `adminStaffId` (exists in SQL, missing from Dart). `create_company._submitForm()` never writes it. Only `setup.page.dart` correctly writes `adminStaffId`. Additionally, the entire schema assumes single-company — not a single table has a `companyId` FK.

## Root Cause: No `companyId` FK anywhere

```sql
-- Search across entire schema.sql:
SELECT 'companyId' or 'company_id' → ZERO matches
```

Every row in every table implicitly belongs to `company.id = 1`. No foreign key, no multi-tenancy, no data isolation. If a second outlet is ever created, data from both bleed together.

## Tables That SHOULD Have `companyId` (20 tables)

| Phase | Tables needing `companyId INTEGER NOT NULL REFERENCES company(id)` | Status |
|---|---|---|
| **A** | `product_category`, `product`, `customer`, `orders`, `tax_slab`, `dining_table_category`, `dining_table` | ❌ All 7 missing |
| **B** | `staff` (employee), `subscription`, `kds_station`, `printer`, `auto_print`, `compliance_report`, `modifier_group` | ❌ All 7 missing |
| **C** | `discount`, `shift`, `business_hours`, `holiday_hours`, `expense_category`, `expense` | ❌ All 6 missing |

**Link-through tables** (no direct `companyId` needed — inherit via parent FK): `order_product` (via `orders`), `payment` (via `orders`), `order_status_history` (via `orders`), `void_log_entry` (via `orders`), `order_discount` (via `orders`), `modifier` (via `modifier_group`), `product_modifier` (junction), `order_product_modifier` (via `order_product`), `time_entry` (via `staff`), `customer_loyalty` (via `customer`), `loyalty_transaction` (via `customer`), `purchase_order_item` (via `purchase_order`), `stock_adjustment` standalone, `reservation` standalone, `supplier` standalone.

## Company Table — Column-by-Column 3-Way Audit

```
SQL column           Dart Company model      saveCompany INSERT          Verdict
══════════════════════════════════════════════════════════════════════════════
id                   int? id (*default=1)     VALUES (1, ...)            ❌ hardcoded
logo                 String? logo             m['logo']                  ✅
name                 String name (required)   m['name']                  ✅
email                String email (required)  m['email']                 ✅
phone                String phone (required)  m['phone']                 ✅
address              String address (req)     m['address']               ✅
password             String? password         m['password']              ❌ ANTI-PATTERN
edition              Taxation taxation        m['edition']               ✅
currencyCode         String? currencyCode     m['currencyCode']          ✅
salesTaxNumber       String? salesTaxNumber   m['salesTaxNumber']        ✅
foodLicenseNo        String? foodLicenseNo    m['foodLicenseNo']         ✅
subscriptionId       int? subscriptionId      m['subscriptionId']        ✅
adminStaffId         ❌ MISSING               ❌ OMITTED                  ❌ 3-way gap
createdAt            ❌                       N/A                        ❌
updatedAt            ❌                       N/A                        ❌
──────────────────────────────────────────────────────────────────────────────
```

## The `adminStaffId` 3-Way Gap (S18)

```
SQL schema:     adminStaffId INTEGER              ← EXISTS
Dart Company:   NO FIELD                         ← model ignores it
saveCompany:    VALUES (1,?,?,?,?,?,?,?,?,?,?,?) ← 12 placeholders, 0 for adminStaffId
  Position 0=logo, 1=name, 2=email, 3=phone, 4=address,
  5=password, 6=edition, 7=currencyCode, 8=salesTaxNumber,
  9=foodLicenseNo, 10=subscriptionId.
  ↑ adminStaffId not at position 11.
_toCompany():   reads row['id']...row['subscriptionId'] ← skips adminStaffId
setup.page:     INSERT INTO company (name, taxation, adminStaffId) VALUES (?,?,?)
                ↑ ONLY place this works correctly
create_company: Company(name:...etc) → NEVER sets adminStaffId → NULL in DB
```

**Effect:** Company records created via the 6-step wizard or edit page have `adminStaffId = NULL`. Only companies created via `setup.page.dart` have it set. This means the admin→company link is broken for the majority creation path.

## Missing Columns — What Industry ERPs Have That Eatery Doesn't

```
Current company table (13 cols):  Standard POS (38+ cols):
  id, logo, name, email,            id, logo, name, displayName, legalName,
  phone, address, password,         email, phone, website, supportEmail,
  edition, currencyCode,            supportPhone, addressLine1, city, state,
  salesTaxNumber, foodLicenseNo,    pincode, country, timezone, defaultLanguage,
  subscriptionId, adminStaffId      businessType, pan, gstin, gstinState, tan,
                                    invoicePrefix, nextInvoiceNo, invoiceTerms,
                                    invoiceFooter, roundOffRule, defaultOrderType,
                                    parentCompanyId, outletCode, outletType,
                                    isHeadOffice, createdAt, updatedAt, createdBy,
                                    isActive, deletedAt, currencyCode,
                                    salesTaxNumber, foodLicenseNo, subscriptionId
```

## Issue Table

| # | Severity | Issue | Scope |
|---|----------|-------|-------|
| **S18** | 🔴 P0 | `adminStaffId` 3-way gap. SQL has column, Dart model doesn't, `saveCompany` INSERT omits it, `create_company` never writes it. Only `setup.page.dart` sets it. Companies created via wizard or edit page have NULL `adminStaffId`. | `company.dart`, `company_repository_sqlite.dart`, `create_company.page.dart` |
| **S19** | 🟡 P1 | No `createdAt`/`updatedAt` on `company`. Every Phase C table has timestamps. The root entity of the entire system has none. | `company` table |
| **S20** | 🟡 P1 | 20 tables need `companyId INTEGER NOT NULL REFERENCES company(id)` for multi-outlet isolation. Currently 0 have it. | All 20 tables across Phase A/B/C |
| **S21** | 🟡 P1 | `orders.staffId` should be `orders.employeeId` (post Staff→Employee rename) + `orders.companyId`. The FK explosion post-rename must include `companyId`. | `orders` |
| **S22** | 🟠 P2 | Missing identity/legal columns: `legalName`, `displayName`, `businessType`, `pan`, `website`, `supportEmail`, `supportPhone` | `company` |
| **S23** | 🟠 P2 | Missing structured address: `addressLine1`, `city`, `state`, `pincode`, `country` — flat `address` text is non-compliant for GST e-way bills | `company` |
| **S24** | 🟠 P2 | Missing invoice config: `invoicePrefix`, `nextInvoiceNo`, `invoiceTerms`, `invoiceFooter`, `roundOffRule` | `company` |
| **S25** | 🟠 P2 | Missing operations config: `timezone`, `defaultLanguage`, `defaultOrderType` | `company` |
| **S26** | 🔵 P3 | Missing multi-outlet columns: `parentCompanyId`, `outletCode`, `outletType`, `isHeadOffice` | `company` |
| **S27** | 🔵 P3 | Missing soft-delete: `isActive`, `deletedAt` | `company` |
| **S28** | 🔵 P3 | `company.password` exists in schema + model + insert as plaintext. Should be a hashed staff PIN on the employee table (see C02). | `company`, `staff` |

## Recommended Fix Order

```
Phase 1 — Critical (P0):  S18 (adminStaffId gap) — unblocks C01
Phase 2 — Structural (P1): S19 (timestamps), S20 (companyId FK on 20 tables)
Phase 3 — Post E-rename (P1): S21 (orders.employeeId + companyId)
Phase 4 — ERP columns (P2):  S22-S25 (legal, address, invoice, ops columns)
Phase 5 — Polish (P3):       S26 (multi-outlet), S27 (soft-delete), S28 (password → employee PIN)
```

## Relationship to Previous Issues

```
S18 extends C01 (adminStaffId missing from Dart model)
S19 is new (no timestamps on company)
S20 is new (zero companyId FKs across 20 tables)
S21 is new (orders FK explosion post Employee rename)
S22-S28 extend C07-C12 (missing ERP columns on company)
S20 depends on C03 (stop hardcoding company.id=1) before companyId FKs make sense
```

---

# Edition → Taxation Naming Gap

> **Date:** 2026-07-16
> **Finding:** The SQL column `company.edition`, the Dart file `edition.dart`, and the extension on `FoodType` named `EditionExtension` are all artifacts of an original project design where `Edition` meant "plan tier" (free/basic/pro/enterprise). The column was later repurposed to store tax regime (GST/VAT/None). The Dart enum was correctly renamed to `Taxation`, but the SQL column, filename, and cross-contaminated extensions were never cleaned up. A `toMap()` hack bridges the gap.

## Current State — One Concept, Three Names

```
Location                  Name Used              Actual Meaning
─────────────────────────────────────────────────────────────────────
SQL column                edition INTEGER         tax regime (GST/VAT/None)
Dart enum (correct)       Taxation                tax regime (GST/VAT/None)
Dart filename (wrong)     edition.dart            holds enum Taxation ← MISMATCH
Extension (correct)       NatureOfTaxExtension    "nature of tax"      ← correct
toMap() hack (wrong)      m['edition'] = ...      translates Taxation → edition ← BAND-AID
FoodType extension        EditionExtension        Veg/NonVeg enum      ← CONTAMINATED
```

## The `toMap()` Hack — Admission of Guilt

```dart
// company.dart line 52-56
Map<String, Object?> toMap() {
  final m = toJson() as Map<String, Object?>;
  // The SQL column is 'edition' but the Dart field is 'taxation'.
  if (m.containsKey('taxation') && !m.containsKey('edition')) {
    m['edition'] = m.remove('taxation');  // rename on the fly
  }
  return m;
}
```

This code exists solely because the SQL column was never renamed. It's a runtime translation layer that would disappear if the column was named `taxation`.

## Blast Radius

| Location | Issue |
|---|---|
| `company.edition` SQL column | Should be `taxation` |
| `company.dart:1` | `import 'edition.dart'` → should be `taxation.dart` |
| `edition.dart` filename | Contains enum `Taxation` — file should be `taxation.dart` |
| `company.dart:52-56` | `toMap()` hack — can be deleted after column rename |
| `company.dart:37` | `fromIterable` reads `'edition'` key → should read `'taxation'` |
| `food_type.dart:12` | `extension EditionExtension on FoodType` — should be `FoodTypeExtension` |
| `eatery_db.dart:26` | `export 'company/edition.dart'` → should be `company/taxation.dart` |
| `seed_data.dart:19` | Writes to `edition` column directly |
| `schema_migrator.dart` | Column rename migration needed |
| `company_repository_sqlite.dart:34,46` | SELECT/INSERT uses `edition` column name |
| `body4.dart:89` | Commented-out code uses `Edition.gst` |

## Already Flagged (in Previous Audits)

```
docs/plan/schema-audit.md:  edition → "confusing name (means taxation)"
docs/plan/schema-audit.md:  "Rename to taxation to match model"
docs/plan/issue-inventory.md DB1: "Company.taxation field vs company.edition column"
```

This has been a known issue through at least 3 audit cycles but never fixed.

## Issue Table

| # | Severity | Issue |
|---|----------|-------|
| **N01** | 🔴 P0 | Rename SQL column `company.edition` → `company.taxation`. Add migration. Remove `toMap()` hack. |
| **N02** | 🔴 P0 | Rename Dart file `edition.dart` → `taxation.dart`. Update import in `company.dart` and barrel exports in `eatery_db.dart`. |
| **N03** | 🟡 P1 | Rename `FoodType.EditionExtension` → `FoodType.FoodTypeExtension`. It's a Veg/NonVeg enum — has nothing to do with editions. |
| **N04** | 🟡 P1 | Audit and rename all remaining references: `seed_data.dart` writes to `edition`, `repository_sqlite.dart` reads/writes `edition`, `fromIterable()` reads key `'edition'`. |

## Fix Checklist

```
Step 1: ALTER TABLE company RENAME COLUMN edition TO taxation (schema migration)
Step 2: Rename file edition.dart → taxation.dart
Step 3: Update import in company.dart (line 1)
Step 4: Update barrel export in eatery_db.dart (line 26)
Step 5: Replace m['edition'] → m['taxation'] in company.dart toMap(), fromIterable()
Step 6: DELETE the m['edition'] = m.remove('taxation') hack
Step 7: Replace 'edition' → 'taxation' in company_repository_sqlite.dart (SELECT + INSERT)
Step 8: Replace 'edition' → 'taxation' in seed_data.dart
Step 9: Rename Extension EditionExtension → FoodTypeExtension in food_type.dart
Step 10: Clean up commented-out Edition.gst references in body4.dart
Step 11: flutter analyze + flutter test (verify no 'edition' references remain)
```

## What Edition SHOULD Be (Future)

If a real "software edition" concept is needed later (plan tier: free/basic/pro/enterprise), it should be stored in a `subscription` table with `planTier` / `featureSet`, NOT in the `company` table. The `company.taxation` column is exclusively for GST/VAT/None.

---

# Global Project Review — Cross-Cutting Concerns

> **Date:** 2026-07-16
> **Scope:** Testing, tooling, security, dependencies, i18n, CI/CD, documentation, developer experience, architecture
> **Stats:** 403 Dart source files | 13 test files (30:1 ratio) | 47 docs | 49 schema tables | 40+ direct deps | 6 ADRs | 4 CI platforms | 29 Zig files

## 1. Testing — Critical Gap

| Metric | Current | Industry Baseline | Gap |
|---|---|---|---|
| Source files | 392 source | — | — |
| Test files | **13** | 50+ for this size | 🔴 |
| Source:test ratio | **30:1** | 3:1 to 5:1 | 🔴 |
| Widget tests | **0** | Every reusable widget | 🔴 |
| UI/integration tests | **0** | Login + create-order flow | 🟡 |
| Golden tests | **0** | Tokenized design system | 🟡 |
| Large-dataset tests | **0** | 1000+ row queries | 🟠 |
| Migration tests | **0** | Every schema change | 🔴 |

| # | Severity | Issue |
|---|----------|-------|
| **T01** | 🔴 P0 | Zero widget tests. 27 reusable widgets in `eatery_core/lib/widgets/`. ADR-006 says "one widget per domain concept" but no automated check verifies all 4 role contexts render. |
| **T02** | 🔴 P0 | Zero schema migration tests. `SchemaMigrator` adds columns, creates tables, and will soon rename `edition→taxation` and `staff→employee`. No test verifies any migration. |
| **T03** | 🟡 P1 | Test isolation is missing. All test files share one in-memory SQLite store. One polluting test breaks downstream. Each suite should `setUp` a fresh store. |
| **T04** | 🟡 P1 | Test data is tiny. No test uses >10 rows. Real POS has 1000+ orders. Add `seed_large_dataset.dart` and one 1000-order query test. |
| **T05** | 🟠 P2 | Zero golden tests for the design system (ADR-004, ADR-005). Token changes have no visual regression catch. |
| **T06** | 🟠 P2 | `AppVariant × AppSemantic × AppSize` matrix (ADR-005) has zero smoke tests. |
| **T07** | 🟠 P2 | No integration test for setup→login→dashboard flow — the most critical user journey. |
| **T08** | 🟠 P2 | No accessibility/semantics tree tests for KDS, Waiter, Display modes. |

## 2. Linting & Static Analysis

| # | Severity | Issue |
|---|----------|-------|
| **L01** | 🟡 P1 | `analysis_options.yaml` uses default `flutter_lints` — the least strict rule set. Missing: `always_declare_return_types`, `unawaited_futures`, `require_trailing_commas`, `prefer_const_constructors`, `prefer_single_quotes`. |
| **L02** | 🟡 P1 | Only 1 `// ignore:` in entire codebase — suggests lints are too permissive, not that code is perfect. |
| **L03** | 🟠 P2 | No `dart_code_metrics` for complexity/coupling detection. |

## 3. Dependencies — Questionable & Unused

| # | Severity | Issue |
|---|----------|-------|
| **D01** | 🔴 P0 | `gbk_codec: ^0.4.0` — Chinese character encoding. Eatery is an English/Indian POS. Dead dep or hidden usage. Verify with `grep -r gbk_codec lib/`. |
| **D02** | 🟡 P1 | `rxdart: ^0.28.0` — Reactive Extensions. Project uses Riverpod everywhere. Remove if no explicit import. |
| **D03** | 🟡 P1 | `hex: ^0.2.0` — `dart:convert` has hex since Dart 2.18. Replace or remove. |
| **D04** | 🟡 P1 | 40+ deps. Overlaps: `fluttertoast` + `sn_progress_dialog` (notifications), `file_picker` + `image_picker` (file handling). Consolidate. |
| **D05** | 🟠 P2 | `encrypt: ^5.0.3` — should be for PIN hashing. If PIN is plaintext (X02), this dep is unused for its intended purpose. |
| **D06** | 🔵 P3 | `devdart_windows_hdsn: ^0.0.2` — unmaintained. Replace with Zig platform channel for device fingerprinting. |

## 4. Security

| # | Severity | Issue |
|---|----------|-------|
| **X01** | 🔴 P0 | `company.password` plaintext in SQLite. `saveCompany()` INSERT includes `m['password']` directly. See C02. |
| **X02** | 🔴 P0 | `staff.pin` plaintext comparison: `staff.pin == pin` in `authenticateStaff()`. No bcrypt/scrypt, no salt, no constant-time compare. |
| **X03** | 🟡 P1 | No rate limiting on PIN attempts. 4-digit PIN is brute-forceable offline against SQLite. |
| **X04** | 🟠 P2 | `app_router.dart:123` checks `company.password != null` to decide route — leaks information. |

## 5. CI/CD & DevOps

| # | Severity | Issue |
|---|----------|-------|
| **CI01** | 🟡 P1 | CI builds all 4 platforms on every `dev` push. Expensive. Build `android+linux` always; `macos+windows` only on PR to `master`. |
| **CI02** | 🟡 P1 | `flutter analyze --no-fatal-infos --no-fatal-warnings` masks ~300 issues. Remove flags when warning count reaches zero. |
| **CI03** | 🟡 P1 | No iOS build in CI. iPads are the #1 restaurant POS hardware. |
| **CI04** | 🟠 P2 | No `--coverage` + upload step. Zero visibility into coverage. |
| **CI05** | 🟠 P2 | No caching of Zig native build output. Rebuilds from scratch every CI job. |
| **CI06** | 🔵 P3 | `ZIG_VERSION: "0.15.2"` in CI. User memory has 0.16 API changes documented. Sync needed. |
| **CI07** | 🔵 P3 | `web/` directory exists but no web build in CI. Either remove or add. |

## 6. Internationalization

| # | Severity | Issue |
|---|----------|-------|
| **I01** | 🟠 P2 | Zero i18n infrastructure. All strings hardcoded English. `intl` installed but only used for `DateFormat`, not message localization. |
| **I02** | 🟠 P2 | Currency display uses `$symbol${amount}` — symbol position varies by locale (₹500 vs 500€). No `NumberFormat.currency()`. |

## 7. Architecture & Code Organization

| # | Severity | Issue |
|---|----------|-------|
| **A01** | 🟡 P1 | `pos.page.dart` is 1,047 lines. Split into: `pos_screen.dart`, `category_bar.dart`, `product_grid.dart`, `cart_panel.dart`. |
| **A02** | 🟡 P1 | 67 raw `Color(0x...)` remain in `lib/` despite ADR-004. Most in `dashboard.page.dart` (16 raw colors). |
| **A03** | 🟡 P1 | `references.dart` exports 154+ files. Single file change invalidates all importers. Split into focused barrels. |
| **A04** | 🟠 P2 | `flutter analyze` reports ~300 issues. Same count pre-Phase-5. No trend toward zero. |

## 8. Documentation Hygiene

| # | Severity | Issue |
|---|----------|-------|
| **DOC01** | 🟡 P1 | `docs/plan/issue-inventory.md` — 106-item audit, many resolved. Archive or merge into ISSUES.md. |
| **DOC02** | 🟡 P1 | `docs/plan/schema-audit.md` — partial implementation. Says "planned" for things now in ISSUES.md as S18/S20/N01-N04. |
| **DOC03** | 🟡 P1 | `docs/plan/onboarding-redesign.md` — describes 2-field setup. `setup.page.dart` implements it but the doc doesn't acknowledge partial completion. |
| **DOC04** | 🟠 P2 | No ADR for: sync protocol choice, SQLite-over-Firebase, single-app unification. |

## 9. Developer Experience

| # | Severity | Issue |
|---|----------|-------|
| **DX01** | 🟡 P1 | No `.vscode/launch.json` checked in. Developers manually configure `--dart-define=role=...`. |
| **DX02** | 🟡 P1 | No pre-commit hooks (`lefthook`, `husky`). Format-on-save is manual. |
| **DX03** | 🟠 P2 | `melos.yaml` was removed. Clean up `melos_eatery.iml` and `melos:` script remnants in `pubspec.yaml`. |

## 10. Platform & Native

| # | Severity | Issue |
|---|----------|-------|
| **P01** | 🟡 P1 | iOS not in CI. iPads are the most common restaurant POS device in India. |
| **P02** | 🟠 P2 | 61 Swift/Kotlin files across `ios/`/`macos/`/`android/`. Mostly plugin-generated. Audit for custom platform channels beyond Zig FFI. |
| **P03** | 🟠 P2 | Android NDK vs Zig cross-compilation target mismatch risk. Verify `ndkVersion` in `build.gradle`. |

## Recommended Priority (Cross-Cutting)

```
Immediate:  T01, T02, D01, X01/X02 document-as-debt
Week 1-2:   L01, T03, A01, D02-D04, DOC01-DOC03
Week 3-4:   T04, T05, I01, CI03, A03
Month 2+:   CI04, X03, I02, DX01-DX03, P01-P03
