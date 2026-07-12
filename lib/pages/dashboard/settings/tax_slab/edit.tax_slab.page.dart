import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/order_provider.dart';

final _pageColor = AppColors.primary;

class EditTaxSlabSettingsPage extends ConsumerStatefulWidget {
  const EditTaxSlabSettingsPage({Key? key, required this.taxSlab})
      : super(key: key);
  final TaxSlab taxSlab;

  @override
  ConsumerState<EditTaxSlabSettingsPage> createState() =>
      _EditTaxSlabSettingsPageState();
}

class _EditTaxSlabSettingsPageState extends ConsumerState<EditTaxSlabSettingsPage> {
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Edit Tax Slab'),
        actions: [
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Confirm before delete
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Tax Slab'),
                  content: const Text('Are you sure you want to delete this tax slab?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.taxSlab.delete();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              });
            },
          ),
        ],
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
                  label: 'Tax Slab Rate',
                  hint: 'Enter tax slab rate',
                  themeColor: _pageColor,
                  focusNode: focus2,
                  suffix: Icon(
                    Icons.percent,
                    color: AppColors.white600,
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
                  foregroundColor: AppColors.black600,
                ),
                SpacingStyle.defaultVerticalSpacing,
                Text(
                  'Select Tax Type',
                  style: TextStyle(
                    color: AppColors.black600,
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
