import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_pos/database/printer.dart';
import 'package:restaurant_pos/extensions/calculations.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
class PrintReport{

  static PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  static Future<void> printReceipt({required List<Map<String, dynamic>> orders, required Map<String, dynamic> account, required DateTime from, required DateTime till}) async {
    List<Map<String, dynamic>> _jsons = await Printer.getAll();
    if(_jsons.isNotEmpty){
      BluetoothDevice _device = BluetoothDevice.fromJson(_jsons.first);
      PrinterBluetooth _printerBt = PrinterBluetooth(_device);
      printerManager.selectPrinter(_printerBt);
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final PosPrintResult res = await printerManager.printTicket((await PrintReport.generateReceipt(paper, profile, orders, account, from, till)));
    }
    else{

    }
  }
  static Future<List<int>> generateReceipt(PaperSize paper, CapabilityProfile profile, List<Map<String, dynamic>> orders, Map<String, dynamic> account, DateTime from, DateTime till) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    bytes += ticket.text('${account['name']}',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ), linesAfter: 1);

    bytes += ticket.text('Sales Report', styles: const PosStyles(align: PosAlign.center, bold: true, width: PosTextSize.size2,), linesAfter: 1);
    bytes += ticket.text('${DateFormat("yyyy-MM-dd").format(from)} - ${DateFormat("yyyy-MM-dd").format(till)}', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(text: 'Date' , width: 6, styles: const PosStyles(align: PosAlign.left)),
      PosColumn(text: 'Order Id', width: 3, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: 'Amount', width: 3, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += ticket.hr();

    double sum = 0;

    for(Map<String, dynamic> order in orders){
      if(DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isAfter(from) && DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).isBefore(till.add(const Duration(days: 1)))){
        
        bytes += ticket.row([
          PosColumn(text: DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.fromMicrosecondsSinceEpoch(order['timestamp'])) , width: 6, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '${order['id']}', width: 3, styles: const PosStyles(align: PosAlign.center)),
          PosColumn(text: '${order['finalTotal']}', width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);
        sum += order['finalTotal'];
      }
    }

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
          text: 'Total Sales',
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: 'INR $sum',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes += ticket.hr(ch: '-', linesAfter: 1);

    bytes += ticket.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += ticket.feed(2);


    ticket.feed(3);
    ticket.cut();
    return bytes;
  }

}