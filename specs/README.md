# Eatery — Restaurant POS System

> **Stack:** Flutter 3.41.5 · Dart ≥3.8.0 · Hive · Riverpod  
> **Platforms:** Android, iOS, macOS, Windows, Linux (full platform with platform-dependent capabilities)  
> **Architecture:** Pragmatic "lite" Clean Architecture (repos + providers + use-cases for business logic only)  
> **State:** Riverpod (NotifierProvider/AsyncNotifierProvider)  
> **DB:** Hive (offline-first, no server)

---

## Project Stats

| Metric | Count |
|--------|-------|
| Dart files (excl. generated) | 216 |
| Hive model files | 30 |
| Page files | 73 |
| Widget/component files | 45 |
| Repository files | 8 |
| Riverpod provider files | 6 |

---

## Directory Map

```
lib/
├── main.dart                          # Entry point — DB init, ProviderScope, runApp
├── references.dart                    # Barrel re-export (legacy, being phased out)
│
├── core/                              # Cross-cutting concerns
│   ├── constants/                     # App-level constants (future home for static config)
│   ├── extensions/                    # double.toPrecision(), String.isNumericOnly
│   ├── routing/                       # Route constants (future GoRouter)
│   ├── theme/                         # Design token system
│   │   ├── app_theme.dart             # ThemeData builder
│   │   ├── app_colors.dart            # All color values
│   │   ├── app_typography.dart        # All text styles
│   │   ├── app_spacing.dart           # Spacing scale + SizedBox shortcuts
│   │   └── app_shadows.dart           # Shadow presets
│   ├── utils/                         # Utilities
│   │   ├── responsive.dart            # Breakpoints, grid cols, spacing
│   │   └── device_id.dart             # Cross-platform device ID
│   └── widgets/                       # 🆕 Responsive component library
│       ├── app_adaptive_shell.dart    # Adaptive nav (mobile→tablet→desktop)
│       ├── app_button.dart            # Button variants (primary/secondary/destructive/ghost)
│       ├── app_card.dart              # Consistent card widget
│       ├── app_dialog.dart            # Adaptive dialog/bottom-sheet
│       ├── app_empty_state.dart       # Empty state placeholder
│       ├── app_page_shell.dart        # Standard page wrapper
│       ├── app_search_field.dart      # Search with desktop shortcut hints
│       ├── app_skeleton.dart          # Shimmer loading placeholders
│       ├── app_table_view.dart        # DataTable (desktop) / CardList (mobile)
│       ├── app_text_field.dart        # Form field with validation
│       └── widgets.dart               # Barrel export
│
├── data/                              # Data layer
│   ├── database/
│   │   ├── eatery_database.dart       # Injectable EateryDatabase (24 Hive boxes)
│   │   └── eatery_db_shim.dart        # Legacy EateryDB singleton → delegates to EateryDatabase
│   ├── models/                        # Hive models (single source of truth)
│   │   ├── eatery_db.dart             # Barrel + TypeIndex
│   │   ├── company/                   # Company, KCurrency, Edition
│   │   ├── config/                    # AutoPrint
│   │   ├── customer/                  # Customer
│   │   ├── dining_table/              # DiningTable, DiningTableCategory, DiningTableStatus
│   │   ├── extensions/               # Hive box extensions
│   │   ├── order/                     # Order, OrderProduct, OrderType
│   │   ├── payment/                   # Payment, PaymentMode
│   │   ├── printer/                   # Printer, PrinterType
│   │   ├── product/                   # Product, ProductCategory, FoodType, ProductType
│   │   ├── staff/                     # Staff, StaffType
│   │   ├── subscription/             # Subscription, SubscriptionType
│   │   └── tax/                       # TaxSlab, TaxType
│   └── repositories/                 # Business data access layer
│       ├── company_repository.dart
│       ├── customer_repository.dart
│       ├── dining_table_repository.dart
│       ├── order_repository.dart
│       ├── payment_repository.dart
│       ├── printer_repository.dart
│       ├── product_repository.dart
│       └── tax_repository.dart
│
├── domain/
│   └── usecases/                      # Business logic (order/tax calculations — WIP)
│
├── presentation/
│   ├── providers/                     # Riverpod providers
│   │   ├── database_provider.dart     # appDatabaseProvider (overridable)
│   │   ├── product_provider.dart      # productRepositoryProvider + productListProvider
│   │   ├── company_provider.dart      # companyProvider + companyRepositoryProvider
│   │   ├── order_provider.dart        # All feature repos (order/customer/payment/tax/diningTable)
│   │   ├── cart_provider.dart         # PosSession + CartNotifier
│   │   └── printer_provider.dart      # PrinterListNotifier
│   ├── pages/                         # All screen widgets (73 files)
│   └── widgets/                       # (future home for migrated widgets)
│
├── constants/                         # Legacy constants (being absorbed into core/)
├── components/                        # Legacy components (being absorbed into core/widgets/)
├── widgets/                           # Legacy widgets (being absorbed into core/widgets/)
├── services/                          # Printing, Google Drive, image library
├── support/                           # Bluetooth thermal printer library
├── functions/                         # Order calculations (→ domain/usecases)
├── extensions/                        # Cart/customer extensions (→ repos)
└── dev/                               # Developer tooling
    ├── seed_data.dart                 # Inline sample data fixtures
    ├── seed_loader.dart               # Populates DB with sample data
    └── database_inspector.dart        # Debug view for DB contents
```

