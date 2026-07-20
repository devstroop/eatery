import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/theme/app_spacing.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery_core/data/repositories/discount_repository.dart";
import "package:eatery/references.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AddDiscountPage extends ConsumerStatefulWidget {
  final Discount? discount;
  const AddDiscountPage({super.key, this.discount});
  @override
  ConsumerState<AddDiscountPage> createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends ConsumerState<AddDiscountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _minCtrl = TextEditingController();
  int _type = 0;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.discount != null) {
      _nameCtrl.text = widget.discount!.name;
      _valueCtrl.text = widget.discount!.value.toString();
      _minCtrl.text = widget.discount!.minOrder?.toString() ?? "";
      _type = widget.discount!.type;
      _isActive = widget.discount!.isActive;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = DiscountRepository(ref.read(eateryStoreProvider));
    await repo.saveDiscount(
      Discount(
        name: _nameCtrl.text.trim(),
        type: _type,
        value: double.parse(_valueCtrl.text),
        minOrder: double.tryParse(_minCtrl.text),
        isActive: _isActive,
        createdAt: widget.discount?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: widget.discount != null ? "Edit Discount" : "Add Discount",
      color: AppColors.menuCategories,
      actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFromField(
                controller: _nameCtrl,
                label: "Discount Name",
                hint: "e.g. Happy Hour 20%",
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ),
              AppSpacing.gapMd,
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
                initialValue: _type,
                items: const [
                  DropdownMenuItem(value: 0, child: Text("Percentage (%)")),
                  DropdownMenuItem(value: 1, child: Text("Fixed Amount")),
                  DropdownMenuItem(value: 2, child: Text("BOGO")),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _type = v);
                },
              ),
              AppSpacing.gapMd,
              CustomTextFromField(
                controller: _valueCtrl,
                label: "Value",
                hint: "10 = 10% or 10.0",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ),
              AppSpacing.gapMd,
              CustomTextFromField(
                controller: _minCtrl,
                label: "Minimum Order",
                hint: "Optional",
                keyboardType: TextInputType.number,
              ),
              AppSpacing.gapMd,
              SwitchListTile(
                title: const Text("Active"),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
