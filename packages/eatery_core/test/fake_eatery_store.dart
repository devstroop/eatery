import 'package:eatery_core/data/database/native/eatery_store_interface.dart';

/// A pure-Dart, in-memory implementation of [EateryStoreInterface].
///
/// Useful for tests that need to verify [OpLogService] logic without loading
/// the native FFI library.
///
/// Supports only the SQL patterns used by [OpLogService]:
///   - `INSERT OR REPLACE INTO op_log (clock, value) VALUES (?, ?)`
///   - `INSERT INTO op_log (clock, value) VALUES (?, ?)`
///   - `SELECT value FROM op_log WHERE clock > ? ORDER BY clock`
///   - `SELECT value FROM op_log ORDER BY clock`
///   - `SELECT MAX(clock) FROM op_log`
///   - `SELECT COUNT(*) FROM op_log`
///
/// Any other SQL statement will throw [UnsupportedError].
class FakeEateryStore implements EateryStoreInterface {
  final _data = <int, String>{};

  @override
  String get version => 'fake';

  @override
  void setKey(String key) {}

  @override
  int execute(String sql, [List<Object?>? params]) {
    final lower = sql.toLowerCase().trim();

    if (lower.startsWith('insert or replace') || lower.startsWith('insert')) {
      final clock = params?[0] as int;
      final value = params?[1] as String;
      if (lower.startsWith('insert or replace')) {
        _data[clock] = value;
      } else {
        _data.putIfAbsent(clock, () => value);
      }
      return 1;
    }

    throw UnsupportedError('FakeEateryStore cannot execute: $sql');
  }

  @override
  List<Map<String, Object?>> query(String sql, [List<Object?>? params]) {
    final lower = sql.toLowerCase();

    if (lower.contains('clock > ?')) {
      final since = params?[0] as int;
      final entries = _data.entries.where((e) => e.key > since).toList();
      entries.sort((a, b) => a.key.compareTo(b.key));
      return entries.map((e) => <String, Object?>{'value': e.value}).toList();
    }

    if (lower.contains('order by clock')) {
      final entries = _data.entries.toList();
      entries.sort((a, b) => a.key.compareTo(b.key));
      return entries.map((e) => <String, Object?>{'value': e.value}).toList();
    }

    throw UnsupportedError('FakeEateryStore cannot query: $sql');
  }

  @override
  Object? queryScalar(String sql, [List<Object?>? params]) {
    final lower = sql.toLowerCase();

    if (lower.contains('max(clock)')) {
      if (_data.isEmpty) return null;
      return _data.keys.reduce((a, b) => a > b ? a : b);
    }

    if (lower.contains('count(*)')) {
      return _data.length;
    }

    throw UnsupportedError('FakeEateryStore cannot queryScalar: $sql');
  }

  @override
  T transaction<T>(T Function() action) => action();

  @override
  void backup(String targetPath) {
    // No-op in-memory — cannot back up a fake.
  }

  @override
  void close() => _data.clear();
}
