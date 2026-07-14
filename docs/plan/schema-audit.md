# Database Schema Audit -- Professional Restaurant Management System

> **Current:** 19 tables, 258 lines
> **Target:** Full-spectrum restaurant management (POS + inventory + HR + reporting)
> **Approach:** Identify every gap between current schema and a production-grade system, then propose additions.

---

## 1. Schema Design Issues (Existing Tables)

### 1.1 Orders -- Missing Relationships

```sql
-- CURRENT: limited columns, unsafe types
CREATE TABLE orders (
  ...
  customerPhone TEXT,         -- FRAGILE: TEXT FK instead of integer
  status        TEXT,          -- WRONG TYPE: should be INTEGER (enum)
  ...
);
```

| Issue | Current | Fix |
|-------|---------|-----|
| No `staffId` | Can't track who took the order | ADD `staffId INTEGER REFERENCES staff(id)` |
| No `diningTableId` | Can't link order to table cleanly | ADD `diningTableId INTEGER REFERENCES dining_table(id)` |
| `status` is TEXT | Any string accepted, no validation | CHANGE to `INTEGER` with `OrderStatus` enum |
| `customerPhone` as FK | Fragile; customer can change phone | CHANGE to `customerId INTEGER REFERENCES customer(id)` + keep phone as denormalized display |

### 1.2 OrderProduct -- Missing Item-Level Lifecycle

```sql
-- Missing: modifiers, notes, item-level cancellation
CREATE TABLE order_product (
  ...
  -- NO note field
  -- NO item-level status
);
```

| Missing | Why |
|---------|-----|
| `note TEXT` | Special instructions ("no onions", "extra spicy") |
| `status INTEGER` | Item-level status: pending/preparing/ready/served/cancelled |
| `modifiersJson TEXT` | Snapshot of applied modifiers at time of order |

### 1.3 Payment -- No Split Payments

```sql
-- Single payment mode per row
CREATE TABLE payment (
  mode INTEGER NOT NULL,  -- single mode
  ...
);
```

**Problem:** A $100 bill can't be split $60 cash + $40 card without creating two rows (which actually works, but the UI doesn't support it and `paidTotal` tracking is manual).

**Fix:** Keep the table as-is (multiple rows per order = split payments), but add `orderId` index and ensure the UI supports adding multiple payments. Add `payment.orderStatusOnCreate` to track whether the payment completed the order.

### 1.4 Staff -- No PIN or Auth Fields

```sql
CREATE TABLE staff (
  ...
  phone TEXT,     -- nullable, no email
  type  INTEGER NOT NULL  -- no admin type
);
```

| Missing | Why |
|---------|-----|
| `pin TEXT` | Per-staff authentication (hashed) |
| `email TEXT` | Forgot PIN recovery, notifications |
| `pinUpdatedAt INTEGER` | Track when PIN was last changed |
| `lastLoginAt INTEGER` | Audit trail |
| StaffType.admin | Admin role missing from enum |

### 1.5 Company -- Needs Modernization

```sql
CREATE TABLE company (
  ...
  password      TEXT,        -- DEPRECATED: use Staff.pin
  edition       INTEGER NOT NULL,  -- confusing name (means taxation)
  subscriptionId INTEGER     -- premature
);
```

| Issue | Fix |
|-------|-----|
| `password` | Remove -- auth via `Staff.pin` |
| `edition` column | Rename to `taxation` to match model |
| `subscriptionId` | Remove from setup -- defer |
| Missing `timezone` | ADD `timezone TEXT` for correct date reporting |
| Missing `businessType` | ADD `businessType TEXT` (restaurant/cafe/bar/food-truck) |

### 1.6 DiningTable -- Missing Floor Plan Data

```sql
CREATE TABLE dining_table (
  ...
  -- NO posX, posY coordinates
  -- NO staffId (assigned waiter)
  -- NO shape or dimensions
);
```

