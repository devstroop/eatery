import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/repositories/order_repository.dart';
import 'package:eatery_core/data/repositories/order_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/customer_repository.dart';
import 'package:eatery_core/data/repositories/customer_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/tax_repository.dart';
import 'package:eatery_core/data/repositories/tax_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/dining_table_repository.dart';
import 'package:eatery_core/data/repositories/dining_table_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/payment_repository.dart';
import 'package:eatery_core/data/repositories/payment_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/staff_repository.dart';
import 'package:eatery_core/data/repositories/staff_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/subscription_repository.dart';
import 'package:eatery_core/data/repositories/modifier_repository.dart';
import 'package:eatery_core/data/repositories/modifier_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/inventory_repository.dart';
import 'package:eatery_core/data/repositories/subscription_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/sqlite_preference_store.dart';
import 'package:eatery_core/providers/database_provider.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return SqliteOrderRepository(store: ref.read(eateryStoreProvider));
});
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return SqliteCustomerRepository(
    store: ref.read(eateryStoreProvider),
    db: ref.read(appDatabaseProvider),
  );
});
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return SqlitePaymentRepository(store: ref.read(eateryStoreProvider));
});
final taxRepositoryProvider = Provider<TaxRepository>((ref) {
  return SqliteTaxRepository(store: ref.read(eateryStoreProvider));
});
final diningTableRepositoryProvider = Provider<DiningTableRepository>((ref) {
  return SqliteDiningTableRepository(store: ref.read(eateryStoreProvider));
});
final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return SqliteStaffRepository(store: ref.read(eateryStoreProvider));
});
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SqliteSubscriptionRepository(store: ref.read(eateryStoreProvider));
});
final sqlitePreferenceStoreProvider = Provider<SqlitePreferenceStore>((ref) {
  return SqlitePreferenceStore(store: ref.read(eateryStoreProvider));
});
final modifierRepositoryProvider = Provider<ModifierRepository>((ref) {
  return SqliteModifierRepository(store: ref.read(eateryStoreProvider));
});
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.read(eateryStoreProvider));
});
