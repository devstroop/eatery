import 'package:eatery_core/eatery_core.dart';
import 'package:flutter_test/flutter_test.dart';

final _schema = '''
CREATE TABLE IF NOT EXISTS op_log (
  clock INTEGER PRIMARY KEY,
  value TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS product (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  mrpPrice REAL NOT NULL,
  type INTEGER NOT NULL,
  isActive INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  status INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS unknown_entity (
  id INTEGER PRIMARY KEY
);
''';

/// Creates a standalone coordinator and uses [SyncService.receiveEntries] to
/// exercise the private [_applyEntry] path.
void main() {
  group('SyncCoordinator._applyEntry', () {
    late EateryStore store;
    late SyncCoordinator coordinator;

    setUp(() {
      store = EateryStore.open(':memory:');
      store.execute(_schema);

      coordinator = SyncCoordinator(
        store: store,
        deviceId: 'test-device',
        isHost: false,
      );
    });

    tearDown(() async {
      await coordinator.dispose();
      store.close();
    });

    OpLogEntry _entry({
      required String entityType,
      required int entityId,
      String operation = 'save',
      Map<String, dynamic> data = const {},
    }) {
      return OpLogEntry(
        id: 'test_${entityType}_$entityId',
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        data: data,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        deviceId: 'remote',
      );
    }

    test('inserts a product row from entry data', () {
      final entry = _entry(
        entityType: 'product',
        entityId: 1,
        data: {'name': 'Mocha', 'mrpPrice': 5.5, 'type': 0, 'isActive': 1},
      );

      coordinator.syncService.receiveEntries([entry]);

      final rows = store.query('SELECT * FROM product WHERE id = ?', [1]);
      expect(rows, hasLength(1));
      expect(rows.first['name'], 'Mocha');
      expect((rows.first['mrpPrice'] as num).toDouble(), 5.5);
    });

    test('deletes a product row on delete operation', () {
      // First insert a row
      store.execute(
        'INSERT INTO product (id, name, mrpPrice, type, isActive) '
        'VALUES (?, ?, ?, ?, ?)',
        [1, 'To Delete', 1.0, 0, 1],
      );

      // Then delete via sync
      final entry = _entry(
        entityType: 'product',
        entityId: 1,
        operation: 'delete',
      );
      coordinator.syncService.receiveEntries([entry]);

      final rows = store.query('SELECT * FROM product WHERE id = ?', [1]);
      expect(rows, isEmpty);
    });

    test('updates existing row via INSERT OR REPLACE', () {
      // Pre-insert a row
      store.execute(
        'INSERT INTO product (id, name, mrpPrice, type, isActive) '
        'VALUES (?, ?, ?, ?, ?)',
        [1, 'Original', 2.0, 0, 1],
      );

      // Apply update via sync
      final entry = _entry(
        entityType: 'product',
        entityId: 1,
        data: {'name': 'Updated', 'mrpPrice': 3.0, 'type': 0, 'isActive': 1},
      );
      coordinator.syncService.receiveEntries([entry]);

      final rows = store.query('SELECT * FROM product WHERE id = ?', [1]);
      expect(rows, hasLength(1));
      expect(rows.first['name'], 'Updated');
      expect((rows.first['mrpPrice'] as num).toDouble(), 3.0);
    });

    test('maps order entityType to orders table', () {
      final entry = _entry(
        entityType: 'order',
        entityId: 1,
        data: {'status': 1},
      );
      coordinator.syncService.receiveEntries([entry]);

      final rows = store.query('SELECT * FROM orders WHERE id = ?', [1]);
      expect(rows, hasLength(1));
      expect(rows.first['status'], 1);
    });

    test('rejects unknown entity types silently', () {
      // This should produce a debugPrint but not crash and not insert
      final entry = _entry(
        entityType: 'unknown_entity',
        entityId: 1,
        data: {'name': 'Should not appear'},
      );

      // Should not throw
      coordinator.syncService.receiveEntries([entry]);

      final rows = store.query('SELECT * FROM unknown_entity');
      expect(rows, isEmpty);
    });

    test('handles void operation as delete', () {
      store.execute(
        'INSERT INTO product (id, name, mrpPrice, type, isActive) '
        'VALUES (?, ?, ?, ?, ?)',
        [1, 'Void Me', 1.0, 0, 1],
      );

      final entry = _entry(
        entityType: 'product',
        entityId: 1,
        operation: 'void',
      );
      coordinator.syncService.receiveEntries([entry]);

      final rows = store.query('SELECT * FROM product WHERE id = ?', [1]);
      expect(rows, isEmpty);
    });
  });
}
