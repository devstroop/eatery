import 'package:eatery_core/data/models/eatery_db.dart';
abstract class CustomerRepository {
  List<Customer> getAllCustomers();
  Customer? getCustomerByPhone(String phone);
  Future<int> saveCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
  double getOutstandingAmount(String phone);
}
