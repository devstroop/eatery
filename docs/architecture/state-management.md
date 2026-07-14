# State Management

Eatery uses **Riverpod** (flutter_riverpod) for all application state. The old `Common` static class was replaced during the reconstruction.

## Architecture

```
Repository (data access) --> Provider (Riverpod provider) --> Page (ConsumerStatefulWidget)
```

## Provider Catalog

### Database Providers (`packages/eatery_core/lib/providers/database_provider.dart`)

| Provider | Type | Purpose |
|----------|------|---------|
| `appDatabaseProvider` | `Provider<EateryDatabase>` | Compatibility DB wrapper (overridden in main.dart) |
| `eateryStoreProvider` | `Provider<EateryStore>` | Native SQLite store (overridden in main.dart) |

### Product Providers (`packages/eatery_core/lib/providers/product_provider.dart`)

| Provider | Type | Purpose |
|----------|------|---------|
| `productRepositoryProvider` | `Provider<ProductRepository>` | Product repository singleton |
| `productListProvider` | `AsyncNotifierProvider<List<Product>>` | Reactive product list |

### Company Provider (`packages/eatery_core/lib/providers/company_provider.dart`)

| Provider | Type | Purpose |
|----------|------|---------|
| `companyRepositoryProvider` | `Provider<CompanyRepository>` | Company repository singleton |
| `companyProvider` | `NotifierProvider<CompanyNotifier, Company?>` | Current company + currency resolver |

### Cart / POS Provider (`packages/eatery_core/lib/providers/cart_provider.dart`)

| Provider | Type | Purpose |
|----------|------|---------|
| `cartProvider` | `NotifierProvider<CartNotifier, PosSession>` | Active POS session state |

`PosSession` holds:
- `activeOrderType` (OrderType?)
- `activeDiningTable` (DiningTable?)
- `activeCustomer` (Customer?)
- `activeOrder` (Order?)
- `cart` (Map<int, CartItem>)

`CartNotifier` methods: `setOrderType`, `setDiningTable`, `setCustomer`, `setActiveOrder`, `addToCart`, `removeFromCart`, `clearCart`, `cartQuantity`, `hasCart`.

### Order / Feature Providers (`packages/eatery_core/lib/providers/order_provider.dart`)

| Provider | Type |
|----------|------|
| `orderRepositoryProvider` | `Provider<OrderRepository>` |
| `customerRepositoryProvider` | `Provider<CustomerRepository>` |
| `paymentRepositoryProvider` | `Provider<PaymentRepository>` |
| `taxRepositoryProvider` | `Provider<TaxRepository>` |
| `diningTableRepositoryProvider` | `Provider<DiningTableRepository>` |

### Printer Provider (`packages/eatery_core/lib/providers/printer_provider.dart`)

| Provider | Type | Purpose |
|----------|------|---------|
| `printerRepositoryProvider` | `Provider<PrinterRepository>` | Printer repository singleton |
| `printerListProvider` | `AsyncNotifierProvider<List<Printer>>` | Reactive printer list |

### Auth Provider (`packages/eatery_core/lib/providers/auth_session.dart`)

| Provider | Type | Purpose |
|----------|------|---------|
| `authSessionProvider` | `StateProvider<Staff?>` | Current authenticated staff (null = unauthenticated) |

### Sync Providers (`packages/eatery_core/lib/data/sync/sync_providers.dart`)

| Provider | Type | Purpose |
|----------|------|---------|
| `syncCoordinatorProvider` | `StateProvider<SyncCoordinator?>` | Active sync coordinator |
| `syncStatusProvider` | `StateProvider<SyncStatus?>` | Current sync connection status |
| `syncInitProvider` | `Provider.family<void, SyncConfig>` | Initializes sync on startup |

## Page Pattern

All pages use `ConsumerStatefulWidget`:

```dart
class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.read(productRepositoryProvider);      // one-shot
    final cart = ref.watch(cartProvider);                   // reactive

    return AppPageShell(
      title: 'My Page',
      child: ...,
    );
  }
}
```

## ref.read vs ref.watch

| Method | When |
|--------|------|
| `ref.read(provider)` | One-shot read — repo method calls, action handlers |
| `ref.watch(provider)` | Reactive — widget rebuilds when state changes |
| `ref.invalidate(provider)` | Forces re-creation (e.g., refresh) |

## Migration from Common

The old `Common` static class had these fields migrated to Riverpod:

| Common Field | New Location |
|-------------|-------------|
| `Common.company` | `companyProvider` |
| `Common.currency` | `companyProvider.notifier.currency` |
| `Common.cart` | `cartProvider.notifier.state.cart` |
| `Common.activeOrder` | `cartProvider.notifier.state.activeOrder` |
| `Common.activeOrderType` | `cartProvider.notifier.state.activeOrderType` |
| `Common.activeDiningTable` | `cartProvider.notifier.state.activeDiningTable` |
| `Common.activeCustomer` | `cartProvider.notifier.state.activeCustomer` |
| `Common.baseDirectory` | AppFileSystem.baseDir |
| `Common.dataDirectory` | AppFileSystem.dataDir |
| `Common.imagesDirectory` | AppFileSystem.imagesDir |
| `Common.backupDirectory` | AppFileSystem.backupDir |
| `Common.tempDirectory` | AppFileSystem.tempDir |
| `Common.cacheDirectory` | AppFileSystem.cacheDir |
