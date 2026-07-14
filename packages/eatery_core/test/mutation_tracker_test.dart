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
''';

void main() {
  group('MutationTracker', () {
    late EateryStore store;
    late SyncCoordinator coordinator;

    setUp(() {
      store = EateryStore.open(':memory:');
      store.execute(_schema);

      // Standalone coordinator — no WS, just mutation tracking
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

    test('trackSave calls trackMutation with correct entity', () {
      final product = Product(
        id: 1,
        name: 'Espresso',
        mrpPrice: 3.5,
        type: ProductType.kitchenDish,
        isActive: true,
      );

      MutationTracker.trackSave(
        coordinator: coordinator,
        entityType: 'product',
        entity: product,
      );

      final entries = coordinator.opLogService.getAllEntries();
      expect(entries, hasLength(1));
      expect(entries.first.entityType, 'product');
      expect(entries.first.entityId, 1);
      expect(entries.first.operation, 'create');
      expect(entries.first.data['name'], 'Espresso');
    });

    test('trackSave with previous entity logs an update', () {
      final before = Product(
        id: 1,
        name: 'Old Name',
        mrpPrice: 2.0,
        type: ProductType.kitchenDish,
        isActive: true,
      );
      final after = Product(
        id: 1,
        name: 'New Name',
        mrpPrice: 2.5,
        type: ProductType.kitchenDish,
        isActive: true,
      );

      MutationTracker.trackSave(
        coordinator: coordinator,
        entityType: 'product',
        entity: after,
        previousEntity: before,
      );

      final entries = coordinator.opLogService.getAllEntries();
      expect(entries, hasLength(1));
      expect(entries.first.operation, 'update');
      expect(entries.first.data['name'], 'New Name');
      expect(entries.first.prevData!['name'], 'Old Name');
    });

    test('trackDelete logs a delete op', () {
      MutationTracker.trackDelete(
        coordinator: coordinator,
        entityType: 'product',
        entityId: 42,
        lastData: {'name': 'Deleted Item'},
      );

      final entries = coordinator.opLogService.getAllEntries();
      expect(entries, hasLength(1));
      expect(entries.first.entityType, 'product');
      expect(entries.first.entityId, 42);
      expect(entries.first.operation, 'delete');
    });
  });
}
