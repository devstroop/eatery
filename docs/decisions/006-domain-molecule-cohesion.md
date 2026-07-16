# ADR 006: Domain Molecule Cohesion — One Widget Per Domain Concept

**Date:** Phase 7 (2026-07)

**Status:** Accepted

## Context

After Phase 6 tokenized atomic components (buttons, badges, cards), a pattern emerged: the same domain entity was rendered by completely different widgets depending on the user's role.

**Example: An `Order` is displayed as:**
- A KDS ticket card (`_StatusBadge` + inline card, ~150 lines)
- A waiter order card (`_OrderCard` + `_statusColor`, ~120 lines)
- A customer-facing display card (`_OrderStatusCard` + pulse animation, ~130 lines)
- An admin list tile (`_OrderCard` with subtitle column, ~60 lines)

Four implementations, zero shared code. Each role defined its own colors, layout, dimensions, and interaction model for the identical `Order` data object. This violated DRY, made status color changes require 4-file sweeps, and prevented visual consistency across roles.

## Decision

**Build domain molecules — multi-atom compositions that express a single business concept, renderable in role-appropriate layouts via a context enum.**

```dart
enum OrderCardContext { kds, waiter, display, admin }

AppOrderCard(
  order: order,
  context: OrderCardContext.kds,
  currencySymbol: '\$',
  onStart: () => repo.startOrder(order),
  onComplete: () => repo.completeOrder(order),
)
```

The widget encapsulates:
- Status badge colors (from `OrderStatus.colorFor()` → `AppColors.status*`)
- Typography (`AppTypography.orderCardTitle`)
- Spacing per context
- Role-appropriate actions (Start/Done for KDS, Edit/Void for admin, tap-to-detail for waiter)
- Animations (Lottie burst for new display orders, pulse for preparing)

## Molecule Inventory

| Molecule | Domain Concept | Contexts | Replaces |
|---|---|---|---|
| `AppOrderCard` | An order summary card | kds, waiter, display, admin | 4 private widgets (~400 lines → ~200 lines) |
| `AppStatusTimeline` | Order status transition history | (standalone, used in view.order) | New functionality — no existing widget |
| `AppMultiStepForm` | Multi-step form with step indicator | (parameterized step list) | Body1–Body6 (~900 lines → `AppMultiStepForm` + inline content) |
| `AppNotificationBanner` | Slide-down alert banner | (Overlay-based, role-agnostic) | 17 ad-hoc `ScaffoldMessenger.showSnackBar` call sites |
| `AppFormField` | Label + text field + spacing molecule | (standalone, used in all forms) | `LabeledCustomTextFormField` (66 call sites across 23 files) |

## Key Patterns

### Status Color Resolution at Data Model Level

Before Phase 7, `OrderStatus` carried raw Flutter `Color` values that were dead code — every role ignored them and hardcoded its own `AppColors.warning` / `AppColors.info` in a local switch statement.

After Phase 7, resolution is centralized:

```dart
// In order_status.dart
static Color colorFor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:   return Color(0xFFF5A142); // ← token value
    case OrderStatus.preparing: return Color(0xFF2F5EC2);
    // ...
  }
}
```

All four roles consume `OrderStatus.colorFor()` instead of maintaining their own color maps. The data model references token values directly (avoiding a circular package dependency on `AppColors`).

### Form Field Cohesion

The `AppFormField` molecule absorbs three patterns that were manually repeated across 23 files:
1. **Label rendering:** `Text(label)` with tokenized typography
2. **Spacing:** `AppSpacing.fieldLabelGap` above field, `AppSpacing.md` below
3. **Focus chaining:** `onFieldSubmitted → FocusScope.requestFocus(focusNext)` replaced by `focusNext` prop

Before: `LabeledCustomTextFormField(label, hint, themeColor, foregroundColor, focusNode, onFieldSubmitted: (v) => focusNodes[N+1].requestFocus(), ...)`
After: `AppFormField(label, hint, controller, focusNode: focusNodes[N], focusNext: focusNodes[N+1])`

### Overlay-Based Notifications

`AppNotificationBanner` uses `Overlay.insert()` — no Scaffold dependency. This is critical because KDS and Display pages may not have a `Scaffold` ancestor. The banner slides down from the top, auto-dismisses, and supports tap-to-navigate.

## When to Create a Molecule

A molecule is warranted when:
- The same data model entity is rendered differently in ≥3 contexts
- There are ≥2 independent implementations of what is conceptually the same widget
- Visual consistency across contexts matters (e.g., the same status color everywhere)
- The shared pattern is non-trivial (not just a 3-line wrapper)

A molecule is NOT warranted when:
- Contexts are fundamentally different UIs (e.g., a list vs a chart)
- The "shared" abstraction would be more complex than the sum of its parts
- Only 2 contexts exist and one is trivially different

## Consequences

### Positive

- **DRY:** Each domain concept has one canonical implementation
- **Consistent:** Status colors match across all roles by construction
- **Auditable:** Changing `OrderStatus.colorFor()` updates all four roles
- **Discoverable:** New developers find `AppOrderCard`, not four private widgets in four files
- **Testable:** One widget test covers all contexts

### Negative

- **Context enum grows:** New roles require new enum values and switch cases
- **Widget interface is larger:** 8-10 optional callbacks for role-specific actions
- **Animation state:** Display context needs `TickerProviderStateMixin` for pulse animation — forces `ConsumerStatefulWidget` even though KDS/Waiter/Admin are stateless
- **Coupling:** All four roles depend on `eatery_core` for their order cards

## Related

- [ADR-004: Zero Raw Visual Values](./004-zero-raw-visual-values.md)
- [ADR-005: Variant × Semantic × Size](./005-variant-semantic-size.md)
- [Component Library](../architecture/component-library.md)
- [Form Patterns Guide](../guides/form-patterns.md)
