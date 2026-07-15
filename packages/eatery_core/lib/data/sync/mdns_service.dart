import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';

const int _mDnsPort = 5353;
final InternetAddress _mDnsAddr = InternetAddress('224.0.0.251');

/// A discovered sync host on the local network.
class MdnsDiscoveredHost {
  final String name;
  final InternetAddress address;
  final int port;

  const MdnsDiscoveredHost({
    required this.name,
    required this.address,
    required this.port,
  });

  String get ip => address.address;
}

/// mDNS-based sync host discovery and advertising.
///
/// - **Host** (admin app): calls [startAdvertising] to announce `_eatery._tcp`
///   on the LAN via unsolicited mDNS response packets.
/// - **Leaf** (waiter/KDS/display): calls [discoverHosts] to find sync hosts.
abstract class MdnsService {
  /// The mDNS service type used by Eatery sync.
  static const String kServiceType = '_eatery._tcp';
  static const String kServiceDomain = '_eatery._tcp.local';

  /// Discover sync hosts on the local network.
  ///
  /// Returns a list of discovered hosts within [timeout]. The list is empty
  /// when no hosts respond.
  static Future<List<MdnsDiscoveredHost>> discoverHosts({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final client = MDnsClient();
    await client.start();

    final hosts = <MdnsDiscoveredHost>[];
    try {
      await for (final ptr
          in client
              .lookup<PtrResourceRecord>(
                ResourceRecordQuery.serverPointer(kServiceDomain),
                timeout: timeout,
              )
              .take(1)
              .timeout(timeout)) {
        await for (final srv
            in client
                .lookup<SrvResourceRecord>(
                  ResourceRecordQuery.service(ptr.domainName),
                  timeout: timeout,
                )
                .take(1)
                .timeout(timeout)) {
          debugPrint(
            'MdnsService: found SRV target=${srv.target} port=${srv.port}',
          );
          await for (final ip
              in client
                  .lookup<IPAddressResourceRecord>(
                    ResourceRecordQuery.addressIPv4(srv.target),
                    timeout: timeout,
                  )
                  .take(1)
                  .timeout(timeout)) {
            debugPrint(
              'MdnsService: resolved IP ${ip.address} for ${srv.target}',
            );
            hosts.add(
              MdnsDiscoveredHost(
                name: ptr.domainName,
                address: ip.address,
                port: srv.port,
              ),
            );
          }
        }
      }
    } on TimeoutException {
      // Expected when no hosts respond — return whatever we found.
    } finally {
      client.stop();
    }

    return hosts;
  }

  /// Start advertising this device as an Eatery sync host.
  ///
  /// Sends unsolicited mDNS response packets every 5 seconds so leaf devices
  /// can discover this host via [discoverHosts].
  ///
  /// Call [stopAdvertising] with the returned [Advertiser] to stop.
  static Future<Advertiser> startAdvertising({
    required int port,
    String? deviceName,
  }) async {
    final socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      _mDnsPort,
      reuseAddress: true,
      reusePort: true,
      ttl: 255,
    );
    socket.joinMulticast(_mDnsAddr);

    final name = deviceName ?? 'eatery-admin';
    final advertiser = Advertiser(socket, name, port);
    advertiser._start();
    return advertiser;
  }
}

/// Handle returned by [MdnsService.startAdvertising].
class Advertiser {
  final RawDatagramSocket _socket;
  final String _name;
  final int _port;
  Timer? _timer;

  /// Creates an advertiser.
  ///
  /// The [socket] must already be bound and joined to the mDNS multicast
  /// group. Normally obtained via [MdnsService.startAdvertising].
  Advertiser(this._socket, this._name, this._port);

  void _start() {
    _sendAnnouncement();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _sendAnnouncement();
    });
  }

  Future<void> _sendAnnouncement() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLinkLocal: true,
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (addr.type != InternetAddressType.IPv4) continue;
          final packet = buildResponse(addr);
          _socket.send(packet, _mDnsAddr, _mDnsPort);
        }
      }
    } catch (e) {
      debugPrint('MdnsService: announce error — $e');
    }
  }

  /// Builds an mDNS response advertising the `_eatery._tcp` service.
  ///
  /// Contains PTR, SRV, and A records for the service instance.
  Uint8List buildResponse(InternetAddress addr) {
    final nameBytes = utf8.encode(_name);
    final serviceTypeEnc = utf8.encode('_eatery._tcp.local');
    final instanceEnc = utf8.encode('$_name._eatery._tcp.local');
    final targetEnc = utf8.encode('$_name.local');
    final addrBytes = addr.rawAddress;

    final buf = BytesBuilder();
    // Header: ID=0, flags=0x8400 (response, authoritative)
    _writeU16(buf, 0);
    _writeU16(buf, 0x8400);
    _writeU16(buf, 0); // questions
    _writeU16(buf, 3); // answers (PTR + SRV + A)

    // ── PTR record: _eatery._tcp.local → instance._eatery._tcp.local ──
    _writeName(buf, serviceTypeEnc);
    _writeU16(buf, 12); // QTYPE PTR
    _writeU16(buf, 0x8001); // CLASS IN + cache-flush
    _writeU32(buf, 120); // TTL
    _writeU16(buf, instanceEnc.length + 2); // RDLENGTH
    _writeName(buf, instanceEnc);

    // ── SRV record: instance._eatery._tcp.local → target:port ──
    _writeName(buf, instanceEnc);
    _writeU16(buf, 33); // QTYPE SRV
    _writeU16(buf, 0x8001);
    _writeU32(buf, 120);
    _writeU16(buf, targetEnc.length + 6); // RDLENGTH
    _writeU16(buf, 0); // priority
    _writeU16(buf, 0); // weight
    _writeU16(buf, _port);
    _writeName(buf, targetEnc);

    // ── A record: target.local → IP ──
    _writeName(buf, targetEnc);
    _writeU16(buf, 1); // QTYPE A
    _writeU16(buf, 0x8001);
    _writeU32(buf, 120);
    _writeU16(buf, addrBytes.length);
    buf.add(addrBytes);

    return buf.toBytes();
  }

  void _writeU16(BytesBuilder buf, int v) {
    buf.add([v >> 8, v & 0xff]);
  }

  void _writeU32(BytesBuilder buf, int v) {
    buf.add([v >> 24, (v >> 16) & 0xff, (v >> 8) & 0xff, v & 0xff]);
  }

  void _writeName(BytesBuilder buf, List<int> labelEncoded) {
    for (final part in utf8.decode(labelEncoded).split('.')) {
      final bytes = utf8.encode(part);
      buf.add([bytes.length]);
      buf.add(bytes);
    }
    buf.add([0]);
  }

  /// Stop advertising.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _socket.close();
  }
}
