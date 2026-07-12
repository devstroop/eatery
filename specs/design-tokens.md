# Design Tokens

> Single source of truth for all visual tokens. Always reference these classes — never use raw values.

---

## Colors

[View source](../../lib/core/theme/app_colors.dart)
Legacy: [KColors](../../lib/constants/style/color_style.dart) (being phased out)

### Brand
```dart
AppColors.primary        = #30A8CF (cyan blue)
AppColors.primaryLight   = #5BC0E5
AppColors.primaryDark    = #227A96

AppColors.secondary      = #4AC3A1 (teal green)
AppColors.secondary2     = #74B952 (green)
AppColors.accent         = #705EE0 (purple)
```

### Semantic
```dart
AppColors.success   = #4AC3A1
AppColors.warning   = #F5A142
AppColors.error     = #EF6850
AppColors.info      = #2F5EC2
```

### Greys
```dart
AppColors.grey50   = #F9FAFB  ← new (lightest)
AppColors.grey100  = #F3F4F6
AppColors.grey200  = #E5E7EB  ← scaffold background
AppColors.grey300  = #D1D5DB
AppColors.grey400  = #9CA3AF
AppColors.grey500  = #6B7280  ← secondary text
AppColors.grey600  = #4B5563
AppColors.grey700  = #374151  ← body text
AppColors.grey800  = #1F2937  ← headings
AppColors.grey900  = #111827  ← display text
```
Legacy `KColors` equivalents: `white600` ≈ grey400, `black600` ≈ grey700, `black900` ≈ grey800

### Menu Tile Colors
```dart
AppColors.menuPos        = #30A8CF
AppColors.menuOrders     = #F5A142
AppColors.menuPayments   = #2F5EC2
AppColors.menuCategories = #D98049
AppColors.menuKitchen    = #4AC3A1
AppColors.menuInventory  = #705EE0
AppColors.menuCustomers  = #2FC289
AppColors.menuStaffs     = #C2592F
AppColors.menuTables     = #EF6850
AppColors.menuSettings   = #222222
```

---

## Typography

[View source](../../lib/core/theme/app_typography.dart)

### Scale
```dart
AppTypography.displayLarge    = 48px, w700
AppTypography.displayMedium   = 36px, w600
AppTypography.headlineLarge   = 32px, w600
AppTypography.headlineMedium  = 28px, w600
AppTypography.headlineSmall   = 24px, w600
AppTypography.titleLarge      = 20px, w600
AppTypography.titleMedium     = 16px, w600
AppTypography.titleSmall      = 14px, w600
AppTypography.bodyLarge       = 16px, w400
AppTypography.bodyMedium      = 14px, w400
AppTypography.bodySmall       = 12px, w400
AppTypography.labelLarge      = 14px, w500
AppTypography.labelMedium     = 12px, w500
AppTypography.labelSmall      = 10px, w500
```

### Responsive Sizing
```dart
Responsive.headlineSize(context)  // 32 desktop, 28 tablet, 24 mobile
Responsive.titleSize(context)     // 20 → 18 → 16
Responsive.bodySize(context)      // 16 → 14 → 12
```

---

## Spacing

[View source](../../lib/core/theme/app_spacing.dart)

4px base unit scale:
```dart
AppSpacing.xs   =  4
AppSpacing.sm   =  8
AppSpacing.md   = 12
AppSpacing.lg   = 16
AppSpacing.xl   = 24
AppSpacing.xxl  = 32
AppSpacing.xxxl = 48
```

### SizedBox Shortcuts
```dart
AppSpacing.gapXs   // SizedBox(height: 4)
AppSpacing.gapSm   // SizedBox(height: 8)
AppSpacing.gapMd   // SizedBox(height: 12)
AppSpacing.gapLg   // SizedBox(height: 16)
AppSpacing.gapXl   // SizedBox(height: 24)
```

### Border Radius
```dart
AppSpacing.radiusSm   =  4
AppSpacing.radiusMd   =  8
AppSpacing.radiusLg   = 12
AppSpacing.radiusXl   = 16
AppSpacing.radiusFull = 9999
```

### Responsive Spacing
```dart
Responsive.spacing(context)  // 24 desktop, 20 tablet, 12 mobile
```

---

## Shadows

[View source](../../lib/core/theme/app_shadows.dart)

```dart
AppShadows.sm   // (0, 1), blur 4, 8% black  — cards
AppShadows.md   // (0, 2), blur 8, 13% black  — raised cards, dialogs
AppShadows.lg   // (0, 4), blur 16, 20% black — floating elements, modals
AppShadows.none
```

---

## AppTheme

[View source](../../lib/core/theme/app_theme.dart)

```dart
MaterialApp(theme: AppTheme.light)
```

Builds complete `ThemeData` with:
- `ColorScheme.fromSeed(seedColor: AppColors.primary)`
- `scaffoldBackgroundColor: AppColors.background` (#F3F4F6 = grey100)
- AppBar: transparent background, no elevation, centered title
- Cards: 12px border radius, no elevation, white
- Buttons: 12px border radius, primary brand color
- Input fields: 12px border radius, grey border
- Bottom nav: no elevation
- Typography: mapped from `AppTypography` scale
- Material 3 enabled

---

## Migration: KColors → AppColors

| KColors (legacy) | AppColors (new) |
|-----------------|-----------------|
| `KColors.primary` | `AppColors.primary` |
| `KColors.secondary` | `AppColors.secondary` |
| `KColors.secondary2` | `AppColors.secondary2` |
| `KColors.tertiary` | `AppColors.menuCategories` |
| `KColors.tertiary2` | `AppColors.warning` |
| `KColors.tertiary3` | `AppColors.error` |
| `KColors.alternate` | `AppColors.menuInventory` |
| `KColors.alternate2` | `AppColors.info` |
| `KColors.white900` | `AppColors.grey100` |
| `KColors.white600` | `AppColors.grey400` |
| `KColors.white500` | `AppColors.grey500` |
| `KColors.black900` | `AppColors.grey800` |
| `KColors.black600` | `AppColors.grey600` |
| `KColors.black500` | `AppColors.grey500` |

---

## Related Specs

- [Component Library](components.md) — How tokens are used
- [Responsive Design](responsive-design.md) — Responsive sizing
