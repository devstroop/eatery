import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

class CustomerRepository {
  CustomerRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  List<Customer> getAllCustomers() => _db.customerBox.values.toList();
  Customer? getCustomerByPhone(String phone) {
    try {
      return _db.customerBox.values.firstWhere((c) => c.phone == phone);
    } catch (_) {
      return null;
    }
  }

  Future<int> saveCustomer(Customer customer) async {
    if (customer.id != null && _db.customerBox.containsKey(customer.id)) {
      await customer.save();
      return customer.id!;
    }
    return await _db.customerBox.add(customer);
  }

  double getOutstandingAmount(String phone) {
    double amount = 0;
    for (var order in _db.orderBox.values.where(
      (o) => o.customerPhone == phone,
    )) {
      var payments = _db.paymentBox.values.where((p) => p.orderId == order.id);
      if (payments.isNotEmpty) {
        amount +=
            order.grandTotal -
            payments.map((e) => e.amount).reduce((a, b) => a + b);
      } else {
        amount += order.grandTotal;
      }
    }
    return amount;
  }
}
