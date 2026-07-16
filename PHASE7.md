# Phase 7 — Molecular Tokenization & Domain Cohesion

> **Prerequisites:**
> - Phase 1 (Single-App Unification) — 28/28 ✅ (`ISSUES.md`)
> - Phase 2 (Feature Completion) — 15/15 ✅ (`PHASE2.md`)
> - Phase 3 (Native Store Hardening) — 12/13 ✅ + 1 ❓ (`PHASE3.md`)
> - Phase 4 (Waiter App & Production Hardening) — 14/14 ✅ (`PHASE4.md`)
> - Phase 6 (Component Tokenization & Design System) — ⚠️ see note below

> **Phase 6 note:** Core token infrastructure (`AppColors`, `AppSpacing`, `AppTypography`, `AppShadows`, `AppComponentStyle`) is complete. All atomic widgets (`AppButton`, `AppBadge`, `AppCard`, `AppTextField`, etc.) are tokenized and exist in `packages/eatery_core/lib/widgets/`. Two legacy files remain in `lib/components/` (`custom_text_from_field.dart`, `labeled_custom_text_from_field.dart`) — Phase 7 M6 retires them.
>
> Phase 6 tokenized atoms. Phase 7 tokenizes **domain molecules** — multi-atom compositions that express restaurant business concepts. A KDS ticket, a Waiter order list, and a Display status card are all the same entity (an `Order`) rendered differently. Currently they share nothing — every role defines its own colors, layout, and interaction model for the same data.
>
> **Core insight:** The `OrderStatus` enum in the data model defines raw `Colors.orange`/`Colors.blue` etc. — directly violating ADR-09. Every role ignores it and hardcodes its own status colors. Phase 7 fixes this at the **data model level**, then builds consistent molecules that consume the unified tokens.

---

## The Problem

### Problem 1: Order status has four competing color systems

**The data model** (`order_status.dart`):
```dart
enum OrderStatus {
  pending(0, 'Pending', Colors.orange),      // raw Flutter color
  preparing(1, 'Preparing', Colors.blue),
  ready(2, 'Ready', Colors.green),
  served(3, 'Served', Colors.teal),
  completed(4, 'Completed', Colors.grey),
  voided(5, 'Voided', Colors.red),
}
```

**KDS** (`ticket_page.dart:434`): `pending → AppColors.warning`, `preparing → AppColors.info`

**Waiter** (`orders_page.dart:332`): `pending → AppColors.warning`, `preparing → AppColors.info`, `completed → AppColors.success`

**Display** (`display_page.dart:376`): `pending → AppColors.warning`, `preparing → AppColors.info`, `completed → AppColors.success`

The data model says pending=orange, but every role shows yellow. The enum's `.color` property is **dead code** — no one reads it because it uses raw Flutter colors. (Verified: all `.status.color` callers reference `DiningTableStatus`, not `OrderStatus`.)

**Same problem in `DiningTableStatus`:** Its `.color` getter in `dining_table_status.dart` also returns raw Flutter colors (`Colors.green`, `Colors.orange`, `Colors.grey`). This is **out of scope** for Phase 7 — the table floor plan and dining table pages are not being refactored — but noted for ADR-09 compliance tracking.

### Problem 2: Order cards are role-specific silos

| Role | Widget | File | Lines | Pattern |
|---|---|---|---|---|
| KDS | `_StatusBadge` + inline card | `ticket_page.dart` | ~150 | Private `ConsumerWidget` inside page |
| Waiter | `_OrderCard` + `_statusColor` | `orders_page.dart` | ~120 | Private widget with switch-case color map |
| Display | `_OrderStatusCard` + `pulseAnimation` | `display_page.dart` | ~130 | Private `ConsumerWidget` with custom animation |
| Admin | Inline `ListTile` or `Card` | `orders.page.dart` | varies | No reusable widget at all |

**Four roles, four implementations, zero shared code.** The same data flows to all of them. This is the opposite of a design system — it's four independent UIs for the same concept.

### Problem 3: 900 lines of copy-paste form scaffolding

