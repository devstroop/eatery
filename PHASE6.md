# Phase 6 — Component Tokenization & Design System

> **Prerequisites:**
> - Phase 1 (Single-App Unification) — 28/28 ✅ (`ISSUES.md`)
> - Phase 2 (Feature Completion) — 15/15 ✅ (`PHASE2.md`)
> - Phase 3 (Native Store Hardening) — 12/13 ✅ + 1 ❓ (`PHASE3.md`)
> - Phase 4 (Waiter App & Production Hardening) — 14/14 ✅ (`PHASE4.md`)
>
> Phase 6 is **not** about moving files or renaming directories. It is about **eliminating every hardcoded visual value** from the codebase. After Phase 6, no widget outside `eatery_core/lib/theme/` contains a raw `Color(0xFF...)`, raw `EdgeInsets.all(N)`, raw `TextStyle(fontSize: N)`, or raw `BorderRadius.circular(N)`. Every visual property derives from a design token.
>
> **Reference models:**
> - **Radzen Blazor**: every component inherits `Variant` × `Shade` × `Size` from a base class. Zero hardcoded values — every visual property maps to a CSS variable.
> - **shadcn/ui**: semantic tokens (`background`, `foreground`, `muted`, `border`, `ring`, `destructive`) defined as CSS custom properties consumed by all components.

---

## The Problem

A full audit of all component files in `lib/components/` reveals ~100 untokenized values:

| Category | Count | Examples |
|---|---|---|
| Raw `Color(...)` in component code | ~15 | `Color(0xFFC8905C)`, `Color(0x9A090F13)`, `Color.fromRGBO(209,215,215,1)`, `Color(0xFF2F2F2F)` |
| Raw `BorderRadius.circular(N)` | ~13 | `circular(2)`, `circular(6)`, `circular(8)`, `circular(12)` — three different radius conventions for the same conceptual "card/container" |
| Raw `EdgeInsets` | ~26 | `LTRB(0,9,0,9)`, `symmetric(horizontal: 8)`, `all(12)`, `only(bottom: 6, right: 12)` |
| Raw `TextStyle(fontSize:...)` | ~6 | `fontSize: 10`, `fontSize: 16`, `fontSize: 18`, `fontWeight: FontWeight.w600` |
| Raw `BoxShadow(Color(0x...))` | ~5 | Two distinct shadow colors (`0x2F000000`, `0x43000000`) with different blur radii |
| Raw widget dimensions (w/h) | ~9 | `width: 60, height: 5`, `SizedBox(width: 24, height: 24)`, `SizedBox(height: 3)` |
| Raw constructor `Color` params | 7 | `color`, `foreColor`, `borderColor`, `themeColor`, `foregroundColor`, `highlightColor` — caller-chosen arbitrary colors |

**Every single legacy component** has at least one raw value. `SelectableCard` alone has 14. `ProductCard` has 8. `SpecialButton` has 7. This is the opposite of a design system — each component is a self-contained silo of visual decisions.

### Per-component breakdown

| Component | Raw colors | Raw radii | Raw spacings | Raw typography | Raw shadows | Raw dimensions |
|---|---|---|---|---|---|---|
| `SpecialButton` | 2 | 1 | 2 | 1 | 1 | 1 |
| `SecondaryButton` | 2 | 1 | 1 | 1 | — | — |
| `BottomViewGrip` | — | 1 | 1 | — | — | 2 |
| `SelectableCard` | 1 | 3 | 6 | 1 | — | 3 |
| `MenuTile` | — | — | — | — | — | — |
| `LabeledCustomTextFormField` | 2 | — | 1 | 1 | — | — |
| `CustomTextFromField` | raw in decoration | — | — | — | — | — |
| `ProductCard` | 1 | 3 | 3 | — | 1 | — |
| `PosCategoryWidget` | 2 | 1 | 5 | — | 1 | — |
| `PosOrderTypeSelectionButton` | 2 | — | 2 | 1 | — | 1 |
| `NotificationWidget` | 2 | 1 | 2 | — | 1 | 1 |
| `LowQtyLabelWidget` | 1 | 1 | 2 | 1 | 1 | — |

---

## The Goal

After Phase 6, every widget references a named member of one of these four classes:

- **`AppColors`** — all colors (brand, semantic, neutrals, component-specific, shadcn semantic tokens)
- **`AppSpacing`** — all dimensions, paddings, radii, gaps, sizes
- **`AppTypography`** — all text styles (display, headline, title, body, label, component-specific)
- **`AppShadows`** — all elevation presets

