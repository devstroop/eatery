# Plan Documents

This directory consolidates audit findings, migration strategies, and design specs for the Eatery POS system.

## Documents

| Document | Audience | Priority | Contents |
|----------|----------|----------|----------|
| [issue-inventory.md](issue-inventory.md) | Dev leads, all contributors | High | Full issue inventory: 106 issues across 12 categories with severity, file locations, and details. ~80 issues resolved since audit. |
| [migration-plan.md](migration-plan.md) | Dev leads, architects | High | Phased migration from monolith to monorepo: core extraction, role-based auth, order status lifecycle, sync transport. |
| [schema-audit.md](schema-audit.md) | Dev leads, backend/devs | High | Database schema audit: 21 design flaws in existing tables, 22 missing entity types, full recommended 41-table schema, 5-phase migration strategy. |
| [onboarding-redesign.md](onboarding-redesign.md) | PMs, designers, dev leads | Medium | Redesign of company setup: 2-field onboarding (name + PIN), deferred collection, demo mode, setup checklist. |
| [ui-standardization.md](ui-standardization.md) | Frontend devs, designers | Medium | UI component standardization plan: shell migration, legacy widget replacement, theme token consolidation, responsive hardening, GoRouter adoption. |
