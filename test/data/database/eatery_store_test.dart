import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// Validates the libeaterystore native library end-to-end through the Dart
/// FFI wrapper. Uses an in-memory SQLite database so no files are touched.
///
/// Requires the dev build of the native lib:
///   (cd libeaterystore && zig build shared-lib)
void main() {
  late EateryStore store;

  setUp(() {
    store = EateryStore.open(':memory:');
    store.execute('''
      CREATE TABLE product (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT NOT NULL,
        price       REAL NOT NULL,
        active      INTEGER NOT NULL DEFAULT 1,
        description TEXT
      );
    ''');
  });

  tearDown(() => store.close());

  test('reports a version', () {
    expect(store.version, contains('sqlite'));
  });

  test('insert + query round-trip with mixed types', () {
    final affected = store.execute(
      'INSERT INTO product (name, price, active, description) VALUES (?, ?, ?, ?)',
      ['Espresso', 3.5, true, null],
    );
    expect(affected, 1);

    final rows = store.query('SELECT * FROM product');
    expect(rows, hasLength(1));

    final row = rows.first;
    expect(row['id'], 1);
    expect(row['name'], 'Espresso');
    expect(row['price'], 3.5);
    expect(row['active'], 1); // bool encoded as int
    expect(row['description'], isNull);
  });

  test('parameterized query filters rows', () {
    store.execute('INSERT INTO product (name, price) VALUES (?, ?)', [
      'A',
      1.0,
    ]);
    store.execute('INSERT INTO product (name, price) VALUES (?, ?)', [
      'B',
      2.0,
    ]);
    store.execute('INSERT INTO product (name, price) VALUES (?, ?)', [
      'C',
      3.0,
    ]);

    final rows = store.query(
      'SELECT name FROM product WHERE price >= ? ORDER BY price DESC',
      [2.0],
    );
    expect(rows.map((r) => r['name']), ['C', 'B']);
  });

  test('last_insert_rowid via queryScalar', () {
    store.execute('INSERT INTO product (name, price) VALUES (?, ?)', [
      'X',
      9.0,
    ]);
    final id = store.queryScalar('SELECT last_insert_rowid()');
    expect(id, 1);
  });

  test('UPDATE returns affected rows', () {
    store.execute('INSERT INTO product (name, price) VALUES (?, ?)', [
      'Y',
      1.0,
    ]);
    final affected = store.execute(
      'UPDATE product SET price = ? WHERE name = ?',
      [5.0, 'Y'],
    );
    expect(affected, 1);
    expect(
      store.queryScalar('SELECT price FROM product WHERE name = ?', ['Y']),
      5.0,
    );
  });

  test('escapes special characters in text', () {
    store.execute('INSERT INTO product (name, price) VALUES (?, ?)', [
      'Tom\'s "Special"\n\tCombo',
      4.0,
    ]);
    final rows = store.query('SELECT name FROM product');
    expect(rows.first['name'], 'Tom\'s "Special"\n\tCombo');
  });

  test('invalid SQL surfaces a native error', () {
    expect(
      () => store.query('SELECT * FROM does_not_exist'),
      throwsA(isA<EateryStoreException>()),
    );
  });

  test('setKey is callable (no-op on plain SQLite)', () {
    // Encryption (SQLCipher) is an optional build-time feature.
    // With plain SQLite the call is a no-op — we verify it doesn't throw.
    expect(() => store.setKey('test-key-12345'), returnsNormally);
  });

  test('vacuum and optimize are callable', () {
    // Maintenance operations on an in-memory database: verify they don't throw.
    expect(() => store.vacuum(), returnsNormally);
    expect(() => store.optimize(), returnsNormally);
  });
}
