# Specs 02 — Data Models

## 1. Model Inventory

| Model | File | Status | Changes Needed |
|-------|------|--------|----------------|
| `Order` | `order.dart` | Existing | Add `staffId`, `diningTableId`, change `status` to enum, add `statusHistory` |
| `OrderProduct` | `order_product.dart` | Existing | No changes |
| `OrderStatus` | (new) | New | Enum with lifecycle |
| `OrderStatusTransition` | (new) | New | Audit trail model |
| `Product` | `product.dart` | Existing | Add `stockQuantity`, `lowStockThreshold` |
| `ProductCategory` | `product_category.dart` | Existing | No changes |
| `DiningTable` | `dining_table.dart` | Existing | Add `staffId`, `posX`, `posY` |
| `DiningTableStatus` | `dining_table_status.dart` | Existing | No changes (already covers available/occupied/reserved/inactive) |
| `Staff` | `staff.dart` | Existing | Add `pin`, `currentDiningTableId` |
| `StaffType` | `staff_type.dart` | Existing | Add `admin` |
| `Customer` | `customer.dart` | Existing | No changes |
| `Payment` | `payment.dart` | Existing | No changes |
| `PaymentMode` | `payment_mode.dart` | Existing | No changes |
| `TaxSlab` | `tax_slab.dart` | Existing | No changes |
| `Company` | `company.dart` | Existing | Remove `password` (migrate to Staff PINs) |
| `Subscription` | `subscription.dart` | Existing | No changes |
| `KdsStation` | `kds_station.dart` | Existing | No changes |
| `Printer` | `printer.dart` | Existing | No changes |

## 2. Order (Extended)

```dart
class Order {
  int? id;
  String? customerPhone;
  int? staffId;                        // NEW: who placed/owns the order
  int? diningTableId;                  // NEW: direct FK (moved from DiningTable.orderId)
  DateTime createdAt;
  DateTime? updatedAt;
  int totalQuantity;
  double subTotal, discountTotal, taxTotal, finalTotal, roundOff, grandTotal;
  double? paidTotal;
  OrderType type;                      // dine, delivery, takeout
  OrderStatus status;                  // CHANGED: String → enum
  String? voidReason, voidedBy;
  DateTime? voidedAt;

  // Computed
  bool get isPaid => (paidTotal ?? 0) >= grandTotal;
  double get outstandingAmount => grandTotal - (paidTotal ?? 0);
}
```

### toMap / fromMap changes

```dart
// New fields in toMap:
'staffId': staffId,
'diningTableId': diningTableId,
'status': status.index,                  // was: status (String)

// New fields in fromMap:
staffId = map['staffId'],
diningTableId = map['diningTableId'],
status = OrderStatus.values[map['status']],  // was: map['status'] ?? 'active'
```

## 3. OrderStatus (New Enum)

```dart
enum OrderStatus {
  pending,     // 0 — Order placed, awaiting kitchen
  preparing,   // 1 — Kitchen acknowledged, cooking
  ready,       // 2 — Food ready to serve
  served,      // 3 — Waiter served the food
  completed,   // 4 — Bill paid, order closed
  voided,      // 5 — Order cancelled
}

/// Valid state transitions:
///   pending → preparing → ready → served → completed
///   pending → voided
///   preparing → voided
```

## 4. OrderStatusTransition (New Model)

```dart
class OrderStatusTransition {
  int? id;
  int orderId;
  OrderStatus fromStatus;
  OrderStatus toStatus;
  int changedByStaffId;       // who triggered the transition
  DateTime changedAt;

  Map<String, Object?> toMap() => {
    'id': id,
    'order_id': orderId,
    'from_status': fromStatus.index,
    'to_status': toStatus.index,
    'changed_by_staff_id': changedByStaffId,
    'changed_at': changedAt.millisecondsSinceEpoch,
  };

  OrderStatusTransition.fromMap(Map<String, dynamic> map) :
    id = map['id'],
    orderId = map['order_id'],
    fromStatus = OrderStatus.values[map['from_status']],
    toStatus = OrderStatus.values[map['to_status']],
    changedByStaffId = map['changed_by_staff_id'],
    changedAt = DateTime.fromMillisecondsSinceEpoch(map['changed_at']);
}
```

