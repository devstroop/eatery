# Component Library

Two widget systems exist side by side:
1. **New (responsive)** — `packages/eatery_core/lib/widgets/` (current standard)
2. **Legacy** — `lib/widgets/` + `lib/components/` (mobile-centric, being migrated)

## New Core Components

All import via `package:eatery_core/widgets/widgets.dart`.

### AppButton (`packages/eatery_core/lib/widgets/app_button.dart`)

Four named constructors:

```dart
AppButton.primary(label: 'Save', onPressed: () {})        // Filled brand color
AppButton.secondary(label: 'Cancel', onPressed: () {})     // Outlined
AppButton.destructive(label: 'Delete', onPressed: () {})   // Red filled
AppButton.ghost(label: 'Skip', onPressed: () {})           // Text-only
```

Each accepts optional `height`, `width`, `loading`, and `icon` parameters.

### AppCard (`packages/eatery_core/lib/widgets/app_card.dart`)

```dart
AppCard(
  onTap: () {},
  padding: EdgeInsets.all(12),
  child: Text('Content'),
)
```

Consistent card with 12px border radius, no elevation, white background, optional tap handler.

### AppTextField (`packages/eatery_core/lib/widgets/app_text_field.dart`)

```dart
AppTextField(
  label: 'Name',
  hint: 'Enter name...',
  controller: myController,
  validator: (v) => v!.isEmpty ? 'Required' : null,
)
```

Standard form field with label, validation, password toggle support.

### AppSearchField (`packages/eatery_core/lib/widgets/app_search_field.dart`)

```dart
AppSearchField(
  hint: 'Search products...',
  onChanged: (query) => filter(query),
)
```

Search bar with Cmd+K/F shortcut hint on desktop.

### AppEmptyState (`packages/eatery_core/lib/widgets/app_empty_state.dart`)

```dart
const AppEmptyState(
  icon: Icons.inbox,
  title: 'No data',
  subtitle: 'Add something to get started',
)
```

### AppSkeleton (`packages/eatery_core/lib/widgets/app_skeleton.dart`)

Shimmer loading placeholders with named constructors:

```dart
AppSkeleton(height: 14)                       // Line
AppSkeleton.card(height: 120)                 // Card
AppSkeleton.avatar(size: 40)                  // Circle
const AppSkeletonList(count: 5)               // List of cards
```

### AppDialog (`packages/eatery_core/lib/widgets/app_dialog.dart`)

Two display modes:

```dart
// Confirmation dialog (platform-default)
await AppDialog.show(
  context,
  title: 'Confirm',
  content: 'Are you sure?',
  confirmLabel: 'Yes',
  cancelLabel: 'No',
  destructive: true,
  onConfirm: () {},
);

// Adaptive: bottom sheet on mobile, dialog on desktop
await AppDialog.showAdaptive(
  context,
  title: 'Filter',
  child: filterWidget,
);
```

### AppPageShell (`packages/eatery_core/lib/widgets/app_page_shell.dart`)

Standard page wrapper for all migrated pages:

```dart
AppPageShell(
  title: 'Products',
  color: AppColors.menuInventory,
  actions: [IconButton(...)],
  floatingActionButton: FloatingActionButton(...),
  fullWidth: false,          // true = no desktop centering
  showBack: true,
  child: ListView(...),
)
```

Provides:
- AppBar with back button and theme color accent
- `AppColors.grey200` background
- Desktop content centering at 720px max width (unless `fullWidth`)
- `resizeToAvoidBottomInset`

### AppAdaptiveShell (`packages/eatery_core/lib/widgets/app_adaptive_shell.dart`)

Adaptive tab navigation scaffold:

```dart
AppAdaptiveShell(
  title: 'Eatery',
  destinations: [
    AppNavDestination(icon: Icons.home, label: 'Dashboard', page: const Dashboard()),
    AppNavDestination(icon: Icons.receipt, label: 'Orders', page: const Orders()),
  ],
)
```

Switches navigation pattern per breakpoint (see [Responsive Design](responsive-design.md)).

### AppTableView (`packages/eatery_core/lib/widgets/app_table_view.dart`)

Renders as `DataTable` on desktop, card list on mobile:

```dart
AppTableView(
  columns: const ['Name', 'Price', 'Qty'],
  rows: products.map((p) => [p.name, '\$${p.mrpPrice}', '10']).toList(),
  onRowTap: (i) => edit(i),
  onRowDelete: (i) => delete(i),
)
```

### floor_plan_widget (`packages/eatery_core/lib/widgets/floor_plan_widget.dart`)

Interactive dining table floor plan — drag-and-drop table positioning with posX/posY coordinates. Used by both Admin (setup) and Waiter (view) apps.

### modifier_sheet (`packages/eatery_core/lib/widgets/modifier_sheet.dart`)

Bottom sheet for selecting product modifiers (add-ons, customizations). Reads from modifier_group/modifier tables.

### sync_host_settings_sheet (`packages/eatery_core/lib/widgets/sync_host_settings_sheet.dart`)

Bottom sheet for configuring sync role: "Become Host" or "Enter Host IP".

### sync_status_chip (`packages/eatery_core/lib/widgets/sync_status_chip.dart`)

Status indicator showing sync connection state (connected/disconnected/syncing). Reads from `syncStatusProvider`.

## Legacy Widgets and Replacements

### `lib/widgets/` (being migrated)

