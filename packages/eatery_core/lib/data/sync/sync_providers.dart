import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/data/sync/sync_coordinator.dart';

/// Host device ID — the admin app that runs the sync server.
const String kHostDeviceId = 'eatery-admin';

/// The active [SyncCoordinator], created during app initialization.
///
/// Read this from any widget that needs to track mutations.
final syncCoordinatorProvider = StateProvider<SyncCoordinator?>((ref) => null);

/// Initializes the sync coordinator and stores it in [syncCoordinatorProvider].
///
/// Call this during app startup (via [SyncInitializer] or initState).
final syncInitProvider = Provider.family<void, SyncConfig>((ref, config) {
  final store = ref.read(eateryStoreProvider);
  final coordinator = SyncCoordinator(
    store: store,
    deviceId: config.deviceId,
    isHost: config.isHost,
    host: config.hostAddress,
    port: config.port,
  );
  ref.read(syncCoordinatorProvider.notifier).state = coordinator;
  ref.onDispose(() => coordinator.dispose());
});

/// Configuration for a device's sync role.
class SyncConfig {
  final String deviceId;
  final bool isHost;
  final String? hostAddress;
  final int port;

  const SyncConfig({
    required this.deviceId,
    this.isHost = false,
    this.hostAddress,
    this.port = 9876,
  });

  /// Config for the admin app (sync host).
  factory SyncConfig.host({String? deviceId}) => SyncConfig(
    deviceId: deviceId ?? kHostDeviceId,
    isHost: true,
  );

  /// Config for a leaf device (waiter, KDS, display).
  factory SyncConfig.leaf({
    required String deviceId,
    required String hostAddress,
    int port = 9876,
  }) => SyncConfig(
    deviceId: deviceId,
    hostAddress: hostAddress,
    port: port,
  );
}
