import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'op_log_entry.dart';

/// Service for recording and querying the operation log.
///
/// Every mutation goes through this service to produce an OpLog entry.
class OpLogService {
  OpLogService({required Box<String> opLogBox, required this.deviceId})
      : _opLogBox = opLogBox;

  final Box<String> _opLogBox;
  final String deviceId;

  int _clock = 0;

  /// Current logical clock value.
  int get clock => _clock;

  /// Initialize clock from existing entries.
  void init() {
    if (_opLogBox.isNotEmpty) {
      final lastKey = _opLogBox.keys.last;
      if (lastKey is int) {
        _clock = lastKey;
      }
    }
  }

  /// Commit an OpLog entry and return it.
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

    _opLogBox.put(_clock, entry.toJsonString());
    return entry;
  }

  /// Get all entries since a given clock value.
  List<OpLogEntry> getEntriesSince(int sinceClock) {
    final entries = <OpLogEntry>[];
    for (var i = sinceClock + 1; i <= _clock; i++) {
      final raw = _opLogBox.get(i);
      if (raw != null) {
        entries.add(OpLogEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      }
    }
    return entries;
  }

  /// Get all entries for a specific entity.
  List<OpLogEntry> getEntriesForEntity(String entityType, int entityId) {
    return getAllEntries()
        .where((e) => e.entityType == entityType && e.entityId == entityId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Get all entries.
  List<OpLogEntry> getAllEntries() {
    return _opLogBox.values
        .map((raw) => OpLogEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Rebuild current state of an entity by folding its ops.
  Map<String, dynamic>? rebuildState(String entityType, int entityId) {
    final entries = getEntriesForEntity(entityType, entityId);
    if (entries.isEmpty) return null;

    Map<String, dynamic>? state;
    for (final entry in entries) {
      state = entry.data;
      // If the entity was voided/deleted, return null
      if (entry.operation == 'void' || entry.operation == 'delete') {
        return null;
      }
    }
    return state;
  }

  /// Total number of entries.
  int get entryCount => _opLogBox.length;

  /// Advance clock (called when receiving ops from host).
  void advanceClockTo(int newClock) {
    if (newClock > _clock) {
      _clock = newClock;
    }
  }

  /// Apply a batch of entries received from sync.
  void applyBatch(List<OpLogEntry> entries) {
    for (final entry in entries) {
      _clock++;
      _opLogBox.put(_clock, entry.toJsonString());
    }
  }

  /// Serialize order state for OpLog data field.
  static Map<String, dynamic> orderToData(Order order) {
    return {
      'id': order.id,
      'customerPhone': order.customerPhone,
      'createdAt': order.createdAt.millisecondsSinceEpoch,
      'updatedAt': order.updatedAt?.millisecondsSinceEpoch,
      'totalQuantity': order.totalQuantity,
      'subTotal': order.subTotal,
      'discountTotal': order.discountTotal,
      'taxTotal': order.taxTotal,
      'finalTotal': order.finalTotal,
      'roundOff': order.roundOff,
      'grandTotal': order.grandTotal,
      'paidTotal': order.paidTotal,
      'orderType': order.type.index,
    };
  }

  /// Serialize payment state for OpLog data field.
  static Map<String, dynamic> paymentToData(Payment payment) {
    return {
      'id': payment.id,
      'orderId': payment.orderId,
      'date': payment.date.millisecondsSinceEpoch,
      'amount': payment.amount,
      'mode': payment.mode.index,
      'reference': payment.reference,
    };
  }
}
