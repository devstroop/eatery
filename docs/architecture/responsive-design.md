# Responsive Design

## Breakpoints

Defined in `packages/eatery_core/lib/utils/responsive.dart`:

| Bucket | Width | Pattern |
|--------|-------|---------|
| Mobile | <600px | Single column, bottom nav, full-width forms |
| Tablet | 600–900px | 2-3 column grids, navigation rail |
| Desktop | >=900px | 3-4 column grids, persistent sidebar, content centering |

### Usage

```dart
if (Responsive.isDesktop(context)) { /* wide layout */ }
if (Responsive.isTablet(context))  { /* medium layout */ }
if (Responsive.isMobile(context))  { /* narrow layout */ }

final cols = Responsive.gridColumns(context);   // 1, 2, 3, or 4
final gap  = Responsive.spacing(context);       // 12, 16, 20, or 24
```

## Navigation Patterns

### AppAdaptiveShell (`packages/eatery_core/lib/widgets/app_adaptive_shell.dart`)

Switches navigation pattern automatically:

| Screen | Width | Pattern |
|--------|-------|---------|
| Mobile | <600px | `NavigationBar` (bottom tab bar) |
| Tablet | 600-900px | `NavigationRail` (side icons) |
| Desktop | >=900px | Persistent sidebar (260px width) |

```dart
AppAdaptiveShell(
  title: 'Eatery',
  destinations: [
    AppNavDestination(icon: Icons.home, label: 'Dashboard', page: const Dashboard()),
  ],
)
```

### AppPageShell (`packages/eatery_core/lib/widgets/app_page_shell.dart`)

Standard page wrapper for non-tabbed screens:

- AppBar with back button + theme color
- `AppColors.grey200` background
- Desktop: content centered at 720px max width (unless `fullWidth: true`)
- Mobile: full-width content

```dart
AppPageShell(
  title: 'Products',
  color: AppColors.menuInventory,
  actions: [IconButton(...)],
  fullWidth: false,
  showBack: true,
  child: ListView(...),
)
```

### Hub-and-Spoke (Dashboard)

The dashboard uses menu tiles that push sub-pages via `Navigator.push`. Each sub-page is an `AppPageShell` with back navigation. This is the current pattern for the entire app (no tab-based navigation yet).

## Responsive Utility Methods

`packages/eatery_core/lib/utils/responsive.dart`:

```dart
Responsive.isMobile(context)      // width < 600
Responsive.isTablet(context)      // 600 <= width < 900
Responsive.isDesktop(context)     // width >= 900
Responsive.gridColumns(context)   // 1/2/3/4 based on width
Responsive.spacing(context)       // 12/16/20/24
Responsive.headlineSize(context)  // 24/28/32
Responsive.titleSize(context)     // 16/18/20
Responsive.bodySize(context)      // 12/14/16
Responsive.desktopConstrained(
  context, child: ..., maxWidth: 480,
)  // centered ConstrainedBox on desktop
```

## Platform-Dependent Capabilities

| Capability | Mobile | Desktop |
|-----------|--------|---------|
| Bluetooth scanning | `flutter_bluetooth_basic` | Hidden (platform-guarded) |
| Camera/Gallery | `image_picker` | `file_picker` fallback |
| Permissions | `permission_handler` | Skipped (no-op) |
| Device ID | Android ID / IDFV | System GUID / hostname |
| Keyboard shortcuts | Not supported | Cmd+K/F on search fields |
| Printing | Bluetooth ESC/POS | WiFi/Ethernet ESC/POS |

## Responsive Widget Strategies

| Component | Mobile | Desktop |
|-----------|--------|---------|
| Navigation | Bottom NavigationBar | Persistent sidebar |
| List pages | `ListView` | `ConstrainedBox(maxWidth: 720)` |
| Grid pages | 2 columns | 4 columns |
| Dialogs | `showModalBottomSheet` | `AlertDialog` |
| Data tables | Card-based list | `DataTable` |
| Forms | Full-width | 480-640px centered |
| Search | Full-width bar | Capped at 400px |
| Buttons | Full-width | Auto-width (inline) |
