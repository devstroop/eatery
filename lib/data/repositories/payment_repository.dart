import 'package:eatery/data/models/eatery_db.dart';
abstract class PaymentRepository {
  List<Payment> getAllPayments();
  List<Payment> getPaymentsByOrder(int orderId);
  Future<int> savePayment(Payment payment);
}
