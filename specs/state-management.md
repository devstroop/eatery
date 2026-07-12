# State Management

> Eatery uses **Riverpod** for all application state. The state management was migrated from `Common` static globals + `setState` during the reconstruction.

---

## Architecture

```
Repository (data access) ──→ Provider (Riverpod) ──→ Page (ConsumerStatefulWidget)
                              (Repository exposed as     (reads via ref.read/ref.watch)
                               Provider, state as
                               NotifierProvider)
```

---

## Provider Catalog

### Database Provider

[View source](../../lib/presentation/providers/database_provider.dart)

```dart
final appDatabaseProvider = Provider<EateryDatabase>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
```

- Overridden in `main.dart` via `ProviderScope(overrides: [appDatabaseProvider.overrideWithValue(appDatabase)])`
- All other providers depend on this one
- Initialized before `runApp()` — guaranteed ready

### Product Provider

[View source](../../lib/presentation/providers/product_provider.dart)

```dart
final productRepositoryProvider = Provider<ProductRepository>(...);
final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<Product>>(...);
```

### Company Provider

[View source](../../lib/presentation/providers/company_provider.dart)

```dart
final companyRepositoryProvider = Provider<CompanyRepository>(...);
final companyProvider = NotifierProvider<CompanyNotifier, Company?>(...);
```

`CompanyNotifier` provides:
- `currency` — resolves `KCurrency` from company's `currencyCode`
- `setCompany(Company?)` — used on login

### Cart / POS Provider

[View source](../../lib/presentation/providers/cart_provider.dart)

```dart
final cartProvider = NotifierProvider<CartNotifier, PosSession>(CartNotifier.new);
```

`PosSession` holds all active POS state:
```dart
class PosSession {
  final OrderType? activeOrderType;
  final DiningTable? activeDiningTable;
  final Customer? activeCustomer;
  final Order? activeOrder;
  final List<Product> cart;
}
```

`CartNotifier` methods:
- `setOrderType()`, `setDiningTable()`, `setCustomer()`, `setActiveOrder()`
- `addToCart(product)`, `removeFromCart(product)`, `clearCart()`
- `cartQuantity(product)` — count of specific product in cart

### Order / Feature Providers

[View source](../../lib/presentation/providers/order_provider.dart)

```dart
final orderRepositoryProvider = Provider<OrderRepository>(...);
final customerRepositoryProvider = Provider<CustomerRepository>(...);
final paymentRepositoryProvider = Provider<PaymentRepository>(...);
final taxRepositoryProvider = Provider<TaxRepository>(...);
final diningTableRepositoryProvider = Provider<DiningTableRepository>(...);
```

### Printer Provider

[View source](../../lib/presentation/providers/printer_provider.dart)

```dart
final printerRepositoryProvider = Provider<PrinterRepository>(...);
final printerListProvider = AsyncNotifierProvider<PrinterListNotifier, List<Printer>>(...);
```

---

## Pattern for Pages

All pages follow this pattern:
```dart
class MyPage extends ConsumerStatefulWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    // Read repositories in build()
    final repo = ref.read(productRepositoryProvider);
    // Watch providers that can change
    final cart = ref.watch(cartProvider);

    return AppPageShell(
      title: 'My Page',
      child: ...,
    );
  }
}
```

### When to use `ref.read` vs `ref.watch`

| Method | When |
|--------|------|
| `ref.read(provider)` | One-shot read — repo methods, actions |
| `ref.watch(provider)` | Reactive — the widget rebuilds when state changes |
| `ref.invalidate(provider)` | Forces a provider to re-create (for refresh) |

---

## Migration from Common

The old `Common` class had 12 static fields:

| Field | New Home |
|-------|----------|
| `Common.company` | `companyProvider` |
| `Common.currency` | `companyProvider.notifier.currency` |
| `Common.cart` | `cartProvider.cart` |
| `Common.activeOrder` | `cartProvider.activeOrder` |
| `Common.activeOrderType` | `cartProvider.activeOrderType` |
| `Common.activeDiningTable` | `cartProvider.activeDiningTable` |
| `Common.activeCustomer` | `cartProvider.activeCustomer` |
| `Common.baseDirectory` | `AppFileSystem.baseDir` |
| `Common.dataDirectory` | `AppFileSystem.dataDir` |
| `Common.imagesDirectory` | `AppFileSystem.imagesDir` |
| `Common.backupDirectory` | `AppFileSystem.backupDir` |
| `Common.tempDirectory` | `AppFileSystem.tempDir` |
| `Common.cacheDirectory` | `AppFileSystem.cacheDir` |

---

## Related Specs

- [Architecture Overview](architecture.md)
- [Data Layer](data-layer.md)
