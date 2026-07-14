import "dart:convert";
import "dart:io";
import "package:eatery_core/widgets/app_page_shell.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery/references.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/widgets/app_dialog.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:file_picker/file_picker.dart";

final _pageColor = AppColors.menuCategories;
class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({super.key});
  @override
  ConsumerState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  final _selected = <String>{};
  bool _exporting = false;

  final _tables = ["product", "product_category", "customer", "staff", "dining_table",
    "dining_table_category", "tax_slab", "supplier", "modifier_group", "modifier"];

  Future<void> _doExport() async {
    if (_selected.isEmpty) return;
    setState(() => _exporting = true);
    try {
      final store = ref.read(eateryStoreProvider);
      final data = <String, dynamic>{};
      for (final table in _selected) {
        final rows = store.query("SELECT * FROM $table");
        data[table] = rows;
      }
      final json = const JsonEncoder.withIndent("  ").convert(data);
      final dir = await FilePicker.platform.getDirectoryPath();
      if (dir != null) {
        final file = File("$dir/eatery_export.json");
        await file.writeAsString(json);
        if (mounted) AppDialog.showMessage(this.context, message: "Exported to ${file.path}", type: MessageType.success);
      }
    } catch (e) {
      if (mounted) AppDialog.showMessage(this.context, message: "Export failed: $e", type: MessageType.error);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: "Export",
      color: _pageColor,
      floatingActionButton: _selected.isEmpty ? null : FloatingActionButton.extended(
        backgroundColor: _pageColor, foregroundColor: AppColors.white,
        label: Text(_exporting ? "Exporting..." : "Export (\${_selected.length})"),
        icon: const Icon(Icons.file_download),
        onPressed: _exporting ? null : _doExport,
      ),
      child: ListView(children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Select tables to export as JSON", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        ..._tables.map((t) => CheckboxListTile(
          title: Text(t.replaceAll("_", " ").split(" ").map((w) => w[0].toUpperCase() + w.substring(1)).join(" ")),
          value: _selected.contains(t),
          onChanged: (v) { setState(() { if (v == true) _selected.add(t); else _selected.remove(t); }); },
        )),
      ]),
    );
  }
}
