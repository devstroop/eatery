import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../sync/op_log_entry.dart';
import '../sync/op_log_service.dart';
import '../sync/sync_message.dart';
import '../sync/sync_service.dart';

/// WebSocket server that runs on the sync host device.
///
/// Listens on port [port] for incoming WebSocket connections from leaf devices.
/// Each connected client receives heartbeats, OpLog broadcasts, and host
/// announcements.
///
/// Only one host should run per restaurant LAN.
class SyncServer {
  final int port;
  final OpLogService opLogService;
  final SyncService syncService;

  SyncServer({
    this.port = 9876,
    required this.opLogService,
    required this.syncService,
  });

  final List<WebSocketChannel> _clients = [];
  HttpServer? _server;
  bool _stopped = false;

  /// Starts the WebSocket server on all interfaces.
  Future<void> start() async {
    final handler = webSocketHandler((WebSocketChannel webSocket, _) {
      _clients.add(webSocket);
      webSocket.stream.listen(
        (data) => _handleMessage(webSocket, data as String),
        onDone: () => _clients.remove(webSocket),
        onError: (_) => _clients.remove(webSocket),
      );
    });

    _server = await shelf_io.serve(
      shelf.Pipeline().addMiddleware(shelf.logRequests()).addHandler(handler),
      InternetAddress.anyIPv4,
      port,
    );

    syncService.becomeHost();

    // Broadcast heartbeats to all clients
    _startBroadcastLoop();
  }

  void _startBroadcastLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (_stopped || _server == null) return false;
      // ... broadcast logic ...
      final heartbeat = SyncMessage.hostAnnounce(
        deviceId: syncService.deviceId,
        clock: opLogService.clock,
        deviceName: syncService.deviceId,
      );
      _broadcast(heartbeat);

      // Push pending entries
      final pending = opLogService.getEntriesSince(
        syncService.status.lastSyncedClock,
      );
      if (pending.isNotEmpty) {
        final broadcast = SyncMessage.opLogBroadcast(
          deviceId: syncService.deviceId,
          clock: opLogService.clock,
          entries: pending.map((e) => e.toJson()).toList(),
        );
        _broadcast(broadcast);
      }
      return true;
    });
  }

  void _broadcast(SyncMessage msg) {
    final json = msg.toJsonString();
    for (final client in _clients.toList()) {
      try {
        client.sink.add(json);
      } catch (_) {
        _clients.remove(client);
      }
    }
  }

  void _handleMessage(WebSocketChannel sender, String data) {
    try {
      final msg = SyncMessage.fromJsonString(data);
      switch (msg.type) {
        case 'oplog_push':
          final entries =
              msg.entries?.map((e) => OpLogEntry.fromJson(e)).toList() ?? [];
          opLogService.applyBatch(entries);
          syncService.receiveAck(opLogService.clock);
          // Apply incoming entries to the host's own store.
          syncService.receiveEntries(entries);
          // Ack the sender so it can advance its lastSyncedClock.
          sender.sink.add(
            SyncMessage.ack(
              deviceId: syncService.deviceId,
              clock: opLogService.clock,
              lastAppliedClock: opLogService.clock,
            ).toJsonString(),
          );
          // Re-broadcast to all other clients
          final broadcast = SyncMessage.opLogBroadcast(
            deviceId: syncService.deviceId,
            clock: opLogService.clock,
            entries: entries.map((e) => e.toJson()).toList(),
          );
          _broadcast(broadcast);
          break;

        case 'oplog_pull':
          final sinceClock = msg.payload?['sinceClock'] as int? ?? 0;
          final entries = opLogService.getEntriesSince(sinceClock);
          final response = SyncMessage.opLogPush(
            deviceId: syncService.deviceId,
            clock: opLogService.clock,
            entries: entries.map((e) => e.toJson()).toList(),
          );
          sender.sink.add(response.toJsonString());
          break;

        case 'host_vote':
          // Forward vote to current host logic
          syncService.receiveHeartbeat();
          break;

        case 'heartbeat':
          syncService.receiveHeartbeat();
          break;
      }
    } catch (e) {
      debugPrint('SyncServer: error handling message: $e');
    }
  }

  Future<void> stop() async {
    _stopped = true;
    final clients = _clients.toList();
    for (final client in clients) {
      try {
        client.sink.close(ws_status.normalClosure);
      } catch (_) {}
    }
    _clients.clear();
    await _server?.close(force: true);
    _server = null;
    syncService.becomeStandalone();
  }
}
