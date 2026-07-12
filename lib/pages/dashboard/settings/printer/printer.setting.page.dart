import 'package:eatery/core/widgets/app_dialog.dart';
import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'dart:io';

import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/presentation/providers/printer_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eatery/core/theme/app_colors.dart';

/// Printer configuration page.
/// Mobile: discovers Bluetooth ESC/POS printers and saves them.
/// Desktop: shows guidance for WiFi/Ethernet network printers.
class PrinterSettingsPage extends ConsumerStatefulWidget {
  const PrinterSettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PrinterSettingsPage> createState() =>
      _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends ConsumerState<PrinterSettingsPage> {
  List<_DiscoveredPrinter> _discovered = [];
  bool _isScanning = false;
  bool _autoPrint = false;
  String _paperSize = '58mm';

  final BluetoothManager _btManager = BluetoothManager.instance;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _autoPrint = prefs.getBool('autoPrint') ?? false;
      _paperSize = prefs.getString('paperSize') ?? '58mm';
    });
  }

  Future<void> _saveAutoPrint(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoPrint', value);
    setState(() => _autoPrint = value);
  }

  Future<void> _savePaperSize(String size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('paperSize', size);
    setState(() => _paperSize = size);
  }

  Future<void> _startScan() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      if (this.context.mounted) {
        AppDialog.showMessage(
          this.context,
          message: 'Bluetooth scanning is only available on mobile devices.\nFor desktop, connect via WiFi/Ethernet ESC/POS.',
          type: MessageType.info,
        );
      }
      return;
    }

    setState(() {
      _discovered = [];
      _isScanning = true;
    });

    try {
      _btManager.startScan(timeout: const Duration(seconds: 8));
      _btManager.scanResults.listen((devices) {
        if (!mounted) return;
        setState(() {
          _discovered = devices
              .where((d) => d.name != null && d.name!.isNotEmpty)
              .map((d) => _DiscoveredPrinter(d.name!, d.address ?? ''))
              .toList();
        });
      });
      await Future.delayed(const Duration(seconds: 8));
    } catch (e) {
      if (this.context.mounted) {
        AppDialog.showMessage(this.context, message: 'Scan failed: $e', type: MessageType.error);
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _addPrinter(String name, String address) async {
    final printer = Printer(
      name: name,
      bluetoothAddress: address,
      type: PrinterType.bluetooth,
    );
    await ref.read(printerRepositoryProvider).addPrinter(printer);
    ref.invalidate(printerListProvider);
    if (this.context.mounted) {
      AppDialog.showMessage(this.context, message: 'Printer added', type: MessageType.success);
    }
  }

  Future<void> _removePrinter(Printer printer) async {
    await ref.read(printerRepositoryProvider).deletePrinter(printer);
    ref.invalidate(printerListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final savedPrinters = ref.watch(printerListProvider);

    return AppPageShell(
      title: 'Printer Settings',
      color: AppColors.menuCategories,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Saved Printers',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          savedPrinters.when(
            data: (printers) {
              if (printers.isEmpty) {
                return const Card(
                  child: ListTile(
                    leading: Icon(Icons.print_disabled),
                    title: Text('No printers configured'),
                    subtitle: Text('Scan for Bluetooth printers below'),
                  ),
                );
              }
              return Column(
                children: printers
                    .map(
                      (p) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.print),
                          title: Text(p.name),
                          subtitle: Text(p.bluetoothAddress ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.error),
                            onPressed: () => _removePrinter(p),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),

          const SizedBox(height: 24),
          const Divider(),
          AppSpacing.gapLg,

          Text(
            'Bluetooth Discovery',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _isScanning ? null : _startScan,
            icon: _isScanning
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bluetooth_searching),
            label: Text(_isScanning ? 'Scanning...' : 'Scan for Printers'),
          ),
          const SizedBox(height: 8),
          if (_discovered.isNotEmpty)
            ..._discovered.map(
              (bp) => Card(
                child: ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(bp.name),
                  subtitle: Text(bp.address),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () => _addPrinter(bp.name, bp.address),
                  ),
                ),
              ),
            ),
          if (_discovered.isEmpty && !_isScanning)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Tap "Scan for Printers" to discover Bluetooth devices',
                style: AppTypography.bodySmall.copyWith(color: Colors.grey),
              ),
            ),

          const SizedBox(height: 24),
          const Divider(),
          AppSpacing.gapLg,

          Text(
            'Print Settings',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Auto-print on sale'),
              subtitle: const Text('Automatically print receipt after payment'),
              value: _autoPrint,
              onChanged: _saveAutoPrint,
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Paper Size'),
              subtitle: Text(_paperSize),
              trailing: DropdownButton<String>(
                value: _paperSize,
                items: const [
                  DropdownMenuItem(value: '58mm', child: Text('58mm')),
                  DropdownMenuItem(value: '80mm', child: Text('80mm')),
                ],
                onChanged: (v) {
                  if (v != null) _savePaperSize(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveredPrinter {
  final String name;
  final String address;
  const _DiscoveredPrinter(this.name, this.address);
}