| Missing | Why |
|---------|-----|
| `posX REAL, posY REAL` | Floor plan positioning |
| `shape INTEGER` | Enum: rectangle/circle/bar-seat |
| `width REAL, height REAL` | Visual dimensions on floor plan |
| `staffId INTEGER` | Assigned waiter for the shift |

### 1.7 Product -- Missing Stock, Variants, Modifiers

```sql
CREATE TABLE product (
  ...
  -- NO stock tracking
  -- NO modifier support
  -- NO barcode/SKU
  -- NO preparation time
);
```

| Missing | Why |
|---------|-----|
| `sku TEXT` | Stock keeping unit for inventory |
| `barcode TEXT` | Barcode for scanning |
| `stockQuantity REAL` | Current stock level (for inventoryItem type); computed from stock_adjustments or stored directly -- see Stock Model below |
| `lowStockThreshold REAL` | Alert when stock drops below this level |
| `prepTime INTEGER` | Estimated preparation time in seconds |
| `sortOrder INTEGER` | Display ordering within category |
| `isPopular INTEGER` | Highlight on POS/waiter app |
| `calories INTEGER` | Nutritional info (future) |

**Stock model note:** Two approaches exist:
- **Stored model** -- `product.stockQuantity` is updated directly by stock_adjustment triggers. Read is O(1). Risk: drift between adjustments and stored value.
- **Computed model** -- No `product.stockQuantity`. Current stock = `SUM(adjustments) FROM stock_adjustment WHERE productId = ?`. Always accurate. Read is O(n) over adjustments.

**Recommendation: Stored model** for POS use. Stock adjustments update `product.stockQuantity` atomically. The `stock_adjustment` table serves as an immutable audit log. Periodic reconciliation jobs can detect drift.

### 1.8 TaxSlab -- No Compound/Multiple Tax Support

```sql
CREATE TABLE tax_slab (
  ...
  rate REAL NOT NULL,  -- single rate
  type INTEGER NOT NULL  -- inclusive/exclusive
);
```

**Problem:** Many jurisdictions have compound tax (e.g., GST = CGST 9% + SGST 9%). A single `rate` field can't represent this.

**Fix:** Add `product_tax_slab` junction table for products with multiple taxes, or add `rate2`, `name2` fields. Better: use a junction table.

### 1.9 Schema Housekeeping

| Issue | Tables Affected |
|-------|----------------|
| Missing `createdAt`/`updatedAt` | All tables except `orders` and `order_product` |
| Missing `notes` field | Most entities need a free-text notes field |
| `onDelete` cascade only on `order_product` | Missing on `payment(orderId)`, `void_log_entry(orderId)` |
| `voidedBy` stored as TEXT | `orders.voidedBy` and `void_log_entry.voidedBy` store staff name as text. Should reference `staff.id` for referential integrity, like the proposed `orders.voidedBy INTEGER REFERENCES staff(id)`. |

---

## 2. Missing Entities (Not in Current Schema)

### Tier 1 -- Core Operations

| Entity | Purpose | Priority |
|--------|---------|----------|
| **modifier_group** | Groups of product customization options | P1 |
| **modifier** | Individual option within a group (e.g., "Extra Cheese" $1.50) | P1 |
| **product_modifier** | Junction: which modifier groups apply to which products | P1 |
| **order_product_modifier** | Modifiers applied to a specific order line item | P1 |
| **order_status_history** | Full lifecycle audit trail for orders | P1 |
| **discount** | Reusable discount rules (%, fixed, BOGO) | P1 |
| **order_discount** | Discounts applied to an order | P1 |

### Tier 2 -- Inventory & Supply Chain