## 5. Staff (Extended)

```dart
class Staff {
  int? id;
  String name;
  String? photo;
  String? phone;
  String? pin;                         // NEW: per-staff PIN (hashed)
  StaffType type;                      // waiter, chef, driver, other, admin
  bool isActive;
  int? currentDiningTableId;           // NEW: current table assignment

  // toMap adds: 'pin': pin, 'currentDiningTableId': currentDiningTableId
}
```

## 6. StaffType (Extended)

```dart
enum StaffType { waiter, chef, driver, other, admin }
```

## 7. DiningTable (Extended)

```dart
class DiningTable {
  int? id;
  String name;
  DiningTableCategory? category;
  String? description;
  int? orderId;
  int? capacity;
  DiningTableStatus status;
  String? customerPhone;
  int? staffId;                        // NEW: assigned waiter
  int? posX;                           // NEW: floor plan X coordinate
  int? posY;                           // NEW: floor plan Y coordinate

  // toMap adds: 'staffId': staffId, 'posX': posX, 'posY': posY
}
```

## 8. Product (Extended)

```dart
class Product {
  // ... existing fields unchanged ...
  int? stationId;
  String? stationName;
  double? stockQuantity;               // NEW: available stock
  double? lowStockThreshold;           // NEW: alert threshold

  // Computed
  bool get isLowStock =>
      stockQuantity != null &&
      lowStockThreshold != null &&
      stockQuantity! <= lowStockThreshold!;
}
```

## 9. Company (Modified)

```dart
class Company {
  // ... existing fields ...
  // REMOVED: String? password;
  // Password field is deprecated — authentication now uses Staff.pin
}
```

## 10. Enum Summary

| Enum | Values | Used By |
|------|--------|---------|
| `OrderType` | dine, delivery, takeout | Order, PosSession |
| `OrderStatus` | pending, preparing, ready, served, completed, voided | Order, OrderStatusTransition |
| `DiningTableStatus` | available, occupied, reserved, inactive | DiningTable |
| `StaffType` | waiter, chef, driver, other, admin | Staff |
| `FoodType` | veg, nonVeg | Product |
| `ProductType` | kitchenDish, inventoryItem | Product |
| `PaymentMode` | cash, card, upi, wallet, other | Payment |
| `TaxType` | inclusive, exclusive | TaxSlab |
| `Taxation` | none, gst, vat | Company |

## 11. Entity Relationships

```
Staff (1) ──── (N) Order          // staffId on Order
Staff (1) ──── (N) OrderStatusTransition  // changedByStaffId
Staff (N) ──── (1) DiningTable    // staffId on DiningTable (assigned waiter)

DiningTable (1) ──── (N) Order    // diningTableId on Order
  OR
DiningTable (1) ──── (1) Order    // orderId on DiningTable (current)

Order (1) ──── (N) OrderProduct   // orderId on OrderProduct
Order (1) ──── (N) OrderStatusTransition  // orderId on Transition
Order (1) ──── (N) Payment        // orderId on Payment

Product (1) ──── (N) OrderProduct // productId on OrderProduct
Product (N) ──── (1) ProductCategory  // categoryId on Product
Product (N) ──── (1) KdsStation  // stationId on Product
Product (N) ──── (1) TaxSlab      // taxSlabId on Product
```

## 12. Migration: Company Password → Staff PIN

Current state:
- `Company.password` holds a single PIN for the entire restaurant
- `Staff` model exists but has no `pin` field
- Login compares against `Company.password`

Migration (Phase 1):
1. Add `pin` column to `staff` table (nullable)
2. Add `admin` value to `StaffType` enum
3. On first launch after migration: create an admin `Staff` entry from the existing company, copy `Company.password` → `Staff.pin`, set `Staff.type = admin`
4. Drop `Company.password` column in a later schema version
5. Login page queries `Staff` by phone/name, verifies `Staff.pin`
