import 'package:eatery_core/data/models/eatery_db.dart';
abstract class OrderRepository {
  List<Order> getAllOrders();
  Order? getOrderById(int id);
  List<OrderProduct> getOrderProducts(int orderId);
  Future<int> saveOrder(Order order);
  Future<void> saveOrderProduct(OrderProduct op);
  Future<int> addOrderProduct(OrderProduct op);
  Future<void> deleteOrder(Order order);
}
