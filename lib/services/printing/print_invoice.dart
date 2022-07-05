import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:restaurant_pos/database/printer.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';

class PrintInvoice{
  static PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  static void print(Map<String, dynamic> order) async {
    List<Map<String, dynamic>> _jsons = await Printer.getAll();
    if(_jsons.isNotEmpty){
      BluetoothDevice _device = BluetoothDevice.fromJson(_jsons.first);
      PrinterBluetooth _printerBt = PrinterBluetooth(_device);
      printerManager.selectPrinter(_printerBt);
      const PaperSize paper = PaperSize.mm58;
      final profile = await CapabilityProfile.load();
      //final PosPrintResult res = await printerManager.printTicket((await demoReceipt(paper, profile)));
      //showSnackBar(context, res.msg);

      // Do print here
    }
    else{

    }
  }
}