No `Color(0xFF...)`, no `EdgeInsets.all(N)`, no `TextStyle(fontSize: N)`, no `BorderRadius.circular(N)`, no `BoxShadow(Color(...))` appears in any widget file.

---

## What We Learn from Radzen Blazor

### Pattern 1: Every component inherits Variant × Shade × Size

```
RadzenComponent
├── Variant:  Filled | Flat | Outlined | Text
├── Shade:    Lighter | Light | Default | Dark | Darker
└── Size:     Small | Medium | Large
```

Every Button, Badge, Card, ToggleButton, Chip inherits from this base. The base maps the (variant, shade, size) triple to CSS classes that reference token variables:

```scss
/* Radzen token system — component code never contains raw values */
.rz-button--filled-primary-default  { background: var(--rz-primary); }
.rz-button--outlined-danger-light   { border-color: var(--rz-danger-light); }
.rz-button--text-base-dark          { color: var(--rz-base-dark); }
```

Flutter equivalent (our design):
```dart
/// Tokens shared by all atomic components.
enum AppVariant { elevated, outlined, ghost, flat }
enum AppSemantic { primary, secondary, danger, success, warning }
enum AppSize   { sm, md, lg }

/// Lookup class that maps variant×semantic×size → design tokens.
/// Components never compute their own colors — they query this class.
class AppComponentStyle {
  const AppComponentStyle();
  Color bg(AppVariant v, AppSemantic s);
  Color fg(AppVariant v, AppSemantic s);
  EdgeInsets padding(AppSize s);
  double height(AppSize s);
}
```

### Pattern 2: Every visual property references a token variable

Radzen defines 50+ CSS variables per theme. Components use `var(--rz-primary)` not `#4340D2`. Adding a dark theme means swapping the variable values, not rewriting any component.

### Pattern 3: 10+ prebuilt themes share the same token names

Radzen ships 10 themes (Material, Standard, Default, Humanistic, Software, Fluent × light/dark). Each defines the same tokens with different values. Theme switching is a single CSS file swap — no component code changes.

---

## Plan

### Phase 6A — Complete the Token Vocabulary

Add ~80 tokens across four files. Zero callers changed. Purely additive.

#### A1: Component color tokens → `packages/eatery_core/lib/theme/app_colors.dart`

```dart
  // ── Button tokens ────────────────────────────────────────────
  // Filled variant
  static const Color buttonFilledPrimaryBg       = primary;
  static const Color buttonFilledPrimaryFg       = white;
  static const Color buttonFilledSecondaryBg     = grey100;
  static const Color buttonFilledSecondaryFg     = grey900;
  static const Color buttonFilledDestructiveBg   = destructive;
  static const Color buttonFilledDestructiveFg   = destructiveForeground;

  // Outlined variant
  static const Color buttonOutlinedPrimaryBorder    = primary;
  static const Color buttonOutlinedPrimaryFg        = primary;
  static const Color buttonOutlinedSecondaryBorder  = grey300;
  static const Color buttonOutlinedSecondaryFg      = grey700;
  static const Color buttonOutlinedDestructiveBorder = destructive;
  static const Color buttonOutlinedDestructiveFg    = destructive;

  // Ghost variant
  static const Color buttonGhostFg = grey700;
  static const Color buttonGhostBg = Colors.transparent;

  // Disabled
  static const double buttonDisabledOpacity = 0.5;

  // ── TextField tokens ────────────────────────────────────────
  static const Color fieldFill        = muted;
  static const Color fieldBorder      = grey300;
  static const Color fieldFocusBorder = primary;
  static const Color fieldErrorBorder = error;
  static const Color fieldHint        = grey400;
  static const Color fieldLabel       = grey600;
  static const Color fieldText        = foreground;

  // ── Card tokens ─────────────────────────────────────────────
  static const Color cardBg               = white;
  static const Color cardBorder           = grey200;
  static const Color cardSelectedBorder   = secondary2;
  static const Color cardUnselectedBorder = grey400;

  // ── SelectCard tokens ──────────────────────────────────────
  static const Color selectCardRadioOuter           = secondary2;
  static const Color selectCardRadioInner           = white;
  static const Color selectCardRadioUnselectedBorder = Color(0xFFD1D7D7);

  // ── MenuTile tokens ────────────────────────────────────────
  static const Color menuTileFg         = grey600;
  static const Color menuTileSubtitleFg = grey700;
  static const Color menuTileTrailingFg = grey400;

  // ── BottomSheet tokens ─────────────────────────────────────
  static const Color bottomSheetGrip = grey400;
  static const Color bottomSheetBg   = background;

  // ── Notification tokens ────────────────────────────────────
  static const Color notificationBg     = Color(0xFF1C1F22);
  static const Color notificationShadow = Color(0x43000000);

  // ── Badge tokens ───────────────────────────────────────────
  static const Color badgeWarningBg = Color(0xFFC8905C);

  // ── Category chip tokens ──────────────────────────────────
  static const Color categoryChipActiveBg     = grey700;
  static const Color categoryChipActiveFg     = white;
  static const Color categoryChipInactiveBg   = white;
  static const Color categoryChipInactiveFg   = grey700;

  // ── Shadow base colors ─────────────────────────────────────
  static const Color shadowBase = Color(0x2F000000);
  static const Color shadowDark = Color(0x43000000);
```

