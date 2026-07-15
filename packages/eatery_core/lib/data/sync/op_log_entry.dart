import 'dart:convert';

/// An immutable operation log entry representing one state mutation.
///
/// Every create, update, void, or refund produces one OpLog entry.
/// The current state of any entity is a fold over all its ops.
class OpLogEntry {
  /// UUID v7 (time-sortable unique ID)
  final String id;

  /// Which entity type ("order", "product", "payment", "customer", "company")
  final String entityType;

  /// Local entity ID within its type
  final int entityId;

  /// "create", "update", "void", "refund", "payment"
  final String operation;

  /// Full snapshot of the entity AFTER the mutation
  final Map<String, dynamic> data;

  /// Snapshot of the entity BEFORE the mutation (null for creates)
  final Map<String, dynamic>? prevData;

  /// Logical clock — milliseconds since epoch on originating device
  final int timestamp;

  /// Originating device ID
  final String deviceId;

  /// Previous OpLog entry ID for this entity (forms a chain per entity)
  final String? parentId;

  /// Which sync host accepted this entry (null if not yet synced)
  final String? hostId;

  /// Free-form metadata (staff who performed action, reason codes, etc.)
  final Map<String, dynamic>? metadata;

  const OpLogEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.data,
    this.prevData,
    required this.timestamp,
    required this.deviceId,
    this.parentId,
    this.hostId,
    this.metadata,
  });

  factory OpLogEntry.fromJson(Map<String, dynamic> json) {
    return OpLogEntry(
      id: json['id'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as int,
      operation: json['operation'] as String,
      data: json['data'] as Map<String, dynamic>,
      prevData: json['prevData'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] as int,
      deviceId: json['deviceId'] as String,
      parentId: json['parentId'] as String?,
      hostId: json['hostId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entityType': entityType,
      'entityId': entityId,
      'operation': operation,
      'data': data,
      'prevData': prevData,
      'timestamp': timestamp,
      'deviceId': deviceId,
      'parentId': parentId,
      'hostId': hostId,
      'metadata': metadata,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  OpLogEntry copyWith({String? hostId, Map<String, dynamic>? metadata}) {
    return OpLogEntry(
      id: id,
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      data: data,
      prevData: prevData,
      timestamp: timestamp,
      deviceId: deviceId,
      parentId: parentId,
      hostId: hostId ?? this.hostId,
      metadata: metadata ?? this.metadata,
    );
  }
}