`create_company` has 6 `Body*` files (`body1.dart` through `body6.dart`) each containing:
- A `ListView` with identical scroll behavior
- `AppSpacing.gapMd` between fields
- `CustomTextFromField` widgets with manual `focusNode` chain
- A `Form(key: formKey)` wrapper

Same pattern appears in `add.customer`, `edit.customer`, `add.staff`, `edit.staff`, `add.product.category`, `edit.product.category`, `edit.company`, `add.tax_slab`, `edit.tax_slab` — **~15+ form pages**.

### Problem 4: Dashboard menu tiles use hardcoded colors that diverge from tokens

`dashboard.page.dart` line 30-110 has `_MenuItem` structs with raw hex colors:
```dart
_MenuItem(icon: Icons.restaurant_menu, label: 'Kitchen',
    color: const Color(0xFF873CA8)),  // ← Purple
```
But `AppColors.menuKitchen` is `Color(0xFF4AC3A1)` (green). The dashboard and settings pages show different colors for the same menu item.

**Full audit of all 16 `_MenuItem` colors:**

| Menu Item | `_MenuItem.color` (raw) | `AppColors.menu*` token | Match? |
|---|---|---|---|
| POS | `0xFF30A8CF` | `primary` (`0xFF30A8CF`) | ✅ |
| Orders | `0xFFF5A142` | `menuOrders` (`0xFFF5A142`) | ✅ |
| Payments | `0xFF2F5EC2` | `menuPayments` (`0xFF2F5EC2`) | ✅ |
| Reports | `0xFF43A047` | *(no menuReports token)* | ⚠️ No token |
| Reservations | `0xFF9C27B0` | *(no menuReservations)* | ⚠️ No token |
| Categories | `0xFFD98049` | `menuCategories` (`0xFFD98049`) | ✅ |
| **Kitchen** | **`0xFF873CA8` (purple)** | **`menuKitchen` (`0xFF4AC3A1`, green)** | ❌ **Mismatch** |
| Inventory | `0xFFC45C27` | `menuInventory` (`0xFF705EE0`) | ❌ **Mismatch** |
| Customers | `0xFF27AE60` | `menuCustomers` (`0xFF2FC289`) | ⚠️ Slight diff |
| Staff | `0xFF2980B9` | `menuStaff` (`0xFFC2592F`) | ❌ **Mismatch** |
| Tables | `0xFF8E44AD` | `menuDining` (`0xFFEF6850`) | ❌ **Mismatch** |
| Library | `0xFF16A085` | *(no menuLibrary token)* | ⚠️ No token |
| Data | `0xFFE74C3C` | `menuData` (`0xFFEF9050`) | ❌ **Mismatch** |
| Settings | `0xFF7F8C8D` | `menuSettings` (`0xFF222222`) | ❌ **Mismatch** |
| Plus 2 extras | `0xFF8B97A2`, `0xFF090F13` | *(in header, not menu)* | — |

**Only 3 of 14 menu items match.** The `_MenuItem.color` values are a completely independent color scheme from the `AppColors.menu*` tokens. The plan should align all `_MenuItem.colors` to the `AppColors.menu*` tokens (which come from the settings page — the intended source of truth).

### Problem 5: No visual notification when orders change status

KDS got a sound chime (Phase 4). But there's no visual banner. Waiter polls `syncStatusProvider` but shows nothing when an order status changes. Display has passive refresh. A unified notification molecule serves all three notification-hungry roles.

---

## The Plan — 5 Domain Molecules

### M1: Fix status colors at the data model level

**File:** `packages/eatery_core/lib/data/models/order/order_status.dart`

**Change:** Remove the raw `Color` field from the enum. Add `AppColors.status*` tokens.