| Entity | Purpose | Priority |
|--------|---------|----------|
| **supplier** | Vendors for inventory procurement | P3 |
| **purchase_order** | Inventory procurement orders | P3 |
| **purchase_order_item** | Line items within purchase orders | P3 |
| **stock_adjustment** | Inventory additions/removals (waste, theft, corrections) | P3 |
| **recipe** | Links kitchen dishes to inventory items | P3 |
| **recipe_item** | Quantity of inventory item needed per dish | P3 |
| **unit_of_measure** | uom catalog (kg, pcs, liter, box) | P3 |

### Tier 3 -- HR & Operations

| Entity | Purpose | Priority |
|--------|---------|----------|
| **shift** | Staff work shift definitions | P7 |
| **time_entry** | Staff clock-in/clock-out records | P7 |
| **expense** | Operational expenses | P7 |
| **expense_category** | Expense categorization | P7 |

### Tier 4 -- Customer Engagement

| Entity | Purpose | Priority |
|--------|---------|----------|
| **reservation** | Table reservations (date, time, party size, status) | P7 |
| **customer_loyalty** | Points, rewards tier, visit count | P8 |
| **loyalty_transaction** | Points earned/redeemed | P8 |
| **customer_address** | Multiple addresses per customer | P8 |

### Tier 5 -- System & Settings

| Entity | Purpose | Priority |
|--------|---------|----------|
| **business_hours** | Operating hours per day of week | P7 |
| **holiday_hours** | Special hours for holidays | P7 |
| **notification_log** | System notification audit trail | P7 |
| **app_config** | Key-value configuration store (already exists as SQLite table) | P0 |

---

## 3. Full Recommended Schema

Below is the complete schema with all additions and fixes.
*New tables are marked with `-- NEW`*.
*Modified tables show only changed columns.*

### 3.1 Staff (Extended)

```sql
CREATE TABLE staff (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  name           TEXT NOT NULL,
  email          TEXT,                          -- NEW: for forgot PIN
  photo          TEXT,
  phone          TEXT,
  pin            TEXT,                          -- NEW: hashed PIN
  pinUpdatedAt   INTEGER,                       -- NEW: track PIN changes
  lastLoginAt    INTEGER,                       -- NEW: audit trail
  type           INTEGER NOT NULL,              -- waiter(0)/chef(1)/driver(2)/other(3)/admin(4)
  isActive       INTEGER NOT NULL DEFAULT 1,
  createdAt      INTEGER NOT NULL,              -- NEW
  updatedAt      INTEGER                        -- NEW
);
```

### 3.2 Company (Modernized)

```sql
CREATE TABLE company (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  logo           TEXT,
  name           TEXT NOT NULL DEFAULT 'My Restaurant',
  email          TEXT,                          -- no longer required at setup
  phone          TEXT,
  address        TEXT,
  taxation       INTEGER NOT NULL DEFAULT -1,   -- renamed from `edition`
  currencyCode   TEXT,
  timezone       TEXT DEFAULT 'UTC',            -- NEW
  businessType   TEXT DEFAULT 'restaurant',     -- NEW
  salesTaxNumber TEXT,
  foodLicenseNo  TEXT,
  adminStaffId   INTEGER,                       -- NEW: link to admin staff
  createdAt      INTEGER NOT NULL,
  updatedAt      INTEGER
);
```

### 3.3 Orders (Extended)

```sql
CREATE TABLE orders (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  customerId     INTEGER REFERENCES customer(id), -- REPLACED customerPhone
  customerPhone  TEXT,                             -- kept as denormalized display
  staffId        INTEGER REFERENCES staff(id),     -- NEW: who took the order
  diningTableId  INTEGER REFERENCES dining_table(id), -- NEW
  orderType      INTEGER NOT NULL,                 -- renamed from `type`
  status         INTEGER NOT NULL DEFAULT 0,       -- CHANGED from TEXT to INTEGER
  source         INTEGER NOT NULL DEFAULT 0,       -- NEW: pos(0)/waiter(1)/kiosk(2)/online(3)
  createdAt      INTEGER NOT NULL,
  updatedAt      INTEGER,
  totalQuantity  INTEGER NOT NULL,
  subTotal       REAL NOT NULL,
  discountTotal  REAL NOT NULL DEFAULT 0,
  taxTotal       REAL NOT NULL DEFAULT 0,
  finalTotal     REAL NOT NULL,
  roundOff       REAL NOT NULL DEFAULT 0,
  grandTotal     REAL NOT NULL,
  paidTotal      REAL DEFAULT 0,
  note           TEXT,                             -- NEW: order-level note
  voidReason     TEXT,
  voidedBy       INTEGER REFERENCES staff(id),     -- CHANGED from TEXT to staff ID
  voidedAt       INTEGER
);
```

