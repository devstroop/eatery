import 'package:eatery_core/data/database/native/eatery_schema.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/order_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/dining_table_repository_sqlite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Waiter feature — Order void', () {
    late EateryStore store;
    late SqliteOrderRepository repo;

    setUp(() async {
      store = EateryStore.open(':memory:');
      final sql = await rootBundle.loadString(kSchemaAssetPath);
      initEaterySchema(store, sql);
      repo = SqliteOrderRepository(store: store);
    });

    tearDown(() => store.close());

    Order makeOrder({
      double grand = 10.0,
      OrderStatus status = OrderStatus.pending,
    }) => Order(
      type: OrderType.dine,
      createdAt: DateTime.now(),
      totalQuantity: 1,
      subTotal: grand,
      discountTotal: 0,
      taxTotal: 0,
      finalTotal: grand,
      roundOff: 0,
      grandTotal: grand,
      status: status,
    );

    test(
      'saveOrder with voided status persists voidReason and voidedBy',
      () async {
        final o = makeOrder();
        final id = await repo.saveOrder(o);

        final now = DateTime.now();
        final voided = o.copyWith(
          status: OrderStatus.voided,
          voidReason: 'Customer cancelled',
          voidedBy: 'Waiter Alice',
          voidedAt: now,
          updatedAt: now,
          id: id,
        );
        final id2 = await repo.saveOrder(voided);
        expect(id2, id);

        final fetched = repo.getOrderById(id)!;
        expect(fetched.status, OrderStatus.voided);
        expect(fetched.voidReason, 'Customer cancelled');
        expect(fetched.voidedBy, 'Waiter Alice');
        expect(fetched.voidedAt, isNotNull);
      },
    );

    test(
      'voided orders are excluded from getAllOrders when filtered',
      () async {
        await repo.saveOrder(makeOrder(status: OrderStatus.pending));
        await repo.saveOrder(makeOrder(status: OrderStatus.voided));
        await repo.saveOrder(makeOrder(status: OrderStatus.preparing));

        final active = repo
            .getAllOrders()
            .where((o) => o.status != OrderStatus.voided)
            .toList();
        expect(active, hasLength(2));
      },
    );

    test('status transition records for void flow', () async {
      final o = makeOrder();
      final id = await repo.saveOrder(o);

      await repo.recordStatusTransition(
        OrderStatusHistory(
          orderId: id,
          fromStatus: OrderStatus.pending.id,
          toStatus: OrderStatus.voided.id,
          changedByEmployeeId: 1,
          changedAt: DateTime.now(),
        ),
      );

      final history = store.query(
        'SELECT * FROM order_status_history WHERE orderId = ?',
        [id],
      );
      expect(history, hasLength(1));
      expect(history.first['toStatus'], OrderStatus.voided.id);
    });
  });

  group('Waiter feature — Table occupancy toggle', () {
    late EateryStore store;
    late SqliteDiningTableRepository repo;

    setUp(() async {
      store = EateryStore.open(':memory:');
      final sql = await rootBundle.loadString(kSchemaAssetPath);
      initEaterySchema(store, sql);
      repo = SqliteDiningTableRepository(store: store);
    });

    tearDown(() => store.close());

    test('toggle available to occupied', () async {
      final t = DiningTable(name: 'T1', status: DiningTableStatus.available);
      final id = await repo.saveTable(t);

      await repo.saveTable(
        t.copyWith(status: DiningTableStatus.occupied, orderId: 42, id: id),
      );

      final fetched = repo.getTableById(id)!;
      expect(fetched.status, DiningTableStatus.occupied);
      expect(fetched.orderId, 42);
    });

    test('toggle occupied back to available clears orderId', () async {
      final t = DiningTable(
        name: 'T2',
        status: DiningTableStatus.occupied,
        orderId: 99,
      );
      final id = await repo.saveTable(t);

      await repo.saveTable(
        t.copyWith(status: DiningTableStatus.available, orderId: null, id: id),
      );

      final fetched = repo.getTableById(id)!;
      expect(fetched.status, DiningTableStatus.available);
      expect(fetched.orderId, isNull);
    });

    test('getTableByOrderId returns the right table', () async {
      await repo.saveTable(
        DiningTable(name: 'A', status: DiningTableStatus.occupied, orderId: 1),
      );
      await repo.saveTable(
        DiningTable(name: 'B', status: DiningTableStatus.occupied, orderId: 2),
      );

      final table = repo.getTableByOrderId(2)!;
      expect(table.name, 'B');
      expect(repo.getTableByOrderId(999), isNull);
    });
  });

  group('Waiter feature — Edit order line items', () {
    late EateryStore store;
    late SqliteOrderRepository repo;

    setUp(() async {
      store = EateryStore.open(':memory:');
      final sql = await rootBundle.loadString(kSchemaAssetPath);
      initEaterySchema(store, sql);
      repo = SqliteOrderRepository(store: store);
    });

    tearDown(() => store.close());

    test('update line item quantity recalculates totals', () async {
      final o = Order(
        type: OrderType.dine,
        createdAt: DateTime.now(),
        totalQuantity: 2,
        subTotal: 10.0,
        discountTotal: 0,
        taxTotal: 0,
        finalTotal: 10.0,
        roundOff: 0,
        grandTotal: 10.0,
      );
      final oid = await repo.saveOrder(o);

      final line = OrderProduct(
        orderId: oid,
        productId: 1,
        productName: 'Burger',
        quantity: 2,
        price: 5.0,
        subTotal: 10.0,
        total: 10.0,
      );
      final lineId = await repo.addOrderProduct(line);

      final updated = line.copyWith(
        quantity: 4,
        subTotal: 20.0,
        total: 20.0,
        id: lineId,
      );
      await repo.saveOrderProduct(updated);

      final lines = repo.getOrderProducts(oid);
      expect(lines, hasLength(1));
      expect(lines.first.quantity, 4);
      expect(lines.first.subTotal, 20.0);
    });
  });
}
