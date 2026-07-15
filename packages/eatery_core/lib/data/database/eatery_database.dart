import 'package:eatery_core/data/database/native/eatery_store.dart';

/// Thin compatibility wrapper around the native store.
///
/// Provides `dataDir`, `hasCompany`, and `deleteAll` for the few remaining
/// pages that still read `appDatabaseProvider`.
class EateryDatabase {
  EateryDatabase({required this.dataDir, required EateryStore store})
    : _store = store;

  final String dataDir;
  final EateryStore _store;

  bool get hasCompany {
    try {
      final rows = _store.query('SELECT 1 FROM company LIMIT 1');
      return rows.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteAll() async {
    final tables = _store.query(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
    for (final t in tables) {
      _store.execute('DELETE FROM "${t['name']}"');
    }
  }
}
