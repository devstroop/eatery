import 'dart:io';

import 'package:eatery_core/data/sync/mdns_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Advertiser packet building', () {
    late Advertiser advertiser;
    late InternetAddress testAddr;

    setUp(() async {
      testAddr = InternetAddress('192.168.1.100');
      final socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0,
        reuseAddress: true,
        reusePort: true,
      );
      advertiser = Advertiser(socket, 'test-admin', 9876);
    });

    test('builds a non-empty mDNS response packet', () {
      final packet = advertiser.buildResponse(testAddr);
      expect(packet, isNotEmpty);
    });

    test('packet has mDNS response flags (0x8400)', () {
      final packet = advertiser.buildResponse(testAddr);
      expect(packet[2], 0x84);
      expect(packet[3], 0x00);
    });

    test('packet contains exactly 3 answer records', () {
      final packet = advertiser.buildResponse(testAddr);
      expect(packet[6], 0);
      expect(packet[7], 3);
    });

    test('packet contains PTR, SRV, and A record types', () {
      final packet = advertiser.buildResponse(testAddr);
      final hasPtr = _hasTypeAtOffset(packet, 12, 12);
      final hasSrv = _hasTypeAtOffset(packet, 33, 12);
      final hasA = _hasTypeAtOffset(packet, 1, 12);
      expect(hasPtr, true, reason: 'Packet should contain PTR type (12)');
      expect(hasSrv, true, reason: 'Packet should contain SRV type (33)');
      expect(hasA, true, reason: 'Packet should contain A type (1)');
    });

    test('packet contains the service type _eatery._tcp', () {
      final packet = advertiser.buildResponse(testAddr);
      final ascii = String.fromCharCodes(packet);
      expect(ascii, contains('_eatery'));
      expect(ascii, contains('_tcp'));
    });

    test('packet contains device name and port 9876', () {
      final packet = advertiser.buildResponse(testAddr);
      final ascii = String.fromCharCodes(packet);
      expect(ascii, contains('test-admin'));
      // Port 9876 = 0x2694 appears somewhere in the packet
      expect(packet, containsAllInOrder([0x26, 0x94]));
    });

    test('packet contains the IP address bytes at the end', () {
      final packet = advertiser.buildResponse(testAddr);
      final last4 = packet.sublist(packet.length - 4);
      expect(last4, [192, 168, 1, 100]);
    });

    tearDown(() {
      advertiser.stop();
    });
  });
}

bool _hasTypeAtOffset(List<int> packet, int type, int headerSkip) {
  final typeHi = type >> 8;
  final typeLo = type & 0xff;
  for (int i = headerSkip; i < packet.length - 1; i++) {
    if (packet[i] == typeHi && packet[i + 1] == typeLo) return true;
  }
  return false;
}
