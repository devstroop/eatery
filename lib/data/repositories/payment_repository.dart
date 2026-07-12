import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

class PaymentRepository {
  PaymentRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  List<Payment> getAllPayments() => _db.paymentBox.values.toList();
  List<Payment> getPaymentsByOrder(int orderId) =>
      _db.paymentBox.values.where((p) => p.orderId == orderId).toList();
  Future<int> savePayment(Payment payment) async {
    if (payment.id != null && _db.paymentBox.containsKey(payment.id)) {
      await payment.save();
      return payment.id!;
    }
    return await _db.paymentBox.add(payment);
  }
}
