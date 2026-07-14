# Architecture Overview

## What Is Eatery

Eatery is an offline-first restaurant operating system built as a **single Flutter binary** that dispatches four distinct UIs based on the device's configured role. The same app, installed on every device in the restaurant, behaves as an Admin terminal, a Waiter tablet, a Kitchen Display (KDS), or a Customer Display — determined by a first-launch role picker (or `--dart-define=role=` for dev). All devices sync over the local network via WebSocket — no internet or cloud required.

## The Four Roles (Single App)

| Role | Activated By | Purpose | Status |
|------|-------------|---------|--------|
| **Admin** | "I'm Staff" → login as StaffType.admin | Full POS, menu management, customers, payments, staff, settings, reports | Functional |
| **Waiter** | "I'm Staff" → login as StaffType.waiter | Order taking, table management, lightweight POS | In progress |
| **KDS** | "Kitchen Display" (no login) | Real-time order feed, KOT display, station routing | In progress |
| **Display** | "Customer Display" (no login) | Customer-facing order status, read-only | In progress |

All four share `packages/eatery_core` for models, database, sync, theme, widgets, and providers. Role-specific pages live in `lib/pages/{waiter,kds,display}/`.

## Technology Stack

| Category | Choice |
|----------|--------|
| Language | Dart 3.11+ / Flutter 3.41+ |
| State Management | Riverpod (`NotifierProvider`, `AsyncNotifierProvider`) |
| Navigation | GoRouter 17.x |
| Database | SQLite via native Zig FFI (`libeaterystore`) |
| Native Store | Zig 0.15+ / `libeaterystore` (embedded SQLite amalgamation v3.47.0 via `dart:ffi`) |
| Sync | WebSocket + OpLog (operation log) + mDNS discovery |
| Code Gen | `freezed`, `json_serializable`, `riverpod_generator`, `build_runner` |
| Monorepo | Melos 8.x workspace |
| Platforms | Android, iOS, macOS, Windows, Linux |

## Architecture Layers

```
┌──────────────────────────────────────────────────┐
│                  Presentation                     │
│  Pages / Widgets / Shells (AppPageShell, etc.)   │
│  Riverpod: ref.watch / ref.read                  │
├��────────��────────────────────────────────────────┤
│                   Domain                         │
│  Business logic (OrderFunction, validation)       │
│  Repository interfaces (ProductRepository, etc.) │
├──────────────────────────────────────────────────┤
│                    Data                           │
│  Repositories (SqliteProductRepository, etc.)     │
│  Database (EateryStore FFI — SQLite)              │
│  Sync (OpLogService, SyncService, WebSocket)     │
│  DTOs (sync serialization)                       │
��──────────────────────────────────────────────────┘
```

## Key Patterns

### State Management: Riverpod

- `NotifierProvider` for mutable state (cart, POS session)
- `FutureProvider` / `AsyncNotifierProvider` for async data (products list, orders)
- `Provider` for dependency injection (repositories, DB handles)
- Override providers in `ProviderScope` for testing
- See [Provider Hierarchy spec](../architecture/provider-hierarchy.md)

### Data Access: Repositories

UI code never calls the database directly. All data access goes through repository interfaces:

```dart
abstract class ProductRepository {
  List<Product> getAllProducts();
  Future<int> saveProduct(Product product);
  // ...
}
```

All implementations use SQLite (`Sqlite*Repository`). The legacy Hive implementations have been removed.

## Navigation: GoRouter with RBAC

A single unified GoRouter (~50 routes) with role-based access control. Route guards check both authentication state and the device's configured role against a permission matrix.

| Role | Auth | Allowed Routes |
|------|------|----------------|
| `admin` | PIN | `*` (all) |
| `waiter` | PIN | `tables`, `menu`, `cart`, `orders`, `viewOrder`, `orderConfirmation`, `orderPrint`, `customers`, `viewCustomer` |
| `kds` | None | `kds`, `viewOrder`, `orderConfirmation` |
| `display` | None | `display`, `viewOrder` |

