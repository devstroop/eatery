import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';

final _pageColor = AppColors.primary;

class AddTaxSlabSettingsPage extends ConsumerStatefulWidget {
  const AddTaxSlabSettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTaxSlabSettingsPage> createState() =>
      _AddTaxSlabSettingsPageState();
}

class _AddTaxSlabSettingsPageState extends ConsumerState<AddTaxSlabSettingsPage> {
  final TextEditingController controllerSlabName = TextEditingController();
  final TextEditingController controllerTaxRate = TextEditingController();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  TaxType selectedTaxType = TaxType.inclusive;

  Future _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      TaxSlab taxSlab = TaxSlab(
          name: controllerSlabName.text,
          rate: double.parse(controllerTaxRate.text),
          type: selectedTaxType);
      await ref.read(taxRepositoryProvider).saveTaxSlab(taxSlab).whenComplete(() {
        AppDialog.showMessage(this.context, message: 'Tax slab created successfully!',
            type: MessageType.success, onConfirm: () => Navigator.pop(this.context));
      });
    } catch (_) {
      AppDialog.showMessage(
          this.context, message: 'Something went wrong!', type: MessageType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Add Tax Slab',
      color: _pageColor,
      child: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                LabeledCustomTextFormField(
                  controller: controllerSlabName,
                  label: 'Tax Slab name',
                  themeColor: _pageColor,
                  hint: 'Enter tax slab name',
                  focusNode: focus1,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus2);
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Tax slab name cannot be blank';
                    } else if (value.trim().length > 8) {
                      return 'Tax slab name cannot be more than 8 characters';
                    }
                    return null;
                  },
                  foregroundColor: AppColors.black600,
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFormField(
                  controller: controllerTaxRate,
                  label: 'Tax Rate',
                  hint: 'Enter tax rate',
                  themeColor: _pageColor,
                  focusNode: focus2,
                  suffix: Icon(
                    Icons.percent,
                    color: AppColors.white600,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value!.trim().isEmpty) return 'Tax rate cannot be blank';
                    return null;
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  foregroundColor: AppColors.black600,
                ),
                SpacingStyle.defaultVerticalSpacing,
                Text(
                  'Select Tax Type',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.black600),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                ToggleSwitch(
                  highlightColor: _pageColor,
                  backgroundColor: const Color(0xFFE5E5E5),
                  foregroundColor: AppColors.white,
                  inactiveForegroundColor: AppColors.black600,
                  children: [
                    ...TaxType.values.map((e) => e.name!)
                  ],
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
      bottomNavigationBar: BottomAppBar(
        child: AppButton.primary(
          height: 48.0,
          onPressed: _submit,
          label: 'Save',
        ),
      ),
    );
  }
}
