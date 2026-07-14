import 'package:eatery_core/eatery_core.dart';
import 'package:flutter_test/flutter_test.dart';

final _schema = '''
CREATE TABLE IF NOT EXISTS op_log (
  clock INTEGER PRIMARY KEY,
  value TEXT NOT NULL
);
''';

void main() {
  group('OpLogService', () {
    late EateryStore store;
    late OpLogService svc;

    setUp(() {
      store = EateryStore.open(':memory:');
      store.execute(_schema);
      svc = OpLogService(store: store, deviceId: 'test-device');
    });

    tearDown(() {
      store.close();
    });

    test('clock starts at max clock in table (0 for empty)', () {
      expect(svc.clock, 0);
    });

    test('commit creates entry and advances clock', () {
      final entry = svc.commit(
        entityType: 'product',
        entityId: 1,
        operation: 'create',
        data: {'name': 'Latte', 'price': 4.5},
      );
      expect(entry.id, 'test-device_1');
      expect(entry.entityType, 'product');
      expect(entry.entityId, 1);
      expect(entry.operation, 'create');
      expect(entry.data['name'], 'Latte');
      expect(svc.clock, 1);
      expect(svc.entryCount, 1);
    });

    test('commit uses INSERT OR REPLACE (same clock is idempotent)', () {
      svc.commit(
        entityType: 'product',
        entityId: 1,
        operation: 'create',
        data: {'name': 'Tea'},
      );
      // Manually re-insert with clock=1 to simulate retry
      store.execute(
        'INSERT OR REPLACE INTO op_log (clock, value) VALUES (?, ?)',
        [1, '{"entityType":"product"}'],
      );
      expect(svc.entryCount, 1);
    });

    test('getEntriesSince returns only entries with clock > sinceClock', () {
      svc.commit(entityType: 'a', entityId: 1, operation: 'c', data: {});
      svc.commit(entityType: 'b', entityId: 2, operation: 'c', data: {});
      svc.commit(entityType: 'c', entityId: 3, operation: 'c', data: {});

      final entries = svc.getEntriesSince(1);
      expect(entries, hasLength(2));
      expect(entries[0].entityType, 'b');
      expect(entries[1].entityType, 'c');
    });

    test('getAllEntries returns all entries in clock order', () {
      svc.commit(entityType: 'z', entityId: 1, operation: 'c', data: {});
      svc.commit(entityType: 'a', entityId: 2, operation: 'c', data: {});

      final all = svc.getAllEntries();
      expect(all, hasLength(2));
      expect(all[0].entityType, 'z');
      expect(all[1].entityType, 'a');
    });

    test('applyBatch adds entries with incremented clocks', () {
      final entries = [
        OpLogEntry(
          id: 'remote_1',
          entityType: 'product',
          entityId: 10,
          operation: 'create',
          data: {'name': 'Burger'},
          timestamp: 1000,
          deviceId: 'remote-device',
        ),
        OpLogEntry(
          id: 'remote_2',
          entityType: 'product',
          entityId: 11,
          operation: 'create',
          data: {'name': 'Fries'},
          timestamp: 1001,
          deviceId: 'remote-device',
        ),
      ];

      svc.applyBatch(entries);
      expect(svc.clock, 2);
      expect(svc.entryCount, 2);

      // Local clock was used, not remote
      final all = svc.getAllEntries();
      expect(all[0].data['name'], 'Burger');
      expect(all[1].data['name'], 'Fries');
    });

    test('advanceClockTo only accepts forward moves', () {
      expect(svc.clock, 0);
      svc.advanceClockTo(5);
      expect(svc.clock, 5);
      svc.advanceClockTo(3); // backward, ignored
      expect(svc.clock, 5);
    });

    test('rebuildState returns null for deleted entity', () {
      svc.commit(
        entityType: 'product',
        entityId: 1,
        operation: 'create',
        data: {'name': 'Cake'},
      );
      svc.commit(
        entityType: 'product',
        entityId: 1,
        operation: 'delete',
        data: {},
      );

      final state = svc.rebuildState('product', 1);
      expect(state, isNull);
    });

    test('rebuildState returns last snapshot for non-deleted entity', () {
      svc.commit(
        entityType: 'product',
        entityId: 1,
        operation: 'create',
        data: {'name': 'Cake', 'price': 3.0},
      );
      svc.commit(
        entityType: 'product',
        entityId: 1,
        operation: 'update',
        data: {'name': 'Cake', 'price': 3.5},
      );

      final state = svc.rebuildState('product', 1);
      expect(state, isNotNull);
      expect(state!['price'], 3.5);
    });

    test('rebuildState returns null for non-existent entity', () {
      final state = svc.rebuildState('product', 999);
      expect(state, isNull);
    });
  });
}
