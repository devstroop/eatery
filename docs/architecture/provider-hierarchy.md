# Provider Hierarchy

## Provider Tree

```
eateryStoreProvider (Provider<EateryStore>, overridden in main.dart)
  |
  +-- appDatabaseProvider (Provider<EateryDatabase>, overridden in main.dart)
  |
  +-- opLogServiceProvider (Provider<OpLogService>)
  |     +-- syncCoordinatorProvider (StateProvider<SyncCoordinator?>)
  |           +-- syncStatusProvider (StateProvider<SyncStatus?>)
  |
  +-- companyRepositoryProvider (Provider<CompanyRepository>)
  |     +-- companyProvider (NotifierProvider<CompanyNotifier, Company?>)
  |
  +-- staffRepositoryProvider (Provider<StaffRepository>)
  |     +-- authSessionProvider (StateProvider<Staff?>)
  |
  +-- productRepositoryProvider (Provider<ProductRepository>)
  |     +-- productListProvider (AsyncNotifierProvider<List<Product>>)
  |     +-- productCategoryListProvider (AsyncNotifierProvider<List<ProductCategory>>)
  |
  +-- orderRepositoryProvider (Provider<OrderRepository>)
  |     +-- orderListProvider (AsyncNotifierProvider<List<Order>>)
  |
  +-- diningTableRepositoryProvider (Provider<DiningTableRepository>)
  |     +-- tableListProvider (AsyncNotifierProvider<List<DiningTable>>)
  |
  +-- customerRepositoryProvider (Provider<CustomerRepository>)
  +-- paymentRepositoryProvider (Provider<PaymentRepository>)
  +-- taxRepositoryProvider (Provider<TaxRepository>)
  +-- printerRepositoryProvider (Provider<PrinterRepository>)
  +-- subscriptionRepositoryProvider (Provider<SubscriptionRepository>)
  |
  +-- cartProvider (NotifierProvider<CartNotifier, PosSession>)
```

## Initialization Order

```
1. WidgetsFlutterBinding.ensureInitialized()
2. AppFileSystem.init(basePath)              — create 7 directories
3. EateryStore.open(dbPath)                  — open native SQLite
4. initEaterySchema(store, schemaSQL)        — CREATE TABLE IF NOT EXISTS
5. SchemaMigrator(store).migrate()           — run pending versioned migrations
6. EateryDatabase(dataDir, store)            — compatibility wrapper
7. ProviderScope(overrides: [                 — DI overrides
     eateryStoreProvider.overrideWithValue(store),
     appDatabaseProvider.overrideWithValue(db),
   ])
8. MyApp -> MaterialApp.router               — GoRouter with auth redirect
9. GoRouter initial route based on:
     hasCompany? -> hasPassword? -> /login : /dashboard
     !hasCompany -> / (onboarding)
```

## Provider Definitions

`packages/eatery_core/lib/providers/database_provider.dart`:

```dart
final appDatabaseProvider = Provider<EateryDatabase>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final eateryStoreProvider = Provider<EateryStore>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
```

### Repository Providers

Each repository provider reads `eateryStoreProvider` and returns a `Sqlite*` implementation:

```dart
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return SqliteProductRepository(store: ref.read(eateryStoreProvider));
});
```

### Notifier Providers

Feature providers use `NotifierProvider` (synchronous) or `AsyncNotifierProvider` (async build):

```dart
// Product list — loads from repository on first read
final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<Product>>(...);

class ProductListNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return ref.read(productRepositoryProvider).getAllProducts();
  }
  Future<void> refresh() async { ... }
}
```

### Cart Provider

```dart
final cartProvider = NotifierProvider<CartNotifier, PosSession>(CartNotifier.new);

class CartNotifier extends Notifier<PosSession> {
  @override
  PosSession build() => const PosSession();
  void addToCart(Product p) { ... }
  void removeFromCart(Product p) { ... }
  void clearCart() { ... }
  // etc.
}
```

## DI Overrides in main.dart

The native store and database wrapper are created synchronously before `runApp()` and injected via `ProviderScope(overrides: [...])`:

```dart
ProviderScope(
  overrides: [
    if (appStore != null)
      eateryStoreProvider.overrideWithValue(appStore!),
    if (appDatabase != null)
      appDatabaseProvider.overrideWithValue(appDatabase!),
  ],
  child: const MyApp(),
)
```
