# ADR 001: Riverpod over Provider

**Date:** During reconstruction (Phase 1)

**Status:** Accepted

## Context

The pre-reconstruction codebase used no state management — global mutable state via a `Common` class with 12 static fields, and raw `setState` throughout. There were no tests, no dependency injection, and no separation between UI and business logic.

The reconstruction needed a state management solution that:

- Is compile-safe (no runtime errors from missing providers)
- Supports dependency injection for testability
- Works well with Flutter's widget tree
- Has an active community and maintenance
- Is not overly verbose for common patterns

## Decision

Use **Riverpod** (`flutter_riverpod` package, `NotifierProvider` / `AsyncNotifierProvider` patterns).

## Consequences

### Positive

- **Compile-time safety:** Missing providers are compilation errors, not runtime crashes
- **Testability:** Providers can be overridden in `ProviderScope` for widget tests
- **No BuildContext dependency:** Providers can be read outside the widget tree
- **Code generation:** `riverpod_generator` reduces boilerplate for common patterns
- **Fine-grained rebuilds:** `ref.watch` only rebuilds widgets that depend on changed providers

### Negative

- **Learning curve:** Team needs to learn Riverpod's provider types and `ref` patterns
- **Boilerplate:** Each repository/service needs a provider declaration
- **Migration effort:** ~100 `setState` / `StatefulWidget` sites needed conversion

## Alternatives Considered

| Solution | Pros | Cons |
|----------|------|------|
| **Provider** | Mature, well-known | Not compile-safe (missing provider = runtime `ProviderNotFoundException`), no `ref` outside widget tree |
| **BLoC** | Clear separation, testable streams | Very verbose for CRUD screens, excessive ceremony for simple state |
| **GetX** | Minimal boilerplate | Strong anti-pattern concerns (global mutable state, implicit dependencies, no type safety), abandoned maintenance perception |
| **Redux** | Predictable state container | Too much ceremony for this project size, action/reducer pattern is overkill for POS screens |

## Usage Pattern

```dart
// Provider for dependency injection
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return SqliteProductRepository(ref.watch(eateryStoreProvider));
});

// Notifier for mutable state
class CartNotifier extends Notifier<PosSession> {
  @override PosSession build() => const PosSession();
  void addToCart(Product p) { ... update state ... }
}
final cartProvider = NotifierProvider<CartNotifier, PosSession>(CartNotifier.new);

// In widget:
class MyPage extends ConsumerStatefulWidget { ... }
class _MyPageState extends ConsumerState<MyPage> {
  @override Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final cart = ref.watch(cartProvider);
    return ...;
  }
}
```
