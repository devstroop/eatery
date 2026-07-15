# Architecture Documentation

Index of all architecture documents for the Eatery POS system.

| # | Document | Description |
|---|----------|-------------|
| 00 | [Single-App Architecture](single-app-architecture.md) | **Target architecture:** single binary with role dispatch, RBAC routing, permission matrix |
| 01 | [Repository Structure](repo-structure.md) | Monorepo layout, dependency graph, package config |
| 02 | [Data Models](data-models.md) | All models, enums, entity relationships, key fields |
| 03 | [Database Schema](database-schema.md) | Hive (legacy — removed) vs SQLite, migration flags, schema versioning |
| 04 | [Sync Protocol](sync-protocol.md) | OpLog entry format, WebSocket transport, host election, mDNS |
| 05 | [Auth & Session](auth-session.md) | PIN authentication, route guards, permission matrix, session management |
| 06 | [Repositories](repositories.md) | Repository interfaces, SQLite impls, OpLog integration |
| 07 | [Provider Hierarchy](provider-hierarchy.md) | Riverpod provider tree, initialization order, DI overrides |
| 08 | [State Management](state-management.md) | Riverpod patterns, provider catalog, ref.read vs ref.watch |
| 09 | [Responsive Design](responsive-design.md) | Breakpoints, navigation shells, platform capabilities |
| 10 | [Design Tokens](design-tokens.md) | Colors, typography, spacing, shadows, AppTheme builder |
| 11 | [Component Library](component-library.md) | AppButton, AppCard, AppDialog, AppTextField, etc. |
| 12 | [Routing](routing.md) | GoRouter setup, unified route table, RBAC redirect guard |
| 13 | [Dev Tooling](dev-tooling.md) | Developer menu, seed data, database inspector, test suite |