| Legacy | Replacement |
|--------|-------------|
| `PrimaryButton` | `AppButton.primary()` |
| `SecondaryButton` | `AppButton.secondary()` |
| `LabeledCustomTextFormField` | `AppFormField` |
| `CustomTextFromField` | `AppFormField` (or `AppTextField` for standalone) |
| `showMessageDialog()` | `AppDialog.show()` |
| `showConfirmationDialog()` | `AppDialog.show(destructive: true)` |
| `MenuCard` / `MenuTile` | `AppMenuTile` |
| `SearchTextField` | `AppSearchField` |
| `ToggleSwitch` | Flutter's `Switch` |

### `lib/components/` (mixed state)

| Component | Status |
|-----------|--------|
| `BottomViewGrip` | Replaced by `AppBottomSheetGrip` |
| `MenuTile` | Replaced by `AppMenuTile` |
| `ProductCard` | Replaced by `AppProductCard` |
| `SelectableCard` | Replaced by `AppSelectCard` |
| `PosCategoryWidget` | Replaced by `AppCategoryChip` |
| `PosOrderTypeSelectionButton` | Replaced by `AppButton.ghost()` |
| `NotificationWidget` | Replaced by `AppNotification` |
| `LabeledCustomTextFormField` | Replaced by `AppFormField` (Phase 7) |
| `CustomTextFromField` | Replaced by `AppFormField` (Phase 7) |

---

## Domain Molecules (Phase 7)

Multi-atom compositions that express a single restaurant business concept. See [ADR-006](../decisions/006-domain-molecule-cohesion.md).

### AppOrderCard (`packages/eatery_core/lib/widgets/app_order_card.dart`)

One widget, four role contexts. Replaces four independent implementations (~400 lines → ~200 lines).

```dart
enum OrderCardContext { kds, waiter, display, admin }

AppOrderCard(
  order: order,
  context: OrderCardContext.kds,
  currencySymbol: '\$',
  onStart: () => repo.startOrder(order),
  onComplete: () => repo.completeOrder(order),
)
```

| Context | Layout | Actions | Animations |
|---|---|---|---|
| `kds` | Large card, prominent status, elapsed timer | Start / Done | None |
| `waiter` | Compact card, status + total | Tap for detail, PopupMenu (edit/void) | Fade on complete |
| `display` | Grid card, customer-facing text | None | Lottie burst on new, pulse on preparing |
| `admin` | List tile, full detail column | Edit / Void / Print | None |

**Status colors resolved via** `OrderStatus.colorFor(status)` → `AppColors.status*` tokens. All four contexts share the same color resolution.

### AppStatusTimeline (`packages/eatery_core/lib/widgets/app_status_timeline.dart`)

Vertical timeline visualizing `OrderStatusHistory` transitions.

```dart
AppStatusTimeline(
  transitions: order.statusHistory,
  staffNames: {1: 'Alice', 2: 'Bob'},  // optional staff name resolution
)
```

Each step: colored dot → status transition label → timestamp → staff name → void reason (if applicable). Consumes `AppColors.status*` for dots, `AppColors.timelineLine` for connectors.

### AppMultiStepForm (`packages/eatery_core/lib/widgets/app_multistep_form.dart`)

Step indicator + content area + back/next button shell. Replaces the Body1–Body6 pattern in `CreateCompanyPage`.

```dart
AppMultiStepForm(
  steps: const ['Company', 'Auth', 'Taxation', 'Tax Reg', 'Currency', 'Plan'],
  currentStep: index,
  hiddenSteps: {3},  // skip Tax Reg when taxation is "No Tax"
  onStepChanged: (i) => setState(() => index = i),
  onNext: () => _advance(),
  onSubmit: () => _submit(),
  onBack: index > 0 ? () => setState(() => index--) : null,
  child: bodies[index],
)
```

Features:
- Variable-length step arrays (`hiddenSteps: Set<int>`)
- Color-coded dots (active=primary, completed=success, inactive=grey300)
- Checkmark on completed steps
- Back/Next/Submit button row

### AppNotificationBanner (`packages/eatery_core/lib/widgets/app_notification_banner.dart`)

Slide-down overlay banner — no Scaffold dependency. Usable from any role at any depth.

```dart
AppNotificationBanner.show(
  context,
  type: NotificationType.orderReady,
  message: 'Order #42 — Table 3 is ready!',
  onTap: () => router.pushNamed('viewOrder'),
  autoDismiss: Duration(seconds: 5),
)
```

Uses `Overlay.insert()` internally. Status-colored left border (`AppColors.status*`). Auto-dismiss with slide-up animation. Replace 17 ad-hoc `ScaffoldMessenger.showSnackBar` call sites.

### AppFormField (`packages/eatery_core/lib/widgets/app_form_field.dart`)

Label + field + spacing molecule. Replaces `LabeledCustomTextFormField` across all CRUD forms. See [Form Patterns Guide](../guides/form-patterns.md).

```dart
AppFormField(
  label: 'Customer Name',
  hint: 'Enter full name',
  controller: _controllerName,
  focusNode: _focusNodes[0],
  focusNext: _focusNodes[1],    // ← replaces manual onFieldSubmitted focus chaining
  validator: (v) => v!.isEmpty ? 'Required' : null,
)
```

**Before (legacy):** `LabeledCustomTextFormField(label, hint, themeColor, foregroundColor, focusNode, onFieldSubmitted: (v) => focusNodes[N+1].requestFocus(), ...)`  
**After (tokenized):** `AppFormField(label, hint, controller, focusNode, focusNext)`

Internal spacing: `AppSpacing.fieldLabelGap` above field, `AppSpacing.md` below field. No external `SizedBox` / `AppSpacing` widgets needed between consecutive `AppFormField`s.

## Tokenized Atoms (Phase 6)
