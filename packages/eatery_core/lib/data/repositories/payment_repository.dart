import 'package:eatery_core/data/models/eatery_db.dart';
abstract class PaymentRepository {
  List<Payment> getAllPayments();
  List<Payment> getPaymentsPage(int limit, int offset);
  int getPaymentCount();
  List<Payment> getPaymentsByOrder(int orderId);
  Future<int> savePayment(Payment payment);
}