### 3.4 OrderProduct (Extended)

```sql
CREATE TABLE order_product (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId        INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  productId      INTEGER REFERENCES product(id),
  productName    TEXT NOT NULL,
  quantity       INTEGER NOT NULL,
  price          REAL NOT NULL,
  subTotal       REAL NOT NULL,
  discountRate   REAL,
  discountAmount REAL,
  taxRate        REAL,
  taxAmount      REAL,
  total          REAL NOT NULL,
  status         INTEGER NOT NULL DEFAULT 0,       -- NEW: pending/preparing/ready/served/cancelled
  note           TEXT,                              -- NEW: item-level special instructions
  modifierJson   TEXT,                              -- NEW: snapshot of applied modifiers
  stationId      INTEGER REFERENCES kds_station(id),
  stationName    TEXT,
  cancelledAt    INTEGER,                           -- NEW
  cancelledBy    INTEGER REFERENCES staff(id)       -- NEW
);
```

### 3.5 DiningTable (Extended)

```sql
CREATE TABLE dining_table (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  name          TEXT NOT NULL,
  categoryId    INTEGER REFERENCES dining_table_category(id),
  description   TEXT,
  capacity      INTEGER DEFAULT 0,
  status        INTEGER NOT NULL,               -- available/occupied/reserved/inactive
  posX          REAL,                           -- NEW: floor plan X
  posY          REAL,                           -- NEW: floor plan Y
  shape         INTEGER DEFAULT 0,              -- NEW: rectangle(0)/circle(1)/bar(2)
  width         REAL,                           -- NEW: visual width
  height        REAL,                           -- NEW: visual height
  staffId       INTEGER REFERENCES staff(id),  -- NEW: assigned waiter
  customerPhone TEXT,
  createdAt     INTEGER NOT NULL,
  updatedAt     INTEGER
);
```

### 3.6 Product (Extended)

```sql
CREATE TABLE product (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  categoryId  INTEGER REFERENCES product_category(id),
  description TEXT,
  image       TEXT,
  sku         TEXT,                            -- NEW
  barcode     TEXT,                            -- NEW
  stockQuantity REAL DEFAULT 0,                -- NEW: current stock (stored model)
  lowStockThreshold REAL,                      -- NEW: alert threshold
  mrpPrice    REAL NOT NULL,
  salePrice   REAL,
  prepTime    INTEGER,                         -- NEW: seconds
  sortOrder   INTEGER DEFAULT 0,               -- NEW
  isPopular   INTEGER DEFAULT 0,               -- NEW
  taxSlabId   INTEGER,
  foodType    INTEGER,
  type        INTEGER NOT NULL,               -- kitchenDish(0)/inventoryItem(1)
  isActive    INTEGER NOT NULL DEFAULT 1,
  stationId   INTEGER REFERENCES kds_station(id),
  stationName TEXT,
  createdAt   INTEGER NOT NULL,
  updatedAt   INTEGER
);
```

### 3.7 New: Modifier Groups & Modifiers

