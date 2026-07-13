import "package:flutter/foundation.dart";
import 'dart:io';

import 'op_log_entry.dart';
import 'op_log_service.dart';
import 'sync_message.dart';
import 'sync_service.dart';

/// WebSocket server that runs on the sync host device.
///
/// Listens on port [port] for incoming WebSocket connections from leaf devices.
class SyncServer {
  final int port;
  final OpLogService opLogService;
  final SyncService syncService;

  SyncServer({
    this.port = 9876,
    required this.opLogService,
    required this.syncService,
  });

  final List<WebSocket> _clients = [];
  HttpServer? _server;

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    syncService.becomeHost();

    _server!.listen((HttpRequest req) {
      if (req.uri.path == '/sync') {
        WebSocketTransformer.upgrade(req).then((WebSocket ws) {
          _clients.add(ws);
          ws.listen(
            (data) => _handleMessage(ws, data as String),
            onDone: () => _clients.remove(ws),
            onError: (_) => _clients.remove(ws),
          );
        });
      } else {
        req.response.statusCode = 404;
        req.response.close();
      }
    });

    _startBroadcastLoop();
  }

  void _startBroadcastLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (_server == null) return false;

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
        client.add(json);
      } catch (_) {
        _clients.remove(client);
      }
    }
  }

  void _handleMessage(WebSocket sender, String data) {
    try {
      final msg = SyncMessage.fromJsonString(data);
      switch (msg.type) {
        case 'oplog_push':
          final entries =
              msg.entries?.map((e) => OpLogEntry.fromJson(e)).toList() ?? [];
          opLogService.applyBatch(entries);
          syncService.receiveAck(opLogService.clock);
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
          sender.add(response.toJsonString());
          break;

        case 'host_vote':
          // Forward vote to current host logic
          syncService.receiveHeartbeat(msg.clock);
          break;

        case 'heartbeat':
          syncService.receiveHeartbeat(msg.clock);
          break;
      }
    } catch (e) {
      debugPrint('SyncServer: error handling message: $e');
    }
  }

  Future<void> stop() async {
    for (final client in _clients) {
      client.close();
    }
    _clients.clear();
    await _server?.close(force: true);
    _server = null;
    syncService.becomeStandalone();
  }
}