```dart
// BEFORE (broken — raw Flutter colors, ignored by all callers)
enum OrderStatus {
  pending(0, 'Pending', Colors.orange),
  preparing(1, 'Preparing', Colors.blue),
  ...
  final Color color;
}

// AFTER (tokenized — single source of truth)
enum OrderStatus {
  pending(0, 'Pending'),
  preparing(1, 'Preparing'),
  ready(2, 'Ready'),
  served(3, 'Served'),
  completed(4, 'Completed'),
  voided(5, 'Voided');
}

// In app_colors.dart — these are the ACTUAL colors every role uses today
static const Color statusPending   = warning;     // yellow — matches all 3 roles
static const Color statusPreparing = info;        // blue  — matches all 3 roles
static const Color statusReady     = success;     // green
static const Color statusServed    = Color(0xFF009688); // teal (from enum)
static const Color statusCompleted = grey500;     // grey
static const Color statusVoided    = error;       // red
```

**New tokens:** 4 (`statusReady`, `statusServed`, `statusCompleted`, `statusPending`/`statusPreparing`/`statusVoided` reuse existing semantic tokens)

**Migration:** KDS, Waiter, Display switch from local `switch(order.status)` color maps → `OrderStatus.colorFor(status)` static method that reads `AppColors.status*`.

**Risk:** Low — colors match what every role already shows (yellow for pending, blue for preparing). Only the data model's dead `Colors.orange`/`Colors.blue` references go away.

---

### M2: `OrderStatusCard` — one card, four roles

**File:** `packages/eatery_core/lib/widgets/app_order_card.dart`

**Purpose:** One widget that renders an order summary across all roles with role-appropriate actions and layout.

```dart
enum OrderCardContext { kds, waiter, display, admin }

AppOrderCard(
  order: order,
  context: OrderCardContext.kds,
  onStart: () => repo.startOrder(order),
  onComplete: () => repo.completeOrder(order),
  onVoid: () => _showVoidDialog(order),
)
```

| Context | Layout | Actions | Animations | Height |
|---|---|---|---|---|
| `kds` | Large card, prominent status badge, elapsed timer | Start / Done | None | Auto-expand |
| `waiter` | Compact card, status + table number | Tap for details | Fade on complete | Fixed 80 |
| `display` | Grid card, customer-facing text, large status | None | Lottie burst on new, pulse on preparing | Aspect 1.6 |
| `admin` | List tile, full detail, edit/void access | Edit / Void / Print | None | Standard tile |

**Tokens consumed:**
- `AppColors.status*` for badge colors
- `AppTypography.orderCardTitle/Subtitle/Status`
- `AppSpacing.orderCard*` for padding/radius per context
- `AppShadows.cardElevated` for kds/waiter, none for display

**Replaces:**
| Old code | Replaced by |
|---|---|
| `_StatusBadge` (KDS, ~30 lines) | `AppOrderCard` internal component |
| `_OrderCard` + `_statusColor` (Waiter, ~80 lines) | `AppOrderCard(context: waiter)` |
| `_OrderStatusCard` + pulse animation (Display, ~100 lines) | `AppOrderCard(context: display)` |
| Admin inline order cards | `AppOrderCard(context: admin)` |

**Files changed:** 1 new + 4 callers refactored. Net ~-200 lines.

---

### M3: `StatusTimeline` — visualize order history

**File:** `packages/eatery_core/lib/widgets/app_status_timeline.dart`

**Purpose:** Vertical timeline showing status transitions. Used in order details (admin/waiter), KDS ticket view, Display order popup.

```dart
AppStatusTimeline(transitions: order.statusHistory)
```

Each step shows: status badge → timestamp → staff name (if available) → reason (if voided).

**Tokens consumed:**
- `AppColors.status*` for step dots
- `AppColors.timelineLine` (new: `grey300`)
- `AppTypography.timelineLabel/Sublabel` (new: `bodySmall`/`labelSmall`)
- `AppSpacing.timelineGap`, `timelineDotSize`

**Files changed:** 1 new + 2 callers (view.order.page, kds ticket detail). **Zero existing widget to replace** — this is new functionality.

**Why it matters:** `OrderStatusHistory` exists in the data model. No screen visualizes them — staff can't see when an order was started or by whom.

**Staff name resolution:** `OrderStatusHistory.changedByStaffId` (int?) requires a join to the `staff` table for display. The `OrderRepository.getStatusHistory()` method should be verified to include staff name data, or a follow-up provider should enrich the timeline entries.

