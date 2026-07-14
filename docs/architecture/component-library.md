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
| `LabeledCustomTextFormField` | `AppTextField` |
| `CustomTextFromField` | `AppTextField` |
| `showMessageDialog()` | `AppDialog.show()` |
| `showConfirmationDialog()` | `AppDialog.show(destructive: true)` |
| `MenuCard` / `MenuTile` | `AppCard` |
| `SearchTextField` | `AppSearchField` |
| `ToggleSwitch` | Flutter's `Switch` |

### `lib/components/` (mixed state)

| Component | Status |
|-----------|--------|
| `BottomViewGrip` | Kept (draggable handle for bottom sheets) |
| `MenuTile` | Replaced by `AppCard` |
| `ProductCard` | Not yet replaced |
| `SelectableCard` | Not yet replaced |
| `PosCategoryWidget` | Not yet replaced |
| `PosOrderTypeSelectionButton` | Not yet replaced |
