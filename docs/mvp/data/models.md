# Data Models

All models in `packages/eatery_core/lib/data/models/`. **Freezed** for immutability + `json_annotation` for serialization.

## Core Entities

```
Company ──┬── Employee (staff)
          ├── Product ──┬── ProductCategory
          │             ├── ModifierGroup → Modifier
          │             └── InventoryItem
          ├── Customer ──── Order ──── OrderProduct
          │                    │
          │                    ├── Payment
          │                    ├── OrderStatusHistory
          │                    ├── OrderDiscount → Discount
          │                    └── OrderProductModifier
          ├── DiningTable ──── DiningTableCategory
          ├── Reservation
          ├── KdsStation
          ├── Tax
          ├── Printer
          ├── Supplier ──── PurchaseOrder → PurchaseOrderItem
          ├── Expense ──── ExpenseCategory
          └── ComplianceReport / VoidLogEntry
```

## Key Enums

> **Note:** `EmployeeRole` is a *job role* within a company (used for Staff authentication and display). It is distinct from *device roles* (`admin`/`waiter`/`kds`/`display`), which determine the UI shell and are set at first launch via `RolePickerPage`.

| Enum | Values |
|------|--------|
| `EmployeeRole` | `waiter`, `chef`, `driver`, `other`, `admin`, `manager` |
| `OrderStatus` | `pending`, `preparing`, `ready`, `served`, `completed`, `voided` |
| `OrderType` | `dine`, `delivery`, `takeout` |
| `DiningTableStatus` | `available`, `occupied`, `reserved`, `inactive` |
| `PaymentMode` | `cash`, `card`, `upi`, `wallet` |
| `FoodType` | `veg`, `nonVeg` |
| `ProductType` | `kitchenDish`, `inventoryItem` |

## Model Pattern

```dart
@freezed
class Product with _$Product {
  const factory Product({
    int? id,
    required String name,
    required double mrpPrice,
    @Default(0) int categoryId,
    // ...
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
```

Always use:
- `copyWith()` for mutations
- `.fromJson()` / `.toJson()` for serialization
- Named constructors for defaults

## Extensions

Model enums have extensions for display logic:

```dart
extension DiningTableStatusExtension on DiningTableStatus {
  Color get color {                   // maps to AppColors token
    switch (this) {
      case DiningTableStatus.available: return AppColors.success;
      // ...
    }
  }
  String get shortName { ... }
}
```

## Cart (In-Memory)

`CartItem` is not persisted — lives in `PosSession.cart` (Riverpod `cartProvider`). Each `CartItem` tracks product, quantity, unit price, and line total.

## Rebuild After Model Changes

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
