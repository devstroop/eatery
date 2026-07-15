# Data Models

All models live in `packages/eatery_core/lib/data/models/` and use `freezed` for immutability with `json_annotation` for serialization.

## File Layout

```
models/
├── eatery_db.dart              # Barrel export for all models
├── cart_item.dart              # Cart line item (in-memory, not persisted)
├── converters.dart             # Epoch timestamp JSON converters
├── company/
│   ├── company.dart            # Restaurant entity / tenant
│   ├── edition.dart            # Taxation enum
│   └── k_currency.dart         # Currency config
├── compliance/
│   ├── compliance_report.dart  # Z/X reports
│   └── void_log_entry.dart     # Voided order audit trail
├── config/
│   └── auto_print.dart         # Auto-print settings
├── customer/
│   └── customer.dart           # Customer profile
├── dining_table/
│   ├── dining_table.dart       # Dining table entity
│   ├── dining_table_category.dart
│   └── dining_table_status.dart
├── discount/
│   ├── discount.dart           # Discount rules
│   └── order_discount.dart     # Per-order discount application
├── drawings/                   # Custom painting widgets (DineIn, Delivery, TakeAway)
├── expense/
│   ├── expense.dart
│   └── expense_category.dart
├── extensions/                 # Box extension methods (Hive legacy)
├── hours/
│   ├── business_hours.dart
│   └── holiday_hours.dart
├── inventory/
│   ├── supplier.dart
│   ├── purchase_order.dart
│   ├── purchase_order_item.dart
│   └── stock_adjustment.dart
├── kds_station.dart            # Kitchen Display Station
├── loyalty/
│   ├── customer_loyalty.dart
│   └── loyalty_transaction.dart
├── modifier/
│   ├── modifier_group.dart
│   ├── modifier.dart
│   ├── product_modifier.dart
│   └── order_product_modifier.dart
├── order/
│   ├── order.dart              # Sales order
│   ├── order_product.dart      # Order line items
│   ├── order_status.dart       # Order lifecycle enum
│   ├── order_status_history.dart # Status transition audit
│   └── order_type.dart         # Dine/Delivery/Takeout
├── payment/
│   ├── payment.dart            # Payment transaction
│   └── payment_mode.dart       # Cash/Card/UPI/Wallet
├── printer/
│   ├── printer.dart            # Printer config
│   └── printer_type.dart
├── product/
│   ├── product.dart            # Menu item (dish or inventory)
│   ├── product_category.dart
│   ├── product_type.dart       # kitchenDish / inventoryItem
│   └── food_type.dart          # veg / nonVeg
├── reservation/
│   └── reservation.dart
├── shift/
│   ├── shift.dart              # Staff shift definition
│   └── time_entry.dart         # Clock in/out records
├── staff/
│   ├── staff.dart              # Staff member
│   └── staff_type.dart         # waiter/chef/driver/other/admin
├── subscription/
│   ├── subscription.dart
│   └── subscription_type.dart
└── tax/
    ├── tax_slab.dart           # Tax rate configuration
    └── tax_type.dart           # inclusive / exclusive
```

## Enum Values

| Enum | Values | Used By |
|------|--------|---------|
| `OrderType` | dine(0), delivery(1), takeout(2) | Order, PosSession |
| `OrderStatus` | pending(0), preparing(1), ready(2), served(3), completed(4), voided(5) | Order, OrderStatusHistory |
| `DiningTableStatus` | available(0), occupied(1), reserved(2), inactive(3) | DiningTable |
| `StaffType` | waiter(0), chef(1), driver(2), other(3), admin(4) | Staff |
| `FoodType` | veg(0), nonVeg(1) | Product |
| `ProductType` | kitchenDish(0), inventoryItem(1) | Product |
| `PaymentMode` | cash(0), card(1), upi(2), wallet(3), other(4) | Payment |
| `TaxType` | inclusive(0), exclusive(1) | TaxSlab |
| `Taxation` | none(-1), gst(0), vat(1) | Company |

## Key Model Fields

### Order (`packages/eatery_core/lib/data/models/order/order.dart`)
- `id`, `customerPhone`, `staffId`, `diningTableId`
- `createdAt`, `updatedAt`
- `totalQuantity`, `subTotal`, `discountTotal`, `taxTotal`, `finalTotal`, `roundOff`, `grandTotal`, `paidTotal`
- `type` (OrderType), `status` (OrderStatus)
- `voidReason`, `voidedBy`, `voidedAt`

### Product (`packages/eatery_core/lib/data/models/product/product.dart`)
- `id`, `name`, `categoryId`, `description`, `image`
- `mrpPrice`, `salePrice`, `taxSlabId`
- `foodType` (FoodType), `type` (ProductType)
- `isActive`, `stationId`, `stationName`

### Staff (`packages/eatery_core/lib/data/models/staff/staff.dart`)
- `id`, `name`, `photo`, `phone`, `pin`
- `type` (StaffType), `isActive`

### Customer (`packages/eatery_core/lib/data/models/customer/customer.dart`)
- `id`, `name`, `phone`, `address`, `landmark`
- `latitude`, `longitude`, `isActive`, `lastOrderAt`

### Payment (`packages/eatery_core/lib/data/models/payment/payment.dart`)
- `id`, `orderId`, `date`, `amount`, `mode` (PaymentMode)
- `reference`, `attachment`
- `processorTransactionId`, `processorName`, `processorStatus`, `cardLastFour`, `terminalId`

### DiningTable (`packages/eatery_core/lib/data/models/dining_table/dining_table.dart`)
- `id`, `name`, `description`, `orderId`, `categoryId`
- `capacity`, `status` (DiningTableStatus), `customerPhone`
- `posX`, `posY`, `shape`, `width`, `height`, `staffId`

### Company (`packages/eatery_core/lib/data/models/company/company.dart`)
- `id`, `logo`, `name`, `email`, `phone`, `address`
- `password` (deprecated — auth uses `Staff.pin`; kept for backward compat)
- `taxation` (Taxation), `currencyCode`, `foodLicenseNo`, `salesTaxNumber`, `subscriptionId`

## Entity Relationships

```
Staff (1) ──── (N) Order                    // staffId on Order
Staff (N) ──── (1) DiningTable              // staffId on DiningTable (assigned waiter)

DiningTable (1) ──── (N) Order              // diningTableId on Order
DiningTable (1) ──── (1) Order              // orderId on DiningTable (current active)

Order (1) ──── (N) OrderProduct             // orderId on OrderProduct
Order (1) ──── (N) OrderStatusHistory       // orderId on OrderStatusHistory
Order (1) ──── (N) Payment                 // orderId on Payment
Order (1) ──── (N) OrderDiscount           // orderId on OrderDiscount

Product (1) ──── (N) OrderProduct          // productId on OrderProduct
Product (N) ──── (1) ProductCategory       // categoryId on Product
Product (N) ──── (1) TaxSlab              // taxSlabId on Product
Product (N) ──── (1) KdsStation           // stationId on Product

Customer (1) ──── (N) Order                // customerPhone on Order
Customer (1) ──── (1) CustomerLoyalty      // customerId on CustomerLoyalty
```
