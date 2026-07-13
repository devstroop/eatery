import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';
import 'package:eatery_core/data/sync/op_log_entry.dart';
import 'package:eatery_core/data/sync/op_log_service.dart';
import 'package:eatery_core/data/sync/sync_client.dart';
import 'package:eatery_core/data/sync/sync_message.dart';
import 'package:eatery_core/data/sync/sync_server.dart';
import 'package:eatery_core/data/sync/sync_service.dart';

/// Coordinates sync for a device.
///
/// Host (admin app): starts SyncServer, broadcasts local ops to leaves.
///
/// Leaf (waiter/KDS/display): connects SyncClient to host, pushes
/// local ops, applies incoming ops to local database.
class SyncCoordinator {
  final EateryStore _store;
  final String deviceId;
  final bool isHost;

  late final OpLogService opLogService;
  late final SyncService syncService;
  SyncServer? _server;
  SyncClient? _client;

  SyncCoordinator({
    required EateryStore store,
    required this.deviceId,
    required this.isHost,
    String? host,
    int port = 9876,
  }) : _store = store {
    opLogService = OpLogService(store: store, deviceId: deviceId);

    setMutationHook((entityType, entityId, operation, data) {
      trackMutation(
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        data: data,
      );
    });
    syncService = SyncService(
      opLogService: opLogService,
      deviceId: deviceId,
      onStatusChange: (status) {
        debugPrint('SyncCoordinator: $deviceId status — ${status.connectionState}');
      },
      onEntriesReceived: (entries) {
        _applyIncomingEntries(entries);
      },
    );

    if (isHost) {
      _server = SyncServer(
        port: port,
        opLogService: opLogService,
        syncService: syncService,
      );
      _server!.start();
    } else if (host != null) {
      syncService.becomeLeaf();
      _client = SyncClient(
        host: host,
        port: port,
        opLogService: opLogService,
        syncService: syncService,
      );
      _client!.connect();
    } else {
      syncService.becomeStandalone();
    }
  }

  /// Commits a mutation to the op log and pushes/publishes it.
  void trackMutation({
    required String entityType,
    required int entityId,
    required String operation,
    required Map<String, dynamic> data,
    Map<String, dynamic>? prevData,
  }) {
    opLogService.commit(
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      data: data,
      prevData: prevData,
    );

    if (!isHost && _client != null) {
      _pushPending();
    }
  }

  void _pushPending() {
    final entries = opLogService.getEntriesSince(
      syncService.status.lastSyncedClock,
    );
    if (entries.isEmpty) return;

    final msg = SyncMessage.opLogPush(
      deviceId: deviceId,
      clock: opLogService.clock,
      entries: entries.map((e) => e.toJson()).toList(),
    );
    _client!.sendMessage(msg);
  }

  /// Applies incoming op log entries to the local database.
  void _applyIncomingEntries(List<OpLogEntry> entries) {
    for (final entry in entries) {
      try {
        _applyEntry(entry);
      } catch (e) {
        debugPrint('SyncCoordinator: failed to apply entry: $e');
      }
    }
  }

  void _applyEntry(OpLogEntry entry) {
    if (entry.operation == 'delete' || entry.operation == 'void') {
      _store.execute(
        'DELETE FROM ${entry.entityType}s WHERE id = ?',
        [entry.entityId],
      );
      return;
    }

    final data = entry.data;
    if (data.isEmpty) return;

    final table = '${entry.entityType}s';
    final columns = data.keys.join(', ');
    final placeholders = data.keys.map((_) => '?').join(', ');
    final values = data.values.toList();

    _store.execute(
      'INSERT OR REPLACE INTO $table (id, $columns) '
      'VALUES (?${placeholders.isNotEmpty ? ', $placeholders' : ''})',
      [entry.entityId, ...values],
    );
  }

  Future<void> dispose() async {
    clearMutationHook();
    await _client?.disconnect();
    await _server?.stop();
    syncService.dispose();
  }
}