```sql
-- NEW: Group of customization options (e.g., "Cheese Options", "Beverage Size")
CREATE TABLE modifier_group (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,               -- e.g., "Extra Toppings"
  description TEXT,
  minSelect   INTEGER NOT NULL DEFAULT 0,  -- minimum selections required
  maxSelect   INTEGER NOT NULL DEFAULT 1,  -- maximum selections allowed (0 = unlimited)
  sortOrder   INTEGER DEFAULT 0,
  isRequired  INTEGER NOT NULL DEFAULT 0,  -- customer must choose at least minSelect
  createdAt   INTEGER NOT NULL,
  updatedAt   INTEGER
);

-- NEW: Individual modifier option
CREATE TABLE modifier (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,             -- e.g., "Extra Cheese", "Large"
  priceAdjust     REAL NOT NULL DEFAULT 0,   -- additional cost
  sortOrder       INTEGER DEFAULT 0,
  isDefault       INTEGER NOT NULL DEFAULT 0,
  createdAt       INTEGER NOT NULL,
  updatedAt       INTEGER
);

-- NEW: Junction -- which modifier groups apply to which products
CREATE TABLE product_modifier (
  productId       INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
  modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id) ON DELETE CASCADE,
  PRIMARY KEY (productId, modifierGroupId)
);

-- NEW: Modifiers applied to a specific order line item
CREATE TABLE order_product_modifier (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  orderProductId  INTEGER NOT NULL REFERENCES order_product(id) ON DELETE CASCADE,
  modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id),
  modifierId      INTEGER NOT NULL REFERENCES modifier(id),
  modifierName    TEXT NOT NULL,             -- denormalized snapshot
  priceAdjust     REAL NOT NULL DEFAULT 0,   -- denormalized snapshot
  quantity        INTEGER NOT NULL DEFAULT 1
);
```

### 3.8 New: Discounts

```sql
-- NEW: Reusable discount rule
CREATE TABLE discount (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,                 -- e.g., "Happy Hour 20%", "BOGO"
  type        INTEGER NOT NULL,              -- percentage(0)/fixed(1)/bogo(2)
  value       REAL NOT NULL,                 -- percentage (10 = 10%) or amount
  minOrder    REAL,                          -- minimum order amount to qualify
  maxUses     INTEGER,                       -- maximum total uses (null = unlimited)
  isActive    INTEGER NOT NULL DEFAULT 1,
  startsAt    INTEGER,                       -- valid from
  endsAt      INTEGER,                       -- valid until
  createdAt   INTEGER NOT NULL,
  updatedAt   INTEGER
);

-- NEW: Discount applied to an order
CREATE TABLE order_discount (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId     INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  discountId  INTEGER REFERENCES discount(id),
  name        TEXT NOT NULL,                 -- denormalized
  type        INTEGER NOT NULL,              -- denormalized
  value       REAL NOT NULL,                 -- denormalized rate/amount
  amount      REAL NOT NULL,                 -- calculated discount amount
  appliedBy   INTEGER REFERENCES staff(id),
  createdAt   INTEGER NOT NULL
);
```

### 3.9 New: Inventory & Recipes

