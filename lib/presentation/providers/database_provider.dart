import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/database/eatery_database.dart';

/// Placeholder provider for [EateryDatabase].
/// Overridden in main.dart after initialization via ProviderScope overrides.
final appDatabaseProvider = Provider<EateryDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in main.dart',
  );
});