**Seed data note:** The test seed data in `lib/dev/seed_data.dart` may need additional `OrderStatusHistory` records added to have data visible during development of this widget.

---

### M4: `AppMultiStepForm` — eliminate body1..body6

**File:** `packages/eatery_core/lib/widgets/app_multistep_form.dart`

**Purpose:** Step indicator + content area + back/next button shell. Replaces the `Body1`-`Body6` pattern in `create_company` and any future multi-step flow.

```dart
AppMultiStepForm(
  steps: const ['Company', 'Auth', 'Taxation', 'Currency', 'Plan', 'Summary'],
  currentStep: index,
  onStepChanged: (i) => setState(() => index = i),
  child: bodies[index],
)
```

Internal implementation: `Column` with step dots row + divider + `Expanded(child)`.

**Tokens consumed:**
- `AppColors.stepActive` (new: `primary`), `stepInactive` (new: `grey300`), `stepCompleted` (new: `success`)
- `AppSpacing.stepIndicatorGap`, `stepDotSize`
- `AppTypography.stepLabel`

**Files changed:** 1 new + `create_company.page.dart` rewritten (~250→80 lines) + 6 body files deleted (~900 lines removed).

**Why it matters:** The create-company flow is the most complex onboarding in the app. 6 body files with identical `ListView` + gap + button patterns. Total ~900 lines of copy-paste.

**Conditional step complexity:** Body4 is conditionally rendered (`taxation != Taxation.none`). When taxation is "No Tax", the step index shifts for Body5 and Body6. The `AppMultiStepForm` implementation must support variable-length step arrays — either by skipping steps entirely or using a `Set<int> hiddenSteps` pattern. The current code uses conditional `if (taxed)` branches in both `bodies()` and `bottomAppBars()` — this is the trickiest part to refactor cleanly.

---

### M5: `AppNotificationBanner` — unified cross-role alerts

**File:** `packages/eatery_core/lib/widgets/app_notification_banner.dart`

**Purpose:** Slide-down banner shown when a new order arrives (KDS), when order status changes (Waiter), or when sync fails (Admin).

```dart
AppNotificationBanner.show(
  context,
  type: NotificationType.orderReady,
  message: 'Order #42 — Table 3',
  onTap: () => router.pushNamed('viewOrder', pathParameters: {'id': '42'}),
  autoDismiss: Duration(seconds: 5),
)
```

Uses `Overlay.insert()` internally — no scaffold dependency. Shows from any role at any depth.

**Tokens consumed:**
- `AppColors.notificationBanner*` (new: reuses existing `notification*` or defines role-specific)
- `AppColors.status*` for status-colored border
- `AppSpacing.bannerHeight`, `bannerPadding`, `bannerAnimationDuration`
- `AppTypography.bannerLabel`

**Existing hacks this replaces:**
| Role | Current hack | Replaced by |
|---|---|---|
| KDS | `AudioPlayer` chime only — no visual | `AppNotificationBanner.show(context, type: orderReady)` + sound |
| Waiter | `ref.listenManual(syncStatusProvider)` with no visible feedback | Banner on status change |
| Admin | `ScaffoldMessenger.showSnackBar` ad-hoc | Unified banner API |

**Files changed:** 1 new + 3 callers. **Zero existing widget to replace** — this is new functionality.

**Diff-based triggering note:** The current `listenManual(syncStatusProvider, ...)` in KDS/Waiter/Display only detects sync cycle completion — it can't tell *which* order changed or *what* changed. To show a meaningful banner like "Order #42 is now Ready!", the notification logic needs to diff the order list before/after each sync. The KDS already has pattern precedent for this — `_activeOrdersProvider` listener (ticket_page.dart:81) compares `prev` vs `next` order counts. This same pattern should be extended to compare individual order statuses.

---

### M6 (low-effort): `AppFormField` — retire the last legacy widget

**File:** `packages/eatery_core/lib/widgets/app_form_field.dart`

**Purpose:** One molecule that absorbs the label + spacing + focus-chain pattern repeated across 50+ files.

