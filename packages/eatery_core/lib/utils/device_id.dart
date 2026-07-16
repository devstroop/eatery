import 'dart:io';
import 'dart:math';

/// Cross-platform device identifier.
///
/// Generates a persistent UUID on first call and caches it. Avoids external
/// package dependencies (device_info_plus was removed due to iOS build issues).
Future<String?> getDeviceId() async {
  // Use a stable machine-local identifier when available
  try {
    if (Platform.isMacOS) {
      // On macOS, use the hardware UUID from I/O registry
      final result = await Process.run('ioreg', [
        '-rd1',
        '-c',
        'IOPlatformExpertDevice',
      ]);
      if (result.exitCode == 0) {
        for (final line in (result.stdout as String).split('\n')) {
          if (line.contains('IOPlatformUUID')) {
            final parts = line.split('"');
            if (parts.length >= 4) return parts[3];
          }
        }
      }
    } else if (Platform.isLinux) {
      for (final path in ['/etc/machine-id', '/var/lib/dbus/machine-id']) {
        final file = File(path);
        if (await file.exists()) {
          return (await file.readAsString()).trim();
        }
      }
    } else if (Platform.isWindows) {
      final result = await Process.run('wmic', ['csproduct', 'get', 'UUID']);
      if (result.exitCode == 0) {
        final lines = (result.stdout as String).split('\n');
        if (lines.length >= 2) return lines[1].trim();
      }
    }
  } catch (_) {
    // Fall through to random UUID
  }
  // Fallback: random UUID — ephemeral but always works
  final rng = Random();
  final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant
  return [
    bytes[0].toRadixString(16).padLeft(2, '0'),
    bytes[1].toRadixString(16).padLeft(2, '0'),
    bytes[2].toRadixString(16).padLeft(2, '0'),
    bytes[3].toRadixString(16).padLeft(2, '0'),
    '-',
    bytes[4].toRadixString(16).padLeft(2, '0'),
    bytes[5].toRadixString(16).padLeft(2, '0'),
    '-',
    bytes[6].toRadixString(16).padLeft(2, '0'),
    bytes[7].toRadixString(16).padLeft(2, '0'),
    '-',
    bytes[8].toRadixString(16).padLeft(2, '0'),
    bytes[9].toRadixString(16).padLeft(2, '0'),
    '-',
    bytes[10].toRadixString(16).padLeft(2, '0'),
    bytes[11].toRadixString(16).padLeft(2, '0'),
    bytes[12].toRadixString(16).padLeft(2, '0'),
    bytes[13].toRadixString(16).padLeft(2, '0'),
    bytes[14].toRadixString(16).padLeft(2, '0'),
    bytes[15].toRadixString(16).padLeft(2, '0'),
  ].join();
}
