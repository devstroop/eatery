import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/database/native/eatery_store.dart';

/// Placeholder provider for [EateryDatabase].
/// Overridden in main.dart after initialization via ProviderScope overrides.
final appDatabaseProvider = Provider<EateryDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in main.dart',
  );
});

/// Placeholder provider for the native SQLite [EateryStore].
/// Overridden in main.dart when the SQLite store spike is enabled
/// (see `kUseSqliteProductStore`). Consumers must only read this when the
/// flag is on.
final eateryStoreProvider = Provider<EateryStore>((ref) {
  throw UnimplementedError(
    'eateryStoreProvider must be overridden in main.dart when the SQLite '
    'store is enabled',
  );
});