```sql
-- NEW: Supplier/vendor
CREATE TABLE supplier (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  contactName TEXT,
  phone       TEXT,
  email       TEXT,
  address     TEXT,
  gstin       TEXT,                         -- supplier's tax ID
  isActive    INTEGER NOT NULL DEFAULT 1,
  createdAt   INTEGER NOT NULL,
  updatedAt   INTEGER
);

-- NEW: Purchase order to supplier
CREATE TABLE purchase_order (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  supplierId      INTEGER REFERENCES supplier(id),
  orderDate       INTEGER NOT NULL,
  expectedDate    INTEGER,
  deliveredDate   INTEGER,
  status          INTEGER NOT NULL DEFAULT 0,  -- ordered(0)/partial(1)/received(2)/cancelled(3)
  totalAmount     REAL NOT NULL DEFAULT 0,
  notes           TEXT,
  createdBy       INTEGER REFERENCES staff(id),
  createdAt       INTEGER NOT NULL,
  updatedAt       INTEGER
);

-- NEW: Purchase order line items
CREATE TABLE purchase_order_item (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  purchaseOrderId INTEGER NOT NULL REFERENCES purchase_order(id) ON DELETE CASCADE,
  productId       INTEGER NOT NULL REFERENCES product(id),
  quantity        REAL NOT NULL,
  unitPrice       REAL NOT NULL,
  totalPrice      REAL NOT NULL,
  receivedQty     REAL DEFAULT 0
);

-- NEW: Bill of materials -- inventory items needed per dish
CREATE TABLE recipe (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  productId   INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,                -- e.g., "Classic Margherita Recipe"
  yieldQty    REAL NOT NULL DEFAULT 1,      -- how many dishes this recipe produces
  isActive    INTEGER NOT NULL DEFAULT 1,
  createdAt   INTEGER NOT NULL,
  updatedAt   INTEGER
);

-- NEW: Individual ingredient in a recipe
CREATE TABLE recipe_item (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  recipeId    INTEGER NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
  productId   INTEGER NOT NULL REFERENCES product(id),  -- must be inventoryItem type
  quantity    REAL NOT NULL,                -- amount needed
  unitOfMeasure TEXT DEFAULT 'pcs',         -- kg, g, l, ml, pcs, box
  wastagePct  REAL DEFAULT 0,               -- typical wastage percentage
  sortOrder   INTEGER DEFAULT 0
);

-- NEW: Stock movement log
CREATE TABLE stock_adjustment (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  productId   INTEGER NOT NULL REFERENCES product(id),
  quantity    REAL NOT NULL,                 -- positive = addition, negative = removal
  reason      TEXT NOT NULL,                 -- purchase/receive/waste/theft/correction/recipe
  referenceId INTEGER,                       -- FK to purchase_order_item / recipe / etc.
  notes       TEXT,
  createdBy   INTEGER REFERENCES staff(id),
  createdAt   INTEGER NOT NULL
);

-- NEW: Unit of measure catalog
CREATE TABLE unit_of_measure (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,                 -- kilogram, liter, piece, box
  abbreviation TEXT NOT NULL,                -- kg, l, pcs, box
  category    TEXT NOT NULL DEFAULT 'unit'   -- weight/volume/unit
);
```

### 3.10 New: Order Lifecycle & History

```sql
-- NEW: Full order status change audit trail
CREATE TABLE order_status_history (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId         INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  fromStatus      INTEGER NOT NULL,
  toStatus        INTEGER NOT NULL,
  changedByStaffId INTEGER REFERENCES staff(id),
  changedAt       INTEGER NOT NULL,
  reason          TEXT                        -- optional reason for the transition
);

CREATE INDEX idx_osh_order ON order_status_history(orderId);
```

### 3.11 New: HR & Shifts

```sql
-- NEW: Shift definitions
CREATE TABLE shift (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,                 -- "Morning", "Evening", "Night"
  startTime   TEXT NOT NULL,                 -- "09:00" (HH:MM format)
  endTime     TEXT NOT NULL,                 -- "17:00"
  isActive    INTEGER NOT NULL DEFAULT 1
);

-- NEW: Staff time tracking
CREATE TABLE time_entry (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  staffId     INTEGER NOT NULL REFERENCES staff(id),
  shiftId     INTEGER REFERENCES shift(id),
  clockIn     INTEGER NOT NULL,
  clockOut    INTEGER,
  breakStart  INTEGER,
  breakEnd    INTEGER,
  note        TEXT,
  createdAt   INTEGER NOT NULL
);

CREATE INDEX idx_time_entry_staff ON time_entry(staffId);
CREATE INDEX idx_time_entry_date ON time_entry(clockIn);
```

### 3.12 New: Expenses