**Actual caller count:** 66 `LabeledCustomTextFormField` matches across **23 files**. This is the largest mechanical change in Phase 7.

```dart
AppFormField(
  label: 'Customer Name',
  hint: 'Enter full name',
  controller: _controllerCustomerName,
  focusNext: _focusNodes[1],
  validator: (v) => v!.isEmpty ? 'Required' : null,
)
```

Internal: `Column` containing `Text(label)` + `AppSpacing.fieldLabelGap` + `AppTextField(...)` + `AppSpacing.gapMd`.

**Tokens consumed:** All existing — `fieldLabel`, `fieldLabelGap`, `gapMd`, `fieldBorder`.

**Files changed:** 1 new + 23 callers (mechanical find-and-replace in batches of 5-8). This finally retires `LabeledCustomTextFormField` and `CustomTextFromField`.

**Risk:** HIGH — Phase 6 explicitly deferred this for a reason. Each file is a real CRUD form (add/edit customer, staff, product, etc.). Testing each manually is impractical. Strategy: migrate in batches of 5-8 files, run `flutter analyze` and `flutter test` after each batch. Run this M6 step **last** after M1-M5 are verified green.

---

## New Tokens Required

| File | Tokens |
|---|---|
| `app_colors.dart` | `statusPending`(=warning), `statusPreparing`(=info), `statusReady`(=success), `statusServed`(=0xFF009688), `statusCompleted`(=grey500), `statusVoided`(=error); `timelineLine`(=grey300); `stepActive`(=primary), `stepInactive`(=grey300), `stepCompleted`(=success) |
| `app_spacing.dart` | `orderCardHeight*` per context; `timelineGap`, `timelineDotSize`; `stepIndicatorGap`, `stepDotSize`; `bannerHeight`, `bannerPadding`, `bannerAnimationDuration` |
| `app_typography.dart` | `orderCardTitle/Subtitle/Status`; `timelineLabel/Sublabel`; `stepLabel`; `bannerLabel` |
| `app_shadows.dart` | (no new tokens — reuse `cardElevated`) |

---

## Files Changed

| # | File | Change |
|---|---|---|
| 1 | `packages/eatery_core/lib/data/models/order/order_status.dart` | Remove raw `Color` field, add static `colorFor()` returning `AppColors.status*` |
| 2 | `packages/eatery_core/lib/theme/app_colors.dart` | Add ~10 domain color tokens |
| 3 | `packages/eatery_core/lib/theme/app_spacing.dart` | Add ~10 domain spacing tokens |
| 4 | `packages/eatery_core/lib/theme/app_typography.dart` | Add ~8 domain typography tokens |
| 5 | `packages/eatery_core/lib/widgets/app_order_card.dart` | **New** — unified order status card |
| 6 | `packages/eatery_core/lib/widgets/app_status_timeline.dart` | **New** — status transition timeline |
| 7 | `packages/eatery_core/lib/widgets/app_multistep_form.dart` | **New** — step indicator + content shell |
| 8 | `packages/eatery_core/lib/widgets/app_notification_banner.dart` | **New** — slide-down notification |
| 9 | `packages/eatery_core/lib/widgets/app_form_field.dart` | **New** — label + field + gap molecule |
| 10 | `packages/eatery_core/lib/widgets/widgets.dart` | Add all new exports |
| 11 | `lib/pages/kds/ticket_page.dart` | Replace `_StatusBadge` + inline card → `AppOrderCard(kds)` |
| 12 | `lib/pages/waiter/orders_page.dart` | Replace `_OrderCard` + `_statusColor` → `AppOrderCard(waiter)` |
| 13 | `lib/pages/display/display_page.dart` | Replace `_OrderStatusCard` → `AppOrderCard(display)` |
| 14 | `lib/pages/dashboard/order/orders.page.dart` | Use `AppOrderCard(admin)` |
| 15 | `lib/pages/dashboard/order/view.order.page.dart` | Add `AppStatusTimeline` |
| 16 | `lib/pages/create_company/create_company.page.dart` | Replace 6 `Body*` files → `AppMultiStepForm` |
| 17-22 | `lib/pages/create_company/components/body1..body6.dart` | **Delete** (6 files, ~900 lines) |
| 23 | `lib/pages/dashboard/dashboard.page.dart` | Replace `_MenuItem.color` raw hex → `AppColors.menu*` tokens |
| 24-28 | KDS/Waiter/Display notification hooks | Wire `AppNotificationBanner.show()` |
| 29 | `lib/components/labeled_custom_text_from_field.dart` | **Delete** — all 50 callers migrated to `AppFormField` |
| 30 | `lib/components/custom_text_from_field.dart` | **Delete** — internal to LabeledCustomTextFormField |
| 31 | `lib/components/` directory | **Delete** — now completely empty |
| 32 | ~23 form page files | `LabeledCustomTextFormField(...)` → `AppFormField(...)` mechanical migration (batches of 5-8, analyze+test each batch) |
| 33 | `lib/references.dart` | Remove dead `./components/` exports |

