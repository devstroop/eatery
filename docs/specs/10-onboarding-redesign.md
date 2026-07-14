# Onboarding & Company Setup — Redesign (Schema-Aligned)

> **Replaces:** 6-step company creation wizard, `main.screen.dart` landing, old `login.page.dart`  
> **Schema foundation:** `docs/specs/11-schema-audit.md`  
> **Design principle:** Collect nothing that can be deferred. Derive what you can. Ask only for identity.

---

## 1. Core Insight

A local-first POS needs exactly **2 things** from a first-time user to be useful:

1. **Who you are** — so actions are attributed to a person
2. **A PIN** — so only you can access the system

Everything else — restaurant name, currency, email, phone, address, logo, taxation, subscription — is either:
- Auto-detected (currency from locale, timezone from system)
- Set to a sensible default (name = "My Restaurant")
- Deferred to the setup checklist (products, staff, tables)
- Deferred to settings (tax registration, printer, business hours)

---

## 2. The Handshake (Setup)

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  Welcome to Eatery                                  │
│  Free & open restaurant POS                         │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │  Set up in under 30 seconds                  │   │
│  │                                             │   │
│  │  Your name     ┌──────────────────────┐     │   │
│  │                │ e.g. Rajesh          │     │   │
│  │                └──────────────────────┘     │   │
│  │                                             │   │
│  │  Create a PIN  ┌──────┐  ┌──────────────┐  │   │
│  │                │ ●●●● │  │  Confirm     │  │   │
│  │                └──────┘  └──────────────┘  │   │
│  │                                             │   │
│  │  ┌─────────────────────────────────────┐   │   │
│  │  │  Start using Eatery                 │   │   │
│  │  └─────────────────────────────────────┘   │   │
│  │                                             │   │
│  │  or  Try Demo →   Explore with sample data  │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  Restore from backup  ·  Docs  ·  GitHub            │
└─────────────────────────────────────────────────────┘
```

**What happens on submit:**
1. Create `Staff` record: `{ name, pin: hashed(PIN), type: admin }`
2. Create `Company` record: `{ name: 'My Restaurant', taxation: none, adminStaffId: staff.id }`
3. Auto-detect currency from locale (fallback: USD)
4. Navigate to dashboard

**Total fields collected: 2** (name + PIN)

---

## 3. What Gets Deferred

| Item | Where User Sets It | Trigger |
|------|-------------------|---------|
| Restaurant name | Settings → Company Profile | Empty state / checklist |
| Email / Phone / Address | Settings → Company Profile | Empty state / checklist |
| Logo | Settings → Company Profile | Empty state / checklist |
| Currency | Auto-detected; change in Settings | Locale detection |
| Taxation | Onboarding checklist or Settings | Checklist item |
| Tax registration numbers | Settings → Tax | Deferred until needed |
| Timezone | Auto-detected; change in Settings | System timezone |
| Subscription | Never asked upfront | Soft upgrade prompts |

---

## 4. Setup Checklist (Post-Setup)

Shown on first dashboard load. Items appear based on what's missing:

```
┌──────────────────────────────────────────────┐
│  Getting Started             2 of 8 done     │
│                                              │
│  ✅  Your admin account                      │
│  ✅  Restaurant created                      │
│  ◻  Add your first menu item   → Products   │
│  ◻  Set up dining tables       → Tables     │
│  ◻  Add your team              → Staff      │
│  ◻  Set your restaurant name   → Settings   │
│  ◻  Configure tax (optional)   → Tax        │
│  ◻  Set up a printer (optional)→ Printers   │
│                                              │
│  [Take me to the dashboard]                  │
└──────────────────────────────────────────────┘
```

Checklist progress stored in `app_config` table. Reopenable from sidebar.

---

## 5. Demo Mode

"Try Demo" flows exactly like setup but with seed data loaded. Single PIN `1234` for the demo admin account. Yellow banner across all pages:

```
📦 Demo Mode — Data is not saved permanently. [Start fresh →] [Export]
```

**Demo→Real transition:** When a demo user taps "Start fresh", the app:
1. Prompts: "Start fresh? This will clear all demo data and begin setting up your restaurant."
2. On confirm, drops all demo records from the database
3. Navigates to the 2-field setup page
4. Demo seed data loader must be idempotent (safe to run multiple times)

**Demo→Export:** The Export button creates a JSON file of all demo data (including any modifications the user made). This lets them explore, customize, then import into a real setup later.

---

## 6. Files Changed

| File | Action |
|------|--------|
| `lib/pages/welcome/welcome.page.dart` | Create — new landing with 2-field setup + demo |
| `lib/pages/dashboard/components/setup_checklist.dart` | Create |
| `lib/pages/dashboard/components/empty_state.dart` | Create — reusable per all list pages |
| `lib/pages/authentication/login.page.dart` | Rewrite — staff PIN login (not company password) |
| `lib/pages/authentication/reset-pin.dart` | Rewrite — working PIN reset |
| `lib/pages/create_company/` | Remove — entire 6-step wizard directory |
| `lib/pages/main.screen.dart` | Remove — replaced by welcome page |
| `lib/dev/seed_data.dart` | Revive — working seed data loader |
| `lib/core/router/app_router.dart` | Update — new routes, redirect via auth session |
| `packages/eatery_core/lib/data/models/staff/staff.dart` | Add `pin`, `email`, `createdAt`; add `admin` type |
| `packages/eatery_core/lib/data/models/staff/staff_type.dart` | Add `admin(4)` |
| `packages/eatery_core/lib/data/models/company/company.dart` | Remove `password`; add `adminStaffId`, `timezone`, `businessType`; make name default; make email/phone/address optional |
| `packages/eatery_core/lib/providers/auth_session.dart` | Create — auth session provider |
| `packages/eatery_core/lib/data/repositories/company_repository_sqlite.dart` | Remove password references |
| `packages/eatery_core/lib/data/repositories/staff_repository_sqlite.dart` | Add PIN save/verify |
| `assets/db/schema.sql` | Phase 1 migrations per schema audit |
