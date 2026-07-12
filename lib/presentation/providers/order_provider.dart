import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/repositories/order_repository.dart';
import 'package:eatery/data/repositories/product_repository.dart';
import 'package:eatery/data/repositories/customer_repository.dart';
import 'package:eatery/data/repositories/tax_repository.dart';
import 'package:eatery/data/repositories/dining_table_repository.dart';
import 'package:eatery/data/repositories/payment_repository.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

// Repository providers
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return OrderRepository(db: db);
});
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return CustomerRepository(db: db);
});
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return PaymentRepository(db: db);
});
final taxRepositoryProvider = Provider<TaxRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return TaxRepository(db: db);
});
final diningTableRepositoryProvider = Provider<DiningTableRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return DiningTableRepository(db: db);
});