#### A2: Component spacing tokens → `packages/eatery_core/lib/theme/app_spacing.dart`

```dart
  // ── Button ─────────────────────────────────────────────────
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;
  static const double buttonRadius   = radiusLg;

  static const EdgeInsets buttonPaddingSm
      = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const EdgeInsets buttonPaddingMd = buttonPadding;
  static const EdgeInsets buttonPaddingLg
      = EdgeInsets.symmetric(horizontal: 32, vertical: 16);

  // ── Icon ──────────────────────────────────────────────────
  static const double iconSizeSm = 16;
  static const double iconSizeMd = 24;
  static const double iconSizeLg = 32;
  static const double iconGapSm  = 6;
  static const double iconGapMd  = 8;
  static const double iconGapLg  = 12;

  // ── Card ──────────────────────────────────────────────────
  static const double cardRadius = radiusLg;

  // ── SelectCard ────────────────────────────────────────────
  static const double selectCardRadius      = 6;
  static const double selectCardRadioSize   = 24;
  static const double selectCardRadioInner  = 10;
  static const double selectCardRadioOffset = 7;

  // ── TextField ─────────────────────────────────────────────
  static const double fieldRadius   = radiusLg;
  static const double fieldLabelGap = xs;

  // ── BottomSheet grip ──────────────────────────────────────
  static const double bottomSheetGripWidth  = 60;
  static const double bottomSheetGripHeight = 5;
  static const double bottomSheetGripRadius = 2;
  static const EdgeInsets bottomSheetGripMargin
      = EdgeInsets.fromLTRB(0, 8, 0, 16);

  // ── Category chip ─────────────────────────────────────────
  static const EdgeInsets categoryChipPadding
      = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets categoryChipImagePadding
      = EdgeInsets.symmetric(vertical: 6, horizontal: 6);
  static const double categoryChipRadius = radiusLg;

  // ── Notification ──────────────────────────────────────────
  static const double notificationHeight = 70;
  static const double notificationRadius = radiusMd;

  // ── Badge ─────────────────────────────────────────────────
  static const EdgeInsets badgePadding = EdgeInsets.all(6);

  // ── Order-type button ─────────────────────────────────────
  static const double orderTypeButtonGap = 6;
```

#### A3: Component typography tokens → `packages/eatery_core/lib/theme/app_typography.dart`

```dart
  // ── Button labels ───────────────────────────────────────────
  static const TextStyle buttonLabelSm = labelLarge;
  static const TextStyle buttonLabelMd
      = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle buttonLabelLg
      = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  // ── Field ──────────────────────────────────────────────────
  static const TextStyle fieldLabel = labelMedium;
  static const TextStyle fieldValue = bodyMedium;

  // ── SelectCard ────────────────────────────────────────────
  static const TextStyle selectCardHeader    = bodyMedium;
  static const TextStyle selectCardTitle
      = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle selectCardHighlight = bodySmall;

  // ── Order-type button ──────────────────────────────────────
  static const TextStyle orderTypeButton
      = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: grey800);

  // ── Badge ──────────────────────────────────────────────────
  static const TextStyle badgeLabel
      = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);
```

#### A4: Shadow tokens → `packages/eatery_core/lib/theme/app_shadows.dart`

```dart
  // ── Card (elevated) ────────────────────────────────────────
  static const List<BoxShadow> cardElevated = [
    BoxShadow(
      color: shadowBase,
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: 1,
    ),
  ];

  // ── Notification card ──────────────────────────────────────
  static const List<BoxShadow> notification = [
    BoxShadow(
      color: shadowDark,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
```

