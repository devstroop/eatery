import 'dart:convert';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_pos/database/printer.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:restaurant_pos/services/printing/print_invoice.dart';


class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({Key? key}) : super(key: key);

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
    printerManager.scanResults.listen((devices) async {
      // print('UI: Devices found ${devices.length}');
      setState(() {
        _devices = devices;
      });
    });
  }

  void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    printerManager.startScan(const Duration(seconds: 4));
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }


  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Printer Settings'),
    );
    return Scaffold(
      appBar: appBar,
      body: _devices.isNotEmpty
          ? ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    PrinterBluetooth printerBt = _devices[index];
                    await Printer.clear();
                    await Printer.add({'name': printerBt.name, 'address': printerBt.address, 'type': printerBt.type});
                    showSnackBar(context, "Successfully saved");
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 60,
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.print),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(_devices[index].name ?? ''),
                                  Text(_devices[index].address!),
                                  /*Text(
                                    'Long press to print a test receipt',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                );
              })
          : const Center(child: Text('No device found')),
      floatingActionButton: StreamBuilder<bool>(
        stream: printerManager.isScanningStream,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: _stopScanDevices,
              backgroundColor: ColorStyle.warning,
            );
          } else {
            return FloatingActionButton(
              backgroundColor: ColorStyle.information,
              child: const Icon(Icons.search),
              onPressed: _startScanDevices,
            );
          }
        },
      ),
    );
  }
}
