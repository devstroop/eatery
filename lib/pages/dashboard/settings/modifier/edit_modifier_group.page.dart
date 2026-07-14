import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditModifierGroupPage extends ConsumerStatefulWidget {
  const EditModifierGroupPage({super.key, required this.group});
  final ModifierGroup group;

  @override
  ConsumerState<EditModifierGroupPage> createState() => _EditModifierGroupPageState();
}

class _EditModifierGroupPageState extends ConsumerState<EditModifierGroupPage> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  List<Modifier> _modifiers = [];
  bool _showAddForm = false;

  @override
  void initState() {
    super.initState();
    _modifiers = ref.read(modifierRepositoryProvider).getModifiers(widget.group.id!);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _addModifier() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    await ref.read(modifierRepositoryProvider).saveModifier(
      Modifier(
        modifierGroupId: widget.group.id!,
        name: name,
        priceAdjust: price,
        createdAt: DateTime.now(),
      ),
    );
    _nameCtrl.clear();
    _priceCtrl.clear();
    setState(() {
      _modifiers = ref.read(modifierRepositoryProvider).getModifiers(widget.group.id!);
      _showAddForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: widget.group.name,
      color: AppColors.warning,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => setState(() => _showAddForm = !_showAddForm),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('Options', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_showAddForm)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    CustomTextFromField(
                      controller: _nameCtrl,
                      label: 'Option Name',
                      hint: 'e.g. Extra Cheese',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _priceCtrl,
                      decoration: const InputDecoration(labelText: 'Price Adjustment'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    AppButton.primary(label: 'Add', onPressed: _addModifier),
                  ],
                ),
              ),
            ),
          if (_modifiers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No options yet')),
            )
          else
            ..._modifiers.map((m) => Card(
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                title: Text(m.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('+${m.priceAdjust}', style: AppTypography.bodyMedium),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        AppDialog.show(
                          context,
                          title: 'Delete ${m.name}',
                          content: 'Remove this option?',
                          destructive: true,
                          onConfirm: () {
                            ref.read(modifierRepositoryProvider).deleteModifier(m.id!);
                            setState(() {
                              _modifiers = ref.read(modifierRepositoryProvider)
                                  .getModifiers(widget.group.id!);
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }
}
