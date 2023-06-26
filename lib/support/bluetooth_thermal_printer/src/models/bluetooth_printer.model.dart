// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
class BluetoothPrinter {
  BluetoothPrinter(this.device);
  final BluetoothDevice device;

  String? get name => device.name;
  String? get address => device.address;
  int? get type => device.type;
}
