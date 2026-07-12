import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/order_provider.dart';

final _pageColor = KColors.primary;

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
        showMessageDialog(this.context, 'Tax slab created successfully!',
            MessageType.success, () => Navigator.pop(this.context));
      });
    } catch (_) {
      showMessageDialog(
          this.context, 'Something went wrong!', MessageType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Add Tax Slab'),
      ),
      body: InkWell(
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
                  foregroundColor: KColors.black600,
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
                    color: KColors.white600,
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
                  foregroundColor: KColors.black600,
                ),
                SpacingStyle.defaultVerticalSpacing,
                Text(
                  'Select Tax Type',
                  style: TextStyle(
                    color: KColors.black600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                ToggleSwitch(
                  highlightColor: _pageColor,
                  backgroundColor: const Color(0xFFE5E5E5),
                  foregroundColor: Colors.white,
                  inactiveForegroundColor: KColors.black600,
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
        child: PrimaryButton(
          color: _pageColor,
          height: 48.0,
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ),
    );
  }
}
