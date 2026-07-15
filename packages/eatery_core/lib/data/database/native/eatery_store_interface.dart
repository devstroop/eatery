/// Abstract interface for the native SQLite store.
///
/// Allows pure-Dart tests of [OpLogService] and other consumers without
/// loading the FFI-backed [EateryStore].
abstract class EateryStoreInterface {
  String get version;

  void setKey(String key);

  int execute(String sql, [List<Object?>? params]);

  List<Map<String, Object?>> query(
    String sql, [
    List<Object?>? params,
    int? maxResults,
  ]);

  Object? queryScalar(String sql, [List<Object?>? params]);

  T transaction<T>(T Function() action);

  /// Creates a backup of the database at [targetPath].
  void backup(String targetPath);

  /// Reclaims unused space — equivalent to `VACUUM;`.
  void vacuum();

  /// Runs `PRAGMA optimize` to let SQLite tune internal heuristics.
  void optimize();

  void close();
}
