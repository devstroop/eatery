# UI Standardization Plan -- Phase 1

> Audit findings + phased migration plan for standardizing all UI components to be responsive, theme-consistent, and platform-friendly across desktop, tablet, and mobile.

---

## 1. Current State Assessment

### 1.1 Shell Wrappers

| Shell | Purpose | Pages Using It |
|-------|---------|---------------|
| `AppPageShell` | Responsive content wrapper with desktop centering (max 720px) | **8/50+** |
| `AppAdaptiveShell` | Multi-platform nav scaffold (bottom nav / rail / sidebar) | **0** |
| Raw `Scaffold` | No responsive constraints | **37+** |

### 1.2 Legacy Component Usage

| Legacy Widget | Replacement | Est. Call Sites |
|---------------|-------------|-----------------|
| `PrimaryButton` | `AppButton.primary()` | 24+ |
| `SecondaryButton` | `AppButton.secondary()` | 8+ |
| `CustomTextFromField` | `AppTextField` | 12+ |
| `LabeledCustomTextFormField` | `AppTextField` | 8+ |
| `SearchTextField` | `AppSearchField` | 3+ |
| `showMessageDialog()` | `AppDialog.show()` (extended) | 20+ |
| `showConfirmationDialog()` | `AppDialog.show()` | 8+ |
| `KColors.*` | `AppColors.*` | 24+ |

### 1.3 Routing

- **100% imperative**: 81 `Navigator.push(MaterialPageRoute(...))` call sites
- **No GoRouter**, no named routes, no deep linking
- Dashboard uses a hand-rolled string-switch router in `_onTap()`

### 1.4 Responsive Readiness

| Page | Responsive? | Shell | Notes |
|------|-------------|-------|-------|
| DashboardPage | Partial | Raw Scaffold | Uses Responsive.*, not AppAdaptiveShell |
| PointOfSalePage | Partial | Raw Scaffold | Category sidebar not collapsible on mobile |
| CartPage | No | Raw Scaffold | 250+ lines business logic in widget |
| LoginPage | Partial | Raw Scaffold | Uses LayoutBuilder |
| OrdersPage | Yes | AppPageShell | Already Migrated |
| CustomersPage | Yes | AppPageShell | Already Migrated |
| ~20 CRUD form pages | No | Raw Scaffold | No desktop width constraint |
| ~5 detail/view pages | No | Raw Scaffold | No desktop width constraint |
| ~5 settings pages | No | Raw Scaffold | No desktop width constraint |
| ~12 StatefulWidget pages | No | Raw Scaffold | Also need Riverpod migration |

---

## 2. Migration Plan

### Sub-phase 1A: Shell Migration

**Goal:** Every page wrapped in either `AppPageShell` or `AppAdaptiveShell`.

| Item | File(s) | Action |
|------|---------|--------|
| 1a.1 | `dashboard.page.dart` | Convert to `AppAdaptiveShell` with `AppNavDestination` routes |
| 1a.2 | ~20 CRUD form pages | Wrap in `AppPageShell` for desktop centering |
| 1a.3 | ~5 detail/view pages | Wrap in `AppPageShell` |
| 1a.4 | ~5 settings pages | Wrap in `AppPageShell` |
| 1a.5 | `LoginPage`, `ResetPinScreen` | Wrap in `AppPageShell` |
| 1a.6 | Remaining stragglers (~10) | Wrap in `AppPageShell` |

**CRUD form pages to migrate:**
- `add.customer.page.dart`, `edit.customer.page.dart`
- `add.payment.page.dart`, `edit.payment.page.dart`
- `add.dining_table.page.dart`, `edit.dining_table.page.dart`
- `add.dining_table.category.page.dart`, `edit.dining_table.category.page.dart`
- `add.product.category.page.dart`, `edit.product.category.page.dart`
- `add.inventory_item.page.dart`, `edit.inventory_item.page.dart`
- `add.kitchen_dish.page.dart`, `edit.kitchen_dish.page.dart`
- `add.staff.page.dart`, `edit.staff.page.dart`
- `add.tax_slab.page.dart`, `edit.tax_slab.page.dart`
- `edit.company.page.dart`, `view.currency_region.page.dart`

**Detail/view pages to migrate:**
- `view.customer.page.dart`, `view.payment.page.dart`
- `view.dining_table.page.dart`, `view.order.page.dart`
- `view.company.page.dart`

**Settings pages to migrate:**
- `settings.page.dart`, `printer.setting.page.dart`
- `tax_slabs.page.dart`, `data_management.page.dart`
- `backup_restore.page.dart`

