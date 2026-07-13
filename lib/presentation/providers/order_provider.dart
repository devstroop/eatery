import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/database/native/store_config.dart';
import 'package:eatery/data/repositories/order_repository.dart';
import 'package:eatery/data/repositories/order_repository_sqlite.dart';
import 'package:eatery/data/repositories/customer_repository.dart';
import 'package:eatery/data/repositories/customer_repository_sqlite.dart';
import 'package:eatery/data/repositories/tax_repository.dart';
import 'package:eatery/data/repositories/tax_repository_sqlite.dart';
import 'package:eatery/data/repositories/dining_table_repository.dart';
import 'package:eatery/data/repositories/dining_table_repository_sqlite.dart';
import 'package:eatery/data/repositories/payment_repository.dart';
import 'package:eatery/data/repositories/payment_repository_sqlite.dart';
import 'package:eatery/data/repositories/staff_repository.dart';
import 'package:eatery/data/repositories/staff_repository_sqlite.dart';
import 'package:eatery/data/repositories/subscription_repository.dart';
import 'package:eatery/data/repositories/subscription_repository_sqlite.dart';
import 'package:eatery/data/repositories/sqlite_preference_store.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

// Repository providers
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  if (kUseSqliteOrderStore) {
    return SqliteOrderRepository(store: ref.read(eateryStoreProvider));
  }
  final db = ref.read(appDatabaseProvider);
  return OrderRepository(db: db);
});
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  if (kUseSqliteCustomerStore) {
    return SqliteCustomerRepository(
      store: ref.read(eateryStoreProvider),
      db: db,
    );
  }
  return CustomerRepository(db: db);
});
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  if (kUseSqlitePaymentStore) {
    return SqlitePaymentRepository(store: ref.read(eateryStoreProvider));
  }
  final db = ref.read(appDatabaseProvider);
  return PaymentRepository(db: db);
});
final taxRepositoryProvider = Provider<TaxRepository>((ref) {
  if (kUseSqliteTaxStore) {
    return SqliteTaxRepository(store: ref.read(eateryStoreProvider));
  }
  final db = ref.read(appDatabaseProvider);
  return TaxRepository(db: db);
});
final diningTableRepositoryProvider = Provider<DiningTableRepository>((ref) {
  if (kUseSqliteDiningTableStore) {
    return SqliteDiningTableRepository(store: ref.read(eateryStoreProvider));
  }
  final db = ref.read(appDatabaseProvider);
  return DiningTableRepository(db: db);
});
final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  if (kUseSqliteStaffStore) {
    return SqliteStaffRepository(store: ref.read(eateryStoreProvider));
  }
  final db = ref.read(appDatabaseProvider);
  return StaffRepository(db: db);
});
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  if (kUseSqliteSubscriptionStore) {
    return SqliteSubscriptionRepository(store: ref.read(eateryStoreProvider));
  }
  final db = ref.read(appDatabaseProvider);
  return SubscriptionRepository(db: db);
});
final sqlitePreferenceStoreProvider = Provider<SqlitePreferenceStore>((ref) {
  return SqlitePreferenceStore(store: ref.read(eateryStoreProvider));
});
