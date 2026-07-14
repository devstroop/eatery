# Code Generation

Eatery uses several code generation tools to reduce boilerplate. All generated files live alongside their source and end in `.freezed.dart`, `.g.dart`, or similar.

## Tools

| Tool | Purpose | Applies To |
|------|---------|------------|
| `build_runner` | Orchestrates generation | `eatery_core` only |
| `freezed` | Immutable data classes, `copyWith`, equality | Models, DTOs |
| `json_serializable` | JSON serialization (`toJson`/`fromJson`) | Models, DTOs |
| `riverpod_generator` | Riverpod provider code gen | Providers |
| Hive type adapters | Hive box serialization (`@HiveType`) | Models (legacy — removed) |

## Commands

### Generate (One-shot)

```bash
melos run generate
```

This runs:
```bash
melos exec -c 1 --scope="eatery_core" -- dart run build_runner build --delete-conflicting-outputs
```

### Watch Mode

```bash
melos run generate:watch
```

Reruns generation automatically when source files change.

### Manual (if melos is unavailable)

```bash
cd packages/eatery_core
dart run build_runner build --delete-conflicting-outputs
```

## Generated Files

| Pattern | Source | Generator |
|---------|--------|-----------|
| `*.freezed.dart` | Models with `@freezed` | `freezed` |
| `*.g.dart` | Models with `@JsonSerializable()` | `json_serializable` |
| `.g.dart` (providers) | Providers with `@riverpod` | `riverpod_generator` |

These files are checked into version control (not in `.gitignore`).

## When to Regenerate

Run `melos run generate` after:

- Adding or modifying a `@freezed` data class
- Adding a `@JsonSerializable()` annotation
- Adding or changing a `@riverpod` annotated provider
- Adding a new `@HiveType` type adapter
- Changing model field names or types
- Pulling from upstream that includes model changes

## Build Runner Conflicts

If you see errors about conflicting outputs:

```bash
# Cleans generated files first, then rebuilds
dart run build_runner build --delete-conflicting-outputs
```

If issues persist:

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Note

Code generation runs only against `packages/eatery_core`. Admin/waiter/KDS/display apps do not have their own `build_runner` — they import generated code via `eatery_core`.
