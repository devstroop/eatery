// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import '../../flutter_bluetooth_adapter.dart';

class BluetoothPrinter {
  BluetoothPrinter(this.device);
  final BluetoothDevice device;

  String? get name => device.name;
  String? get address => device.address;
  int? get type => device.type;
}
