import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModifierGroupPage extends ConsumerStatefulWidget {
  const AddModifierGroupPage({super.key, this.group});
  final ModifierGroup? group;

  @override
  ConsumerState<AddModifierGroupPage> createState() =>
      _AddModifierGroupPageState();
}

class _AddModifierGroupPageState extends ConsumerState<AddModifierGroupPage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int _minSelect = 0;
  int _maxSelect = 1;
  bool _isRequired = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _nameCtrl.text = widget.group!.name;
      _descCtrl.text = widget.group!.description ?? '';
      _minSelect = widget.group!.minSelect;
      _maxSelect = widget.group!.maxSelect;
      _isRequired = widget.group!.isRequired;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(modifierRepositoryProvider);
    final now = DateTime.now();
    final group = ModifierGroup(
      id: widget.group?.id,
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      minSelect: _minSelect,
      maxSelect: _maxSelect,
      isRequired: _isRequired,
      sortOrder: widget.group?.sortOrder ?? 0,
      createdAt: widget.group?.createdAt ?? now,
      updatedAt: now,
    );
    await repo.saveGroup(group);
    if (mounted) Navigator.pop(this.context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.group != null;
    return AppPageShell(
      title: isEdit ? 'Edit Modifier Group' : 'Add Modifier Group',
      color: AppColors.warning,
      actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFromField(
                controller: _nameCtrl,
                label: 'Group Name',
                hint: 'e.g. Extra Toppings',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              AppSpacing.gapMd,
              CustomTextFromField(
                controller: _descCtrl,
                label: 'Description (optional)',
                hint: 'e.g. Choose your extra toppings',
              ),
              AppSpacing.gapLg,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Min Select',
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: _minSelect.toString(),
                      ),
                      onChanged: (v) => _minSelect = int.tryParse(v) ?? 0,
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Max Select (0 = any)',
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: _maxSelect.toString(),
                      ),
                      onChanged: (v) => _maxSelect = int.tryParse(v) ?? 1,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapMd,
              SwitchListTile(
                title: const Text('Required'),
                subtitle: const Text(
                  'Customer must select at least min options',
                ),
                value: _isRequired,
                onChanged: (v) => setState(() => _isRequired = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
