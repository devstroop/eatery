import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

class OrderRepository {
  OrderRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  List<Order> getAllOrders() => _db.orderBox.values.toList();
  Order? getOrderById(int id) {
    try {
      return _db.orderBox.values.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  List<OrderProduct> getOrderProducts(int orderId) =>
      _db.orderProductBox.values.where((op) => op.id == orderId).toList();
  Future<int> saveOrder(Order order) async {
    if (order.id != null && _db.orderBox.containsKey(order.id)) {
      await order.save();
      return order.id!;
    }
    return await _db.orderBox.add(order);
  }

  Future<void> saveOrderProduct(OrderProduct op) async => await op.save();
  Future<int> addOrderProduct(OrderProduct op) async =>
      await _db.orderProductBox.add(op);
  Future<void> deleteOrder(Order order) async => await order.delete();
}
