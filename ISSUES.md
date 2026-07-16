# Issues & Backlog

## GitHub Issues (42 open)

The canonical backlog. Tracked on GitHub.

| # | Priority | Title |
|---|----------|-------|
| [#89](https://github.com/devstroop/eatery/issues/89) | 🔴 P0 | Hardcoded Google Drive OAuth credentials |
| [#93](https://github.com/devstroop/eatery/issues/93) | 🟡 P2 | AppFileSystem duplicates Common directory logic |
| [#96](https://github.com/devstroop/eatery/issues/96) | 🟡 P1 | Convert list screens to responsive GridView |
| [#97](https://github.com/devstroop/eatery/issues/97) | 🟠 P2 | Centralize theme via ThemeData |
| [#98](https://github.com/devstroop/eatery/issues/98) | 🟠 P2 | Desktop-friendly layouts |
| [#100](https://github.com/devstroop/eatery/issues/100) | 🟠 P2 | POS product grid SliverGrid refactor |
| [#101](https://github.com/devstroop/eatery/issues/101) | 🟠 P2 | Login page desktop vertical centering |
| [#122](https://github.com/devstroop/eatery/issues/122) | 🔴 P0 | Add user-facing error handling — 65 silent catch blocks |
| [#123](https://github.com/devstroop/eatery/issues/123) | 🔴 P0 | Enable strict lint rules |
| [#124](https://github.com/devstroop/eatery/issues/124) | 🧹 P1 | Standardise async patterns — replace 76 .then() chains |
| [#125](https://github.com/devstroop/eatery/issues/125) | 🔴 P0 | Rename SQL column edition→taxation + delete toMap() hack |
| [#126](https://github.com/devstroop/eatery/issues/126) | 🔴 P0 | Add adminStaffId to Dart Company model |
| [#127](https://github.com/devstroop/eatery/issues/127) | 🔴 P0 | Route params use dynamic type — use typed extras |
| [#128](https://github.com/devstroop/eatery/issues/128) | 🟡 P1 | Add createdAt/updatedAt to company table + model |
| [#129](https://github.com/devstroop/eatery/issues/129) | 🟡 P1 | Add companyId FK to 20 core tables |
| [#130](https://github.com/devstroop/eatery/issues/130) | 🟡 P1 | Add email/pinUpdatedAt/lastLoginAt to Employee model |
| [#131](https://github.com/devstroop/eatery/issues/131) | 🟡 P1 | Add widget interaction tests for form pages |
| [#132](https://github.com/devstroop/eatery/issues/132) | 🧹 P1 | Replace .then() chains with async/await |
| [#133](https://github.com/devstroop/eatery/issues/133) | 🟡 P1 | Add FK from orders(customerPhone) to customer(phone) |
| [#134](https://github.com/devstroop/eatery/issues/134) | 🟡 P1 | Add missing indices to Phase C tables |
| [#135](https://github.com/devstroop/eatery/issues/135) | 🟠 P2 | Add structured address to company |
| [#136](https://github.com/devstroop/eatery/issues/136) | 🟠 P2 | Add invoice config to company |
| [#137](https://github.com/devstroop/eatery/issues/137) | 🟠 P2 | Add business identity fields (legalName, businessType, pan) |
| [#138](https://github.com/devstroop/eatery/issues/138) | 🟠 P2 | Add operations config (timezone, language, orderType) |
| [#139](https://github.com/devstroop/eatery/issues/139) | 🟠 P2 | Standardize FK patterns (3 styles coexist) |
| [#140](https://github.com/devstroop/eatery/issues/140) | 🟠 P2 | Refactor compliance_report — break JSON blobs |
| [#141](https://github.com/devstroop/eatery/issues/141) | 🟠 P2 | Add EmployeeRole.manager enum value |
| [#142](https://github.com/devstroop/eatery/issues/142) | 🔵 P3 | Add soft-delete to company table |
| [#143](https://github.com/devstroop/eatery/issues/143) | 🔵 P3 | Add multi-outlet columns to company |
| [#144](https://github.com/devstroop/eatery/issues/144) | 🔵 P3 | Add bank/UPI details to company |
| [#145](https://github.com/devstroop/eatery/issues/145) | 🔵 P3 | Add printer/hardware config |
| [#146](https://github.com/devstroop/eatery/issues/146) | 🔵 P3 | Add business hours + holiday hours management |
| [#147](https://github.com/devstroop/eatery/issues/147) | 🔵 P3 | Add onboarding checklist post-setup widget |
| [#148](https://github.com/devstroop/eatery/issues/148) | 🔵 P3 | Remove company.password — employee PIN is standard |
| [#149](https://github.com/devstroop/eatery/issues/149) | 🧹 P1 | Add error boundary widget + standard error type |
| [#150](https://github.com/devstroop/eatery/issues/150) | 🧹 P2 | Phase out references.dart god barrel |
| [#151](https://github.com/devstroop/eatery/issues/151) | 🧹 P2 | Add CI pipeline (analyze + test + format) |
| [#152](https://github.com/devstroop/eatery/issues/152) | 🧹 P2 | Add form validation tests for 23 AppFormField pages |
| [#153](https://github.com/devstroop/eatery/issues/153) | 🧹 P2 | Add repositories for 9 orphan SQL tables |

---

## Backlog Summary

| Priority | Count | Issue Numbers |
|---|---|---|
| 🔴 P0 | 7 | 89, 122, 123, 125, 126, 127, 128 |
| 🟡 P1 | 10 | 96, 129, 130, 131, 132, 133, 134, 149, 124, 128 |
| 🟠 P2 | 16 | 93, 97, 98, 100, 101, 135, 136, 137, 138, 139, 140, 141, 150, 151, 152, 153 |
| 🔵 P3 | 7 | 142, 143, 144, 145, 146, 147, 148 |
| **Total** | **40 open** | |

## Lifecycle Tracking

Items below are for reference — all active work is tracked in GitHub issues above.

### Schema Hardening (Fixed)
S01-S10, S17 — all resolved in schema.sql + migration v10.

### Staff→Employee Rename (Fixed)
E01-E03, E06 — schema rename, Dart model rename, enum rename, page renames complete.
E04 (email field), E05 (pinUpdatedAt/lastLoginAt), E07 (manager role) → tracked in GitHub.

### Naming Residues
Minor: `authStaff` variable (app_router.dart:594/627), "Select Staff Type" label (add.employee.page.dart:191), "I'm Staff" picker label (role_picker.page.dart:10). Low priority cosmetic fixes.

### Edition→Taxation Gap
Tracked in [#125](https://github.com/devstroop/eatery/issues/125). N01-N04: SQL column rename, file rename, FoodType extension fix, remove toMap() hack.

### Repository Gaps
9 SQL tables lack repositories. Tracked in [#153](https://github.com/devstroop/eatery/issues/153).
