# Development Guide

> Setup, conventions, and dev tooling for the Eatery project.

---

## Quick Start

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── core/                     # Cross-cutting: theme, utils, widgets
├── data/                     # Data layer: models, database, repositories, DTOs
├── domain/                   # Business logic use cases
├── presentation/             # Providers + pages
├── services/                 # Printing, cloud, file utilities
└── dev/                      # Dev tooling (debug builds only)
```

## Conventions

### Files
- One class per file
- File name: `snake_case.description.dart`
- Export barrels at directory level where useful

### State
- New pages: `ConsumerStatefulWidget` + Riverpod
- Old pages being migrated: `ConsumerStatefulWidget` (even if currently using raw Scaffold)
- Avoid `setState` — prefer Riverpod notifiers

### Data
- Models: `@HiveType` + `fromMap`/`toMap` duality
- DTOs: `fromJson`/`toJson` only — no Hive annotations
- Repositories: typed CRUD, injected via Riverpod

### Serialization Rule
- **Hive adapters** (generated `.g.dart`) — local persistence only
- **fromMap/toMap** — legacy import/export (Excel, JSON files)
- **DTOs** — network sync only (WebSocket/HTTP to cloud and peer devices)

## Code Generation

```bash
# After editing @HiveType models
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch
```

## Testing

```bash
flutter test
flutter test --coverage
```

See [Dev Tooling](../dev-tooling.md) for seed data and debug tools.
