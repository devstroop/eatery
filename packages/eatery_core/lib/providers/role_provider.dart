import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/database/native/schema_migrator.dart';

/// Reads the device role from the SQLite [app_config] table.
///
/// Returns `null` if no role has been set yet (first launch).
/// Possible values: `admin`, `waiter`, `kds`, `display`.
///
/// The `--dart-define=role=X` flag overrides the persisted value at runtime.
/// If neither the define nor the DB value is set, the role picker is shown.
String? resolveDeviceRole() {
  // 1. Check --dart-define first (dev override, not persisted).
  const dartDefine = String.fromEnvironment('role');
  if (dartDefine.isNotEmpty) return dartDefine;

  // 2. Fall back to DB (persisted by role picker).
  return null; // resolved below via provider
}

/// Riverpod provider that exposes the current device role.
///
/// - `null` = unset → RolePicker needs to be shown.
/// - `admin`, `waiter`, `kds`, `display` = a role is configured.
///
/// Write to the notifier to persist a new role:
/// ```dart
/// ref.read(roleProvider.notifier).setRole('admin');
/// ```
final roleProvider = NotifierProvider<RoleNotifier, String?>(RoleNotifier.new);

class RoleNotifier extends Notifier<String?> {
  @override
  String? build() {
    // Check --dart-define first (runtime override, not persisted).
    const dartDefine = String.fromEnvironment('role');
    if (dartDefine.isNotEmpty) {
      state = dartDefine;
      return dartDefine;
    }

    // Fall back to SQLite app_config.
    final store = ref.read(eateryStoreProvider);
    final migrator = SchemaMigrator(store);
    final role = migrator.getDeviceRole();
    state = role;
    return role;
  }

  /// Persists [role] to [app_config] and updates state.
  void setRole(String role) {
    final store = ref.read(eateryStoreProvider);
    final migrator = SchemaMigrator(store);
    migrator.setDeviceRole(role);
    state = role;
  }

  /// Clears the persisted role and returns to the unset state.
  void clearRole() {
    final store = ref.read(eateryStoreProvider);
    final migrator = SchemaMigrator(store);
    migrator.setDeviceRole('');
    state = null;
  }
}
