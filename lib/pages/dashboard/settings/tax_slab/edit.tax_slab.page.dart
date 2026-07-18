import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';

final _pageColor = AppColors.primary;

class EditTaxSlabSettingsPage extends ConsumerStatefulWidget {
  const EditTaxSlabSettingsPage({super.key, required this.taxSlab});
  final TaxSlab taxSlab;

  @override
  ConsumerState<EditTaxSlabSettingsPage> createState() =>
      _EditTaxSlabSettingsPageState();
}

class _EditTaxSlabSettingsPageState
    extends ConsumerState<EditTaxSlabSettingsPage> {
  final TextEditingController controllerSlabName = TextEditingController();
  final TextEditingController controllerTaxRate = TextEditingController();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  TaxType selectedTaxType = TaxType.inclusive;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {});
    controllerSlabName.text = widget.taxSlab.name;
    controllerTaxRate.text = '${widget.taxSlab.rate}';
    selectedTaxType = widget.taxSlab.type;
    setState(() {});
  }

  Future _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      final updated = widget.taxSlab.copyWith(
        name: controllerSlabName.text,
        rate: double.parse(controllerTaxRate.text),
        type: selectedTaxType,
      );
      ref.read(taxRepositoryProvider).saveTaxSlab(updated);
      AppDialog.showMessage(
        context,
        message: 'Tax slab updated successfully!',
        type: MessageType.success,
        onConfirm: () => Navigator.pop(context),
      );
    } catch (_) {
      AppDialog.showMessage(
        context,
        message: 'Something went wrong!',
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Tax Slab',
      color: _pageColor,
      actions: [
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Confirm before delete
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Tax Slab'),
                  content: const Text(
                    'Are you sure you want to delete this tax slab?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(taxRepositoryProvider)
                            .deleteTaxSlab(widget.taxSlab.id!);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
      bottomAction: AppButton.primary(
        height: 48.0,
        onPressed: _submit,
        label: 'Update',
      ),
      child: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppFormField(
                  controller: controllerSlabName,
                  label: 'Tax Slab Name',
                  hint: 'Enter tax slab name',
                  focusNode: focus1,
                  focusNext: focus2,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Tax slab name cannot be blank';
                    } else if (value.trim().length > 8) {
                      return 'Tax slab name cannot be more than 8 characters';
                    }
                    return null;
                  },
                ),
                AppFormField(
                  controller: controllerTaxRate,
                  label: 'Tax Slab Rate',
                  hint: 'Enter tax slab rate',
                  focusNode: focus2,
                  suffix: Icon(Icons.percent, color: AppColors.white600),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Tax slab rate cannot be blank';
                    }
                    return null;
                  },
                ),
                Text(
                  'Select Tax Type',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.black600,
                  ),
                ),
                const SizedBox(height: 3.0),
                ToggleSwitch(
                  highlightColor: _pageColor,
                  backgroundColor: const Color(0xFFE5E5E5),
                  foregroundColor: AppColors.white,
                  inactiveForegroundColor: AppColors.black600,
                  children: [...TaxType.values.map((e) => e.name!)],
                  selectedIndex: selectedTaxType.index,
                  onChange: (int? index) {
                    if (index != null) {
                      setState(() {
                        selectedTaxType = TaxType.values[index];
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
