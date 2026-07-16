# Issues & Technical Debt Tracker

**Global Status:** Phase 1 (28/28 ✅) | Company (0/14) | Employee Rename (0/7) | Schema Audit (1/17 🟢 S10 done) | Company Table Audit (0/11) | **Total: 29/77 ✅**

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
| **C01** | `adminStaffId` missing from Dart model | 🔴 P0 | SQL column `adminStaffId` exists in `company` table and `setup.page.dart` writes it, but the Dart `Company` model has no such field in its `@freezed` factory. The `saveCompany` INSERT also omits it. `schema_migrator.dart` and `onboarding-redesign.md` both reference this field. *(Same issue as S18 below — C01 is the canonical entry.)* | `packages/eatery_core/lib/data/models/company/company.dart`, `packages/eatery_core/lib/data/repositories/company_repository_sqlite.dart` |
| **C02** | `company.password` is a security anti-pattern | 🔴 P0 | The Company model stores a plaintext password. Industry standard: Company has NO password. Staff have PINs (hashed). This field is used in `app_router.dart:123` to decide the initial route (`password != null ? '/login' : '/dashboard'`), in `login.page.dart` to display company info, and in `create_company.page.dart` to collect it from users. `setup.page.dart` already omits it — the rest of the app needs to follow. *(Same issue as S28 below — C02 is the canonical entry.)* | `company.dart`, `company_repository_sqlite.dart`, `app_router.dart`, `login.page.dart`, `create_company.page.dart`, `edit.company.page.dart` |
| **C03** | `company.id = 1` hardcoded in saveCompany | 🔴 P0 | `saveCompany()` at line 33 uses `VALUES (1,?...` and then `company.copyWith(id: 1)`. This makes multi-outlet structurally impossible. Even for a single restaurant, hardcoding the PK is fragile. Use `company.id ?? (await getNextId())`. | `packages/eatery_core/lib/data/repositories/company_repository_sqlite.dart` |
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
Week 1 — Critical (P0):  C01 → C02 → C03
Week 2 — Edit page (P1): C04 → C05 → C06 → C13
Week 3 — ERP parity (P2): C08 → C09 → C07
Week 4 — Polish (P3):    C14 → C10 → C11 → C12
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
