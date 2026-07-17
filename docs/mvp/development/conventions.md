# Coding Conventions

## File Naming

```
Pages:       add.product.page.dart     (action.entity.page.dart)
Models:      product.dart              (singular)
Repos:       product_repository.dart   (entity_repository.dart)
Providers:   product_provider.dart     (entity_provider.dart)
Widgets:     app_button.dart           (app_widget.dart)
Themes:      app_colors.dart           (app_domain.dart)
```

## Design Tokens (mandatory)

**NEVER use raw values. Always use tokens.**

```dart
// ❌ WRONG
Container(color: Colors.red)
Text('Hi', style: TextStyle(fontSize: 14))
SizedBox(height: 16)
EdgeInsets.all(12)

// ✅ CORRECT
Container(color: AppColors.error)
Text('Hi', style: AppTypography.bodyMedium)
AppSpacing.gapLg                         // SizedBox(height: 16)
EdgeInsets.all(AppSpacing.md)            // 12px
```

**Token locations:**

| Domain | File |
|--------|------|
| Colors | `packages/eatery_core/lib/theme/app_colors.dart` |
| Typography | `packages/eatery_core/lib/theme/app_typography.dart` |
| Spacing | `packages/eatery_core/lib/theme/app_spacing.dart` |
| Components | `packages/eatery_core/lib/theme/app_component.dart` |

## Components (use these, don't recreate)

| Need | Use |
|------|-----|
| Primary button | `AppButton.primary(label: 'Save', onPressed: (){})` |
| Cancel/secondary | `AppButton.secondary(label: 'Cancel', onPressed: (){})` |
| Delete/danger | `AppButton.destructive(label: 'Delete', onPressed: (){})` |
| Text-only | `AppButton.ghost(label: 'Skip', onPressed: (){})` |
| Form field | `AppTextField(label: 'Name', controller: ctrl)` |
| Empty screen | `AppEmptyState(icon: Icons.inbox, title: 'No data')` |
| Loading skeleton | `AppSkeleton.card()` / `AppSkeleton.line()` / `AppSkeletonList(count: 5)` |
| Page wrapper | `AppPageShell(title: 'Products', child: ...)` |
| Navigation shell | `AppAdaptiveShell(destinations: [...])` |
| Notification | `AppNotificationBanner.show(ctx, type: ..., message: ...)` |

## State Management

```dart
// Read once (event handlers)
final repo = ref.read(orderRepositoryProvider);

// Watch reactively (build method)
final orders = ref.watch(ordersProvider);

// Write
ref.read(cartProvider.notifier).addToCart(product);
```

## Async Patterns

```dart
// ❌ WRONG — .then() chains
repo.getOrders().then((orders) { ... });

// ✅ CORRECT — async/await
final orders = await repo.getOrders();

// ❌ WRONG — silent catch
try { ... } catch (e) {}

// ✅ CORRECT — handle or log
try { ... } catch (e) {
  debugPrint('Failed: $e');
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Operation failed: $e')),
    );
  }
}
```

## Page Pattern

```dart
class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);

    return AppPageShell(
      title: 'Products',
      child: products.when(
        data: (list) => ListView(...),
        loading: () => AppSkeletonList(count: 5),
        error: (e, _) => AppEmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load',
          subtitle: e.toString(),
        ),
      ),
    );
  }
}
```

## Imports

```dart
// Shared core (barrel)
import 'package:eatery_core/eatery_core.dart';

// Theme tokens
import 'package:eatery_core/theme/app_colors.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Router
import 'package:go_router/go_router.dart';
```

## Testing

```bash
flutter test                          # all tests
flutter test test/order_calculations_test.dart  # single file
flutter analyze                       # static analysis
```