**Stragglers:**
- `import.page.dart`, `export.page.dart`
- `calculator.page.dart`, `help.page.dart`, `upgrade.page.dart`
- `pos.page.dart`, `cart.page.dart`, `order_confirmation.page.dart`
- `order_print.page.dart`, `image_library.page.dart`

### Sub-phase 1B: Legacy Component Replacement

**Goal:** Zero references to legacy widget classes. Delete old files after migration.

| Item | Old | New | Scope |
|------|-----|-----|-------|
| 1b.1 | `PrimaryButton` | `AppButton.primary()` | 24+ sites across all pages |
| 1b.2 | `SecondaryButton` | `AppButton.secondary()` | Settings, auth pages |
| 1b.3 | `CustomTextFromField` | `AppTextField` | All CRUD forms |
| 1b.4 | `LabeledCustomTextFormField` | `AppTextField` | All CRUD forms |
| 1b.5 | `SearchTextField` | `AppSearchField` | POS, order search |
| 1b.6 | `showMessageDialog()` | `AppDialog.show()` + icon support | All pages |
| 1b.7 | `showConfirmationDialog()` | `AppDialog.show(destructive:)` | All pages |

**Pre-requisite:** Extend `AppDialog.show()` to support optional icon + icon color parameter so it can replace `showMessageDialog`'s type-based icons.

### Sub-phase 1C: Theme Token Migration

**Goal:** Zero references to `KColors`, `SpacingStyle`, raw `TextStyle(fontSize:)`, raw padding/margin.

| Item | What | Scope |
|------|------|-------|
| 1c.1 | `KColors.*` -> `AppColors.*` | 24+ references -- audit each for correct value mapping |
| 1c.2 | Raw `TextStyle(fontSize:)` -> `AppTypography.*` | Legacy widgets, page titles, bottom sheets |
| 1c.3 | Raw padding/margin -> `AppSpacing.*` | Legacy widgets, POS layout |
| 1c.4 | Raw `Color(0xFF...)` in legacy widgets -> `AppColors.*` | `FoodTypeBadge`, `NotificationWidget`, `LowQtyLabelWidget` |

**KColors -> AppColors mapping (divergent values to resolve):**

