import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/database/native/eatery_store_isolate.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EateryStoreIsolate store;

  setUp(() async {
    store = await EateryStoreIsolate.open(':memory:');
    final schema = await rootBundle.loadString('assets/db/schema.sql');
    await store.execute(schema);
  });

  tearDown(() => store.close());

  test('version returns a string', () async {
    final v = await store.version;
    expect(v, contains('sqlite'));
  });

  test('insert + query round-trip', () async {
    await store.execute(
      'INSERT INTO product (name, mrpPrice, type, isActive) VALUES (?,?,?,?)',
      ['Latte', 4.5, 0, 1],
    );
    final rows = await store.query('SELECT * FROM product');
    expect(rows, hasLength(1));
    expect(rows.first['name'], 'Latte');
    expect(rows.first['mrpPrice'], 4.5);
  });

  test('queryScalar works across isolate', () async {
    await store.execute(
      'INSERT INTO product (name, mrpPrice, type, isActive) VALUES (?,?,?,?)',
      ['Test', 1.0, 0, 1],
    );
    final id = await store.queryScalar('SELECT last_insert_rowid()');
    expect(id, 1);
  });

  test('transaction commits', () async {
    await store.transaction([
      {
        'sql':
            "INSERT INTO product (name, mrpPrice, type, isActive) VALUES ('A',1.0,0,1)",
        'params': null,
      },
      {
        'sql':
            "INSERT INTO product (name, mrpPrice, type, isActive) VALUES ('B',2.0,0,1)",
        'params': null,
      },
    ]);
    final count = await store.queryScalar('SELECT COUNT(*) FROM product');
    expect(count, 2);
  });

  test('error surfaces as EateryStoreException', () async {
    await expectLater(
      store.query('SELECT * FROM nonexistent'),
      throwsA(isA<EateryStoreException>()),
    );
  });
}
