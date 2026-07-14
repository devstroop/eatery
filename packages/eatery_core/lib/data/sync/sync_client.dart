import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../sync/op_log_entry.dart';
import '../sync/op_log_service.dart';
import '../sync/sync_message.dart';
import '../sync/sync_service.dart';

/// WebSocket client that connects to a sync host.
///
/// Runs on leaf devices (Waiter, Kitchen, Display apps).
/// Connects to the host's IP:port, sends heartbeats, pushes local ops,
/// and receives broadcast entries from other devices.
class SyncClient {
  final String host;
  final int port;
  final OpLogService opLogService;
  final SyncService syncService;

  SyncClient({
    required this.host,
    this.port = 9876,
    required this.opLogService,
    required this.syncService,
  });

  WebSocketChannel? _channel;
  Timer? _pushTimer;
  Timer? _reconnectTimer;
  bool _connected = false;
  int _reconnectAttempt = 0;

  /// Maximum reconnect delay in seconds.
  static const _maxReconnectDelay = 30;

  /// Connects to the sync host and starts listening.
  Future<void> connect() async {
    try {
      final uri = Uri.parse('ws://$host:$port');
      _channel = WebSocketChannel.connect(uri);

      syncService.connectToHost(host, host);

      _channel!.stream.listen(
        (data) => _handleMessage(data as String),
        onDone: () {
          _connected = false;
          syncService.disconnect();
          _scheduleReconnect();
        },
        onError: (_) {
          _connected = false;
          syncService.disconnect();
          _scheduleReconnect();
        },
      );

      _connected = true;
      _reconnectAttempt = 0;

      // Pull initial state from host
      final pullMsg = SyncMessage.opLogPull(
        deviceId: syncService.deviceId,
        clock: opLogService.clock,
        sinceClock: 0,
      );
      _send(pullMsg);

      // Periodically push pending local entries
      _pushTimer?.cancel();
      _pushTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        _pushPending();
      });
    } catch (e) {
      debugPrint('SyncClient: connection failed to $host:$port — $e');
      _scheduleReconnect();
    }
  }

  void _pushPending() {
    if (!_connected) return;
    final pending = opLogService.getEntriesSince(
      syncService.status.lastSyncedClock,
    );
    if (pending.isEmpty) return;

    final pushMsg = SyncMessage.opLogPush(
      deviceId: syncService.deviceId,
      clock: opLogService.clock,
      entries: pending.map((e) => e.toJson()).toList(),
    );
    _send(pushMsg);
  }

  void _handleMessage(String data) {
    try {
      final msg = SyncMessage.fromJsonString(data);
      switch (msg.type) {
        case 'host_announce':
          syncService.receiveHostAnnounce(
            hostDeviceId: msg.deviceId,
            hostName: msg.deviceName ?? msg.deviceId,
          );
          break;

        case 'oplog_broadcast':
          final entries =
              msg.entries?.map((e) => OpLogEntry.fromJson(e)).toList() ?? [];
          syncService.receiveEntries(entries);
          break;

        case 'oplog_push':
          // Server sent us a response to our pull request
          final entries =
              msg.entries?.map((e) => OpLogEntry.fromJson(e)).toList() ?? [];
          if (entries.isNotEmpty) {
            syncService.receiveEntries(entries);
          }
          break;

        case 'ack':
          final lastApplied = msg.payload?['lastAppliedClock'] as int?;
          if (lastApplied != null) {
            syncService.receiveAck(lastApplied);
          }
          break;
      }
    } catch (e) {
      debugPrint('SyncClient: error handling message: $e');
    }
  }

  /// Sends a message to the host (called externally by coordinator).
  void sendMessage(SyncMessage msg) => _send(msg);

  void _send(SyncMessage msg) {
    try {
      _channel?.sink.add(msg.toJsonString());
    } catch (_) {
      _connected = false;
    }
  }

  void _scheduleReconnect() {
    _reconnectAttempt++;
    final delay = Duration(
      seconds: (1 << (_reconnectAttempt - 1)).clamp(1, _maxReconnectDelay),
    );
    debugPrint(
      'SyncClient: reconnect in ${delay.inSeconds}s (attempt $_reconnectAttempt)',
    );
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (!_connected) connect();
    });
  }

  Future<void> disconnect() async {
    _pushTimer?.cancel();
    _pushTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _connected = false;
    await _channel?.sink.close();
    _channel = null;
    syncService.disconnect();
  }
}
