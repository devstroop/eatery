import 'eatery_store.dart';

/// Asset path for the canonical SQL schema file.
const String kSchemaAssetPath = 'assets/db/schema.sql';

/// Executes the SQL schema statements on [store].
///
/// Load the SQL from [kSchemaAssetPath] via `rootBundle.loadString()` at the
/// app level (see main.dart) and pass it in. This function is intentionally
/// free of Flutter dependencies so it compiles in test environments.
void initEaterySchema(EateryStore store, String sql) {
  store.execute(sql);
}
