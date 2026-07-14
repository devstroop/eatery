import 'package:eatery_core/data/models/eatery_db.dart';
abstract class OrderRepository {
  List<Order> getAllOrders();
  List<Order> getOrdersPage(int limit, int offset);
  int getOrderCount();
  Order? getOrderById(int id);
  List<OrderProduct> getOrderProducts(int orderId);
  Future<int> saveOrder(Order order);
  Future<void> saveOrderProduct(OrderProduct op);
  Future<int> addOrderProduct(OrderProduct op);
  Future<void> deleteOrder(Order order);
  List<OrderStatusHistory> getStatusHistory(int orderId);
  Future<void> recordStatusTransition(OrderStatusHistory transition);
  void adjustStock(int productId, int quantity);
}
