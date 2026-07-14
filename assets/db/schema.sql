-- ============================================================================
-- eatery SQLite schema
-- ============================================================================
-- Column names and types line up 1:1 with each model's toMap() / fromMap().
-- Type mapping:
--   * enums stored as INTEGER id/index
--   * booleans stored as INTEGER 0/1
--   * DateTime stored as INTEGER epoch millis
--   * id is INTEGER PRIMARY KEY AUTOINCREMENT
-- ============================================================================

-- ── Phase A: Core POS entities ──────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS product_category (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  description TEXT,
  image       TEXT
);

CREATE TABLE IF NOT EXISTS product (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  categoryId  INTEGER,
  description TEXT,
  image       TEXT,
  mrpPrice    REAL NOT NULL,
  salePrice   REAL,
  taxSlabId   INTEGER,
  foodType    INTEGER,
  type        INTEGER NOT NULL,
  isActive    INTEGER NOT NULL DEFAULT 1,
  stationId   INTEGER,
  stationName TEXT,
  stockQuantity REAL DEFAULT 0,
  lowStockThreshold REAL
);

CREATE INDEX IF NOT EXISTS idx_product_category ON product(categoryId);
CREATE INDEX IF NOT EXISTS idx_product_type ON product(type);

CREATE TABLE IF NOT EXISTS customer (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT,
  phone       TEXT NOT NULL,
  address     TEXT,
  landmark    TEXT,
  latitude    REAL,
  longitude   REAL,
  isActive    INTEGER NOT NULL DEFAULT 1,
  lastOrderAt INTEGER
);

CREATE INDEX IF NOT EXISTS idx_customer_phone ON customer(phone);

CREATE TABLE IF NOT EXISTS orders (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  customerPhone TEXT,
  createdAt     INTEGER NOT NULL,
  updatedAt     INTEGER,
  totalQuantity INTEGER NOT NULL,
  subTotal      REAL NOT NULL,
  discountTotal REAL NOT NULL,
  taxTotal      REAL NOT NULL,
  finalTotal    REAL NOT NULL,
  roundOff      REAL NOT NULL,
  grandTotal    REAL NOT NULL,
  paidTotal     REAL,
  type          INTEGER NOT NULL,
  status        TEXT NOT NULL DEFAULT 'active',
  voidReason    TEXT,
  voidedBy      TEXT,
  voidedAt      INTEGER
);

CREATE TABLE IF NOT EXISTS order_product (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId        INTEGER REFERENCES orders(id) ON DELETE CASCADE,
  productId      INTEGER,
  productName    TEXT NOT NULL,
  quantity       INTEGER NOT NULL,
  price          REAL NOT NULL,
  subTotal       REAL NOT NULL,
  discountRate   REAL,
  discountAmount REAL,
  taxRate        REAL,
  taxAmount      REAL,
  total          REAL NOT NULL,
  note           TEXT,
  status         INTEGER NOT NULL DEFAULT 0,
  stationId      INTEGER,
  stationName    TEXT
);

CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customerPhone);
CREATE INDEX IF NOT EXISTS idx_order_product_order ON order_product(orderId);

CREATE TABLE IF NOT EXISTS payment (
  id                     INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId                INTEGER,
  date                   INTEGER NOT NULL,
  amount                 REAL NOT NULL,
  mode                   INTEGER NOT NULL,
  reference              TEXT,
  attachment             TEXT,
  processorTransactionId TEXT,
  processorName          TEXT,
  processorStatus        TEXT,
  cardLastFour           TEXT,
  terminalId             TEXT
);

CREATE INDEX IF NOT EXISTS idx_payment_order ON payment(orderId);