**Files touched:** 4 (`app_colors.dart`, `app_spacing.dart`, `app_typography.dart`, `app_shadows.dart`)
**Risk:** Zero. Purely additive.

---

### Phase 6B — Build Tokenized Component Foundation

All work in `packages/eatery_core/lib/`.

#### B1: Create `app_component.dart` (NEW)

`packages/eatery_core/lib/theme/app_component.dart`

```dart
/// Every atomic widget derives its visual properties from these enums.
/// Components accept Variant × Semantic × Size, never raw Color/double/EdgeInsets.
enum AppVariant  { elevated, outlined, ghost, flat }
enum AppSemantic { primary, secondary, danger, success, warning }
enum AppSize    { sm, md, lg }

/// Lookup table that maps (variant, semantic, size) → design tokens.
///
/// Used by [AppButton], [AppBadge], [AppCategoryChip], [AppSelectCard].
/// Passed as a parameter so every component can be tested with any token
/// configuration — no subclassing required. Instantiation is cheap.
class AppComponentStyle {
  const AppComponentStyle();

  Color bg(AppVariant v, AppSemantic s)     { /* map to tokens */ }
  Color fg(AppVariant v, AppSemantic s)     { /* map to tokens */ }
  EdgeInsets padding(AppSize s)              { /* buttonPaddingSm/Md/Lg */ }
  double height(AppSize s)                   { /* buttonHeightSm/Md/Lg */ }
  double iconSize(AppSize s)                 { /* iconSizeSm/Md/Lg */ }
}

/// Ghost buttons use secondary semantics by default.
/// No dedicated semantic — ghost is a variant, not a meaning.
const defaultGhostSemantic = AppSemantic.secondary;
```

#### B2: Rebuild `AppButton` → `app_button.dart`

**Removes:** `AppButtonStyle` enum (legacy). `SpecialButton` and `SecondaryButton` absorbed.

**New API:**
```dart
AppButton(
  label: 'Delete',
  variant: AppVariant.elevated,
  semantic: AppSemantic.danger,
  size: AppSize.md,
  icon: Icons.trash,
  trailingIcon: Icons.chevron_right,
  onPressed: () {},
)
```

Named constructors kept as convenience:
```dart
AppButton.primary(label: 'Save', onPressed: fn)
AppButton.secondary(label: 'Cancel', onPressed: fn)
AppButton.destructive(label: 'Delete', onPressed: fn)
AppButton.ghost(label: 'Skip', onPressed: fn)
```
`AppButton.ghost()` defaults to `AppSemantic.secondary` for its text color; pass `semantic:` to override.

No `Color` or `EdgeInsets` params — everything delegates to `AppComponentStyle` + tokens.

All internal values reference `AppColors.*`, `AppSpacing.*`, `AppTypography.*`.

**Subsumes:**
| Legacy | File | Replaced by |
|---|---|---|
| `SpecialButton` | `pos.page.dart:885` | `AppButton(variant: elevated, icon: ..., trailingIcon: Icons.chevron_right)` |
| `SecondaryButton` | `app_file_system.dart:121` | `AppButton(variant: outlined, ...)` |
| `PosOrderTypeSelectionButton` | `pos.page.dart:564` | `AppButton(variant: ghost, trailingIcon: ..., size: lg)` |

> ⚠️ **Migration note:** `SpecialButton` took raw `Color color, Color foreColor` params — callers must now choose `AppSemantic` instead. Check each caller's current color to pick the right semantic value.

#### B3: Rebuild `AppTextField` → `app_text_field.dart`

**Changes from current:**
- Label color: hardcoded → `AppColors.fieldLabel`
- Border radius: hardcoded → `AppSpacing.fieldRadius`
- Border color: hardcoded → `AppColors.fieldBorder`
- Focus border: hardcoded → `AppColors.fieldFocusBorder`
- Remove `accentColor` param (was `Color?`) — replace with optional `semantic: AppSemantic` that maps to `fieldFocusBorder`

> ⚠️ **Design rule:** No `Color` override params on tokenized components. If a caller needs a different accent, it passes `AppSemantic` and the token system resolves the color.

