import 'package:eatery_core/data/database/native/eatery_store.dart';

/// Loads demo data into the SQLite store for evaluation purposes.
class SeedData {
  /// Loads all demo data. Idempotent — safe to call multiple times.
  static Future<void> load(EateryStore store) async {
    // Check if data already exists
    final existing = store.queryScalar('SELECT COUNT(*) FROM product');
    if (existing is int && existing > 0) return;

    // Create admin employee with PIN 1234
    store.execute(
      'INSERT INTO employee (name, phone, pin, type, isActive) VALUES (?,?,?,?,?)',
      ['Admin', 'admin', '1234', 4, 1],
    );

    // Create demo company
    store.execute(
      'INSERT INTO company (name, email, phone, address, edition, currencyCode) '
      'VALUES (?,?,?,?,?,?)',
      [
        'Demo Restaurant',
        'demo@eatery.app',
        '555-0100',
        '123 Main St, City',
        -1,
        'USD',
      ],
    );

    // Product categories
    final catNames = ['Beverages', 'Starters', 'Main Course', 'Desserts'];
    for (var i = 0; i < catNames.length; i++) {
      store.execute('INSERT INTO product_category (name) VALUES (?)', [
        catNames[i],
      ]);
    }

    // Products
    final products = [
      ['Coffee', 1, 3.50, 0],
      ['Tea', 1, 2.50, 0],
      ['Soda', 1, 2.00, 0],
      ['Nachos', 2, 6.00, 0],
      ['Spring Rolls', 2, 7.00, 0],
      ['Burger', 3, 10.00, 0],
      ['Pizza', 3, 14.00, 0],
      ['Pasta', 3, 12.00, 0],
      ['Ice Cream', 4, 5.00, 0],
      ['Cheesecake', 4, 7.00, 1],
    ];
    for (final p in products) {
      store.execute(
        'INSERT INTO product (name, categoryId, mrpPrice, type, isActive, foodType) '
        'VALUES (?,?,?,?,?,?)',
        [p[0], p[1], p[2], 0, 1, p[3]],
      );
    }

    // Dining table categories
    final tableCats = ['Window', 'Patio', 'Bar'];
    for (final c in tableCats) {
      store.execute(
        'INSERT INTO dining_table_category (name, isActive) VALUES (?,?)',
        [c, 1],
      );
    }

    // Dining tables
    for (var i = 1; i <= 8; i++) {
      final catId = ((i - 1) % 3) + 1;
      store.execute(
        'INSERT INTO dining_table (name, categoryId, capacity, status) '
        'VALUES (?,?,?,?)',
        ['Table $i', catId, 4, 0],
      );
    }

    // Tax slabs
    store.execute('INSERT INTO tax_slab (name, rate, type) VALUES (?,?,?)', [
      'GST 5%',
      5.0,
      0,
    ]);
    store.execute('INSERT INTO tax_slab (name, rate, type) VALUES (?,?,?)', [
      'GST 12%',
      12.0,
      0,
    ]);

    // Employees
    store.execute(
      'INSERT INTO employee (name, phone, pin, type, isActive) VALUES (?,?,?,?,?)',
      ['Waiter 1', '555-0101', '1111', 0, 1],
    );
    store.execute(
      'INSERT INTO employee (name, phone, pin, type, isActive) VALUES (?,?,?,?,?)',
      ['Chef 1', '555-0102', '2222', 1, 1],
    );

    // Customers
    store.execute(
      'INSERT INTO customer (name, phone, isActive) VALUES (?,?,?)',
      ['John Doe', '555-0200', 1],
    );
    store.execute(
      'INSERT INTO customer (name, phone, isActive) VALUES (?,?,?)',
      ['Jane Smith', '555-0201', 1],
    );

    // KDS stations
    store.execute(
      'INSERT INTO kds_station (name, sortOrder, isActive) VALUES (?,?,?)',
      ['Main Kitchen', 0, 1],
    );
    store.execute(
      'INSERT INTO kds_station (name, sortOrder, isActive) VALUES (?,?,?)',
      ['Pantry', 1, 1],
    );
  }
}
