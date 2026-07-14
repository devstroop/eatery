import 'package:eatery_core/data/database/native/eatery_store.dart';

/// Default host address when nothing has been configured.
const String kDefaultHostAddress = 'localhost';

/// Key used to persist the host address in the app_config table.
const String _kHostAddressKey = 'sync_host_address';

/// Persists and resolves the sync host address using the local SQLite store.
///
/// The host address is stored in a simple key-value `app_config` table that
/// is lazily created on first access. No extra dependencies required.
class SyncHostConfig {
  final EateryStore _store;

  SyncHostConfig(this._store);

  void _ensureTable() {
    _store.execute(
      'CREATE TABLE IF NOT EXISTS app_config (key TEXT PRIMARY KEY, value TEXT)',
    );
  }

  /// Returns the persisted host address, or [kDefaultHostAddress] if unset.
  String getHostAddress() {
    _ensureTable();
    final rows = _store.query(
      'SELECT value FROM app_config WHERE key = ?',
      [_kHostAddressKey],
    );
    if (rows.isEmpty) return kDefaultHostAddress;
    return rows.first['value'] as String? ?? kDefaultHostAddress;
  }

  /// Persists a new host address.
  void setHostAddress(String address) {
    _ensureTable();
    _store.execute(
      'INSERT OR REPLACE INTO app_config (key, value) VALUES (?, ?)',
      [_kHostAddressKey, address],
    );
  }
}
