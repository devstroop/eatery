# ADR 005: Variant × Semantic × Size Component Model

**Date:** Phase 6 (2026-07)

**Status:** Accepted

## Context

After establishing design tokens (ADR-004), the next question was how atomic widgets should *consume* those tokens. The project had ~12 legacy components (`SpecialButton`, `SecondaryButton`, `SelectableCard`, `ProductCard`, etc.), each with its own constructor API for colors, spacing, and typography. Callers passed raw `Color` and `EdgeInsets` values freely — there was no consistent API pattern.

The question was: **How should an atomic widget (button, badge, card, chip) accept visual styling input without accepting raw visual values?**

## Decision

Atomic widgets expose three enums — `AppVariant`, `AppSemantic`, `AppSize` — and **never** accept raw `Color`, `EdgeInsets`, or `TextStyle` for visual styling.

```dart
enum AppVariant  { filled, outlined, flat, ghost, elevated }
enum AppSemantic { primary, secondary, danger, warning }
enum AppSize     { sm, md, lg }

AppButton(
  label: 'Delete',
  variant: AppVariant.filled,
  semantic: AppSemantic.danger,
  size: AppSize.md,
  onPressed: () => delete(),
)
```

The `AppComponentStyle` lookup class resolves (variant, semantic, size) into token references:

```dart
class AppComponentStyle {
  Color bg(AppVariant v, AppSemantic s) {
    // AppVariant.filled + AppSemantic.primary → AppColors.buttonFilledPrimaryBg
    // AppVariant.outlined + AppSemantic.danger → Colors.transparent
  }
  Color fg(AppVariant v, AppSemantic s) { /* ... */ }
}
```

Components never compute their own colors — they delegate to `AppComponentStyle` which reads from `AppColors` and `AppSpacing` tokens.

### Reference Model

This pattern is adapted from **Radzen Blazor**, where every component inherits `Variant` × `Shade` × `Size` from a base class. Radzen uses 5 shades (Lighter/Light/Default/Dark/Darker) and 5 variants; we use 4 semantics and 5 variants — different dimension count but the same architectural principle.

Radzen's CSS variable approach:
```css
.rz-button--filled-primary { background: var(--rz-primary); }
.rz-button--outlined-danger  { border-color: var(--rz-danger); }
```

Flutter equivalent (our design):
```dart
AppButton(variant: filled, semantic: primary)
// → bg = AppColors.buttonFilledPrimaryBg = AppColors.primary
// → fg = AppColors.buttonFilledPrimaryFg = AppColors.white
```

## Why Not Color Override Params?

Some design systems allow `color` as an escape hatch:

```dart
// ❌ Anti-pattern we explicitly reject
AppButton(label: 'Delete', color: Colors.red, onPressed: () {})
```

This would:
- Bypass token resolution — a theme swap would miss this color
- Allow visual inconsistency — callers choose arbitrary colors
- Defeat dark theme — hardcoded red doesn't invert to a dark-mode red
- Duplicate intent — `AppSemantic.danger` already means "red button"

## Consequences

### Positive

- **Theme-safe:** Changing `AppColors.primary` flows to every `AppSemantic.primary` component
- **Ergonomic:** `AppButton.primary(label: ...)` and `AppButton.destructive(label: ...)` as named constructors
- **Auditable:** Grepping for `AppVariant` / `AppSemantic` finds all component usages
- **Consistent:** The same (variant, semantic, size) pattern works for buttons, badges, category chips, and selectable cards

### Negative

- **Less flexible:** Callers can't choose arbitrary colors — must use the predefined semantics
- **New semantics require code change:** Adding a new `AppSemantic` value means updating `AppComponentStyle` switch cases
- **Naming tension:** `AppSemantic.warning` maps to `AppColors.warning` (yellow) but doesn't capture the exact shade — if two "warning" shades are needed, the model breaks

## Component Coverage

| Component | Variants | Semantics | Sizes |
|---|---|---|---|
| `AppButton` | filled, outlined, ghost | primary, secondary, danger | sm(36), md(48), lg(56) |
| `AppBadge` | filled | warning | sm |
| `AppCategoryChip` | filled | primary (implicit) | md |
| `AppSelectCard` | elevated | primary (implicit) | md |

## Related

- [ADR-004: Zero Raw Visual Values](./004-zero-raw-visual-values.md)
- [ADR-006: Domain Molecule Cohesion](./006-domain-molecule-cohesion.md)
- [Design Tokens](../architecture/design-tokens.md)
- [Component Library](../architecture/component-library.md)
