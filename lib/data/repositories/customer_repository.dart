import 'package:eatery/data/models/eatery_db.dart';
abstract class CustomerRepository {
  List<Customer> getAllCustomers();
  Customer? getCustomerByPhone(String phone);
  Future<int> saveCustomer(Customer customer);
  double getOutstandingAmount(String phone);
}
