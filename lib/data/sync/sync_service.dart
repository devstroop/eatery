import 'dart:async';
import 'package:eatery/data/sync/op_log_entry.dart';
import 'package:eatery/data/sync/op_log_service.dart';
import 'package:eatery/data/sync/sync_message.dart';

/// Possible roles for a device in the sync network.
enum SyncRole {
  /// Acts as sync host — runs server, coordinates replication.
  host,

  /// Leaf node — connects to host, sends/receives ops.
  leaf,

  /// Not connected to any sync network.
  standalone,
}

/// Connection state with the sync host.
enum HostConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

/// Status of the sync service.
class SyncStatus {
  final SyncRole role;
  final HostConnectionState connectionState;
  final String? connectedHostId;
  final String? connectedHostName;
  final int localClock;
  final int lastSyncedClock;
  final int pendingEntryCount;
  final DateTime? lastHeartbeat;

  const SyncStatus({
    required this.role,
    required this.connectionState,
    this.connectedHostId,
    this.connectedHostName,
    required this.localClock,
    required this.lastSyncedClock,
    required this.pendingEntryCount,
    this.lastHeartbeat,
  });
}

/// High-level sync service that manages the device's role in the network,
/// heartbeat monitoring, host election, and push/pull of OpLog entries.
class SyncService {
  final OpLogService _opLogService;
  final String deviceId;

  SyncRole _role = SyncRole.standalone;
  HostConnectionState _connectionState = HostConnectionState.disconnected;
  String? _connectedHostId;
  String? _connectedHostName;
  int _lastSyncedClock = 0;
  int _hostClock = 0;
  Timer? _heartbeatTimer;
  Timer? _hostCheckTimer;
  DateTime? _lastHeartbeat;
  int _missedHeartbeats = 0;

  // Callbacks for state changes
  final void Function(SyncStatus status)? onStatusChange;
  final void Function(List<OpLogEntry> entries)? onEntriesReceived;
  final void Function()? onHostLost;
  final void Function()? onHostElected;

  SyncService({
    required OpLogService opLogService,
    required this.deviceId,
    this.onStatusChange,
    this.onEntriesReceived,
    this.onHostLost,
    this.onHostElected,
  }) : _opLogService = opLogService;

  // ── Getters ──

  SyncRole get role => _role;
  HostConnectionState get connectionState => _connectionState;
  SyncStatus get status => SyncStatus(
        role: _role,
        connectionState: _connectionState,
        connectedHostId: _connectedHostId,
        connectedHostName: _connectedHostName,
        localClock: _opLogService.clock,
        lastSyncedClock: _lastSyncedClock,
        pendingEntryCount: _opLogService.clock - _lastSyncedClock,
        lastHeartbeat: _lastHeartbeat,
      );

  // ── Role management ──

  void becomeHost() {
    _role = SyncRole.host;
    _connectionState = HostConnectionState.connected;
    _connectedHostId = deviceId;
    _connectedHostName = '${deviceId}_host';
    _startHeartbeat();
    onStatusChange?.call(status);
    onHostElected?.call();
  }

  void becomeLeaf() {
    _role = SyncRole.leaf;
    _connectionState = HostConnectionState.disconnected;
    _connectedHostId = null;
    _connectedHostName = null;
    _stopHeartbeat();
    onStatusChange?.call(status);
  }

  void becomeStandalone() {
    _role = SyncRole.standalone;
    _connectionState = HostConnectionState.disconnected;
    _connectedHostId = null;
    _connectedHostName = null;
    _stopHeartbeat();
    onStatusChange?.call(status);
  }

  // ── Connection management ──

  void connectToHost(String hostId, String hostName) {
    _connectionState = HostConnectionState.connecting;
    _connectedHostId = hostId;
    _connectedHostName = hostName;
    onStatusChange?.call(status);

    // Pull missed ops
    final pullMsg = SyncMessage.opLogPull(
      deviceId: deviceId,
      clock: _opLogService.clock,
      sinceClock: _lastSyncedClock,
    );
    _sendMessage(pullMsg);

    _connectionState = HostConnectionState.connected;
    _missedHeartbeats = 0;
    _startHostCheck();
    onStatusChange?.call(status);
  }

  void disconnect() {
    _connectionState = HostConnectionState.disconnected;
    _connectedHostId = null;
    _connectedHostName = null;
    _stopHostCheck();
    _stopHeartbeat();
    onStatusChange?.call(status);
  }

  // ── OpLog push ──

  void pushPendingEntries() {
    final entries = _opLogService.getEntriesSince(_lastSyncedClock);
    if (entries.isEmpty) return;

    final pushMsg = SyncMessage.opLogPush(
      deviceId: deviceId,
      clock: _opLogService.clock,
      entries: entries.map((e) => e.toJson()).toList(),
    );
    _sendMessage(pushMsg);
  }

  // ── Receiving data ──

  void receiveEntries(List<OpLogEntry> entries) {
    _opLogService.applyBatch(entries);
    _lastSyncedClock = _opLogService.clock;
    onEntriesReceived?.call(entries);
    onStatusChange?.call(status);
  }

  void receiveAck(int lastAppliedClock) {
    if (lastAppliedClock > _lastSyncedClock) {
      _lastSyncedClock = lastAppliedClock;
      onStatusChange?.call(status);
    }
  }

  void receiveHeartbeat(int hostClock) {
    _hostClock = hostClock;
    _lastHeartbeat = DateTime.now();
    _missedHeartbeats = 0;
  }

  void receiveHostAnnounce({
    required String hostDeviceId,
    required String hostName,
    required int hostClock,
  }) {
    _connectedHostId = hostDeviceId;
    _connectedHostName = hostName;
    _hostClock = hostClock;
    _lastHeartbeat = DateTime.now();
    _missedHeartbeats = 0;
    if (_connectionState != HostConnectionState.connected) {
      _connectionState = HostConnectionState.connected;
      onStatusChange?.call(status);
    }
  }

  // ── Host election (for leaf nodes when host is lost) ──

  void detectHostLoss() {
    _missedHeartbeats++;
    if (_missedHeartbeats >= 3) {
      // 3 missed heartbeats = host is down
      onHostLost?.call();
      _connectionState = HostConnectionState.reconnecting;
      onStatusChange?.call(status);

      // Broadcast vote for new host
      final voteMsg = SyncMessage.hostVote(
        deviceId: deviceId,
        clock: _opLogService.clock,
        uptimeSeconds: _getUptimeSeconds(),
      );
      _sendMessage(voteMsg);
    }
  }

  // ── Internal ──

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_role == SyncRole.host) {
        final msg = SyncMessage.hostAnnounce(
          deviceId: deviceId,
          clock: _opLogService.clock,
          deviceName: deviceId,
        );
        _sendMessage(msg);
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _startHostCheck() {
    _hostCheckTimer?.cancel();
    _hostCheckTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_role == SyncRole.leaf &&
          _connectionState == HostConnectionState.connected) {
        final now = DateTime.now();
        if (_lastHeartbeat != null &&
            now.difference(_lastHeartbeat!).inSeconds > 15) {
          detectHostLoss();
        }
      }
    });
  }

  void _stopHostCheck() {
    _hostCheckTimer?.cancel();
    _hostCheckTimer = null;
  }

  int _getUptimeSeconds() {
    // Placeholder — in production, track process start time
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  void _sendMessage(SyncMessage message) {
    // TODO: Implement actual WebSocket send
  }

  /// Dispose timers on service teardown.
  void dispose() {
    _stopHeartbeat();
    _stopHostCheck();
  }
}
