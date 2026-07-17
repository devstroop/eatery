# Component Library

All components in `packages/eatery_core/lib/widgets/`. Import via `package:eatery_core/eatery_core.dart`.

## Buttons

### AppButton

```dart
AppButton.primary(label: 'Save', onPressed: () {}, height: 48)
AppButton.secondary(label: 'Cancel', onPressed: () {})
AppButton.destructive(label: 'Delete', onPressed: () {})  // ⚠️ only for deletion
AppButton.ghost(label: 'Skip', onPressed: () {})
```

All support: `loading`, `icon`, `width`, `height`, `size` (sm/md/lg).

## Layout Shells

### AppPageShell

Wraps every screen. Auto-constrains to 720px on desktop.

```dart
AppPageShell(
  title: 'Products',
  color: AppColors.menuCategories,  // optional app bar tint
  showBack: true,
  actions: [IconButton(...)],
  child: ListView(...),
)
```

### AppAdaptiveShell

Dashboard navigation — adapts to screen size:
- **Mobile** → Bottom Navigation Bar
- **Tablet** → Navigation Rail
- **Desktop** → Navigation Rail + content

```dart
AppAdaptiveShell(
  destinations: [
    AppNavDestination(icon: Icons.dashboard, label: 'Sales', page: ...),
    AppNavDestination(icon: Icons.restaurant_menu, label: 'Products', page: ...),
  ],
)
```

## Data Display

### AppTableView

Responsive table — cards on mobile, proper table on desktop.

```dart
AppTableView(
  columns: const ['Name', 'Price', 'Qty'],
  rows: products.map((p) => ['${p.name}', '\$${p.price}', '${p.qty}']).toList(),
  onRowTap: (i) => ...,
  emptyTitle: 'No products',
)
```

### AppStatusTimeline

Vertical timeline for order status history.

```dart
AppStatusTimeline(
  items: [
    StatusItem(label: 'Ordered', time: DateTime.now()),
    StatusItem(label: 'Preparing', time: DateTime.now()),
  ],
)
```

## Feedback

### AppEmptyState

```dart
AppEmptyState(
  icon: Icons.inbox_outlined,
  title: 'No orders yet',
  subtitle: 'Tap a table to start',
)
```

### AppSkeleton / AppSkeletonList

```dart
AppSkeleton.line(width: 200)            // text placeholder
AppSkeleton.card()                       // card placeholder
AppSkeleton.avatar(size: 40)             // circle placeholder
AppSkeletonList(count: 5, itemHeight: 80) // list of card placeholders
```

### AppNotificationBanner

Slide-down overlay using `Overlay.of(context).insert()` — requires a `Navigator` ancestor but no `Scaffold`.

```dart
AppNotificationBanner.show(
  context,
  type: NotificationType.orderReady,
  message: 'Order #42 — Table 3 is ready!',
  autoDismiss: Duration(seconds: 5),
)
```

## Selection

### AppSelectCard

Radio-style selectable card.

```dart
AppSelectCard(
  header: 'Plan',
  title: 'Free',
  highlights: ['5 users', '1 GB'],
  footer: 'Free forever',
  value: plan,
  groupValue: selectedPlan,
  onChanged: (v) => ...,
)
```

## Form

### AppTextField

```dart
AppTextField(
  label: 'Name',
  hint: 'Enter product name...',
  controller: myController,
  validator: (v) => v!.isEmpty ? 'Required' : null,
)
```

### AppSearchField

```dart
AppSearchField(
  hint: 'Search products...',
  onChanged: (query) => filter(query),
)
```

## Sync

### SyncStatusChip

Shows sync connection status in AppBar actions.

```dart
const SyncStatusChip()
```

### SyncHostSettingsSheet

Settings bottom sheet for configuring sync host.

```dart
SyncHostSettingsSheet.show(context)
```
