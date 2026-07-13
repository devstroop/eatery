import 'dart:io';

import 'package:eatery_core/eatery_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal SQL schema for testing.
const _testSchema = '''
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

CREATE TABLE IF NOT EXISTS op_log (
  clock INTEGER PRIMARY KEY,
  value TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS app_config (
  key TEXT PRIMARY KEY,
  value TEXT
);
''';

void main() {
  late Directory tmpDir;
  late EateryStore hostStore;
  late EateryStore leafStore;
  late int port;
  late SyncCoordinator hostCoordinator;
  late SyncCoordinator leafCoordinator;

  setUp(() async {
    tmpDir = Directory.systemTemp.createTempSync('eatery_sync_e2e_');

    hostStore = EateryStore.open('${tmpDir.path}/host.db');
    leafStore = EateryStore.open('${tmpDir.path}/leaf.db');
    initEaterySchema(hostStore, _testSchema);
    initEaterySchema(leafStore, _testSchema);

    // Pick a random high port.
    port = 9876 + DateTime.now().millisecondsSinceEpoch.remainder(10000);
  });

  tearDown(() async {
    await Future.wait([
      hostCoordinator.dispose(),
      leafCoordinator.dispose(),
    ]);
    hostStore.close();
    leafStore.close();
    tmpDir.deleteSync(recursive: true);
  });

  /// Helper to wait long enough for a push+broadcast cycle (3s push + 5s
  /// broadcast + buffer).
  Future<void> waitForSync() =>
      Future.delayed(const Duration(seconds: 10));

  /// Helper to start both coordinators and connect leaf to host.
  Future<void> startSync() async {
    hostCoordinator = SyncCoordinator(
      store: hostStore,
      deviceId: 'test-host',
      isHost: true,
      port: port,
    );
    await Future.delayed(const Duration(milliseconds: 200));

    leafCoordinator = SyncCoordinator(
      store: leafStore,
      deviceId: 'test-leaf',
      isHost: false,
      host: 'localhost',
      port: port,
    );
    await Future.delayed(const Duration(milliseconds: 300));
  }

  test('sync replicates a product from host to leaf', () async {
    await startSync();

    // Save a product on the host.
    final repo = SqliteProductRepository(store: hostStore);
    final productId = await repo.saveProduct(Product(
      name: 'Test Burger',
      mrpPrice: 9.99,
      type: ProductType.kitchenDish,
      isActive: true,
    ));

    await waitForSync();

    // Verify the leaf has the product.
    final leafRows = leafStore.query(
      'SELECT * FROM product WHERE id = ?', [productId],
    );
    expect(leafRows, hasLength(1));
    expect(leafRows.first['name'], 'Test Burger');
    expect((leafRows.first['mrpPrice'] as num).toDouble(), 9.99);
    expect(leafRows.first['type'], ProductType.kitchenDish.index);
  });

  test('sync replicates a product from leaf to host', () async {
    await startSync();

    // Save a product on the leaf.
    final repo = SqliteProductRepository(store: leafStore);
    final productId = await repo.saveProduct(Product(
      name: 'Leaf Item',
      mrpPrice: 4.99,
      type: ProductType.kitchenDish,
      isActive: true,
    ));

    await waitForSync();

    // Verify the host has the product.
    final hostRows = hostStore.query(
      'SELECT * FROM product WHERE id = ?', [productId],
    );
    expect(hostRows, hasLength(1));
    expect(hostRows.first['name'], 'Leaf Item');
    expect((hostRows.first['mrpPrice'] as num).toDouble(), 4.99);
  });

  test('sync replicates a delete from host to leaf', () async {
    await startSync();

    // Insert a product on both sides (simulating initial sync state).
    hostStore.execute(
      'INSERT INTO product (id, name, mrpPrice, type, isActive) '
      'VALUES (?, ?, ?, ?, ?)',
      [1, 'To Delete', 5.0, 0, 1],
    );
    leafStore.execute(
      'INSERT INTO product (id, name, mrpPrice, type, isActive) '
      'VALUES (?, ?, ?, ?, ?)',
      [1, 'To Delete', 5.0, 0, 1],
    );

    // Delete on the host via the repository (triggers mutation tracking).
    final repo = SqliteProductRepository(store: hostStore);
    await repo.deleteProduct(Product(
      id: 1,
      name: 'To Delete',
      mrpPrice: 5.0,
      type: ProductType.kitchenDish,
      isActive: true,
    ));

    await waitForSync();

    // Verify the leaf also deleted it.
    final leafRows = leafStore.query(
      'SELECT * FROM product WHERE id = ?', [1],
    );
    expect(leafRows, isEmpty);
  });

  test('sync replicates a delete from leaf to host', () async {
    await startSync();

    // Pre-insert on both sides.
    hostStore.execute(
      'INSERT INTO product (id, name, mrpPrice, type, isActive) '
      'VALUES (?, ?, ?, ?, ?)',
      [2, 'Leaf Delete', 5.0, 0, 1],
    );
    leafStore.execute(
      'INSERT INTO product (id, name, mrpPrice, type, isActive) '
      'VALUES (?, ?, ?, ?, ?)',
      [2, 'Leaf Delete', 5.0, 0, 1],
    );

    // Delete on the leaf.
    final repo = SqliteProductRepository(store: leafStore);
    await repo.deleteProduct(Product(
      id: 2,
      name: 'Leaf Delete',
      mrpPrice: 5.0,
      type: ProductType.kitchenDish,
      isActive: true,
    ));

    await waitForSync();

    // Verify the host also deleted it.
    final hostRows = hostStore.query(
      'SELECT * FROM product WHERE id = ?', [2],
    );
    expect(hostRows, isEmpty);
  });

  test('host pulls pending entries from leaf on reconnect', () async {
    await startSync();

    // Disconnect the leaf.
    await leafCoordinator.dispose();

    // Save a product on the leaf while disconnected (goes into op_log).
    final leafRepo = SqliteProductRepository(store: leafStore);
    final productId = await leafRepo.saveProduct(Product(
      name: 'Offline Item',
      mrpPrice: 7.99,
      type: ProductType.kitchenDish,
      isActive: true,
    ));

    // Reconnect the leaf.
    leafCoordinator = SyncCoordinator(
      store: leafStore,
      deviceId: 'test-leaf',
      isHost: false,
      host: 'localhost',
      port: port,
    );

    await waitForSync();

    // Verify host received the product saved while offline.
    final hostRows = hostStore.query(
      'SELECT * FROM product WHERE id = ?', [productId],
    );
    expect(hostRows, hasLength(1));
    expect(hostRows.first['name'], 'Offline Item');
  });
}
