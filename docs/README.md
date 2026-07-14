# Eatery — Documentation Index

> Multi-app, offline-first restaurant operating system.

## Documents

### Product Requirements (`docs/prd/`)

| File | Content |
|------|---------|
| [00-index.md](prd/00-index.md) | Overview of all PRD documents |
| [01-vision.md](prd/01-vision.md) | Product vision, four-app strategy, core principles |
| [02-personas.md](prd/02-personas.md) | Personas, user stories, priority matrix |
| [03-features-by-phase.md](prd/03-features-by-phase.md) | Detailed feature requirements per phase (P0–P8) |
| [04-nonfunctional.md](prd/04-nonfunctional.md) | Performance, security, reliability, scalability targets |
| [05-release-criteria.md](prd/05-release-criteria.md) | Exit criteria for each phase |
| [06-prd-audit.md](prd/06-prd-audit.md) | PRD gap analysis, missing features, phase reorganization |

### Technical Specifications (`docs/specs/`)

| File | Content |
|------|---------|
| [00-index.md](specs/00-index.md) | Index of all spec documents |
| [01-repo-structure.md](specs/01-repo-structure.md) | Monorepo layout, package dependencies, build config |
| [02-data-models.md](specs/02-data-models.md) | All model changes, enums, extensions, relationships |
| [03-database-schema.md](specs/03-database-schema.md) | SQL schema, migration strategy, new tables |
| [04-sync-protocol.md](specs/04-sync-protocol.md) | OpLog, WebSocket transport, CRDT, host election, discovery |
| [05-auth-session.md](specs/05-auth-session.md) | Auth flow, route guards, session management, role permissions |
| [06-repositories.md](specs/06-repositories.md) | Repository interfaces, SQLite impls, OpLog integration pattern |
| [07-provider-hierarchy.md](specs/07-provider-hierarchy.md) | Riverpod provider tree, init order, lifecycle |
| [08-testing.md](specs/08-testing.md) | Unit, widget, integration, E2E testing strategy |
| [09-migration-plan.md](specs/09-migration-plan.md) | Step-by-step migration per phase |
| [10-onboarding-redesign.md](specs/10-onboarding-redesign.md) | Company creation, welcome screen, demo mode, setup checklist |
| [11-schema-audit.md](specs/11-schema-audit.md) | Schema review, 22 new tables, design improvements |

### Codebase Audit (`docs/audit/`)

| File | Content |
|------|---------|
| [00-index.md](audit/00-index.md) | Audit methodology and severity guide |
| [01-auth-flow.md](audit/01-auth-flow.md) | Auth/login issues |
| [02-pos-flow.md](audit/02-pos-flow.md) | Point-of-sale flow issues |
| [03-order-flow.md](audit/03-order-flow.md) | Order management issues |
| [04-dining-table-flow.md](audit/04-dining-table-flow.md) | Dining table issues |
| [05-payment-flow.md](audit/05-payment-flow.md) | Payment flow issues |
| [06-customer-staff-flow.md](audit/06-customer-staff-flow.md) | Customer & staff management issues |
| [07-product-management.md](audit/07-product-management.md) | Product/inventory management issues |
| [08-data-layer-sync.md](audit/08-data-layer-sync.md) | Repository, service, sync layer issues |
| [09-ui-ux.md](audit/09-ui-ux.md) | UI/UX issues |
| [10-missing-features.md](audit/10-missing-features.md) | Missing feature inventory |
| [11-quick-wins.md](audit/11-quick-wins.md) | Issues fixable immediately |
