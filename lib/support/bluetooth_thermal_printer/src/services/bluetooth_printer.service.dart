import 'dart:async';
import 'dart:io';

import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import '../../bluetooth_thermal_printer.dart';

class BluetoothPrinterService {
  final BluetoothManager _bluetoothManager = BluetoothManager.instance;
  bool _isPrinting = false;
  bool _isConnected = false;
  StreamSubscription? _scanResultsSubscription;
  StreamSubscription? _isScanningSubscription;
  BluetoothPrinter? _selectedPrinter;

  final BehaviorSubject<bool> _isScanning = BehaviorSubject.seeded(false);
  Stream<bool> get isScanningStream => _isScanning.stream;

  final BehaviorSubject<List<BluetoothPrinter>> _scanResults =
      BehaviorSubject.seeded([]);
  Stream<List<BluetoothPrinter>> get scanResults => _scanResults.stream;

  Future _runDelayed(int seconds) {
    return Future<dynamic>.delayed(Duration(seconds: seconds));
  }

  void startScan(Duration timeout) async {
    _scanResults.add(<BluetoothPrinter>[]);

    _bluetoothManager.startScan(timeout: timeout);

    _scanResultsSubscription = _bluetoothManager.scanResults.listen((devices) {
      _scanResults.add(devices.map((d) => BluetoothPrinter(d)).toList());
    });

    _isScanningSubscription =
        _bluetoothManager.isScanning.listen((isScanningCurrent) async {
      // If isScanning value changed (scan just stopped)
      if (_isScanning.value! && !isScanningCurrent) {
        _scanResultsSubscription!.cancel();
        _isScanningSubscription!.cancel();
      }
      _isScanning.add(isScanningCurrent);
    });
  }

  void stopScan() async {
    await _bluetoothManager.stopScan();
  }

  void selectPrinter(BluetoothPrinter printer) {
    _selectedPrinter = printer;
  }

  Future<PrintResult> writeBytes(
    List<int> bytes, {
    int chunkSizeBytes = 20,
    int queueSleepTimeMs = 20,
  }) async {
    final Completer<PrintResult> completer = Completer();

    const int timeout = 5;
    if (_selectedPrinter == null) {
      return Future<PrintResult>.value(PrintResult.printerNotSelected);
    } else if (_isScanning.value!) {
      return Future<PrintResult>.value(PrintResult.scanInProgress);
    } else if (_isPrinting) {
      return Future<PrintResult>.value(PrintResult.printInProgress);
    }

    _isPrinting = true;

    // We have to re-scan before connecting, otherwise we can connect only once
    await _bluetoothManager.startScan(timeout: const Duration(seconds: 1));
    await _bluetoothManager.stopScan();

    // Connect
    await _bluetoothManager.connect(_selectedPrinter!.device);

    // Subscribe to the events
    _bluetoothManager.state.listen((state) async {
      switch (state) {
        case BluetoothManager.CONNECTED:
          // To avoid double call
          if (!_isConnected) {
            final len = bytes.length;
            List<List<int>> chunks = [];
            for (var i = 0; i < len; i += chunkSizeBytes) {
              var end = (i + chunkSizeBytes < len) ? i + chunkSizeBytes : len;
              chunks.add(bytes.sublist(i, end));
            }

            for (var i = 0; i < chunks.length; i += 1) {
              await _bluetoothManager.writeData(chunks[i]);
              sleep(Duration(milliseconds: queueSleepTimeMs));
            }

            completer.complete(PrintResult.success);
          }
          // TODO sending disconnect signal should be event-based
          _runDelayed(3).then((dynamic v) async {
            await _bluetoothManager.disconnect();
            _isPrinting = false;
          });
          _isConnected = true;
          break;
        case BluetoothManager.DISCONNECTED:
          _isConnected = false;
          break;
        default:
          break;
      }
    });

    // Printing timeout
    _runDelayed(timeout).then((dynamic v) async {
      if (_isPrinting) {
        _isPrinting = false;
        completer.complete(PrintResult.timeout);
      }
    });

    return completer.future;
  }

  Future<PrintResult> printTicket(
    List<int> bytes, {
    int chunkSizeBytes = 20,
    int queueSleepTimeMs = 20,
  }) async {
    if (bytes.isEmpty) {
      return Future<PrintResult>.value(PrintResult.ticketEmpty);
    }
    return writeBytes(
      bytes,
      chunkSizeBytes: chunkSizeBytes,
      queueSleepTimeMs: queueSleepTimeMs,
    );
  }
}
