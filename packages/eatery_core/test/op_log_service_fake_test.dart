import 'package:eatery_core/eatery_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_eatery_store.dart';

/// Pure-Dart tests of [OpLogService] using a [FakeEateryStore] — no native
/// library needed. These focus on OpLogService logic (clock management, entry
/// filtering) rather than SQL correctness.
void main() {
  group('OpLogService (FakeEateryStore)', () {
    late FakeEateryStore store;
    late OpLogService svc;

    setUp(() {
      store = FakeEateryStore();
      svc = OpLogService(store: store, deviceId: 'test-device');
    });

    test('clock starts at 0 for empty store', () {
      expect(svc.clock, 0);
    });

    test('commit creates entry with incremented clock', () {
      final entry = svc.commit(
        entityType: 'product',
        entityId: 1,
        operation: 'create',
        data: {'name': 'Latte'},
      );
      expect(entry.id, 'test-device_1');
      expect(svc.clock, 1);
      expect(svc.entryCount, 1);

      final all = svc.getAllEntries();
      expect(all, hasLength(1));
      expect(all.first.data['name'], 'Latte');
    });

    test('getEntriesSince filters by clock', () {
      svc.commit(entityType: 'a', entityId: 1, operation: 'c', data: {});
      svc.commit(entityType: 'b', entityId: 2, operation: 'c', data: {});
      svc.commit(entityType: 'c', entityId: 3, operation: 'c', data: {});

      expect(svc.getEntriesSince(1), hasLength(2));
      expect(svc.getEntriesSince(0), hasLength(3));
      expect(svc.getEntriesSince(3), isEmpty);
    });

    test('applyBatch increments clock for each entry', () {
      svc.applyBatch([
        OpLogEntry(
          id: 'r1',
          entityType: 'product',
          entityId: 1,
          operation: 'create',
          data: {},
          timestamp: 1000,
          deviceId: 'remote',
        ),
        OpLogEntry(
          id: 'r2',
          entityType: 'product',
          entityId: 2,
          operation: 'create',
          data: {},
          timestamp: 1001,
          deviceId: 'remote',
        ),
      ]);
      expect(svc.clock, 2);
      expect(svc.entryCount, 2);
    });

    test('advanceClockTo only accepts forward moves', () {
      svc.advanceClockTo(10);
      expect(svc.clock, 10);
      svc.advanceClockTo(5);
      expect(svc.clock, 10); // unchanged
    });

    test('rebuildState returns last snapshot', () {
      svc.commit(
        entityType: 'order',
        entityId: 1,
        operation: 'create',
        data: {'status': 'new'},
      );
      svc.commit(
        entityType: 'order',
        entityId: 1,
        operation: 'update',
        data: {'status': 'paid'},
      );

      final state = svc.rebuildState('order', 1);
      expect(state, isNotNull);
      expect(state!['status'], 'paid');
    });

    test('rebuildState returns null for deleted entity', () {
      svc.commit(
        entityType: 'order',
        entityId: 1,
        operation: 'create',
        data: {'status': 'new'},
      );
      svc.commit(
        entityType: 'order',
        entityId: 1,
        operation: 'delete',
        data: {},
      );

      expect(svc.rebuildState('order', 1), isNull);
    });

    test('rebuildState returns null for non-existent entity', () {
      expect(svc.rebuildState('product', 999), isNull);
    });
  });
}
