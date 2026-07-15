import 'dart:convert';
import 'package:eatery_core/data/database/native/eatery_store_interface.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'op_log_entry.dart';

/// Service for recording and querying the operation log.
///
/// Uses an `op_log` table in the native SQLite store instead of a Hive Box.
/// Same `int -> String` interface as the original Hive-backed version.
class OpLogService {
  OpLogService({
    required EateryStoreInterface store,
    required this.deviceId,
    this.maxQueueDepth = _kDefaultMaxQueueDepth,
  }) : _store = store {
    _initClock();
  }

  final EateryStoreInterface _store;
  final String deviceId;

  static const _kDefaultMaxQueueDepth = 10000;

  /// Maximum number of op_log entries to retain. When exceeded, the oldest
  /// entries are pruned. 0 means unlimited.
  ///
  /// This prevents unbounded clock growth on a leaf device that generates
  /// many offline ops before reconnecting.
  final int maxQueueDepth;

  int _clock = 0;

  /// Current logical clock value.
  int get clock => _clock;

  void _initClock() {
    final max = _store.queryScalar('SELECT MAX(clock) FROM op_log');
    if (max is int) _clock = max;
  }

  /// Returns a subset of [entries] suitable for a single sync message,
  /// respecting the per-message batch limit.
  ///
  /// Preserves FIFO order by taking the **oldest** entries first. The
  /// caller's ack tracking ensures the remaining entries are pushed in
  /// subsequent batches.
  List<OpLogEntry> batchForPush(List<OpLogEntry> entries) {
    const maxBatch = 500;
    if (entries.length <= maxBatch) return entries;
    return entries.sublist(0, maxBatch);
  }

  OpLogEntry commit({
    required String entityType,
    required int entityId,
    required String operation,
    required Map<String, dynamic> data,
    Map<String, dynamic>? prevData,
    String? parentId,
    Map<String, dynamic>? metadata,
  }) {
    _clock++;
    final entry = OpLogEntry(
      id: '${deviceId}_$_clock',
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      data: data,
      prevData: prevData,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      deviceId: deviceId,
      parentId: parentId,
      metadata: metadata,
    );
    _store.execute(
      'INSERT OR REPLACE INTO op_log (clock, value) VALUES (?, ?)',
      [_clock, entry.toJsonString()],
    );
    _pruneIfNeeded();
    return entry;
  }

  /// Removes the oldest entries when [maxQueueDepth] is exceeded.
  void _pruneIfNeeded() {
    if (maxQueueDepth <= 0) return;
    final count = _store.queryScalar('SELECT COUNT(*) FROM op_log') as int;
    if (count <= maxQueueDepth) return;
    final excess = count - maxQueueDepth;
    _store.execute(
      'DELETE FROM op_log WHERE clock IN ('
      'SELECT clock FROM op_log ORDER BY clock LIMIT ?)',
      [excess],
    );
  }

  List<OpLogEntry> getEntriesSince(int sinceClock) {
    final rows = _store.query(
      'SELECT value FROM op_log WHERE clock > ? ORDER BY clock',
      [sinceClock],
    );
    return rows
        .map(
          (r) => OpLogEntry.fromJson(
            jsonDecode(r['value'] as String) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  List<OpLogEntry> getEntriesForEntity(String entityType, int entityId) {
    return getAllEntries()
        .where((e) => e.entityType == entityType && e.entityId == entityId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  List<OpLogEntry> getAllEntries() {
    final rows = _store.query('SELECT value FROM op_log ORDER BY clock');
    return rows
        .map(
          (r) => OpLogEntry.fromJson(
            jsonDecode(r['value'] as String) as Map<String, dynamic>,
          ),
        )
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Map<String, dynamic>? rebuildState(String entityType, int entityId) {
    final entries = getEntriesForEntity(entityType, entityId);
    if (entries.isEmpty) return null;
    Map<String, dynamic>? state;
    for (final entry in entries) {
      state = entry.data;
      if (entry.operation == 'void' || entry.operation == 'delete') return null;
    }
    return state;
  }

  int get entryCount {
    final count = _store.queryScalar('SELECT COUNT(*) FROM op_log');
    return (count as int?) ?? 0;
  }

  void advanceClockTo(int newClock) {
    if (newClock > _clock) _clock = newClock;
  }

  void applyBatch(List<OpLogEntry> entries) {
    for (final entry in entries) {
      _clock++;
      _store.execute('INSERT INTO op_log (clock, value) VALUES (?, ?)', [
        _clock,
        entry.toJsonString(),
      ]);
    }
  }
}
