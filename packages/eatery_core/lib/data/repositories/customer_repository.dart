import 'package:eatery_core/data/models/eatery_db.dart';

abstract class CustomerRepository {
  List<Customer> getAllCustomers();
  List<Customer> getCustomersPage(int limit, int offset);
  int getCustomerCount();
  Customer? getCustomerByPhone(String phone);
  Future<int> saveCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
  double getOutstandingAmount(String phone);
}
