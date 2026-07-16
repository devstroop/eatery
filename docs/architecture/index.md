# Architecture Documentation

Index of all architecture documents for the Eatery POS system.

| # | Document | Description |
|---|----------|-------------|
| 00 | [Single-App Architecture](single-app-architecture.md) | **Target architecture:** single binary with role dispatch, RBAC routing, permission matrix |
| 01 | [Repository Structure](repo-structure.md) | Monorepo layout, dependency graph, package config |
| 02 | [Data Models](data-models.md) | All models, enums, entity relationships, key fields |
| 03 | [Database Schema](database-schema.md) | SQLite schema, WAL configuration, migrations, FK enforcement |
| 04 | [Sync Protocol](sync-protocol.md) | OpLog entry format, WebSocket transport, host election, mDNS, queue resilience |
| 05 | [Auth & Session](auth-session.md) | PIN authentication, route guards, permission matrix, session management |
| 06 | [Repositories](repositories.md) | Repository interfaces, SQLite impls, OpLog integration, provider patterns |
| 07 | [Provider Hierarchy](provider-hierarchy.md) | Riverpod provider tree, initialization order, DI overrides |
| 08 | [State Management](state-management.md) | Riverpod patterns, provider catalog, ref.read vs ref.watch |
| 09 | [Responsive Design](responsive-design.md) | Breakpoints, navigation shells, platform capabilities |
| 10 | [Design Tokens](design-tokens.md) | Colors, typography, spacing, shadows, component-specific tokens, domain tokens |
| 11 | [Component Library](component-library.md) | Tokenized atoms, domain molecules, legacy migration table |
| 12 | [Routing](routing.md) | GoRouter setup, unified route table, RBAC redirect guard |
| 13 | [Dev Tooling](dev-tooling.md) | Developer menu, seed data, database inspector, test suite, CI |

## Architecture Decision Records

Located in `docs/decisions/`:

| ADR | Title | Phase |
|-----|-------|-------|
| [001](../decisions/001-riverpod-over-provider.md) | Riverpod over Provider | Reconstruction |
| [002](../decisions/002-sqlite-over-hive.md) | SQLite over Hive | 2-3 |
| [003](../decisions/003-zig-for-native.md) | Zig for Native Code | 2-3 |
| [004](../decisions/004-zero-raw-visual-values.md) | Zero Raw Visual Values in Widget Code | 6-7 |
| [005](../decisions/005-variant-semantic-size.md) | Variant × Semantic × Size Component Model | 6 |
| [006](../decisions/006-domain-molecule-cohesion.md) | Domain Molecule Cohesion | 7 |

## Guides

| Guide | Description |
|-------|-------------|
| [Form Patterns](../guides/form-patterns.md) | AppFormField usage, focus chaining, multi-step forms |
| [Getting Started](../guides/getting-started.md) | First-time setup, build commands, dev workflow |
| [Architecture Overview](../guides/architecture-overview.md) | High-level architecture walkthrough |
| [Data Flow](../guides/data-flow.md) | How data moves through the system |