CREATE TABLE IF NOT EXISTS tax_slab (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  rate REAL NOT NULL,
  type INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS dining_table_category (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  description TEXT,
  isActive    INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dining_table (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  name          TEXT NOT NULL,
  categoryId    INTEGER,
  description   TEXT,
  orderId       INTEGER,
  capacity      INTEGER DEFAULT 0,
  status        INTEGER NOT NULL,
  customerPhone TEXT,
  posX          REAL,
  posY          REAL,
  shape         INTEGER DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_dining_table_category ON dining_table(categoryId);
CREATE INDEX IF NOT EXISTS idx_dining_table_status ON dining_table(status);

-- ── Phase B: Company / Settings / Compliance ─────────────────────────────────

CREATE TABLE IF NOT EXISTS company (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  logo           TEXT,
  name           TEXT NOT NULL,
  email          TEXT NOT NULL,
  phone          TEXT NOT NULL,
  address        TEXT NOT NULL,
  password       TEXT,
  edition        INTEGER NOT NULL,
  currencyCode   TEXT,
  salesTaxNumber TEXT,
  foodLicenseNo  TEXT,
  subscriptionId INTEGER,
  adminStaffId   INTEGER
);

CREATE TABLE IF NOT EXISTS currency (
  code                            TEXT PRIMARY KEY,
  name                            TEXT NOT NULL,
  symbol                          TEXT NOT NULL,
  flag                            TEXT,
  number                          INTEGER NOT NULL,
  decimal_digits                  INTEGER NOT NULL,
  name_plural                     TEXT NOT NULL,
  symbol_on_left                  INTEGER NOT NULL,
  decimal_separator               TEXT NOT NULL,
  thousands_separator             TEXT NOT NULL,
  space_between_amount_and_symbol INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS staff (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  name           TEXT NOT NULL,
  email          TEXT,
  photo          TEXT,
  phone          TEXT,
  pin            TEXT,
  pinUpdatedAt   INTEGER,
  lastLoginAt    INTEGER,
  type           INTEGER NOT NULL,
  isActive       INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS subscription (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  purchaseCode     TEXT,
  validFrom        INTEGER,
  validTill        INTEGER,
  subscriptionType INTEGER
);

CREATE TABLE IF NOT EXISTS auto_print (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  invoicePrint      INTEGER,
  kotPrint          INTEGER,
  invoicePrinterId  INTEGER,
  kotPrinterId      INTEGER
);

CREATE TABLE IF NOT EXISTS kds_station (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  description TEXT,
  sortOrder   INTEGER NOT NULL DEFAULT 0,
  isActive    INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS compliance_report (
  id                 INTEGER PRIMARY KEY AUTOINCREMENT,
  reportType         TEXT NOT NULL,
  generatedAt        INTEGER NOT NULL,
  generatedBy        TEXT NOT NULL,
  periodStart        INTEGER NOT NULL,
  periodEnd          INTEGER NOT NULL,
  reportNumber       TEXT NOT NULL,
  grossSales         REAL NOT NULL,
  netSales           REAL NOT NULL,
  taxCollected       REAL NOT NULL,
  transactionCount   INTEGER NOT NULL,
  averageTicket      REAL NOT NULL,
  totalDiscounts     REAL NOT NULL DEFAULT 0,
  discountCount      INTEGER NOT NULL DEFAULT 0,
  voidCount          INTEGER NOT NULL DEFAULT 0,
  voidAmount         REAL NOT NULL DEFAULT 0,
  refundCount        INTEGER NOT NULL DEFAULT 0,
  refundAmount       REAL NOT NULL DEFAULT 0,
  openingBalance     REAL NOT NULL,
  closingBalance     REAL NOT NULL,
  expectedCash       REAL,
  actualCash         REAL,
  cashVariance       REAL,
  paymentBreakdownJson TEXT,
  taxBreakdownJson   TEXT
);

CREATE TABLE IF NOT EXISTS void_log_entry (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId           INTEGER NOT NULL,
  voidedAt          INTEGER NOT NULL,
  voidedBy          TEXT NOT NULL,
  reasonCode        TEXT NOT NULL,
  reasonDescription TEXT,
  amount            REAL NOT NULL,
  orderReference    TEXT
);

-- ── Printer configuration ───────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS printer (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  name            TEXT NOT NULL,
  bluetoothAddress TEXT,
  usbVendorId     TEXT,
  usbProductId    TEXT,
  type            INTEGER
);

-- ── Order status history (order lifecycle audit trail) ──────────────────────

CREATE TABLE IF NOT EXISTS order_status_history (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  orderId          INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  fromStatus       INTEGER NOT NULL,
  toStatus         INTEGER NOT NULL,
  changedByStaffId INTEGER,
  changedAt        INTEGER NOT NULL,
  reason           TEXT
);

CREATE INDEX IF NOT EXISTS idx_osh_order ON order_status_history(orderId);

-- ── Modifiers (product customization) ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS modifier_group (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  description TEXT,
  minSelect   INTEGER NOT NULL DEFAULT 0,
  maxSelect   INTEGER NOT NULL DEFAULT 1,
  sortOrder   INTEGER DEFAULT 0,
  isRequired  INTEGER NOT NULL DEFAULT 0,
  createdAt   INTEGER NOT NULL,
  updatedAt   INTEGER
);

CREATE TABLE IF NOT EXISTS modifier (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  priceAdjust     REAL NOT NULL DEFAULT 0,
  sortOrder       INTEGER DEFAULT 0,
  isDefault       INTEGER NOT NULL DEFAULT 0,
  createdAt       INTEGER NOT NULL,
  updatedAt       INTEGER
);

CREATE TABLE IF NOT EXISTS product_modifier (
  productId       INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
  modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id) ON DELETE CASCADE,
  PRIMARY KEY (productId, modifierGroupId)
);

CREATE TABLE IF NOT EXISTS order_product_modifier (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  orderProductId  INTEGER NOT NULL REFERENCES order_product(id) ON DELETE CASCADE,
  modifierGroupId INTEGER NOT NULL REFERENCES modifier_group(id),
  modifierId      INTEGER NOT NULL REFERENCES modifier(id),
  modifierName    TEXT NOT NULL,
  priceAdjust     REAL NOT NULL DEFAULT 0,
  quantity        INTEGER NOT NULL DEFAULT 1
);

-- ── OpLog (sync layer) ─���────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS op_log (
  clock INTEGER PRIMARY KEY,
  value TEXT NOT NULL
);
