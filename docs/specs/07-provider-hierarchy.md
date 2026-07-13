# Specs 07 — Provider Hierarchy

## 1. Provider Tree

```
eateryStoreProvider (global singleton, EateryStore)
  │
  ├── sqlitePreferenceStoreProvider (SqlitePreferenceStore)
  │
  ├── opLogServiceProvider (OpLogService)
  │     └── syncServiceProvider (SyncService)
  │           └── syncStatusProvider (Stream<SyncStatus>)
  │
  ├── companyRepositoryProvider (CompanyRepository)
  │     └── companyProvider (NotifierProvider<Company?>)
  │
  ├── staffRepositoryProvider (StaffRepository)
  │     └── authSessionProvider (NotifierProvider<AuthSessionState>)
  │
  ├── productRepositoryProvider (ProductRepository)
  │     └── productListProvider (AsyncNotifierProvider<List<Product>>)
  │     └── productCategoryListProvider (AsyncNotifierProvider<List<ProductCategory>>)
  │
  ├── orderRepositoryProvider (OrderRepository)
  │     └── orderListProvider (AsyncNotifierProvider<List<Order>>)
  │
  ├── diningTableRepositoryProvider (DiningTableRepository)
  │     └── tableListProvider (AsyncNotifierProvider<List<DiningTable>>)
  │
  ├── customerRepositoryProvider (CustomerRepository)
  ├── paymentRepositoryProvider (PaymentRepository)
  ├── taxRepositoryProvider (TaxRepository)
  ├── printerRepositoryProvider (PrinterRepository)
  ├── subscriptionRepositoryProvider (SubscriptionRepository)
  │
  └── cartProvider (NotifierProvider<PosSession>)
```

## 2. Initialization Order

```
1. EateryStore.open(path)          — Open native SQLite (blocking, ~10ms)
2. initEaterySchema(store, ddl)    — CREATE TABLE IF NOT EXISTS (~50ms)
3. SchemaMigrator(store).migrate() — Run pending migrations
4. OpLogService(store, deviceId)   — Initialize clock from DB
5. SyncService(opLog, deviceId)    — Restore previous role
6. ProviderScope overrides applied (main.dart)
7. GoRouter creates initial route based on auth state
8. Company check → Login or Dashboard
```

## 3. Provider Definitions

```dart
// ── Database ──

final eateryStoreProvider = Provider<EateryStore>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final opLogServiceProvider = Provider<OpLogService>((ref) {
  final store = ref.read(eateryStoreProvider);
  final deviceId = getDeviceId();
  return OpLogService(store: store, deviceId: deviceId);
});

// ── Sync ──

final syncServiceProvider = Provider<SyncService>((ref) {
  final opLog = ref.read(opLogServiceProvider);
  final deviceId = getDeviceId();
  return SyncService(opLogService: opLog, deviceId: deviceId);
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final sync = ref.read(syncServiceProvider);
  // Emit status on every change
  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => sync.status,
  );
});

// ── Repositories ──

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final store = ref.read(eateryStoreProvider);
  return SqliteCompanyRepository(store: store);
});

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  final store = ref.read(eateryStoreProvider);
  final opLog = ref.read(opLogServiceProvider);
  return SqliteStaffRepository(store: store, opLog: opLog);
});

// ── Auth ──

final authSessionProvider = NotifierProvider<AuthSessionNotifier, AuthSessionState>(
  AuthSessionNotifier.new,
);

// ── Data lists ──

final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<Product>>(
  ProductListNotifier.new,
);

// ── Cart ──

final cartProvider = NotifierProvider<CartNotifier, PosSession>(
  CartNotifier.new,
);
```

## 4. Notifier Implementations

```dart
class ProductListNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getAllProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
```

## 5. main.dart (After Extraction)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init database
  final store = EateryStore.open(dbPath);
  final schema = await rootBundle.loadString('assets/db/schema.sql');
  initEaterySchema(store, schema);
  SchemaMigrator(store).migrate();

  runApp(
    ProviderScope(
      overrides: [
        eateryStoreProvider.overrideWithValue(store),
      ],
      child: const EateryAdminApp(),
    ),
  );
}

class EateryAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: createAppRouter(),
    );
  }
}
```
