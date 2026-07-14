/// Drop-in API-compatible replacement for the abandoned `flutter_bluetooth_basic`
/// package. Exposes the same classes and constants so the local
/// `support/bluetooth_thermal_printer` module compiles unchanged.
///
/// **All methods are no-ops / return empty streams.** This is a build-time
/// stub, not a working Bluetooth implementation. Replace with a real plugin
/// (e.g. `esc_pos_bluetooth`, `flutter_blue_plus` for BLE, or
/// `flutter_bluetooth_serial` for SPP) when connecting to physical printers.
///
/// Files that previously imported `package:flutter_bluetooth_basic/…` now
/// import this file instead.
library flutter_bluetooth_adapter;

import 'dart:async';

// ---------------------------------------------------------------------------
// BluetoothDevice
// ---------------------------------------------------------------------------

class BluetoothDevice {
  BluetoothDevice({this.name, this.address, this.type});

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

  @override
  bool operator ==(Object other) =>
      other is BluetoothDevice && other.address == address;

  @override
  int get hashCode => address.hashCode;
}

// ---------------------------------------------------------------------------
// BluetoothManager (singleton, stub)
// ---------------------------------------------------------------------------

class BluetoothManager {
  BluetoothManager._();

  static final BluetoothManager instance = BluetoothManager._();

  // State constants (must match the original integer values for any
  // `switch (state)` in consuming code to compile).
  static const int CONNECTED = 1;
  static const int DISCONNECTED = 0;

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
    _isScanningController.add(true);
    await Future.delayed(timeout);
    _isScanningController.add(false);
    _scanController.add(const []);
  }

  Future<void> stopScan() async {
    _isScanningController.add(false);
  }

  // Connection
  final StreamController<int> _stateController =
      StreamController<int>.broadcast();
  Stream<int> get state => _stateController.stream;

  Future<void> connect(BluetoothDevice device) async {
    _stateController.add(CONNECTED);
  }

  Future<void> disconnect() async {
    _stateController.add(DISCONNECTED);
  }

  // Data
  Future<void> writeData(List<int> data) async {
    // no-op stub
  }
}