| KColors | AppColors | Same? |
|---------|-----------|-------|
| `KColors.primary` (#30A8CF) | `AppColors.primary` (#30A8CF) | Yes |
| `KColors.secondary` (#4AC3A1) | `AppColors.secondary` (#4AC3A1) | Yes |
| `KColors.secondary2` (#5CAA4B) | `AppColors.secondary2` (#74B952) | Differs |
| `KColors.green` (#5CAA4B) | `AppColors.success` (#4AC3A1) | Differs |
| `KColors.yellow` (#AD8D3B) | `AppColors.warning` (#F5A142) | Differs |
| `KColors.red` (#E53935) | `AppColors.error` (#EF6850) | Differs |

### Sub-phase 1D: Responsive Hardening

**Goal:** Every page properly handles all screen sizes, not just mobile.

| Item | Page | Issue | Fix |
|------|------|-------|-----|
| 1d.1 | `pos.page.dart` | Category sidebar is fixed `Flexible(flex: 2)` -- doesn't collapse | Wrap in responsive sidebar (drawer on mobile, persistent on desktop) |
| 1d.2 | `cart.page.dart` | No desktop width constraint; 250+ lines business logic in widget | Wrap in `AppPageShell`; extract `placeOrder` into controller/use-case |
| 1d.3 | `dashboard.page.dart` | After shell migration, ensure `Wrap` grid adapts to `AppAdaptiveShell`'s sidebar | Use `LayoutBuilder` inside content area |
| 1d.4 | List pages (x6) | Don't use `ResponsiveListView` | Apply `ResponsiveListView` to remaining `AppPageShell` list pages |

### Sub-phase 1E: GoRouter Adoption (Optional -- Deep First)

**Goal:** Replace 81 imperative `Navigator.push` calls with declarative routing.

| Item | Action |
|------|--------|
| 1e.1 | Install GoRouter, define route table |
| 1e.2 | Replace `DashboardRoutes._onTap` switch with `context.goNamed()` |
| 1e.3 | Replace `Navigator.push(MaterialPageRoute(...))` in all pages with `context.push()` |
| 1e.4 | Replace `Navigator.pushAndRemoveUntil` / `Navigator.pushReplacement` with GoRouter equivalents |

### Sub-phase 1F: StatefulWidget -> ConsumerStatefulWidget

**Goal:** Every stateful page uses Riverpod.

| Item | Page | File |
|------|------|------|
| 1f.1 | MainScreen | `main.screen.dart` |
| 1f.2 | ResetPinScreen | `reset-pin.dart` |
| 1f.3 | CalculatorPage | `calculator.page.dart` |
| 1f.4 | ImageLibraryPage | `image_library.page.dart` |
| 1f.5 | LogoutPage | `logout.page.dart` |
| 1f.6 | Body5, Body6 | Create company components |
| 1f.7 | CreateCompanyResultPage | `result.create_company.dart` |
| 1f.8 | EditOrderPage | `edit.order.page.dart` |
| 1f.9 | ExportPage | `export.page.dart` |
| 1f.10 | UpgradePage | `upgrade.page.dart` |
| 1f.11 | HelpPage | `help.page.dart` |

### Sub-phase 1G: Cleanup

**Goal:** Delete migrated legacy files, update specs.

| Item | Action |
|------|--------|
| 1g.1 | Delete `lib/widgets/buttons/primary.button.dart` |
| 1g.2 | Delete `lib/widgets/buttons/secondary.button.dart` (if exists) |
| 1g.3 | Delete `lib/components/custom_text_from_field.dart` |
| 1g.4 | Delete `lib/components/labeled_custom_text_from_field.dart` |
| 1g.5 | Delete `lib/components/secondary_button.dart` |
| 1g.6 | Delete `lib/components/special_button.dart` (if fully replaced) |
| 1g.7 | Delete `lib/constants/style/color_style.dart` (KColors) |
| 1g.8 | Delete `lib/constants/style/spacing_style.dart` |
| 1g.9 | Delete `lib/widgets/dialogs/showConfirmationDialog.dart` |
| 1g.10 | Delete `lib/widgets/dialogs/showMessageDialog.dart` |
| 1g.11 | Delete `lib/widgets/textFields/search.textField.dart` |
| 1g.12 | Update `specs/` documents to reflect final state |

---

## 3. Dependency Graph

```
1A (Shells) --------------------------------+
     |                                       |
     v                                       v
1B (Legacy replacement) <-- 1C (Theme tokens) --> 1D (Responsive)
     |                                       |
     v                                       |
1F (StatefulWidget) ---- 1E (GoRouter) <-----+
     |
     v
1G (Cleanup)
```

**Ordering constraints:**
- 1A (Shells) blocks everything -- must be first
- 1B (Legacy replacement) and 1C (Theme tokens) can run in parallel
- 1D (Responsive hardening) depends on 1A for shell, but can run early on pages already wrapped
- 1E (GoRouter) depends on 1A (pages need stable shell before route restructuring)
- 1F (StatefulWidget migration) depends on 1B (need AppButton/AppDialog available)
- 1G (Cleanup) is last -- only after all replacements are verified

---

## 4. Files to Modify

### Core Framework Changes
| File | Change |
|------|--------|
| `lib/core/widgets/app_dialog.dart` | Add optional `icon` + `iconColor` params to `show()` |
| `lib/core/widgets/app_page_shell.dart` | Verify all params cover CRUD form needs |
| `lib/pages/dashboard/dashboard.page.dart` | Rewrite to use `AppAdaptiveShell` + `AppNavDestination` |

### Per-Page Changes
~50 page files, each getting:
- Import changes (old -> new widget imports)
- Constructor calls (PrimaryButton -> AppButton.primary, etc.)
- Dialog calls (showMessageDialog -> AppDialog.show)
- Shell wrapper (raw Scaffold -> AppPageShell)
- Color references (KColors -> AppColors)
- Typography (raw TextStyle -> AppTypography)
- Spacing (raw padding -> AppSpacing)

### Deletions
~20 legacy files deleted after full migration.

---

## 5. Verification

### Build integrity
```bash
dart analyze lib/
# Zero errors
```

### Visual consistency checklist
- [ ] All list pages use `AppPageShell` with desktop centering
- [ ] All CRUD form pages use `AppPageShell` with desktop centering
- [ ] Dashboard uses `AppAdaptiveShell` with correct breakpoint behavior
- [ ] POS page sidebar collapses on mobile
- [ ] Cart page has desktop width constraint
- [ ] All buttons use `AppButton` variants
- [ ] All text fields use `AppTextField`
- [ ] All dialogs use `AppDialog.show()`
- [ ] All colors reference `AppColors.*` (zero `KColors`)
- [ ] All typography references `AppTypography.*`
- [ ] All spacing references `AppSpacing.*`

### Counts
- [ ] Zero `PrimaryButton` references
- [ ] Zero `SecondaryButton` references
- [ ] Zero `CustomTextFromField` references
- [ ] Zero `showMessageDialog`/`showConfirmationDialog` references
- [ ] Zero `KColors.*` references
- [ ] Zero `SpacingStyle.*` references
- [ ] Zero `StatefulWidget` pages remaining (all -> `ConsumerStatefulWidget`)
- [ ] Zero legacy widget files remaining (all old `.dart` files deleted)
