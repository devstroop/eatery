# Design Tokens

Single source of truth for all visual tokens. Always reference these classes — never use raw values.

## Colors

`packages/eatery_core/lib/theme/app_colors.dart`. Legacy: `KColors` (being phased out).

### Brand

```dart
AppColors.primary      = #30A8CF (cyan blue)
AppColors.primaryLight = #5BC0E5
AppColors.primaryDark  = #227A96

AppColors.secondary   = #4AC3A1 (teal green)
AppColors.secondary2  = #74B952 (green)
AppColors.accent      = #705EE0 (purple)
```

### Semantic

```dart
AppColors.success = #4AC3A1
AppColors.warning = #F5A142
AppColors.error   = #EF6850
AppColors.info    = #2F5EC2
```

### Greys

```dart
AppColors.grey50  = #F8F9FA
AppColors.grey100 = #F5F5F5
AppColors.grey200 = #EEEEEE     // scaffold / border
AppColors.grey300 = #D5D5D5
AppColors.grey400 = #A5A5A5
AppColors.grey500 = #858585     // muted foreground
AppColors.grey600 = #666666
AppColors.grey700 = #454545
AppColors.grey800 = #2F2F2F     // headings
AppColors.grey900 = #151515     // foreground
```

### Menu Tile Colors

```dart
AppColors.menuPrimary    = #30A8CF  // POS / main
AppColors.menuOrders     = #F5A142
AppColors.menuPayments   = #2F5EC2
AppColors.menuCategories = #D98049
AppColors.menuKitchen    = #4AC3A1
AppColors.menuInventory  = #705EE0
AppColors.menuCustomers  = #2FC289
AppColors.menuStaff      = #C2592F
AppColors.menuDining     = #EF6850
AppColors.menuData       = #EF9050
AppColors.menuSettings   = #222222
```

### Shadcn-style Semantic Tokens

```dart
AppColors.background            = #FFFFFF
AppColors.foreground            = #151515
AppColors.card                  = #FFFFFF
AppColors.cardForeground        = #151515
AppColors.muted                 = #F5F5F5
AppColors.mutedForeground       = #858585
AppColors.border                = #EEEEEE
AppColors.input                 = #EEEEEE
AppColors.ring                  = #30A8CF (primary)
AppColors.destructive           = #EF6850
AppColors.destructiveForeground = #FFFFFF
```

## Typography

`packages/eatery_core/lib/theme/app_typography.dart`:

```dart
displayLarge   = 48px, w700
displayMedium  = 36px, w600
headlineLarge  = 32px, w600
headlineMedium = 28px, w600
headlineSmall  = 24px, w600
titleLarge     = 20px, w600
titleMedium    = 16px, w600
titleSmall     = 14px, w600
bodyLarge      = 16px, w400
bodyMedium     = 14px, w400
bodySmall      = 12px, w400
labelLarge     = 14px, w500
labelMedium    = 12px, w500
labelSmall     = 10px, w500
```

## Spacing

`packages/eatery_core/lib/theme/app_spacing.dart`:

### 4px Scale

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
AppSpacing.gapXxl  // SizedBox(height: 32)
```

### Border Radius

```dart
AppSpacing.radiusSm   =  4
AppSpacing.radiusMd   =  8
AppSpacing.radiusLg   = 12
AppSpacing.radiusXl   = 16
AppSpacing.radiusFull = 9999
```

### Page / Component Padding

```dart
AppSpacing.pageMobile   = EdgeInsets.all(12)
AppSpacing.pageTablet   = EdgeInsets.symmetric(horizontal: 24, vertical: 20)
AppSpacing.pageDesktop  = EdgeInsets.symmetric(horizontal: 32, vertical: 24)
AppSpacing.cardPadding  = EdgeInsets.all(12)
AppSpacing.tilePadding  = EdgeInsets.symmetric(horizontal: 16, vertical: 12)
AppSpacing.buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12)
AppSpacing.fieldPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4)
```

## Shadows

`packages/eatery_core/lib/theme/app_shadows.dart`:

```dart
AppShadows.sm  // (0, 1), blur 4, 8% black  — cards
AppShadows.md  // (0, 2), blur 8, 13% black  �� raised cards, dialogs
AppShadows.lg  // (0, 4), blur 16, 20% black — floating elements, modals
AppShadows.none
```

## AppTheme Builder

`packages/eatery_core/lib/theme/app_theme.dart`:

```dart
MaterialApp(theme: AppTheme.light, ...)
```

Builds complete `ThemeData` with:
- `useMaterial3: true`
- `ColorScheme.fromSeed(seedColor: AppColors.primary)`
- `scaffoldBackgroundColor: AppColors.background`
- AppBar: transparent background, no elevation, centered title
- Cards: 12px border radius, no elevation, white
- Buttons: 12px border radius, primary brand color
- Input fields: 12px border radius, grey border
- Bottom nav: no elevation
- Typography: mapped from `AppTypography` scale

## Migration: KColors -> AppColors

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
