import 'package:eatery/references.dart';

final _pageColor = KColors.primary;

class AddTaxSlabSettingsPage extends StatefulWidget {
  const AddTaxSlabSettingsPage({Key? key}) : super(key: key);

  @override
  State<AddTaxSlabSettingsPage> createState() => _AddTaxSlabSettingsPageState();
}

class _AddTaxSlabSettingsPageState extends State<AddTaxSlabSettingsPage> {
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
      await EateryDB.instance.taxSlabBox!.add(taxSlab).whenComplete(() {
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
                LabeledCustomTextFromField(
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
                    }
                    return null;
                  },
                  foregroundColor: KColors.text200,
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFromField(
                  controller: controllerTaxRate,
                  label: 'Tax Rate',
                  hint: 'Enter tax rate',
                  themeColor: _pageColor,
                  focusNode: focus2,
                  suffix: Icon(
                    Icons.percent,
                    color: KColors.text400,
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
                  foregroundColor: KColors.text200,
                ),
                SpacingStyle.defaultVerticalSpacing,
                Text(
                  'Select Tax Type',
                  style: TextStyle(
                    color: KColors.text200,
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
                  inactiveForegroundColor: KColors.text200,
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
