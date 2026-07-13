import 'eatery_store.dart';

/// Creates the SQLite schema for the tables owned by the native store.
///
/// Full schema covering all entities. Column names and types line up 1:1 with
/// each model's `toMap()` / `fromMap()` so the repositories can marshal rows
/// with almost no transformation.
///
/// Type mapping notes:
///   * enums are stored as their integer id/index
///   * booleans are stored as INTEGER 0/1
///   * DateTime is stored as INTEGER epoch millis
///   * id is INTEGER PRIMARY KEY AUTOINCREMENT
void initEaterySchema(EateryStore store) {
  // --- Phase A: Core POS entities ---

  store.execute('''
    CREATE TABLE IF NOT EXISTS product_category (
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      name        TEXT NOT NULL,
      description TEXT,
      image       TEXT
    );
  ''');

  store.execute('''
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
      stationName TEXT
    );
  ''');

  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_product_category ON product(categoryId);',
  );
  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_product_type ON product(type);',
  );

  store.execute('''
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
  ''');

  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_customer_phone ON customer(phone);',
  );

  store.execute('''
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
  ''');

  store.execute('''
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
      stationId      INTEGER,
      stationName    TEXT
    );
  ''');

  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customerPhone);',
  );
  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_order_product_order ON order_product(orderId);',
  );

  store.execute('''
    CREATE TABLE IF NOT EXISTS payment (
      id                    INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId               INTEGER,
      date                  INTEGER NOT NULL,
      amount                REAL NOT NULL,
      mode                  INTEGER NOT NULL,
      reference             TEXT,
      attachment            TEXT,
      processorTransactionId TEXT,
      processorName         TEXT,
      processorStatus       TEXT,
      cardLastFour          TEXT,
      terminalId            TEXT
    );
  ''');

  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_payment_order ON payment(orderId);',
  );

  store.execute('''
    CREATE TABLE IF NOT EXISTS tax_slab (
      id   INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      rate REAL NOT NULL,
      type INTEGER NOT NULL
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS dining_table_category (
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      name        TEXT NOT NULL,
      description TEXT,
      isActive    INTEGER NOT NULL DEFAULT 0
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS dining_table (
      id            INTEGER PRIMARY KEY AUTOINCREMENT,
      name          TEXT NOT NULL,
      categoryId    INTEGER,
      description   TEXT,
      orderId       INTEGER,
      capacity      INTEGER DEFAULT 0,
      status        INTEGER NOT NULL,
      customerPhone TEXT
    );
  ''');

  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_dining_table_category ON dining_table(categoryId);',
  );
  store.execute(
    'CREATE INDEX IF NOT EXISTS idx_dining_table_status ON dining_table(status);',
  );

  // --- Phase B: Company / Settings / Compliance ---

  store.execute('''
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
      subscriptionId INTEGER
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS currency (
      code                         TEXT PRIMARY KEY,
      name                         TEXT NOT NULL,
      symbol                       TEXT NOT NULL,
      flag                         TEXT,
      number                       INTEGER NOT NULL,
      decimal_digits               INTEGER NOT NULL,
      name_plural                  TEXT NOT NULL,
      symbol_on_left               INTEGER NOT NULL,
      decimal_separator            TEXT NOT NULL,
      thousands_separator          TEXT NOT NULL,
      space_between_amount_and_symbol INTEGER NOT NULL
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS staff (
      id       INTEGER PRIMARY KEY AUTOINCREMENT,
      name     TEXT NOT NULL,
      photo    TEXT,
      phone    TEXT,
      type     INTEGER NOT NULL,
      isActive INTEGER NOT NULL DEFAULT 1
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS subscription (
      id               INTEGER PRIMARY KEY AUTOINCREMENT,
      purchaseCode     TEXT,
      validFrom        INTEGER,
      validTill        INTEGER,
      subscriptionType INTEGER
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS auto_print (
      id                INTEGER PRIMARY KEY AUTOINCREMENT,
      invoicePrint      INTEGER,
      kotPrint          INTEGER,
      invoicePrinterId  INTEGER,
      kotPrinterId      INTEGER
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS kds_station (
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      name        TEXT NOT NULL,
      description TEXT,
      sortOrder   INTEGER NOT NULL DEFAULT 0,
      isActive    INTEGER NOT NULL DEFAULT 1
    );
  ''');

  store.execute('''
    CREATE TABLE IF NOT EXISTS compliance_report (
      id                INTEGER PRIMARY KEY AUTOINCREMENT,
      reportType        TEXT NOT NULL,
      generatedAt       INTEGER NOT NULL,
      generatedBy       TEXT NOT NULL,
      periodStart       INTEGER NOT NULL,
      periodEnd         INTEGER NOT NULL,
      reportNumber      TEXT NOT NULL,
      grossSales        REAL NOT NULL,
      netSales          REAL NOT NULL,
      taxCollected      REAL NOT NULL,
      transactionCount  INTEGER NOT NULL,
      averageTicket     REAL NOT NULL,
      totalDiscounts    REAL NOT NULL DEFAULT 0,
      discountCount     INTEGER NOT NULL DEFAULT 0,
      voidCount         INTEGER NOT NULL DEFAULT 0,
      voidAmount        REAL NOT NULL DEFAULT 0,
      refundCount       INTEGER NOT NULL DEFAULT 0,
      refundAmount      REAL NOT NULL DEFAULT 0,
      openingBalance    REAL NOT NULL,
      closingBalance    REAL NOT NULL,
      expectedCash      REAL,
      actualCash        REAL,
      cashVariance      REAL,
      paymentBreakdownJson TEXT,
      taxBreakdownJson  TEXT
    );
  ''');

  store.execute('''
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
  ''');
}
