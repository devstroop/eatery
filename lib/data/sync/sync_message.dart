/// Wire protocol messages between devices and sync host.
///
/// All messages are JSON-encoded WebSocket frames.
class SyncMessage {
  final String type;
  final String deviceId;
  final int clock;
  final String? deviceName;
  final String? devicePlatform;
  final String? appVersion;
  final List<Map<String, dynamic>>? entries;
  final Map<String, dynamic>? payload;

  const SyncMessage({
    required this.type,
    required this.deviceId,
    required this.clock,
    this.deviceName,
    this.devicePlatform,
    this.appVersion,
    this.entries,
    this.payload,
  });

  factory SyncMessage.fromJson(Map<String, dynamic> json) {
    return SyncMessage(
      type: json['type'] as String,
      deviceId: json['deviceId'] as String,
      clock: json['clock'] as int,
      deviceName: json['deviceName'] as String?,
      devicePlatform: json['devicePlatform'] as String?,
      appVersion: json['appVersion'] as String?,
      entries: (json['entries'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      payload: json['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'deviceId': deviceId,
      'clock': clock,
      if (deviceName != null) 'deviceName': deviceName,
      if (devicePlatform != null) 'devicePlatform': devicePlatform,
      if (appVersion != null) 'appVersion': appVersion,
      if (entries != null) 'entries': entries,
      if (payload != null) 'payload': payload,
    };
  }

  // ── Factory constructors for each message type ──

  factory SyncMessage.hostAnnounce({
    required String deviceId,
    required int clock,
    required String deviceName,
  }) {
    return SyncMessage(
      type: 'host_announce',
      deviceId: deviceId,
      clock: clock,
      deviceName: deviceName,
    );
  }

  factory SyncMessage.opLogPush({
    required String deviceId,
    required int clock,
    required List<Map<String, dynamic>> entries,
  }) {
    return SyncMessage(
      type: 'oplog_push',
      deviceId: deviceId,
      clock: clock,
      entries: entries,
    );
  }

  factory SyncMessage.opLogPull({
    required String deviceId,
    required int clock,
    int? sinceClock,
  }) {
    return SyncMessage(
      type: 'oplog_pull',
      deviceId: deviceId,
      clock: clock,
      payload: sinceClock != null ? {'sinceClock': sinceClock} : null,
    );
  }

  factory SyncMessage.opLogBroadcast({
    required String deviceId,
    required int clock,
    required List<Map<String, dynamic>> entries,
  }) {
    return SyncMessage(
      type: 'oplog_broadcast',
      deviceId: deviceId,
      clock: clock,
      entries: entries,
    );
  }

  factory SyncMessage.hostVote({
    required String deviceId,
    required int clock,
    required int uptimeSeconds,
  }) {
    return SyncMessage(
      type: 'host_vote',
      deviceId: deviceId,
      clock: clock,
      payload: {'uptimeSeconds': uptimeSeconds},
    );
  }

  factory SyncMessage.hostClaim({
    required String deviceId,
    required int clock,
    required int lastOpTimestamp,
    required int entryCount,
  }) {
    return SyncMessage(
      type: 'host_claim',
      deviceId: deviceId,
      clock: clock,
      payload: {
        'lastOpTimestamp': lastOpTimestamp,
        'entryCount': entryCount,
      },
    );
  }

  factory SyncMessage.heartbeat({
    required String deviceId,
    required int clock,
  }) {
    return SyncMessage(
      type: 'heartbeat',
      deviceId: deviceId,
      clock: clock,
    );
  }

  factory SyncMessage.ack({
    required String deviceId,
    required int clock,
    required int lastAppliedClock,
  }) {
    return SyncMessage(
      type: 'ack',
      deviceId: deviceId,
      clock: clock,
      payload: {'lastAppliedClock': lastAppliedClock},
    );
  }
}
