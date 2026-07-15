/// Real BLE adapter using `flutter_blue_plus`.
///
/// Drop-in replacement for the abandoned `flutter_bluetooth_basic` package.
/// Exposes the same classes (`BluetoothDevice`, `BluetoothManager`) and
/// integer constants so that `bluetooth_printer.service.dart` compiles
/// unchanged.
///
/// Device discovery uses BLE (compatible with most modern thermal printers
/// such as Star, Epson, Bixolon, etc.). Data is written to the first
/// discoverable writable characteristic.
library flutter_bluetooth_adapter;

import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

// ---------------------------------------------------------------------------
// BluetoothDevice (wraps fbp.ScanResult / fbp.BluetoothDevice)
// ---------------------------------------------------------------------------

class BluetoothDevice {
  BluetoothDevice({
    this.name,
    this.address,
    this.type,
    this.remoteId,
  });

  factory BluetoothDevice.fromJson(Map<String, dynamic> json) =>
      BluetoothDevice(
        name: json['name'] as String?,
        address: json['address'] as String?,
        type: json['type'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'type': type,
  };

  final String? name;
  final String? address;
  final int? type;
  final String? remoteId;

  String get id => remoteId ?? address ?? name ?? '';

  @override
  bool operator ==(Object other) =>
      other is BluetoothDevice && other.address == address;

  @override
  int get hashCode => address.hashCode;

  static BluetoothDevice fromScanResult(fbp.ScanResult r) {
    final device = r.device;
    return BluetoothDevice(
      name: device.platformName.isEmpty ? r.advertisementData.advName : device.platformName,
      address: device.remoteId.str,
      remoteId: device.remoteId.str,
    );
  }
}

// ---------------------------------------------------------------------------
// BluetoothManager (singleton, real BLE via flutter_blue_plus)
// ---------------------------------------------------------------------------

class BluetoothManager {
  BluetoothManager._();

  static final BluetoothManager instance = BluetoothManager._();

  // State constants (same values as original flutter_bluetooth_basic).
  static const int CONNECTED = 1;
  static const int DISCONNECTED = 0;

  fbp.BluetoothDevice? _connectedDevice;
  fbp.BluetoothCharacteristic? _txCharacteristic;

  // Scan
  final StreamController<List<BluetoothDevice>> _scanController =
      StreamController<List<BluetoothDevice>>.broadcast();
  final StreamController<bool> _isScanningController =
      StreamController<bool>.broadcast();

  Stream<List<BluetoothDevice>> get scanResults => _scanController.stream;
  Stream<bool> get isScanning => _isScanningController.stream;

  Future<void> startScan({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      _isScanningController.add(true);

      fbp.FlutterBluePlus.scanResults.listen((results) {
        final devices = results
            .map((r) => BluetoothDevice.fromScanResult(r))
            .toList();
        _scanController.add(devices);
      });

      await fbp.FlutterBluePlus.startScan(
        timeout: timeout,
        withServices: [],
      );

      await Future.delayed(timeout);
    } catch (e) {
      debugPrint('[BLE] Scan error: $e');
    } finally {
      _isScanningController.add(false);
    }
  }

  Future<void> stopScan() async {
    try {
      await fbp.FlutterBluePlus.stopScan();
    } catch (_) {}
    _isScanningController.add(false);
  }

  // Connection state
  final StreamController<int> _stateController =
      StreamController<int>.broadcast();
  Stream<int> get state => _stateController.stream;

  Future<void> connect(BluetoothDevice device) async {
    try {
      _connectedDevice = fbp.FlutterBluePlus.connectedDevices
          .where((d) => d.remoteId.str == device.id)
          .firstOrNull;

      if (_connectedDevice == null) {
        final found = await _findDeviceById(device.id);
        if (found == null) {
          debugPrint('[BLE] Device not found: ${device.id}');
          _stateController.add(DISCONNECTED);
          return;
        }
        _connectedDevice = found;
        await _connectedDevice!.connect(timeout: const Duration(seconds: 10));
      }

      _stateController.add(CONNECTED);

      final svcs = await _connectedDevice!.discoverServices();
      for (final service in svcs) {
        for (final characteristic in service.characteristics) {
          if (characteristic.properties.write ||
              characteristic.properties.writeWithoutResponse) {
            _txCharacteristic = characteristic;
            break;
          }
        }
        if (_txCharacteristic != null) break;
      }

      if (_txCharacteristic == null) {
        debugPrint('[BLE] No writable characteristic found');
      }
    } catch (e) {
      debugPrint('[BLE] Connect error: $e');
      _stateController.add(DISCONNECTED);
    }
  }

  Future<void> disconnect() async {
    try {
      await _connectedDevice?.disconnect();
    } catch (_) {}
    _connectedDevice = null;
    _txCharacteristic = null;
    _stateController.add(DISCONNECTED);
  }

  Future<void> writeData(List<int> data) async {
    if (_txCharacteristic == null) {
      debugPrint('[BLE] No TX characteristic available');
      return;
    }
    try {
      await _txCharacteristic!.write(data, withoutResponse: true);
    } catch (e) {
      debugPrint('[BLE] Write error: $e');
    }
  }

  Future<fbp.BluetoothDevice?> _findDeviceById(String id) async {
    fbp.BluetoothDevice? found;
    final sub = fbp.FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        if (r.device.remoteId.str == id) {
          found = r.device;
        }
      }
    });
    await fbp.FlutterBluePlus.startScan(timeout: const Duration(seconds: 3));
    // startScan with [timeout] auto-stops after the duration
    await Future.delayed(const Duration(seconds: 4));
    await sub.cancel();
    return found;
  }
}
