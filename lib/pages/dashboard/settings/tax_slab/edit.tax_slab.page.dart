import 'package:eatery/references.dart';

final _pageColor = KColors.primary;

class EditTaxSlabSettingsPage extends StatefulWidget {
  const EditTaxSlabSettingsPage({Key? key, required this.taxSlab})
      : super(key: key);
  final TaxSlab taxSlab;

  @override
  State<EditTaxSlabSettingsPage> createState() =>
      _EditTaxSlabSettingsPageState();
}

class _EditTaxSlabSettingsPageState extends State<EditTaxSlabSettingsPage> {
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
      widget.taxSlab.name = controllerSlabName.text;
      widget.taxSlab.rate = double.parse(controllerTaxRate.text);
      widget.taxSlab.type = selectedTaxType;
      widget.taxSlab.save();
      showMessageDialog(this.context, 'Tax slab updated successfully!',
          MessageType.success, () => Navigator.pop(this.context));
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
        title: const Text('Edit Tax Slab'),
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
                  label: 'Tax Slab Name',
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
                  foregroundColor: KColors.black600,
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFormField(
                  controller: controllerTaxRate,
                  label: 'Tax Slab Rate',
                  hint: 'Enter tax slab rate',
                  themeColor: _pageColor,
                  focusNode: focus2,
                  suffix: Icon(
                    Icons.percent,
                    color: KColors.white600,
                  ),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value!.trim().isEmpty) return 'Tax slab rate cannot be blank';
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
          child: const Text('Update'),
        ),
      ),
    );
  }
}
