# Eatery — Documentation

> Multi-app, offline-first restaurant operating system.

## Quick Links

| Link | Description |
|------|-------------|
| [Getting Started](guides/getting-started.md) | Developer setup, build, and run |
| [Architecture Overview](guides/architecture-overview.md) | High-level system design |
| [Contributing](CONTRIBUTING.md) | How to contribute |
| [Issue Inventory](plan/issue-inventory.md) | All known issues and plans |

---

## Product (`docs/product/`)

Requirements, vision, and roadmap for product managers and stakeholders.

| Document | Content |
|----------|---------|
| [Index](product/index.md) | Product overview and doc index |
| [Vision](product/01-vision.md) | Product vision, four-app strategy |
| [Personas](product/02-personas.md) | User personas and stories |
| [Features by Phase](product/03-features-by-phase.md) | Feature requirements P0–P8 |
| [Non-Functional](product/04-nonfunctional.md) | Performance, security, reliability |
| [Release Criteria](product/05-release-criteria.md) | Exit criteria per phase |
| [PRD Audit](product/06-prd-audit.md) | Gap analysis and improvements |

## Architecture (`docs/architecture/`)

Technical specifications for the engineering team.

| Document | Content |
|----------|---------|
| [Index](architecture/index.md) | Architecture doc index |
| [Repository Structure](architecture/repo-structure.md) | Monorepo layout, packages, dependencies |
| [Data Models](architecture/data-models.md) | All models, enums, relationships |
| [Database Schema](architecture/database-schema.md) | SQL schema, migration strategy |
| [Sync Protocol](architecture/sync-protocol.md) | OpLog, WebSocket, CRDT, discovery |
| [Auth & Session](architecture/auth-session.md) | Auth flow, route guards, permissions |
| [Repositories](architecture/repositories.md) | Repository interfaces and implementations |
| [Provider Hierarchy](architecture/provider-hierarchy.md) | Riverpod provider tree |
| [State Management](architecture/state-management.md) | Riverpod patterns and catalog |
| [Responsive Design](architecture/responsive-design.md) | Breakpoints, layout, navigation |
| [Design Tokens](architecture/design-tokens.md) | Colors, typography, spacing, shadows |
| [Component Library](architecture/component-library.md) | Widget catalog and migration status |
| [Routing](architecture/routing.md) | GoRouter setup and migration |
| [Dev Tooling](architecture/dev-tooling.md) | Seed data, DB inspector, debugging |

## Apps (`docs/architecture/apps/`)

Per-app documentation for the multi-app ecosystem.

| Document | Content |
|----------|---------|
| [Multi-App Overview](../guides/multi-app-overview.md) | How the 4 apps work together |
| Admin | Full POS, management, config, reports |
| Waiter | Order entry, table management |
| Kitchen (KDS) | Order feed, station routing |
| Display | Customer-facing order status |

## Development (`docs/development/`)

Procedures and guides for contributors.

| Document | Content |
|----------|---------|
| [Setup](development/setup.md) | Environment setup, build, and run |
| [Testing Strategy](development/testing-strategy.md) | Unit, widget, integration, E2E |
| [Code Generation](development/code-generation.md) | build_runner, freezed, riverpod_generator |
| [Native Build](development/native-build.md) | Zig/SQLite FFI library build |
| [Migration Patterns](development/migration-patterns.md) | Strangler fig migration reference |

## Plans & Roadmaps (`docs/plan/`)

Project management, audits, and execution plans.

| Document | Content |
|----------|---------|
| [Index](plan/index.md) | Plan overview |
| [Issue Inventory](plan/issue-inventory.md) | All 106 cataloged issues |
| [UI Standardization Plan](plan/ui-standardization.md) | UI component migration |
| [Schema Audit](plan/schema-audit.md) | Database schema review |
| [Onboarding Redesign](plan/onboarding-redesign.md) | Company creation redesign |
| [Migration Plan](plan/migration-plan.md) | Step-by-step phase migration |

## Architecture Decisions (`docs/decisions/`)

Architecture Decision Records (ADRs).

| Document | Decision |
|----------|----------|
| [001 — Riverpod over Provider](decisions/001-riverpod-over-provider.md) | Why Riverpod |
| [002 — SQLite over Hive](decisions/002-sqlite-over-hive.md) | Why SQLite migration |
| [003 — Zig for Native](decisions/003-zig-for-native.md) | Why Zig for FFI layer |

---

## Document Conventions

- **File naming:** `snake-case.md`, numbered where order matters
- **Internal links:** Relative paths from `docs/` directory
- **Live docs:** Documents should reflect current state of the codebase
- **Historical records:** Reconstruction history and migration logs live in `docs/plan/`
