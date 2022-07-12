import 'dart:convert';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:eatery/components/bottom_view_grip.dart';
import 'package:eatery/database/account.dart';
import 'package:eatery/database/printer.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:eatery/services/printing/print_invoice.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({Key? key, this.account}) : super(key: key);
  final dynamic account;
  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  final List<PrinterBluetooth> _savedDevices = [];



  Future<void> loadDevicesFromDatabase() async {
    List<Map<String, dynamic>> _devices = await Printer.getAll();
    for (Map<String, dynamic> _device in _devices) {
      setState(() {
        _savedDevices.add(PrinterBluetooth(BluetoothDevice.fromJson(_device)));
      });
    }
  }
  Widget buildPrinterConfigBottomSheet() => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    bool autoPrintOnSale = widget.account['autoPrintOnSale'] ?? false;
    List<String> printerSizes = ['58mm', '80mm'];
    String selectedPrinterSize = widget.account['printerSize'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: BottomViewGrip(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Auto print on sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              FlutterSwitch(
                activeText: "on",
                inactiveText: "off",
                value: autoPrintOnSale,
                valueFontSize: 14.0,
                width: 72,
                height: 36,
                borderRadius: 36.0,
                showOnOff: true,
                activeTextFontWeight: FontWeight.w500,
                inactiveTextFontWeight: FontWeight.w500,
                toggleSize: 30.0,
                // activeToggleColor: Color(0xFF6E40C9),
                // inactiveToggleColor: Color(0xFF2F363D),
                // activeColor: getThemeColor(),
                // inactiveColor: Colors.white,
                // activeTextColor: Colors.black,
                // inactiveTextColor: Colors.white,

                onToggle: (value) async {
                  widget.account['autoPrintOnSale'] = !autoPrintOnSale;
                  await Account.update(widget.account);
                  setState(() {
                    autoPrintOnSale = !autoPrintOnSale;
                  });
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              DropDown(
                //isExpanded: true,
                initialValue: widget.account['printerSize'],
                items: printerSizes,
                hint: const Text("Select"),
                icon: Icon(
                  Icons.expand_more,
                  color: ColorStyle.logoColor,
                ),
                onChanged: (value) async {
                  widget.account['printerSize'] = selectedPrinterSize;
                  await Account.update(widget.account);
                  setState((){
                    selectedPrinterSize = value.toString();
                  });
                },
              ),
            ],
          ),

          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadDevicesFromDatabase());
    //loadDevicesFromDatabase();

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
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          _savedDevices.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _savedDevices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                          context: context,
                          builder: (context) => buildPrinterConfigBottomSheet()),

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
                                      Text(_savedDevices[index].name ?? ''),
                                      Text(_savedDevices[index].address!),
                                      Text(
                                        'Tap to configure',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: ColorStyle.information,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  })
              : const SizedBox.shrink(),
          _devices.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        PrinterBluetooth printerBt = _devices[index];
                        await Printer.clear();
                        await Printer.add(
                            {'name': printerBt.name, 'address': printerBt.address, 'type': printerBt.type});
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
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  })
              : const SizedBox.shrink(),
        ],
      ),
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