```sql
-- NEW: Expense categories
CREATE TABLE expense_category (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,                 -- "Ingredients", "Utilities", "Rent"
  description TEXT,
  isActive    INTEGER NOT NULL DEFAULT 1
);

-- NEW: Individual expenses
CREATE TABLE expense (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  categoryId  INTEGER REFERENCES expense_category(id),
  amount      REAL NOT NULL,
  description TEXT NOT NULL,
  expenseDate INTEGER NOT NULL,
  paymentMode INTEGER NOT NULL DEFAULT 0,    -- cash/card/upi/etc
  reference   TEXT,
  receipt     TEXT,                          -- receipt image path
  createdBy   INTEGER REFERENCES staff(id),
  createdAt   INTEGER NOT NULL
);
```

### 3.13 New: Reservations

```sql
-- NEW: Table reservations
CREATE TABLE reservation (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  customerId      INTEGER REFERENCES customer(id),
  customerName    TEXT NOT NULL,
  customerPhone   TEXT,
  diningTableId   INTEGER REFERENCES dining_table(id),  -- null until assigned
  partySize       INTEGER NOT NULL,
  dateTime        INTEGER NOT NULL,          -- reservation time
  duration        INTEGER DEFAULT 60,        -- expected duration in minutes
  status          INTEGER NOT NULL DEFAULT 0, -- pending(0)/confirmed(1)/seated(2)/completed(3)/cancelled(4)
  note            TEXT,
  createdBy       INTEGER REFERENCES staff(id),
  createdAt       INTEGER NOT NULL,
  updatedAt       INTEGER
);
```

### 3.14 New: Business Hours

```sql
-- NEW: Operating hours per day
CREATE TABLE business_hours (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  dayOfWeek   INTEGER NOT NULL,             -- 0=Monday .. 6=Sunday
  openTime    TEXT NOT NULL,                 -- "09:00" (HH:MM)
  closeTime   TEXT NOT NULL,                -- "22:00"
  isClosed    INTEGER NOT NULL DEFAULT 0    -- closed on this day
);

-- NEW: Special holiday hours (overrides business_hours)
CREATE TABLE holiday_hours (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  date        TEXT NOT NULL,                 -- "2026-12-25"
  openTime    TEXT,                          -- null = closed all day
  closeTime   TEXT,
  description TEXT
);
```

### 3.15 Payment -- Split Payment Support

```sql
-- MODIFIED: enable multiple payments per order
-- (table structure is fine, but add index + order status tracking)

-- NEW: Track which payment completed the order
ALTER TABLE payment ADD COLUMN completedOrder INTEGER DEFAULT 0;
```

### 3.16 OpLog -- Better ID Scheme

```sql
-- MODIFIED: UUID instead of clock-based PK
CREATE TABLE IF NOT EXISTS op_log (
  id      TEXT PRIMARY KEY,         -- UUID v7
  clock   INTEGER NOT NULL,         -- monotonically increasing per device
  value   TEXT NOT NULL
);

CREATE INDEX idx_op_log_clock ON op_log(clock);
```

**Migration impact:** This is a breaking change for any existing deployment with sync data.
- Existing `op_log` table has `clock INTEGER PRIMARY KEY` -- the PK type changes from int to text.
- Migration strategy: Create new table with `id TEXT PRIMARY KEY`, copy existing rows with `id = 'migrated_$clock'`, drop old table, rename new table.
- `OpLogService.clock` continues as the monotonic counter for ordering; `id` is the collision-safe UUID.
- All existing sync deployments (0 at this stage) must run the migration before upgrading.

### 3.17 VAT/GST Compound Tax Support

```sql
-- NEW: Junction table supporting multiple taxes per product
CREATE TABLE product_tax (
  productId INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
  taxSlabId INTEGER NOT NULL REFERENCES tax_slab(id) ON DELETE CASCADE,
  isDefault INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (productId, taxSlabId)
);
```

---

## 4. Summary: Tables Added

