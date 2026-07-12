# Navigation & Responsive Design

> Breakpoints, layout patterns, navigation systems, and the responsive component architecture.

---

## Breakpoints

[View source (responsive utility)](../../lib/core/utils/responsive.dart)

| Bucket | Width | Pattern |
|--------|-------|---------|
| **Mobile** | <600px | Single column, bottom nav, full-width forms |
| **Tablet** | 600–900px | 2-3 column grids, navigation rail |
| **Desktop** | ≥900px | 3-4 column grids, persistent sidebar, content centering |

### Usage

```dart
if (Responsive.isDesktop(context)) { /* wide layout */ }
if (Responsive.isTablet(context))  { /* medium layout */ }
if (Responsive.isMobile(context))  { /* narrow layout */ }

final cols = Responsive.gridColumns(context);   // 1/2/3/4
final gap  = Responsive.spacing(context);       // 12/16/20/24
```

---

## Navigation Patterns

### AppAdaptiveShell

[View source](../../lib/core/widgets/app_adaptive_shell.dart)

The `AppAdaptiveShell` switches navigation pattern automatically:

```
Mobile (<600px)        Tablet (600–900px)       Desktop (>900px)
┌──────────────┐       ┌──────┬────────┐       ┌────────┬────────┐
│              │       │  Nav │        │       │ Sidebar│        │
│   Content    │       │  Rail│ Content│       │ 260px  │ Content│
│              │       │      │        │       │        │        │
├──────────────┤       ├──────┤        │       ├────────┤        │
│ Bottom Nav   │       │ Icons│        │       │ Nav    │        │
└──────────────┘       └──────┴────────┘       │ Items  │        │
                                                └────────┴────────┘
```

Mobile: `NavigationBar`  
Tablet: `NavigationRail`  
Desktop: Persistent sidebar (no hamburger)

### AppPageShell

[View source](../../lib/core/widgets/app_page_shell.dart)

Standard page wrapper for non-tabbed screens:
- AppBar with back button + theme color
- `AppColors.grey200` background
- Desktop: content centered at **720px max width** (unless `fullWidth: true`)
- Mobile: full-width content

Used by all migrated list/detail pages.

### Hub-and-Spoke (Dashboard)

The dashboard uses a hub-and-spoke pattern — menu tiles push sub-pages via `Navigator.push`. Each sub-page is a `AppPageShell` with back navigation. This is the current pattern for the entire app (no tab-based navigation yet).

---

## Responsive Widget Strategies

| Component | Mobile | Desktop |
|-----------|--------|---------|
| **Navigation** | Bottom NavigationBar | Persistent sidebar |
| **List pages** | `ListView` | `ConstrainedBox(maxWidth: 720)` |
| **Grid pages** | 2 columns | 4 columns |
| **Dialogs** | `showModalBottomSheet` | `AlertDialog` |
| **Data tables** | Card-based list | `DataTable` |
| **Forms** | Full-width | 480-640px centered |
| **Search** | Full-width bar | Capped at 400px |
| **Buttons** | Full-width | Auto-width (inline) |
| **Typography** | 24/16/12 | 32/20/16 |

---

## Responsive Form Factor

```dart
// Page wrappers
AppPageShell       → Standard page (constrained on desktop)
AppAdaptiveShell   → Tab navigation (switches pattern)

// Content sizing
Responsive.headlineSize(context)  → desktop: 32, tablet: 28, mobile: 24
Responsive.titleSize(context)     → desktop: 20, tablet: 18, mobile: 16
Responsive.bodySize(context)      → desktop: 16, tablet: 14, mobile: 12
Responsive.spacing(context)       → desktop: 24, tablet: 20, mobile: 12

// Desktop content centering
ConstrainedBox(maxWidth: 720)     → Standard pages
ConstrainedBox(maxWidth: 640)     → Forms (create company)
ConstrainedBox(maxWidth: 480)     → Narrow (login)
ConstrainedBox(maxWidth: 1100)    → Wide (dashboard/onboarding)
```

---

## Platform-Dependent Capabilities

| Capability | Mobile | Desktop |
|-----------|--------|---------|
| Bluetooth scanning | ✅ `flutter_bluetooth_basic` | ❌ Hidden (platform-guarded) |
| Camera/Gallery | ✅ `image_picker` | ✅ `file_picker` fallback |
| Permissions | ✅ `permission_handler` | ❌ Skipped (no-op) |
| Device ID | ✅ Android ID / IDFV | ✅ System GUID / hostname |
| Keyboard shortcuts | ❌ | ✅ ⌘K/F on search |
| Printing | ✅ Bluetooth ESC/POS | ✅ WiFi/Ethernet ESC/POS (planned) |

---

## Related Specs

- [Component Library](components.md) — AppAdaptiveShell, AppPageShell
- [Design Tokens](design-tokens.md) — Spacing scale
