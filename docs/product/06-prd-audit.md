# PRD Audit — Gaps & Improvements

> **Auditing:** `01-vision.md` through `05-release-criteria.md`  
> **Against:** `../plan/schema-audit.md` (schema review), `../plan/onboarding-redesign.md` (onboarding), `../plan/issue-inventory.md` (codebase audit)
> **Goal:** Identify missing features, underdeveloped areas, and phase reorganization opportunities

---

## 1. Major Gaps (Not Addressed in Any PRD)

These are entire feature areas with zero coverage in the PRDs but essential for a professional restaurant management system.

| Gap | Why It Matters | Suggested Phase |
|-----|---------------|-----------------|
| **Product Modifiers** (extra cheese, size options, customizations) | Every restaurant POS needs this. Customers want to customize orders. Without it, the POS is incomplete. Toast/Square all have modifiers. | P0/P1 |
| **Discount Engine** (percentage, fixed amount, BOGO, happy hour) | Discounts are used daily in restaurants. Current code has hardcoded discount fields with no reusable rules. | P1 |
| **Reservations** (customer books a table for a date/time) | Core feature for dine-in restaurants. Without it, you need a separate booking system. | P2 |
| **Staff Shifts & Time Tracking** (clock-in/out, shift assignments) | Labor cost is the #1 expense for restaurants. Tracking hours is essential for payroll. | P2 |
| **Expense Tracking** (operational expenses, categories, receipts) | Running a restaurant involves many expenses (supplies, repairs, utilities). Standard ERP feature. | P2 |
| **Business Hours** (operating hours per day, holiday hours) | Needed for reporting (which day's sales), online ordering integration, and reservations. | P1 |
| **Onboarding Flow** (how a new user sets up the system) | Currently no PRD coverage of the first-run experience. The existing 6-step wizard is not documented in the PRD. | P0 |

---

## 2. Underdeveloped Areas (Mentioned but Insufficient)

### 2.1 Inventory & Supply Chain (Phase 7)

**Current PRD scope:**
- Stock counts, low-stock alerts, purchase orders

**Missing:**
- Suppliers (vendor management)
- Recipes / Bill of Materials (which inventory items go into each dish)
- Unit of measure catalog (kg, pcs, liter)
- Stock adjustments (waste, theft, corrections)
- Recipe yield management (how many dishes a batch produces)

**Why it matters:** Without recipes, "stock count" is meaningless — you can't calculate how much inventory a dish consumes. A restaurant needs to know: "If I sell 30 pizzas, did I use 30 pizza bases?"

### 2.2 Reporting & Analytics (Phase 7)

**Current PRD scope:**
- Z-Report, X-Report, daily summary, dashboard charts

**Missing:**
- Profit & loss (revenue - cost of goods sold - expenses)
- Product-level sales ranking (best/worst sellers)
- Staff performance metrics (orders taken, average ticket by waiter)
- Hourly sales distribution (peak hours)
- Tax liability report (total tax collected per rate)
- Payment mode breakdown (cash vs card vs UPI trends over time)

### 2.3 Multi-App Architecture (P0-P8)

**Current PRD scope:**
- 4 apps: Admin, Waiter, KDS, Display

**Missing:**
- The Waiter app PRD doesn't mention offline resilience (waiter app needs to work when sync is down)
- No spec for what happens to the KDS/Display apps when the Admin host is offline
- No mention of a shared/community component library across apps
- No mention of per-app theming (KDS needs large fonts, Display needs kiosk mode)

### 2.4 Customer Management

**Current PRD scope:**
- US05 (payments), US12 (display)

**Missing:**
- Customer loyalty / rewards program (points per visit, redeemable discounts)
- Customer visit history (number of visits, favorite items, average spend)
- Customer notes (allergies, preferences) visible to waitstaff
- Multiple addresses/contacts per customer
- Customer communication (SMS/email receipt, promotional messages)

---

## 3. Phase Reorganization Proposal

The current P0-P8 phasing was designed around core extraction first, but the schema audit reveals a better dependency order:

### Proposed: Revised Phases

| Phase | Focus | Key Deliverables | Dependencies |
|-------|-------|------------------|--------------|
| **P0** | Foundation | Onboarding redesign, schema migration framework, empty states, demo mode | None |
| **P1** | Core POS + Auth | Per-staff PIN auth, product modifiers, discount engine, order status lifecycle | P0 (schema) |
| **P2** | Multi-Device Sync | Sync layer hardening (what's built works), leaf app real-time updates, sync status | P1 (orders) |
| **P3** | Admin Deepening | Z/X reports, inventory (stock count, recipes, suppliers), modifiers UI | P1 (products) |
| **P4** | Waiter App | Table floor plan, streamlined POS, KOT printing, offline resilience | P2 (sync) |
| **P5** | KDS App | Order card feed, station filter, acknowledge/ready, sound alerts, item-level status | P2 (sync) |
| **P6** | Display App | Order number display, auto-scroll, color coding | P2 (sync) |
| **P7** | Operations | Reservations, shifts/time tracking, expenses, business hours | P3 (admin) |
| **P8** | Growth | Customer loyalty, cloud sync, multi-location, online ordering, mobile payments | P7 (ops) |

### Key changes from current PRD:

| Change | Rationale |
|--------|-----------|
| **Onboarding moved to P0** | Must be fixed before anyone can use the product. Current wizard ships 15 fields upfront. |
| **Schema migration moved to P0** | Every subsequent phase depends on schema changes. Must have a migration framework first. |
| **Modifiers added to P1** | Without modifiers, the POS is not usable for real restaurants. Critical gap. |
| **Discount engine added to P1** | Restaurants run promotions and discounts daily. Manual `discountAmount` fields are insufficient. |
| **Sync moved after core POS** | The sync layer exists and works. P1 doesn't need cloud sync — focus on product completeness first. |
| **Inventory broken into P3** | Suppliers and recipes depend on products existing (P1). Stock counts alone aren't useful without recipes. |
| **Reservations moved from "future" to P7** | A restaurant POS without reservations is incomplete. |
| **Customer loyalty added** | Essential for customer retention. Even a simple "10th visit free" program adds value. |

---

## 4. Missing User Stories

The current 25 user stories (US01-US25) omit important scenarios. Below are additions organized by persona.

### Owner (Rajesh) — Additions

| ID | Story | Priority |
|----|-------|----------|
| US26 | As an owner, I want to customize products with modifier groups (sizes, toppings, extras). | P0 |
| US27 | As an owner, I want to create discounts (percentage off, BOGO, happy hour) and apply them to orders. | P1 |
| US28 | As an owner, I want to see which menu items are selling best and worst. | P1 |
| US29 | As an owner, I want to configure my operating hours and holiday closures. | P1 |
| US30 | As an owner, I want to create recipes linking my dishes to inventory items. | P3 |
| US31 | As an owner, I want to track employee clock-in/clock-out and see hours worked. | P2 |
| US32 | As an owner, I want to log business expenses with receipts. | P2 |
| US33 | As an owner, I want customers to book tables through the system. | P2 |
| US34 | As an owner, I want to run a loyalty program (points per visit, redeemable rewards). | P3 |
| US35 | As an owner, I want to set up the system in under 30 seconds and configure details later. | P0 |

### Waiter (Priya) — Additions

| ID | Story | Priority |
|----|-------|---------|
| US36 | As a waiter, I want to add modifiers to items in an order (e.g., extra cheese, no onions). | P0 |
| US37 | As a waiter, I want to apply a discount to a customer's bill. | P1 |
| US38 | As a waiter, I want to see customer notes (allergies, preferences) when I select them. | P2 |
| US39 | As a waiter, I want to clock in/out from the app. | P2 |

### Chef (Hassan)  Additions

| ID | Story | Priority |
|----|-------|---------|
| US40 | As a chef, I want to see modifier selections on the KDS (e.g., "Extra Cheese" on a pizza). | P0 |
| US41 | As a chef, I want to see prep time estimates on order cards. | P1 |
| US42 | As a chef, I want to mark individual items as complete (not just the whole order). | P1 |

---

## 5. Non-Functional Requirements Updates

The current NFRs in `04-nonfunctional.md` are solid but have gaps:

| Gap | Suggested Addition |
|-----|-------------------|
| **Offline queue capacity** | How many pending operations should the offline queue hold? Suggestion: 10,000 entries |
| **Sync bandwidth** | Bandwidth target for sync between devices. Suggestion: < 100KB per typical sync cycle |
| **Database migration** | Schema versioning and migration strategy. Currently undocumented. Must support additive + breaking changes. |
| **Accessibility** | KDS needs high-contrast mode. Waiter app needs to work with gloves (larger touch targets). |
| **Multi-language** | Should UI strings be localizable? Suggest English + Hindi as initial targets for the Indian market. |
| **Concurrent order creation** | What happens when 3 waiters create orders simultaneously on different devices? Need to test with 5 concurrent creators. |

---

## 6. Specs That Need Updates Based on Schema Audit

| Spec Document | What Needs Updating |
|---------------|---------------------|
| `02-data-models.md` | Add OrderStatus enum, modifier_group/modifier models, discount models, recipe models. Update Staff (pin, email, admin type). Update Company (remove password, add adminStaffId). Update Order (staffId, diningTableId). Remove references to `company.password`. |
| `03-database-schema.md` | Incorporate 22 new tables. Update orders.status to INTEGER. Add order_status_history. Add staff.pin. Add modifier tables. Add discount tables. Add inventory tables (supplier, purchase_order, recipe). Add shifts/expenses/reservations. |
| `05-auth-session.md` | Update to reflect onboarding flow: admin staff created during setup, not migrated from Company.password. Add forgot-PIN flow with email. |
| `06-repositories.md` | Add repository interfaces for new entities (ModifierGroup, Discount, Recipe, etc.). Update OpLog integration checklist. |
| `07-provider-hierarchy.md` | Add providers for new entities. Update init order to include schema migration step. |
| `08-testing.md` | Add test cases for modifiers, discounts, inventory, reservations. Add E2E scenarios for multi-device order creation. |
| `09-migration-plan.md` | Add schema migration steps for each new table. Update phase plan to match revised phases (P0-P8 above). |

---

## 7. Summary

| Metric | Count |
|--------|-------|
| Missing feature areas (not in any PRD) | 6 |
| Underdeveloped areas (insufficient PRD coverage) | 4 |
| New user stories proposed | 17 |
| NFR gaps identified | 6 |
| Specs needing updates | 7 |
| Phases reorganized | All 9 phases revised |
