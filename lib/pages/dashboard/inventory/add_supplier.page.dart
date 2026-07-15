import "package:flutter/material.dart";
import "package:eatery_core/widgets/widgets.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/theme/app_spacing.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery_core/data/repositories/inventory_repository.dart";
import "package:eatery_core/data/models/eatery_db.dart";
import "package:eatery/references.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class AddSupplierPage extends ConsumerStatefulWidget {
  final Supplier? supplier;
  const AddSupplierPage({super.key, this.supplier});
  @override
  ConsumerState<AddSupplierPage> createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends ConsumerState<AddSupplierPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(),
      _contactCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(),
      _emailCtrl = TextEditingController();
  final _addrCtrl = TextEditingController(), _gstCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameCtrl.text = widget.supplier!.name;
      _contactCtrl.text = widget.supplier!.contactName ?? "";
      _phoneCtrl.text = widget.supplier!.phone ?? "";
      _emailCtrl.text = widget.supplier!.email ?? "";
      _addrCtrl.text = widget.supplier!.address ?? "";
      _gstCtrl.text = widget.supplier!.gstin ?? "";
    }
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _contactCtrl,
      _phoneCtrl,
      _emailCtrl,
      _addrCtrl,
      _gstCtrl,
    ])
      c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = InventoryRepository(ref.read(eateryStoreProvider));
    await repo.saveSupplier(
      Supplier(
        name: _nameCtrl.text.trim(),
        contactName: _contactCtrl.text.trim().isEmpty
            ? null
            : _contactCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        address: _addrCtrl.text.trim().isEmpty ? null : _addrCtrl.text.trim(),
        gstin: _gstCtrl.text.trim().isEmpty ? null : _gstCtrl.text.trim(),
        createdAt: widget.supplier?.createdAt ?? DateTime.now(),
      ),
    );
    if (mounted) Navigator.pop(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: widget.supplier != null ? "Edit Supplier" : "Add Supplier",
      color: AppColors.menuInventory,
      actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFromField(
                controller: _nameCtrl,
                label: "Name",
                hint: "Supplier name",
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              CustomTextFromField(
                controller: _contactCtrl,
                label: "Contact Person",
                hint: "Optional",
              ),
              const SizedBox(height: 12),
              CustomTextFromField(
                controller: _phoneCtrl,
                label: "Phone",
                hint: "Optional",
              ),
              const SizedBox(height: 12),
              CustomTextFromField(
                controller: _emailCtrl,
                label: "Email",
                hint: "Optional",
              ),
              const SizedBox(height: 12),
              CustomTextFromField(
                controller: _addrCtrl,
                label: "Address",
                hint: "Optional",
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              CustomTextFromField(
                controller: _gstCtrl,
                label: "GSTIN",
                hint: "Optional",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
