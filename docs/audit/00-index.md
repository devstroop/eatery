# Codebase Audit — Index

## Severity Guide

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| **CRITICAL** | Data loss, security hole, or broken core flow | Fix immediately |
| **HIGH** | Major feature broken, performance problem, or incorrect behavior | Fix this phase |
| **MEDIUM** | Code quality issue, missing validation, or inconsistency | Fix when in area |
| **LOW** | Cosmetic, dead code, or minor UX polish | Fix when convenient |

## Files

| # | Document | Issues | Critical | High |
|---|----------|--------|----------|------|
| 01 | [Auth Flow](01-auth-flow.md) | 9 | 1 | 2 |
| 02 | [POS Flow](02-pos-flow.md) | 13 | 1 | 3 |
| 03 | [Order Flow](03-order-flow.md) | 12 | 1 | 3 |
| 04 | [Dining Table Flow](04-dining-table-flow.md) | 6 | 1 | 2 |
| 05 | [Payment Flow](05-payment-flow.md) | 5 | 0 | 1 |
| 06 | [Customer & Staff Flow](06-customer-staff-flow.md) | 8 | 0 | 4 |
| 07 | [Product Management](07-product-management.md) | 7 | 0 | 2 |
| 08 | [Data Layer & Sync](08-data-layer-sync.md) | 12 | 2 | 4 |
| 09 | [UI/UX](09-ui-ux.md) | 8 | 0 | 2 |
| 10 | [Missing Features](10-missing-features.md) | 15 | 0 | 0 |
| 11 | [Quick Wins](11-quick-wins.md) | 10 | 0 | 0 |

**Total: 95 issues** (6 critical, 23 high, 42 medium, 24 low)