---

## Execution Order

```
M1 (OrderStatus colors)
  ↓
M2 (AppOrderCard — unified card, 4 roles)
  ↓
M3 (AppStatusTimeline — new widget)
  ↓
M4 (AppMultiStepForm — create-company refactor)
  ↓
M5 (AppNotificationBanner — overlay banner + wire 3 roles)
  ↓
M6 ⬅️ DO LAST — AppFormField + 23-file migration in batches
```

**Key sequencing rules:**
1. **M1 first** — every other molecule consumes `AppColors.status*` tokens
2. **M6 last** — highest risk, do only after everything else is green
3. **M5 before M6** — the banner uses `AppNotification` (already exists in `eatery_core`) and needs live listeners to test — do while the app is fully operational before the 23-form migration
4. **M2-M4** are independent of each other (all consume M1 tokens) and can be done in any order

**ADR-09 formalization:** The ADR-09 standard ("Zero raw visual values in widget code") is currently only documented in `PHASE6.md`. After completing Phase 7, promote it to `docs/decisions/004-zero-raw-visual-values.md` for permanent documentation.

---

## Build & Verify

```bash
# After M1 (data model — 3 role callers need update):
flutter analyze lib/    # status color field removal catches all stale references

# After each M2-M6 step:
flutter analyze lib/    # verify no regressions
flutter test            # 81/81 passed

# After M4 (multistep form):
flutter test            # verify create-company flow still works in tests

# After M6 (form field migration — largest mechanical change):
flutter analyze lib/    # 0 errors
flutter test            # 81/81 passed
flutter test packages/eatery_core/test/    # 51/51 passed

# Full build:
flutter build apk --debug
```

## Smoke Tests

| # | Role | Scenario | Expected |
|---|---|---|---|
| S1 | KDS | New order arrives | `AppOrderCard(kds)` renders with yellow pending badge, elapsed timer |
| S2 | KDS | Tap "Start" | Status badge turns blue (preparing), "Done" button appears |
| S3 | KDS | Tap "Done" | Card animates out, `AppNotificationBanner` shows "completed" |
| S4 | Waiter | View orders list | `AppOrderCard(waiter)` shows status + table number compact |
| S5 | Waiter | Tap order card | Opens order detail with `AppStatusTimeline` |
| S6 | Waiter | KDS completes their order | `AppNotificationBanner` slides down on Waiter screen |
| S7 | Display | New order created | `AppOrderCard(display)` renders with Lottie burst animation |
| S8 | Display | Order preparing | Pulse animation starts, customer-facing status text |
| S9 | Admin | View all orders | `AppOrderCard(admin)` shows full data with edit/void access |
| S10 | Admin | Open order detail | `AppStatusTimeline` shows all transitions with timestamps |
| S11 | Admin | Create company flow | `AppMultiStepForm` renders 6 steps with correct active/inactive dots |
| S12 | Admin | Add customer form | `AppFormField` renders label + field + gap consistently |
| S13 | Admin | Settings → Kitchen | Menu tile color matches `AppColors.menuKitchen` (green) |
| S14 | Admin | Dashboard → Kitchen | Menu card color matches settings (green) — no more purple/blue inconsistency |
