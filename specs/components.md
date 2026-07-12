# Component Library

> Two widget systems exist side-by-side:
> 1. **Legacy** — `lib/widgets/` + `lib/components/` (mobile-centric, being migrated)
> 2. **New (responsive)** — `lib/core/widgets/` (responsive-first, current standard)

---

## New Core Components (`lib/core/widgets/`)

All new components are **responsive-first** and should be used for all new pages. Import via:
```dart
import 'package:eatery/core/widgets/widgets.dart';
```

### AppButton

[View source](../../lib/core/widgets/app_button.dart)

Four named constructors:
```dart
AppButton.primary(label: 'Save', onPressed: () {})      // Filled brand color
AppButton.secondary(label: 'Cancel', onPressed: () {})   // Outlined
AppButton.destructive(label: 'Delete', onPressed: () {}) // Red filled
AppButton.ghost(label: 'Skip', onPressed: () {})         // Text-only
```

Each has `height`, `width`, `loading`, and `icon` parameters.

### AppCard

[View source](../../lib/core/widgets/app_card.dart)

```dart
AppCard(
  onTap: () {},
  padding: EdgeInsets.all(12),
  child: Text('Content'),
)
```

Consistent card with 12px border radius, subtle shadow, and optional tap.

### AppTextField

[View source](../../lib/core/widgets/app_text_field.dart)

```dart
AppTextField(
  label: 'Name',
  hint: 'Enter name...',
  controller: myController,
  validator: (v) => v!.isEmpty ? 'Required' : null,
)
```

Standard form field with label, validation, password toggle support.

### AppSearchField

[View source](../../lib/core/widgets/app_search_field.dart)

```dart
AppSearchField(
  hint: 'Search products...',
  onChanged: (query) => filter(query),
)
```

Search bar with ⌘K/F shortcut hint on desktop.

### AppEmptyState

[View source](../../lib/core/widgets/app_empty_state.dart)

```dart
const AppEmptyState(
  icon: Icons.inbox,
  title: 'No data',
  subtitle: 'Add something to get started',
)
```

### AppSkeleton

[View source](../../lib/core/widgets/app_skeleton.dart)

Shimmer loading placeholders:
```dart
AppSkeleton(height: 14)                    // Line
AppSkeleton.card(height: 120)              // Card
AppSkeleton.avatar(size: 40)               // Circle
const AppSkeletonList(count: 5)            // List of cards
```

### AppDialog

[View source](../../lib/core/widgets/app_dialog.dart)

```dart
// Confirmation dialog
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

### AppPageShell

[View source](../../lib/core/widgets/app_page_shell.dart)

Standard page wrapper used by all migrated pages:
```dart
AppPageShell(
  title: 'Products',
  color: AppColors.menuInventory,
  actions: [IconButton(...)],
  floatingActionButton: FloatingActionButton(...),
  fullWidth: false,        // true = no desktop centering
  showBack: true,
  child: ListView(...),
)
```

Provides:
- AppBar with back button and theme color
- `AppColors.grey200` background
- Desktop content centering at 720px max width (unless `fullWidth`)
- `resizeToAvoidBottomInset`

### AppAdaptiveShell

[View source](../../lib/core/widgets/app_adaptive_shell.dart)

Adaptive navigation scaffold:
```dart
AppAdaptiveShell(
  title: 'Eatery',
  destinations: [
    AppNavDestination(icon: Icons.home, label: 'Dashboard', page: Dashboard()),
    AppNavDestination(icon: Icons.receipt, label: 'Orders', page: Orders()),
  ],
)
```

Switches navigation pattern per breakpoint:
| Screen | Width | Pattern |
|--------|-------|---------|
| Mobile | <600px | `NavigationBar` (bottom) |
| Tablet | 600-900px | `NavigationRail` (side) |
| Desktop | >900px | Persistent sidebar (260px) |

### AppTableView

[View source](../../lib/core/widgets/app_table_view.dart)

Renders as `DataTable` on desktop, `CardList` on mobile:
```dart
AppTableView(
  columns: const ['Name', 'Price', 'Qty'],
  rows: products.map((p) => [p.name, '\$${p.mrpPrice}', '10']).toList(),
  onRowTap: (i) => edit(i),
  onRowDelete: (i) => delete(i),
)
```

---

## Legacy Widgets (Migration Target)

### `lib/widgets/` — Mobile-centric, being migrated to `core/widgets/`

| Widget | Replacement |
|--------|-------------|
| `PrimaryButton` | `AppButton.primary()` |
| `SecondaryButton` | `AppButton.secondary()` |
| `LabeledCustomTextFormField` | `AppTextField` |
| `CustomTextFromField` | `AppTextField` |
| `showMessageDialog()` | `AppDialog.show()` |
| `showConfirmationDialog()` | `AppDialog.show(destructive: true)` |
| `BottomSheetGrip` | (removed — `BottomViewGrip` is now in `components/`) |
| `FoodTypeBadge` | Not yet replaced |
| `MenuCard` / `MenuTile` | `AppCard` |
| `SearchTextField` | `AppSearchField` |
| `ToggleSwitch` | Flutter's `Switch` |
| `UploadButton` | Not yet replaced |
| `KProductView` | Not yet replaced |

### `lib/components/` — Mixed state

| Widget | Status |
|--------|--------|
| `BottomViewGrip` | Kept (draggable handle for bottom sheets) |
| `PrimaryButton` | Replaced by `AppButton` |
| `SecondaryButton` | Replaced by `AppButton` |
| `CustomTextFromField` | Replaced by `AppTextField` |
| `LabeledCustomTextFormField` | Replaced by `AppTextField` |
| `MenuTile` | Replaced by `AppCard` |
| `ProductCard` | Not yet replaced |
| `SelectableCard` | Not yet replaced |
| `SpecialButton` | Not yet replaced |
| `PosCategoryWidget` | Not yet replaced |
| `PosOrderTypeSelectionButton` | Not yet replaced |
| `NotificationWidget` | Not yet replaced |

---

## Responsive Utilities

[View source (core/utils/responsive.dart)](../../lib/core/utils/responsive.dart)

```dart
Responsive.isMobile(context)   // width < 600
Responsive.isTablet(context)   // 600 ≤ width < 900
Responsive.isDesktop(context)  // width ≥ 900
Responsive.gridColumns(context) // 1/2/3/4 based on width
Responsive.spacing(context)    // 12/16/20/24 based on width
Responsive.headlineSize(context) // 24/28/32
Responsive.titleSize(context)  // 16/18/20
Responsive.bodySize(context)   // 12/14/16
```

---

## Related Specs

- [Design Tokens](design-tokens.md) — Colors, typography, spacing
- [Responsive Design](responsive-design.md) — Layout patterns
- [Architecture Overview](architecture.md) — How components fit in
