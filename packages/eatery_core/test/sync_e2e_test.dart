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

  test('sync replicates a product from host to leaf', () async {
    // Start host coordinator.
    hostCoordinator = SyncCoordinator(
      store: hostStore,
      deviceId: 'test-host',
      isHost: true,
      port: port,
    );

    // Small delay so the WS server is listening.
    await Future.delayed(const Duration(milliseconds: 200));

    // Start leaf coordinator (connects to host).
    leafCoordinator = SyncCoordinator(
      store: leafStore,
      deviceId: 'test-leaf',
      isHost: false,
      host: 'localhost',
      port: port,
    );

    // Wait for the WS connection to establish.
    await Future.delayed(const Duration(milliseconds: 300));

    // Use the mutation hook path: save a product via the repository.
    final repo = SqliteProductRepository(store: hostStore);
    final product = Product(
      name: 'Test Burger',
      mrpPrice: 9.99,
      type: ProductType.kitchenDish,
      isActive: true,
    );

    final productId = await repo.saveProduct(product);

    // Wait for sync to propagate.
    await Future.delayed(const Duration(milliseconds: 500));

    // Verify the leaf has the product.
    final leafRows = leafStore.query('SELECT * FROM product WHERE id = ?', [
      productId,
    ]);
    expect(leafRows.length, 1);
    expect(leafRows.first['name'], 'Test Burger');
    expect((leafRows.first['mrpPrice'] as num).toDouble(), 9.99);
    expect(leafRows.first['type'], ProductType.kitchenDish.index);
  });
}
