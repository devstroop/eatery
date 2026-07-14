import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// Cross-platform device identifier.
///
/// Replaces platform_device_id which lacks macOS/desktop support.
Future<String?> getDeviceId() async {
  try {
    final plugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      return info.id; // Android ID
    } else if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      return info.identifierForVendor;
    } else if (Platform.isMacOS) {
      final info = await plugin.macOsInfo;
      return info.systemGUID;
    } else if (Platform.isWindows) {
      final info = await plugin.windowsInfo;
      return info.computerName;
    } else if (Platform.isLinux) {
      final info = await plugin.linuxInfo;
      return info.machineId;
    }
    return null;
  } catch (_) {
    return null;
  }
}