**Risk:** Backward-compatible (dropping `accentColor` — verify callers don't pass it). All existing `AppTextField(...)` callers otherwise unaffected.

#### B4: Rebuild `AppCard` → `app_card.dart`

**Changes:**
- Radius: hardcoded → `AppSpacing.cardRadius`
- Add `AppVariant variant`: `elevated` (current — bg + shadow), `outlined` (border, no shadow), `flat` (no border, no shadow, muted bg)

#### B5: New `AppBadge` → `app_badge.dart`

Replaces `LowQtyLabelWidget`.

```dart
AppBadge(
  label: '5 in stock',
  variant: AppVariant.elevated,
  semantic: AppSemantic.warning,
  size: AppSize.sm,
)
```

All colors from `AppColors.badgeWarningBg` etc. Typography from `AppTypography.badgeLabel`.

#### B6: New `AppSelectCard` → `app_select_card.dart`

Replaces `SelectableCard`.

```dart
AppSelectCard(
  header: 'Basic',
  title: 'Free Plan',
  highlights: ['5 users', '1 GB'],
  footer: 'Free forever',
  value: selectedValue,
  groupValue: currentValue,
  onChanged: (v) => setState(() => currentValue = v),
)
```

All colors from `AppColors.selectCardRadio*`, dimensions from `AppSpacing.selectCard*`, typography from `AppTypography.selectCard*`.

Adds `Radio<String>`-style `groupValue` + `value` pattern instead of `selected: bool`.

#### B7: New `AppMenuTile` → `app_menu_tile.dart`

Replaces `MenuTile`.

```dart
AppMenuTile(
  title: 'Categories',
  subtitle: 'Manage product categories',
  leading: Icons.category,
  onTap: () {},
  color: AppColors.menuCategories,  // override for per-page theming
)
```

Default colors from `AppColors.menuTile*`, optional `color` override.

#### B8: New `AppBottomSheetGrip` → `app_bottom_sheet_grip.dart`

Replaces `BottomViewGrip`.

Color from `AppColors.bottomSheetGrip`, dimensions from `AppSpacing.bottomSheetGrip*`.

#### B9: New `AppNotification` → `app_notification.dart`

Replaces `NotificationWidget`.

Colors from `AppColors.notification*`, dimensions from `AppSpacing.notification*`, shadows from `AppShadows.notification`.

#### B10: New `AppCategoryChip` → `app_category_chip.dart`

Replaces `PosCategoryWidget`.

```dart
AppCategoryChip(
  label: 'Beverages',
  selected: isActive,
  leading: SvgPicture.asset(...),
  onTap: () {},
)
```

Colors from `AppColors.categoryChip*`, spacing from `AppSpacing.categoryChip*`.

**Files:** 11 files (1 `AppComponentStyle` class + 3 rebuilt + 6 new + 1 widget exports update)

**Risk assessment:**
| Step | Risk | Mitigation |
|---|---|---|
| B2 `AppButton` | Medium — `SpecialButton` callers pass raw colors, must map to `AppSemantic` | Check each caller's color before choosing semantic value |
| B3 `AppTextField` | Low — `accentColor` param removed; verify 0 callers pass it | `grep -r 'accentColor' lib/` before migration |
| B4 `AppCard` | Low — additive change, old callers unaffected | — |
| B5–B10 new files | None — additive | — |

---

### Phase 6C — Delete All 18 Untokenized Legacy Files

| # | Delete | Replaced by | Caller count |
|---|---|---|---|
| 1 | `lib/components/special_button.dart` | `AppButton` (filled + trailingIcon) | 1 |
| 2 | `lib/components/secondary_button.dart` | `AppButton` (outlined) | 1 |
| 3 | `lib/components/bottom_view_grip.dart` | `AppBottomSheetGrip` | ~7 |
| 4 | `lib/components/menu_tile.dart` | `AppMenuTile` | ~10 |
| 5 | `lib/components/selectable_card.dart` | `AppSelectCard` | ~7 |
| 6 | `lib/components/low_qty_label_widget.dart` | `AppBadge` | 0 (commented out) |
| 7 | `lib/components/notification_widget.dart` | `AppNotification` | 1 |
| 8 | `lib/components/pos_category_widget.dart` | `AppCategoryChip` | ~4 |
| 9 | `lib/components/pos_order_type_selection_button.dart` | `AppButton` (ghost + trailingIcon) | 1 |
| 10 | `lib/components/labeled_custom_text_from_field.dart` | `@Deprecated` → `AppTextField` (50 callers kept) | ~50 |
| 11 | `lib/components/custom_text_from_field.dart` | Internal to `LabeledCustomTextFormField` | 0 external |
| 12-16 | 5 `lib/components/bottomsheets/*.dart` | Rewrite as `AppBottomSheet` pattern | 5 |
| 17 | `lib/constants/style/color_style.dart` | `AppColors` (already dead, 0 usages) | 0 |
| 18 | `lib/constants/style/spacing_style.dart` | `AppSpacing` (71 usages → mechanical migration) | ~21 files |

After this phase, `lib/components/` is empty → delete the directory.
`lib/constants/style/` is empty → delete the directory.

**Risk:** Mechanical find-and-replace. Every migration step is gated by `flutter analyze`. The 71 `spacing_style.dart` usages are the largest single mechanical change — do them last and validate with `flutter analyze` after every ~10 replacements.

---

### Phase 6D — Tokenize Feature-Specific Widgets & Fix Anti-Patterns

#### D1: Tokenize `ProductCard` → `lib/pages/dashboard/pos/components/product_card.dart`

- `EdgeInsets.fromLTRB(0, 9, 0, 9)` → `AppSpacing.cardGapY`
- `BoxShadow(Color(0x2F000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: 1)` → `AppShadows.cardElevated`
- `BorderRadius.circular(6)` → `AppSpacing.selectCardRadius`
- `Positioned(top: 12, right: 12)` → `AppSpacing.cardBadgeOffset`

#### D2: Tokenize order-type button → same directory

- `Color(0xFF2F2F2F)` → `AppColors.grey800`
- `TextStyle(fontSize: 18, fontWeight: FontWeight.w600)` → `AppTypography.orderTypeButton`
- `SizedBox(width: 6.0)` → `AppSpacing.iconGapSm`

#### D3: Fix BuildContext anti-pattern in 3 bottom sheets

`UploadImageBottomSheet`, `ForgotPasswordBottomSheet`, and `UpgradeToAccessBottomSheet` accept `BuildContext context` as a constructor parameter — a Flutter anti-pattern. Remove the param; use `context` from `build(BuildContext context)` method.

---

### Out of Scope for Phase 6

| What | Why |
|---|---|
| **`LabeledCustomTextFormField`** (~50 usages) | Works correctly. Add `@Deprecated('Use AppTextField')` annotation. Migrating 50 files is high-risk with zero functional benefit. Natural attrition will migrate callers over time. |
| **`lib/widgets/`** (9 dot-separated files) | Separate naming convention problem (`foodType.badge.dart`). These are mostly feature-specific wrappers already covered by tokenized atoms (`AppBadge`, `AppButton`). Audit and removal in Phase 7. |
| **`references.dart` mega-barrel** | Imported by 111 files. Splitting into focused libraries is a separate refactor. The established convention works. |
| **Dark theme** | Phase 6 only defines light-mode token values. The architecture guarantees dark theme works by swapping token values — see ADR-09. Dark theme is a follow-up feature, not a standardization fix. |
| **Lint rules** | Nice-to-have enforcement. Separate Phase 7+ project. |

---

## Complete Token Catalog (Post-Phase 6)

### `AppColors` — new tokens (~38)

| Group | Tokens |
|---|---|
| Button (filled) | `buttonFilledPrimaryBg/Fg`, `buttonFilledSecondaryBg/Fg`, `buttonFilledDestructiveBg/Fg` |
| Button (outlined) | `buttonOutlinedPrimaryBorder/Fg`, `buttonOutlinedSecondaryBorder/Fg`, `buttonOutlinedDestructiveBorder/Fg` |
| Button (ghost) | `buttonGhostFg`, `buttonGhostBg` |
| Button (misc) | `buttonDisabledOpacity` |
| TextField | `fieldFill`, `fieldBorder`, `fieldFocusBorder`, `fieldErrorBorder`, `fieldHint`, `fieldLabel`, `fieldText` |
| Card | `cardBg`, `cardBorder`, `cardSelectedBorder`, `cardUnselectedBorder` |
| SelectCard | `selectCardRadioOuter`, `selectCardRadioInner`, `selectCardRadioUnselectedBorder` |
| MenuTile | `menuTileFg`, `menuTileSubtitleFg`, `menuTileTrailingFg` |
| BottomSheet | `bottomSheetGrip`, `bottomSheetBg` |
| Notification | `notificationBg`, `notificationShadow` |
| Badge | `badgeWarningBg` |
| CategoryChip | `categoryChipActiveBg/Fg`, `categoryChipInactiveBg/Fg` |
| Shadow | `shadowBase`, `shadowDark` |

### `AppSpacing` — new tokens (~30)

| Group | Tokens |
|---|---|
| Button | `buttonHeightSm/Md/Lg` (36/48/56), `buttonRadius`, `buttonPaddingSm/Md/Lg` |
| Icon | `iconSizeSm/Md/Lg` (16/24/32), `iconGapSm/Md/Lg` (6/8/12) |
| Card | `cardRadius`, `cardGapY` (9), `cardBadgeOffset` |
| SelectCard | `selectCardRadius`, `selectCardRadioSize`, `selectCardRadioInner`, `selectCardRadioOffset` |
| TextField | `fieldRadius`, `fieldLabelGap` |
| BottomSheet | `bottomSheetGripWidth/Height/Radius`, `bottomSheetGripMargin` |
| CategoryChip | `categoryChipPadding`, `categoryChipImagePadding`, `categoryChipRadius` |
| Notification | `notificationHeight`, `notificationRadius` |
| Badge | `badgePadding` |
| OrderType | `orderTypeButtonGap` |

### `AppTypography` — new tokens (~10)

| Group | Tokens |
|---|---|
| Button | `buttonLabelSm/Md/Lg` |
| Field | `fieldLabel`, `fieldValue` |
| SelectCard | `selectCardHeader`, `selectCardTitle`, `selectCardHighlight` |
| OrderType | `orderTypeButton` |
| Badge | `badgeLabel` |

### `AppShadows` — new tokens (2)

| Group | Tokens |
|---|---|
| Card | `cardElevated` |
| Notification | `notification` |

**Total new tokens:** ~80 across all four theme files.

> **Note — Dark theme:** Phase 6 defines only light-mode token values. A dark theme can be added in a follow-up phase by swapping the `static const` values in the four token files. No component code changes would be required — the architecture guarantees it. See ADR-09.

---

## Architecture Decision Records

### ADR-09: Zero raw visual values in widget code

**Decision:** Every `Color`, `EdgeInsets`, `double` (spacing), `BorderRadius`, `TextStyle`, and `BoxShadow` in every widget file must reference a member of `AppColors`, `AppSpacing`, `AppTypography`, or `AppShadows`. No exceptions.

**Why:**
- Single point of change for visual decisions
- Enables dark theme by swapping token values
- Makes the design language explicit and auditable
- Prevents visual inconsistency (3 different "card radius" conventions)

### ADR-10: Variant × Semantic × Size for all atomic components

**Decision:** Atomic widgets expose `AppVariant`, `AppSemantic`, `AppSize` enums. They do NOT accept raw `Color` or `EdgeInsets` for visual styling. Color override params are forbidden — use `AppSemantic` if a caller needs a different accent.

**Why:**
- Mirrors Radzen Blazor's proven tokenization model (Variant × Shade → adapted to Semantic since Flutter components have fewer shade levels)
- Component doesn't "know" its own colors — it delegates to `AppComponentStyle` which reads tokens
- Changing `AppColors.primary` flows to every `AppSemantic.primary` component automatically
- Named constructors (`.primary()`, `.destructive()`) remain as ergonomic shortcuts
- No `Color?` escape hatch means dark theme works without component changes

### ADR-11: `App` prefix convention

**Decision:** All reusable primitives in `eatery_core/lib/widgets/` use `App` prefix (`AppButton`, `AppCard`, `AppBadge`). Feature-specific widgets use descriptive names without prefix (`ProductCard`, `OrderTypeButton`).

---

## Files Changed

| # | File | Change |
|---|---|---|
| 1 | `packages/eatery_core/lib/theme/app_colors.dart` | Add ~38 component color tokens |
| 2 | `packages/eatery_core/lib/theme/app_spacing.dart` | Add ~30 component spacing tokens |
| 3 | `packages/eatery_core/lib/theme/app_typography.dart` | Add ~10 component type tokens |
| 4 | `packages/eatery_core/lib/theme/app_shadows.dart` | Add 2 component shadow tokens |
| 5 | `packages/eatery_core/lib/theme/app_component.dart` | **New** — `AppVariant`, `AppSemantic`, `AppSize` enums + `AppComponentStyle` class |
| 6 | `packages/eatery_core/lib/widgets/app_button.dart` | Rebuild with full tokenization, subsumes 3 legacy widgets |
| 7 | `packages/eatery_core/lib/widgets/app_text_field.dart` | Replace hardcoded values with tokens, add `labelColor` |
| 8 | `packages/eatery_core/lib/widgets/app_card.dart` | Replace hardcoded radius, add `AppVariant` support |
| 9 | `packages/eatery_core/lib/widgets/app_badge.dart` | **New** — tokenized badge atom |
| 10 | `packages/eatery_core/lib/widgets/app_select_card.dart` | **New** — tokenized selectable card |
| 11 | `packages/eatery_core/lib/widgets/app_menu_tile.dart` | **New** — tokenized menu tile |
| 12 | `packages/eatery_core/lib/widgets/app_bottom_sheet_grip.dart` | **New** — tokenized drag grip |
| 13 | `packages/eatery_core/lib/widgets/app_notification.dart` | **New** — tokenized notification card |
| 14 | `packages/eatery_core/lib/widgets/app_category_chip.dart` | **New** — tokenized category chip |
| 15 | `packages/eatery_core/lib/widgets/widgets.dart` | Add all new exports |
| 16 | `lib/components/` (18 files) | **Delete** after migration |
| 17 | `lib/constants/style/color_style.dart` | **Delete** (0 usages) |
| 18 | `lib/constants/style/spacing_style.dart` | **Delete** (migrate 71 usages → `AppSpacing`) |
| 19 | `lib/references.dart` | Remove legacy exports, add new `eatery_core` widget exports |
| 20 | ~25 files (legacy component callers) | Mechanical migration to tokenized equivalents |
| 21 | 3 bottom sheets | Remove `BuildContext context` constructor param |
| 22 | `lib/pages/dashboard/pos/components/product_card.dart` | Replace hardcoded values with tokens |

---

## Build & Verify

```bash
# After Phase 6A (token additions — no callers changed):
flutter analyze --no-fatal-infos --no-fatal-warnings lib/      # 0 errors
flutter test packages/eatery_core/test/                          # all green

# After each Phase 6B step (new/rebuilt component):
flutter analyze --no-fatal-infos --no-fatal-warnings lib/      # verify no regressions
# Also run component-specific widget tests if added:
flutter test packages/eatery_core/test/widgets/                  # AppButton, AppBadge, etc.

# After Phase 6C (legacy deletion + migration):
flutter analyze --no-fatal-infos --no-fatal-warnings lib/      # 0 errors
flutter test                                                     # 81/81 passed
flutter test packages/eatery_core/test/                          # 51/51 passed

# After Phase 6D (feature component tokenization):
flutter analyze --no-fatal-infos --no-fatal-warnings lib/      # 0 errors

# Full platform build matrix:
flutter build apk --debug
flutter build ios --no-codesign
flutter build macos --debug
flutter build linux --debug
flutter build windows --debug
```

### Widget tests (recommended)

Add `packages/eatery_core/test/widgets/app_button_test.dart` to validate the variant×semantic×size matrix renders without error. This prevents regressions when tokens change:

```dart
// Pseudo-structure (expand in implementation)
testWidgets('AppButton renders all variant×semantic combinations', (tester) async {
  for (final v in AppVariant.values) {
    for (final s in AppSemantic.values) {
      await tester.pumpWidget(
        MaterialApp(home: AppButton(label: '$v-$s', variant: v, semantic: s, onPressed: () {})),
      );
      expect(find.text('$v-$s'), findsOneWidget);
    }
  }
});
```

Similar smoke tests can be added for `AppBadge`, `AppSelectCard`, and `AppCategoryChip`.

---

## Smoke Tests

| # | Scenario | Expected |
|---|---|---|
| S1 | All `AppButton` variants | Filled, outlined, ghost all render with correct `AppColors.button*Bg/Fg` |
| S2 | `AppButton` sizes | sm(36), md(48), lg(56) heights; padding from `AppSpacing.buttonPadding*` |
| S3 | `AppButton` with `icon` + `trailingIcon` | Icon 24px, gap 8px from `AppSpacing.icon*` |
| S4 | `AppTextField` labels | Uses `AppColors.fieldLabel` (grey600), consistent across all forms |
| S5 | Settings `AppMenuTile` grid | All 9 tiles render, per-page `color` override works |
| S6 | POS `ProductCard` | Tokenized shadows, radii, margins — no raw `Color(0x...)` |
| S7 | POS `AppCategoryChip` | Active/inactive states use `AppColors.categoryChip*` |
| S8 | `AppSelectCard` in role picker | Radio-dot at correct size from `AppSpacing.selectCardRadio*` |
| S9 | `AppBottomSheetGrip` on all sheets | 60×5, correct `bottomSheetGrip` color |
| S10 | `AppNotification` card | Dark bg, 70px height, shadow from `AppShadows.notification` |
| S11 | `AppBadge` | 6px padding, font from `AppTypography.badgeLabel` |
| S12 | All forms | Tokenized `AppTextField`, no raw `TextStyle(fontSize:...)` |
| S13 | POS order-type button | `AppButton` ghost + trailingIcon, typography from `orderTypeButton` |
