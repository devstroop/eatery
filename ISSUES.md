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

All but S01 and S17 verified against `assets/db/schema.sql` on 2026-07-16.

| # | Severity | Issue |
|---|----------|-------|
| **S01** | 🔴 P0 | `dining_table_category.isActive DEFAULT 0` — should be `1`. Creating a category without setting `isActive` silently hides it. |
| **S02** | 🔴 P0 | Missing index: `orders(status)` — KDS queries `WHERE status IN (pending, preparing)` on every refresh. |
| **S03** | 🔴 P0 | Missing index: `orders(staffId)` — Waiter "my orders" queries `WHERE staffId = ?`. |
| **S04** | 🟡 P1 | Missing index: `orders(createdAt)` — Reports filter by date range. |
| **S05** | 🟡 P1 | Missing index: `reservation(dateTime)` — Today's reservations query. |
| **S06** | 🟡 P1 | Missing index: `reservation(diningTableId)` — Table availability check. |
| **S07** | 🟡 P1 | Missing index: `time_entry(staffId)` — Shift reports. |
| **S08** | 🟡 P1 | Missing index: `expense(expenseDate)` — P&L reports. |
| **S09** | 🟡 P1 | Missing index: `stock_adjustment(productId)` — Inventory audit trail. |
| **S10** | 🟡 P1 | `orders.status TEXT` vs `OrderStatus` enum (int `id` values 0-5). Verify ORM serialization — TEXT or INTEGER? |
| **S17** | 🟡 P1 | Phase C tables (15: v3-v9 migrations) have **zero indices**. Every Phase A table gets one. |

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

Mechanical rename across ~41 files. Schema: `staff` table → `employee`, all 10 FK columns renamed. Dart: `Staff` → `Employee`, `StaffType` → `EmployeeRole`. See `docs/architecture/auth-session.md` for auth implications.

| # | Priority | Scope |
|---|----------|-------|
| **E01** | 🔴 P0 | Schema: rename `staff` table → `employee`, update 10 FK columns |
| **E02** | 🔴 P0 | Dart model: `Staff` → `Employee` (~97 refs, ~27 files) |
| **E03** | 🔴 P0 | Enum: `StaffType` → `EmployeeRole` |
| **E04** | 🟡 P1 | Add `email` to Dart model (exists in SQL, missing in Dart) |
| **E05** | 🟡 P1 | Add `pinUpdatedAt`, `lastLoginAt` to Dart model |
| **E06** | 🟡 P1 | Rename pages: `staffs` → `employees`, route `/staffs` → `/employees` |
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
