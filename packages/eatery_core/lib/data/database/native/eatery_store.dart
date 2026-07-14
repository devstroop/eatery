import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'eatery_store_bindings.dart';
import 'eatery_store_interface.dart';

/// Thrown when a native store operation fails. Carries the message reported
/// by the native layer via `es_last_error`.
class EateryStoreException implements Exception {
  EateryStoreException(this.message, {this.sql});

  final String message;
  final String? sql;

  @override
  String toString() =>
      'EateryStoreException: $message${sql != null ? ' (sql: $sql)' : ''}';
}

/// High-level, Dart-friendly wrapper around libeaterystore.
///
/// This is the single seam through which the app talks to the embedded SQLite
/// database. Parameters are sent as a JSON array; query results come back as a
/// JSON array of row objects which is decoded into `List<Map<String, Object?>>`.
///
/// Values map as follows across the FFI boundary:
///   * `null`   <-> SQL NULL
///   * `int`    <-> INTEGER
///   * `double` <-> REAL
///   * `bool`   -> INTEGER (0/1); read back as `int`
///   * `String` <-> TEXT
///
/// Booleans and enums are the caller's responsibility to encode/decode (see
/// the SQLite-backed repositories).
class EateryStore implements EateryStoreInterface {
  EateryStore._(this._bindings, this._handle);

  final EateryStoreBindings _bindings;
  final Pointer<EsStore> _handle;
  bool _closed = false;

  /// Opens (creating if needed) the database at [path].
  factory EateryStore.open(String path, {EateryStoreBindings? bindings}) {
    final b = bindings ?? EateryStoreBindings(EateryStoreBindings.load());
    final pathPtr = path.toNativeUtf8();
    try {
      final handle = b.esOpen(pathPtr);
      if (handle == nullptr) {
        throw EateryStoreException('Failed to open database at "$path"');
      }
      return EateryStore._(b, handle);
    } finally {
      malloc.free(pathPtr);
    }
  }

  /// Native library version string.
  @override
  String get version => _bindings.esVersion().toDartString();

  /// Set the SQLCipher encryption key. Must be called immediately after open
  /// when using an encrypted database. No-op with plain SQLite (the symbol
  /// exists but the underlying library is compiled without SQLCipher).
  @override
  void setKey(String key) {
    final keyBytes = utf8.encode(key);
    final keyPtr = malloc.allocate<Uint8>(keyBytes.length);
    keyPtr.asTypedList(keyBytes.length).setAll(0, keyBytes);
    _bindings.esKey(_handle, keyPtr, keyBytes.length);
    malloc.free(keyPtr);
  }

  /// Executes a non-query statement (INSERT/UPDATE/DELETE/DDL). Returns the
  /// number of affected rows. Multiple `;`-separated statements are supported
  /// (params bind to the first statement only — intended for schema setup).
  @override
  int execute(String sql, [List<Object?>? params]) {
    _ensureOpen();
    final sqlPtr = sql.toNativeUtf8();
    final paramsPtr = _encodeParams(params);
    try {
      final affected = _bindings.esExec(_handle, sqlPtr, paramsPtr);
      if (affected < 0) {
        throw EateryStoreException(_lastError(), sql: sql);
      }
      return affected;
    } finally {
      malloc.free(sqlPtr);
      if (paramsPtr != nullptr) malloc.free(paramsPtr);
    }
  }

  /// Runs a SELECT and returns the decoded rows.
  @override
  List<Map<String, Object?>> query(String sql, [List<Object?>? params]) {
    _ensureOpen();
    final sqlPtr = sql.toNativeUtf8();
    final paramsPtr = _encodeParams(params);
    Pointer<Utf8> resultPtr = nullptr;
    try {
      resultPtr = _bindings.esQuery(_handle, sqlPtr, paramsPtr);
      if (resultPtr == nullptr) {
        throw EateryStoreException(_lastError(), sql: sql);
      }
      final jsonStr = resultPtr.toDartString();
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => (e as Map<String, dynamic>).cast<String, Object?>())
          .toList(growable: false);
    } finally {
      malloc.free(sqlPtr);
      if (paramsPtr != nullptr) malloc.free(paramsPtr);
      if (resultPtr != nullptr) _bindings.esFree(resultPtr);
    }
  }

  /// Convenience: run a query expected to return a single scalar in the first
  /// column of the first row (e.g. `SELECT last_insert_rowid()`).
  @override
  Object? queryScalar(String sql, [List<Object?>? params]) {
    final rows = query(sql, params);
    if (rows.isEmpty) return null;
    final first = rows.first;
    if (first.isEmpty) return null;
    return first.values.first;
  }

  /// Runs [action] inside a database transaction. Commits on success and rolls
  /// back if [action] throws, then rethrows. Useful for atomic multi-row
  /// writes (e.g. saving an order together with its line items).
  ///
  /// Not re-entrant: SQLite does not support nested transactions via BEGIN.
  @override
  T transaction<T>(T Function() action) {
    _ensureOpen();
    execute('BEGIN IMMEDIATE');
    try {
      final result = action();
      execute('COMMIT');
      return result;
    } catch (_) {
      try {
        execute('ROLLBACK');
      } catch (_) {
        // Ignore rollback failures; surface the original error.
      }
      rethrow;
    }
  }

  /// Closes the underlying database. Safe to call multiple times.
  @override
  void close() {
    if (_closed) return;
    _closed = true;
    _bindings.esClose(_handle);
  }

  // -------------------------------------------------------------------------

  Pointer<Utf8> _encodeParams(List<Object?>? params) {
    if (params == null || params.isEmpty) return nullptr;
    return jsonEncode(params).toNativeUtf8();
  }

  String _lastError() => _bindings.esLastError(_handle).toDartString();

  void _ensureOpen() {
    if (_closed) {
      throw EateryStoreException('Store has been closed');
    }
  }
}
