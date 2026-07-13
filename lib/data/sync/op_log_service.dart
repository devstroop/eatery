import 'dart:convert';
import 'package:eatery/data/database/native/eatery_store.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'op_log_entry.dart';

/// Service for recording and querying the operation log.
///
/// Uses an `op_log` table in the native SQLite store instead of a Hive Box.
/// Same `int -> String` interface as the original Hive-backed version.
class OpLogService {
  OpLogService({required EateryStore store, required this.deviceId})
      : _store = store {
    _initClock();
  }

  final EateryStore _store;
  final String deviceId;

  int _clock = 0;

  /// Current logical clock value.
  int get clock => _clock;

  void _initClock() {
    final max = _store.queryScalar('SELECT MAX(clock) FROM op_log');
    if (max is int) _clock = max;
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
    return entry;
  }

  List<OpLogEntry> getEntriesSince(int sinceClock) {
    final rows = _store.query(
      'SELECT value FROM op_log WHERE clock > ? ORDER BY clock', [sinceClock],
    );
    return rows.map((r) => OpLogEntry.fromJson(
      jsonDecode(r['value'] as String) as Map<String, dynamic>,
    )).toList();
  }

  List<OpLogEntry> getEntriesForEntity(String entityType, int entityId) {
    return getAllEntries()
        .where((e) => e.entityType == entityType && e.entityId == entityId)
        .toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  List<OpLogEntry> getAllEntries() {
    final rows = _store.query('SELECT value FROM op_log ORDER BY clock');
    return rows.map((r) => OpLogEntry.fromJson(
      jsonDecode(r['value'] as String) as Map<String, dynamic>,
    )).toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
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
      _store.execute(
        'INSERT INTO op_log (clock, value) VALUES (?, ?)',
        [_clock, entry.toJsonString()],
      );
    }
  }
}
