/// Feature flags for the native SQLite store spike.
///
/// This is the single switch that routes a repository through the native
/// libeaterystore (SQLite) instead of Hive. Flip to `false` to fall back to
/// the original Hive-backed repositories with zero other changes.
library;

/// When true, [productRepositoryProvider] is backed by the native SQLite store
/// (libeaterystore) instead of Hive. Spike scope: Product + ProductCategory.
const bool kUseSqliteProductStore = true;

/// When true, [customerRepositoryProvider] is backed by the native SQLite store
/// instead of Hive. Customer-only queries run on SQLite; cross-entity reads
/// (outstanding amount over Orders/Payments) still use Hive until those
/// entities are migrated.
const bool kUseSqliteCustomerStore = true;

/// When true, [orderRepositoryProvider] is backed by the native SQLite store
/// instead of Hive. Covers Order + OrderProduct (foreign-key related).
const bool kUseSqliteOrderStore = true;

/// When true, [paymentRepositoryProvider] is backed by the native SQLite store
/// instead of Hive.
const bool kUseSqlitePaymentStore = true;

/// When true, [taxRepositoryProvider] is backed by the native SQLite store
/// instead of Hive.
const bool kUseSqliteTaxStore = true;

/// When true, [diningTableRepositoryProvider] is backed by the native SQLite
/// store instead of Hive.
const bool kUseSqliteDiningTableStore = true;

// ── Phase B flags ─────────────────────────────────────────────────────────

const bool kUseSqliteCompanyStore = true;
const bool kUseSqliteStaffStore = true;
const bool kUseSqliteSubscriptionStore = true;
const bool kUseSqliteAutoPrintStore = true;
const bool kUseSqliteKdsStationStore = true;
const bool kUseSqliteComplianceStore = true;
const bool kUseSqliteVoidLogStore = true;

/// All Phase A+B flags aggregated — used in main.dart to open the store
/// when any entity is routed through SQLite.
const bool kUseSqliteStore = kUseSqliteProductStore || kUseSqliteCustomerStore ||
    kUseSqliteOrderStore || kUseSqlitePaymentStore || kUseSqliteTaxStore ||
    kUseSqliteDiningTableStore || kUseSqliteCompanyStore || kUseSqliteStaffStore ||
    kUseSqliteSubscriptionStore || kUseSqliteAutoPrintStore ||
    kUseSqliteKdsStationStore || kUseSqliteComplianceStore || kUseSqliteVoidLogStore;

/// Filename of the SQLite database inside the app data directory.
const String kEateryDbFileName = 'eatery.db';