| Tier | Tables Added | Count |
|------|-------------|-------|
| Modifiers | `modifier_group`, `modifier`, `product_modifier`, `order_product_modifier` | 4 |
| Discounts | `discount`, `order_discount` | 2 |
| Inventory | `supplier`, `purchase_order`, `purchase_order_item`, `recipe`, `recipe_item`, `stock_adjustment`, `unit_of_measure` | 7 |
| Order Lifecycle | `order_status_history` | 1 |
| HR/Shifts | `shift`, `time_entry` | 2 |
| Expenses | `expense_category`, `expense` | 2 |
| Reservations | `reservation` | 1 |
| Hours | `business_hours`, `holiday_hours` | 2 |
| Tax | `product_tax` | 1 |
| OpLog | (modified) | 0 |

**Total new tables: 22**
**Current tables: 19 -> 41**
**Columns modified: ~17 existing columns** (added stock fields, staff PIN, posX/Y, note/status, timestamps; renamed edition; removed password; changed voidedBy to staff FK)

---

## 5. Migration Strategy

Migration phases map to product phases defined in `../product/06-prd-audit.md`:

| Migration Phase | Product Phase | Content | Breaking? |
|----------------|---------------|---------|-----------|
| 1 | P0-P1 | Auth, modifiers, order lifecycle | No (additive) |
| 2 | P3 | Inventory & supply chain | No (additive) |
| 3 | P7 | HR, expenses, business hours | No (additive) |
| 4 | P7-P8 | Customer, discounts, reservations | No (additive) |
| 5 | P1-P3 | Column renames, type changes | Yes |

### Phase 1: Foundation (P0-P1 -- schema safe)
1. Add `staff.pin`, `staff.email`, `staff.pinUpdatedAt`, `staff.lastLoginAt`
2. Add `company.adminStaffId`
3. Add `dining_table.posX`, `dining_table.posY`, `dining_table.shape`
4. Add `order_product.note`, `order_product.status`
5. Create `order_status_history` table
6. Create `modifier_group`, `modifier`, `product_modifier` tables
7. Add `product.stockQuantity`, `product.lowStockThreshold`

### Phase 2: Inventory (P3 -- schema safe)
8. Create `supplier`, `purchase_order`, `purchase_order_item` tables
9. Create `recipe`, `recipe_item`, `stock_adjustment` tables
10. Create `unit_of_measure` table

### Phase 3: HR & Operations (P7 -- schema safe)
11. Create `shift`, `time_entry` tables
12. Create `expense_category`, `expense` tables
13. Create `business_hours`, `holiday_hours` tables

### Phase 4: Customer & Discounts (P7-P8 -- schema safe)
14. Create `reservation` table
15. Create `discount`, `order_discount` tables
16. Create `customer_loyalty`, `loyalty_transaction` tables
17. Create `product_tax` table
18. Migrate `op_log` to UUID PK (requires data migration)

### Phase 5: Breaking Changes (P1-P3)
19. Migrate `orders.status` from TEXT to INTEGER
20. Migrate `orders.customerPhone` to `orders.customerId`
21. Add `orders.staffId`, `orders.diningTableId`
22. Rename `company.edition` to `company.taxation`
23. Remove `company.password`
24. Migrate `orders.voidedBy` and `void_log_entry.voidedBy` from TEXT to INTEGER REFERENCES staff(id)

---

## 6. Impact on Current Codebase

| Area | Impact |
|------|--------|
| **Existing queries** | All SELECT * queries continue to work (adding columns is additive) |
| **fromMap/toMap methods** | Need new field mappings for added columns; nullable for backward compat |
| **Enum id vs index** | Standardize all enums to use `.index` (consistent with ProductType, TaxType) |
| **Repositories** | New tables = new repository interfaces + implementations |
| **Sync allowlist** | Add new entity types to `SyncCoordinator._allowedEntityTypes` |
| **Providers** | New Riverpod providers for new entities |
| **Migrator** | SchemaMigrator class needed for versioned upgrades |
