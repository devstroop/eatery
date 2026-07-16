import 'package:intl/intl.dart';
import 'package:eatery/references.dart';

class PrintInvoice {
  static BluetoothPrinterService printerManager = BluetoothPrinterService();
  static Future<String> printReceipt({
    required Map<String, dynamic> order,
    required Map<String, dynamic> account,
  }) async {
    List<Map<String, dynamic>> jsons = []; // await Printer.getAll();
    if (jsons.isNotEmpty) {
      BluetoothDevice device = BluetoothDevice.fromJson(jsons.first);
      BluetoothPrinter printerBt = BluetoothPrinter(device);
      printerManager.selectPrinter(printerBt);
      PaperSize? paper = (account['printerSize'] == '80mm')
          ? PaperSize.mm80
          : (account['printerSize'] == '58mm')
          ? PaperSize.mm58
          : null;
      if (paper != null) {
        final profile = await CapabilityProfile.load();
        final PrintResult res = await printerManager.printTicket(
          (await PrintInvoice.generateReceipt(paper, profile, order, account)),
        );
        return res.msg;
      } else {
        return 'Printer not configured';
      }
    } else {
      return 'Printer not configured';
    }
  }

  static Future<List<int>> generateReceipt(
    PaperSize paper,
    CapabilityProfile profile,
    Map<String, dynamic> order,
    Map<String, dynamic> account,
  ) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    bytes += ticket.text(
      account['name'],
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1,
    );

    bytes += ticket.text(
      '${account['taxNo'] != '' ? (account['taxName'] != '' ? account['taxName'] : 'Tax') + ': ' : ''}${account['taxNo'] != '' ? account['taxNo'] + ', ' : ''}${account['foodLicenseNo'] != '' ? 'FSSAI:${account['foodLicenseNo']}' : ''}',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += ticket.text(
      '${account['address']}',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += ticket.text(
      '${account['phone']}, ${account['email']}',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: 'Order Id: #${order['id']}',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '${order['orderTypeText']}',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    ]);

    bytes += ticket.row([
      PosColumn(
        text: '${order['customerName'] ?? ''}',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '${order['customerPhone'] ?? ''}',
        width: 4,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '${order['customerAddress'] ?? ''}',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Particulars', width: 6),
      PosColumn(
        text: 'Price',
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: 'Amount',
        width: 2,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += ticket.hr();
    for (Map<String, dynamic> item in order['cart'].values) {
      bytes += ticket.row([
        PosColumn(
          text: Calculations.compressDoubleToString(item['quantity']),
          width: 1,
        ),
        PosColumn(text: item['name'], width: 6),
        PosColumn(
          text:
              '${Calculations.calculatePriceWithoutTax(taxType: item['taxType'], price: item['price'], tax: item['tax_slab'])}/-',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text:
              '${Calculations.calculatePriceWithoutTax(taxType: item['taxType'], price: item['price'], tax: item['tax_slab']) * item['quantity']}',
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: 'Taxable',
        width: 7,
        styles: const PosStyles(align: PosAlign.left, width: PosTextSize.size1),
      ),
      PosColumn(
        text: '${order['taxableTotal']}',
        width: 5,
        styles: const PosStyles(
          align: PosAlign.right,
          width: PosTextSize.size1,
          bold: true,
        ),
      ),
    ]);
    bytes += ticket.row([
      PosColumn(
        text: "${account['taxName'] != '' ? account['taxName'] : 'Tax'}",
        width: 7,
        styles: const PosStyles(align: PosAlign.left, width: PosTextSize.size1),
      ),
      PosColumn(
        text: '${order['taxTotal']}',
        width: 5,
        styles: const PosStyles(
          align: PosAlign.right,
          width: PosTextSize.size1,
          bold: true,
        ),
      ),
    ]);
    if (order['roundOff'] > 0) {
      bytes += ticket.row([
        PosColumn(
          text: 'Round off (+/-)',
          width: 7,
          styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: '${order['roundOff']}',
          width: 5,
          styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            bold: true,
          ),
        ),
      ]);
    }

    bytes += ticket.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
      PosColumn(
        text: '${account['currencySymbol']}${order['finalTotal']}',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    ]);

    bytes += ticket.hr(ch: '-', linesAfter: 1);

    bytes += ticket.text(
      'Thank you!',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += ticket.text(
      timestamp,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += ticket.qrcode(order['id']);
    bytes += ticket.feed(2);

    bytes += ticket.hr(ch: '=', linesAfter: 2);

    bytes += ticket.text(
      'KOT',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1,
    );

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: 'Order Id: ${order['id']}',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '${order['orderTypeText']}',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    ]);

    bytes += ticket.hr();
    for (Map<String, dynamic> item in order['cart'].values) {
      bytes += ticket.row([
        PosColumn(
          text: item['name'],
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: Calculations.compressDoubleToString(item['quantity']),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += ticket.hr();

    if (order['tableName'] != null) {
      bytes += ticket.row([
        PosColumn(
          text: 'Table',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size2,
          ),
        ),
        PosColumn(
          text: '${order['tableName']}',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size2,
            bold: true,
          ),
        ),
      ]);
      bytes += ticket.hr(ch: '-', linesAfter: 1);
    }

    bytes += ticket.text(
      timestamp,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += ticket.qrcode(order['id']);
    bytes += ticket.feed(2);

    // Print QR Code from image
    // try {
    //   const String qrData = 'example.com';
    //   const double qrSize = 200;
    //   final uiImg = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //     gapless: false,
    //   ).toImageData(qrSize);
    //   final dir = await getTemporaryDirectory();
    //   final pathName = '${dir.path}/qr_tmp.png';
    //   final qrFile = File(pathName);
    //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
    //   final img = decodeImage(imgFile.readAsBytesSync());

    //   bytes += ticket.image(img);
    // } catch (e) {
    //   print(e);
    // }

    ticket.feed(3);
    ticket.cut();
    return bytes;
  }
}
