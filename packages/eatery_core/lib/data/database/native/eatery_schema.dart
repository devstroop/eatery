import 'eatery_store.dart';

/// Asset path for the canonical SQL schema file.
const String kSchemaAssetPath = 'assets/db/schema.sql';

/// Executes the SQL schema statements on [store].
///
/// Load the SQL from [kSchemaAssetPath] via `rootBundle.loadString()` at the
/// app level (see main.dart) and pass it in. This function is intentionally
/// free of Flutter dependencies so it compiles in test environments.
///
/// If [latestVersion] is > 0 and no schema_version exists yet (fresh DB), the
/// version is recorded so that [SchemaMigrator.migrate] skips all migrations —
/// the SQL script already contains the latest schema.
void initEaterySchema(EateryStore store, String sql, {int latestVersion = 0}) {
  store.execute(sql);
  if (latestVersion > 0) {
    store.execute(
      'CREATE TABLE IF NOT EXISTS app_config (key TEXT PRIMARY KEY, value TEXT)',
    );
    final rows = store.query(
      "SELECT value FROM app_config WHERE key = 'schema_version'",
    );
    if (rows.isEmpty) {
      store.execute('INSERT INTO app_config (key, value) VALUES (?, ?)', [
        'schema_version',
        latestVersion.toString(),
      ]);
    }
  }
}