Pages navigate via `context.push()` / `context.go()`. Unauthorized routes redirect to the role's home page with an "Access denied" toast.

See [Single-App Architecture](../architecture/single-app-architecture.md) for the full role dispatch flow and RBAC sequence diagram.

## Database Strategy: Dual DB During Migration

The migration from Hive (NoSQL) to SQLite (relational) is complete.

| Aspect | Hive (Legacy — Removed) | SQLite (Current) |
|--------|---------------|-----------------|
| Storage | (removed) | Single `eatery.db` file |
| Queries | Full scan + Dart filter | SQL WHERE/ORDER/JOIN |
| Relations | Manual key management | Foreign keys, CASCADE |
| Migrations | Manual code | Schema versioning + `SchemaMigrator` |
| Sync | Manual | OpLog integrated |

Feature flags in `packages/eatery_core/lib/data/database/native/store_config.dart` control which repositories use SQLite:

```dart
const bool kUseSqliteProductStore = true;
const bool kUseSqliteCustomerStore = true;
// ...
const bool kUseSqliteStore = kUseSqliteProductStore || kUseSqliteCustomerStore || ...;
```

## Sync Architecture

```
┌─────────────────────────────────┐
│  Device: role = admin           │  ← Sync Host
│  Runs SyncServer on :9876       │
└────────────┬────────────────────┘
             │ WebSocket
    ┌────────┼────────┬───────────┐
    │        │        │           │
    ▼        ▼        ▼           ▼
┌──────┐ ┌──────┐ ┌──────┐ ┌──────────┐
│ admin │ │waiter│ │ kds  │ │ display  │
│(other)│ │ leaf │ │ leaf │ │  leaf    │
└──────┘ └──────┘ └──────┘ └──────────┘
```

- **OpLog:** Every write commits an operation log entry with clock, entity, operation type, and data snapshot.
- **Conflict Resolution:** Last-Writer-Wins by logical clock.
- **Discovery:** mDNS (`_eatery-sync._tcp`) with `localhost` fallback.
- **Offline-First:** All roles work without a connection; sync when available.
- See [Sync Protocol spec](../architecture/sync-protocol.md)

## Design System

All shared design tokens live in `packages/eatery_core/lib/theme/`:

| File | Contents |
|------|----------|
| `app_colors.dart` | `AppColors` — brand, semantic, neutral, menu tile colors |
| `app_typography.dart` | `AppTypography` — text style presets |
| `app_spacing.dart` | `AppSpacing` — padding/margin constants |
| `app_shadows.dart` | `AppShadows` �� elevation presets |
| `app_theme.dart` | `AppTheme.light` — Material theme |

Core widgets in `packages/eatery_core/lib/widgets/`:

| Widget | Purpose |
|--------|---------|
| `AppPageShell` | Responsive content wrapper with desktop centering |
| `AppAdaptiveShell` | Multi-platform nav (bottom nav / rail / sidebar) |
| `AppButton` | Primary, secondary, destructive variants |
| `AppCard` | Consistent card surfaces |
| `AppTextField` | Unified text input |
| `AppDialog` | Modal dialogs with icon support |
| `AppSearchField` | Search input |
| `AppTableView` | Responsive table |
| `FloorPlanWidget` | Table floor plan (shared by Admin + Waiter) |

## Detailed Docs

| Link | Content |
|------|---------|
| [Data Flow](data-flow.md) | How data moves through the system |
| [Sync Protocol](../architecture/sync-protocol.md) | OpLog, WebSocket, conflict resolution |
| [Database Schema](../architecture/database-schema.md) | SQL schema and migration strategy |
| [Repositories](../architecture/repositories.md) | All repository interfaces |
| [Provider Hierarchy](../architecture/provider-hierarchy.md) | Riverpod provider tree |
| [UI Standardization Plan](../plan/ui-standardization.md) | Component migration roadmap |
| [Multi-App Overview](multi-app-overview.md) | How the four apps work together |
