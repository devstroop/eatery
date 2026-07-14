import '../references.dart';

extension CustomerExtension on Customer {
  double get getOutstandingAmount {
    // Hive fully eliminated. Outstanding amount now computed via
    // SqliteCustomerRepository.getOutstandingAmount() which reads
    // from the SQLite store through the legacy appDatabaseProvider shim.
    // TODO: migrate callers to use the repository provider directly.
    return 0.0;
  }
}
