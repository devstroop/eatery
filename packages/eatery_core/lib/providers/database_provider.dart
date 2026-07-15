import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/database/eatery_database.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/database/native/eatery_store_isolate.dart';
import 'package:eatery_core/data/database/native/store_config.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

/// Provider for the isolate-backed store, used for heavy queries that would
/// otherwise jank the UI thread. Loaded lazily — the isolate is not spawned
/// until the first read.
///
/// The isolate opens its own connection to the same .db file. The DB path
/// is resolved the same way as the main store (matching main.dart logic).
final eateryStoreIsolateProvider =
    FutureProvider.autoDispose<EateryStoreIsolate?>((ref) async {
      if (!kUseSqliteStore) return null;
      try {
        final dir = Platform.isAndroid || Platform.isIOS
            ? await getApplicationDocumentsDirectory()
            : await getApplicationSupportDirectory();
        final path = '${dir.path}/$kEateryDbFileName';
        final isolate = await EateryStoreIsolate.open(path);
        // Register dispose AFTER the isolate is assigned.
        ref.onDispose(() async {
          try {
            await isolate.close();
          } catch (_) {}
        });
        return isolate;
      } catch (e) {
        debugPrint('Failed to open isolate store: $e');
        return null;
      }
    });
