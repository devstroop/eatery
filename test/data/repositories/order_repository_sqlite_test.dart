import 'package:eatery_core/data/database/native/eatery_schema.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/order_repository_sqlite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SqliteOrderRepository', () {
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
      String? phone,
      OrderType type = OrderType.dine,
      double grand = 10.0,
      int qty = 1,
    }) => Order(
      customerPhone: phone,
      type: type,
      createdAt: DateTime.now(),
      totalQuantity: qty,
      subTotal: grand,
      discountTotal: 0,
      taxTotal: 0,
      finalTotal: grand,
      roundOff: 0,
      grandTotal: grand,
    );

    OrderProduct makeLine(int? orderId, {String name = 'Latte', int qty = 1}) =>
        OrderProduct(
          orderId: orderId,
          productId: 1,
          productName: name,
          quantity: qty,
          price: 5.0,
          subTotal: 5.0 * qty,
          total: 5.0 * qty,
        );

    test('saveOrder inserts, assigns id, round-trips fields', () async {
      final o = makeOrder(
        phone: '555-1',
        type: OrderType.delivery,
        grand: 42.5,
      );
      final id = await repo.saveOrder(o);

      expect(id, greaterThan(0));

      final fetched = repo.getOrderById(id)!;
      expect(fetched.customerPhone, '555-1');
      expect(fetched.type, OrderType.delivery);
      expect(fetched.grandTotal, 42.5);
      expect(fetched.grandTotal, isA<double>());
      expect(fetched.status, OrderStatus.pending);
      expect(fetched.createdAt, isNotNull);
    });

    test(
      'multiple new orders get distinct ids (no provisional-id collision)',
      () async {
        final ids = <int>{};
        for (var i = 0; i < 5; i++) {
          ids.add(await repo.saveOrder(makeOrder(phone: 'p$i')));
        }
        expect(ids, hasLength(5));
        expect(repo.getAllOrders(), hasLength(5));
      },
    );

    test('update mutates the existing order (no duplicate)', () async {
      final o = makeOrder(grand: 10);
      final id = await repo.saveOrder(o);

      final updated = o.copyWith(
        status: OrderStatus.completed,
        grandTotal: 12.0,
        id: id,
      );
      final id2 = await repo.saveOrder(updated);

      expect(id2, id);
      expect(repo.getAllOrders(), hasLength(1));
      final fetched = repo.getOrderById(id)!;
      expect(fetched.status, OrderStatus.completed);
      expect(fetched.grandTotal, 12.0);
    });

    test('addOrderProduct + getOrderProducts filters by orderId', () async {
      final a = await repo.saveOrder(makeOrder(phone: 'a'));
      final b = await repo.saveOrder(makeOrder(phone: 'b'));

      await repo.addOrderProduct(makeLine(a, name: 'A1'));
      await repo.addOrderProduct(makeLine(a, name: 'A2'));
      await repo.addOrderProduct(makeLine(b, name: 'B1'));

      expect(repo.getOrderProducts(a).map((l) => l.productName), ['A1', 'A2']);
      expect(repo.getOrderProducts(b).map((l) => l.productName), ['B1']);
    });

    test('addOrderProduct assigns id to the line item', () async {
      final o = await repo.saveOrder(makeOrder());
      final line = makeLine(o);
      final id = await repo.addOrderProduct(line);
      expect(id, greaterThan(0));
    });

    test('saveOrderProduct updates an existing line', () async {
      final o = await repo.saveOrder(makeOrder());
      final line = makeLine(o, name: 'Tea', qty: 1);
      final lineId = await repo.addOrderProduct(line);

      final updated = line.copyWith(quantity: 3, total: 15.0, id: lineId);
      await repo.saveOrderProduct(updated);

      final lines = repo.getOrderProducts(o);
      expect(lines, hasLength(1));
      expect(lines.first.quantity, 3);
      expect(lines.first.total, 15.0);
    });

    test(
      'deleteOrder cascade-deletes its line items (FK ON DELETE CASCADE)',
      () async {
        final o = makeOrder();
        final id = await repo.saveOrder(o);
        await repo.addOrderProduct(makeLine(id, name: 'X'));
        await repo.addOrderProduct(makeLine(id, name: 'Y'));
        expect(repo.getOrderProducts(id), hasLength(2));

        await repo.deleteOrder(o.copyWith(id: id));

        expect(repo.getOrderById(id), isNull);
        expect(repo.getOrderProducts(id), isEmpty);
        expect(store.queryScalar('SELECT COUNT(*) FROM order_product'), 0);
      },
    );

    test('transaction commits on success', () {
      store.transaction(() {
        store.execute(
          'INSERT INTO orders (createdAt, totalQuantity, subTotal, discountTotal, '
          'taxTotal, finalTotal, roundOff, grandTotal, type) '
          'VALUES (?,?,?,?,?,?,?,?,?)',
          [DateTime.now().millisecondsSinceEpoch, 1, 1.0, 0, 0, 1.0, 0, 1.0, 0],
        );
      });
      expect(store.queryScalar('SELECT COUNT(*) FROM orders'), 1);
    });

    test('transaction rolls back on error', () {
      expect(
        () => store.transaction(() {
          store.execute(
            'INSERT INTO orders (createdAt, totalQuantity, subTotal, discountTotal, '
            'taxTotal, finalTotal, roundOff, grandTotal, type) '
            'VALUES (?,?,?,?,?,?,?,?,?)',
            [
              DateTime.now().millisecondsSinceEpoch,
              1,
              1.0,
              0,
              0,
              1.0,
              0,
              1.0,
              0,
            ],
          );
          throw StateError('boom');
        }),
        throwsA(isA<StateError>()),
      );
      // The insert must have been rolled back.
      expect(store.queryScalar('SELECT COUNT(*) FROM orders'), 0);
    });
  });
}
