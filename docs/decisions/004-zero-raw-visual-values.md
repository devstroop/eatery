# ADR 004: Zero Raw Visual Values in Widget Code

**Date:** Phase 6-7 (2026-07)

**Status:** Accepted

## Context

After Phase 5's 114-warning cleanup and the introduction of `AppColors`, `AppSpacing`, `AppTypography`, and `AppShadows` token files, a full audit of `lib/components/` revealed ~100 untokenized values across 12 legacy components:

- 15 raw `Color(0xFF...)` in component code
- 13 `BorderRadius.circular(N)` with three competing radius conventions
- 26 raw `EdgeInsets` with inconsistent gap sizes
- 6 raw `TextStyle(fontSize: N)` with no scale alignment
- 5 `BoxShadow(Color(...))` with two distinct shadow colors
- 9 raw widget dimensions (`width: 60, height: 5`)

This is the opposite of a design system — each component is a self-contained silo of visual decisions. Adding a dark theme would require modifying every component individually.

## Decision

**Every `Color`, `EdgeInsets`, `double` (spacing), `BorderRadius`, `TextStyle`, and `BoxShadow` in every widget file outside `eatery_core/lib/theme/` must reference a named member of `AppColors`, `AppSpacing`, `AppTypography`, or `AppShadows`.**

No `Color(0xFF...)`, no `EdgeInsets.all(N)`, no `TextStyle(fontSize: N)`, no `BorderRadius.circular(N)`, no `BoxShadow(Color(...))` appears in any widget file.

### Tokenized Data Models

Data model enums must not carry raw Flutter `Color` values. Instead:

```dart
// BEFORE (Phase 5 — raw Flutter colors, dead code)
enum OrderStatus {
  pending(0, 'Pending', Colors.orange),    // ← no one reads .color
  preparing(1, 'Preparing', Colors.blue),
  ...
}

// AFTER (Phase 7 — tokenized single source of truth)
enum OrderStatus {
  pending(0, 'Pending'),
  preparing(1, 'Preparing'),
  ...
}

// Resolutions lives in the token file:
// AppColors.statusPending = AppColors.warning
// AppColors.statusPreparing = AppColors.info

// Data model provides color resolution via static method:
// OrderStatus.colorFor(status) → AppColors.status*
```

### Reference Model

Inspired by **Radzen Blazor** and **shadcn/ui**: both define every visual property as a named token variable. Components never contain raw values. Changing `AppColors.primary` flows to every `AppSemantic.primary` component automatically.

## Consequences

### Positive

- **Single point of change** for all visual decisions
- **Dark theme ready** — swap token values, zero component changes
- **Design language is explicit** — auditing tokens is possible without reading component code
- **Eliminates visual inconsistency** — 3 different "card radius" conventions merged into one token
- **Data models are decoupled from visual presentation** — `OrderStatus` no longer imports `dart:ui` just for colors

### Negative

- **Token files grow** — ~80 tokens added in Phase 6, ~15 more in Phase 7
- **Migration is mechanical but voluminous** — Phase 6 touched ~20 files, Phase 7 touched ~30 files
- **Requires discipline** — reviewers must reject PRs that introduce raw values
- **Token naming requires thought** — every new color/spacing needs a semantic name

## Token Categories

| Token File | Scope | Examples |
|---|---|---|
| `app_colors.dart` | All colors (brand, semantic, neutrals, status, component-specific) | `primary`, `warning`, `grey300`, `statusPending`, `buttonFilledPrimaryBg` |
| `app_spacing.dart` | Dimensions, paddings, radii, gaps, sizes | `xs`(4), `sm`(8), `md`(12), `lg`(16), `radiusLg`(12), `fieldLabelGap` |
| `app_typography.dart` | Text styles — display, headline, title, body, label, component-specific | `titleMedium`, `bodySmall`, `labelSmall`, `badgeLabel` |
| `app_shadows.dart` | Elevation presets | `sm`, `md`, `lg`, `cardElevated`, `notification` |

## Exceptions

- `Colors.transparent` is acceptable as it's not a design decision (it's a color constant that means "no color")
- `colors.withValues(alpha: N)` is acceptable for opacity adjustments on existing token colors
- Animation parameters (durations, curves) are not visual values — they live in animation code, not token files

## Related

- [ADR-005: Variant × Semantic × Size Component Model](./005-variant-semantic-size.md)
- [Design Tokens](../architecture/design-tokens.md)
- [Component Library](../architecture/component-library.md)
- [Form Patterns Guide](../guides/form-patterns.md)
