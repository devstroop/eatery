# Contributing to Eatery

## Development Setup

See [docs/guides/getting-started.md](guides/getting-started.md) for full setup instructions.

```bash
melos bootstrap
melos run generate
melos run analyze
melos run test
```

## Code Conventions

- **Files:** `snake_case` (e.g., `product_repository.dart`, `cart_page.dart`)
- **Classes:** `PascalCase` (e.g., `CartNotifier`, `SqliteProductRepository`)
- **Pages:** `ConsumerStatefulWidget` for any page with state; `StatelessWidget` + `ref.watch` for pure presentations
- **Constants:** `kPrefixedCamelCase` (e.g., `kUseSqliteStore`, `kEateryDbFileName`)

## State Management

- Use **Riverpod** (`flutter_riverpod`). No `setState` except in trivial local-only widgets.
- `Notifier` / `AsyncNotifier` for mutable state; `Provider` / `FutureProvider` for derived data.
- Inject repositories via `Provider` overrides — never instantiate repositories in widgets.

## Data Layer

- UI code **never** calls database boxes or native store directly.
- All data access goes through **repository interfaces** (e.g., `ProductRepository`).
- Choose SQLite-backed implementation unless the entity hasn't been migrated yet (Hive fallback controlled by feature flags in `store_config.dart`).

## Pull Request Process

1. Create a feature branch from `master`.
2. Make changes, keeping the app compilable and runnable at every commit (strangler fig).
3. Run `melos run analyze` and `melos run test` — zero errors.
4. Open a PR with a clear description of what changed and why.
5. Reference any related issues (e.g., `#76`).
6. Request review from a maintainer.

## Testing

- Write tests alongside code: `*_test.dart` next to source.
- Unit test repositories against an in-memory SQLite store.
- Widget tests should wrap pages in `ProviderScope` with mocked providers.
- Run `melos run test` before pushing.

## Migration Guidelines

This project is mid-strangler-fig migration. When touching legacy code:

1. Replace `setState` / `StatefulWidget` with Riverpod where practical.
2. Use repository interfaces instead of direct `EateryDB.instance.*Box` calls.
3. Wrap new/edited pages in `AppPageShell` instead of raw `Scaffold`.
4. Reference `AppColors.*`, `AppTypography.*`, and `AppSpacing.*` — not `KColors.*` or raw `TextStyle`.
