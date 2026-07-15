import 'package:eatery_core/eatery_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SyncMessage serialization', () {
    test('opLogPush roundtrips', () {
      final msg = SyncMessage.opLogPush(
        deviceId: 'device-1',
        clock: 42,
        entries: [
          {
            'id': 'e1',
            'entityType': 'product',
            'entityId': 1,
            'operation': 'create',
            'data': {'name': 'Latte'},
            'timestamp': 1000,
            'deviceId': 'device-1',
          },
        ],
      );
      final json = msg.toJsonString();
      final restored = SyncMessage.fromJsonString(json);
      expect(restored.type, 'oplog_push');
      expect(restored.deviceId, 'device-1');
      expect(restored.clock, 42);
      expect(restored.entries, hasLength(1));
      expect(restored.entries!.first['entityType'], 'product');
    });

    test('opLogPull roundtrips', () {
      final msg = SyncMessage.opLogPull(
        deviceId: 'device-2',
        clock: 10,
        sinceClock: 5,
      );
      final json = msg.toJsonString();
      final restored = SyncMessage.fromJsonString(json);
      expect(restored.type, 'oplog_pull');
      expect(restored.payload!['sinceClock'], 5);
    });

    test('opLogBroadcast roundtrips', () {
      final msg = SyncMessage.opLogBroadcast(
        deviceId: 'host-1',
        clock: 99,
        entries: [
          {
            'id': 'e2',
            'entityType': 'order',
            'entityId': 7,
            'operation': 'update',
            'data': {'status': 'paid'},
            'timestamp': 2000,
            'deviceId': 'waiter-1',
          },
        ],
      );
      final json = msg.toJsonString();
      final restored = SyncMessage.fromJsonString(json);
      expect(restored.type, 'oplog_broadcast');
      expect(restored.entries, hasLength(1));
    });

    test('hostAnnounce roundtrips', () {
      final msg = SyncMessage.hostAnnounce(
        deviceId: 'host-1',
        clock: 15,
        deviceName: 'Admin iPad',
      );
      final json = msg.toJsonString();
      final restored = SyncMessage.fromJsonString(json);
      expect(restored.type, 'host_announce');
      expect(restored.deviceName, 'Admin iPad');
    });

    test('hostVote roundtrips', () {
      final msg = SyncMessage.hostVote(
        deviceId: 'leaf-1',
        clock: 3,
        uptimeSeconds: 3600,
      );
      final json = msg.toJsonString();
      final restored = SyncMessage.fromJsonString(json);
      expect(restored.type, 'host_vote');
      expect(restored.payload!['uptimeSeconds'], 3600);
    });

    test('ack roundtrips', () {
      final msg = SyncMessage.ack(
        deviceId: 'host-1',
        clock: 50,
        lastAppliedClock: 45,
      );
      final json = msg.toJsonString();
      final restored = SyncMessage.fromJsonString(json);
      expect(restored.type, 'ack');
      expect(restored.payload!['lastAppliedClock'], 45);
    });

    test('heartbeat roundtrips', () {
      final msg = SyncMessage.heartbeat(deviceId: 'leaf-1', clock: 7);
      final json = msg.toJsonString();
      final restored = SyncMessage.fromJsonString(json);
      expect(restored.type, 'heartbeat');
      expect(restored.clock, 7);
    });
  });
}