---

## Key Architectural Decisions

1. **Hive models as single source of truth** — No separate domain entities or mappers. Models are annotated with `@HiveType` AND have `fromMap()/toMap()` for serialization parity.

2. **Strangler-fig migration** — Old `EateryDB.instance` singleton delegates to new injectable `EateryDatabase` via the shim. Pages migrate one-by-one; the shim is deleted when all consumers are gone.

3. **Repository pattern** — Each aggregate has a repository that wraps Hive box operations. Repositories are injected via Riverpod providers, making them testable.

4. **Riverpod over Provider** — Compile-safe, better testability via `ProviderScope` overrides.

5. **Responsive components** — New components in `core/widgets/` are built responsive-first (see [responsive design spec](responsive-design.md)).

---

## Feature Issues (all resolved)

| # | Feature | Status |
|---|---------|--------|
| #79 | Products CRUD | ✅ 10 pages migrated |
| #80 | Orders + POS/Cart | ✅ 10 pages migrated |
| #81 | Customers | ✅ 4 pages migrated |
| #82 | Payments | ✅ 4 pages migrated |
| #83 | Dining Tables | ✅ 7 pages migrated |
| #84 | Staff + Settings | ✅ 13 pages migrated |
| #85 | Backup/Restore | ✅ Rewritten (#90) |
| #86 | Package merge + cleanup | ✅ eatery_db/eatery_components deleted |
| #87 | Tests + dev tooling | ✅ 7 tests, seed data, DB inspector |
| #89 | OAuth credentials | ⏳ Needs GCP Console action |
| #90 | Restore no-op | ✅ Rewritten |
| #91 | Printer settings | ✅ Rewritten from dead code |
| #92 | Null-safety risk | ✅ Mitigated |
| #93 | AppFileSystem consolidation | ✅ Done |

---

## Quick Links

| Document | Description |
|----------|-------------|
| [Architecture Overview](architecture.md) | Layers, patterns, data flow |
| [Data Layer](data-layer.md) | Hive models, EateryDatabase, repositories |
| [Component Library](components.md) | All widgets — legacy and new |
| [Page Directory](pages.md) | Every screen, its state, and its data dependencies |
| [Navigation & Responsive Design](responsive-design.md) | Breakpoints, adaptive layouts, navigation patterns |
| [State Management](state-management.md) | Riverpod providers, notifiers, patterns |
| [Design Tokens](design-tokens.md) | Colors, typography, spacing, shadows |
| [Dev Tooling & Tests](dev-tooling.md) | Seed data, DB inspector, test suite |
| [Reconstruction History](reconstruction.md) | Full migration log from old architecture |
