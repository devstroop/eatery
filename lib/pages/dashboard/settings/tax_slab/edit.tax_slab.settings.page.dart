import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_components/switches/toggle.switch.dart';
import 'package:flutter/material.dart';
import 'package:eatery_db/eatery_db.dart';

class EditTaxSlabSettingsPage extends StatefulWidget {
  const EditTaxSlabSettingsPage(
      {Key? key, required this.taxSlab})
      : super(key: key);
  final TaxSlab taxSlab;

  @override
  State<EditTaxSlabSettingsPage> createState() =>
      _EditTaxSlabSettingsPageState();
}

class _EditTaxSlabSettingsPageState extends State<EditTaxSlabSettingsPage> {
  final TextEditingController controllerSlabName = TextEditingController();
  final TextEditingController controllerTaxRate = TextEditingController();
  final localColor = ColorStyle.primary;
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  TaxType _taxType = TaxType.inclusive;

  @override
  void initState() {
    super.initState();
    controllerSlabName.text = widget.taxSlab.name;
    controllerTaxRate.text = '${widget.taxSlab.rate}';
    _taxType = widget.taxSlab.type;
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
      widget.taxSlab.type = _taxType;
      widget.taxSlab.save();
      showSnackBar(context, 'Successfully updated!');
      Navigator.of(context).pop();
    } catch (_) {
      showSnackBar(context, 'Failed to created!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: localColor,
        title: const Text('Edit Tax Slab'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Slab name',
                    style: TextStyle(
                      color: ColorStyle.text400,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SpacingStyle.defaultHorizontalSpacing,
                  SpacingStyle.defaultHorizontalSpacing,
                  Flexible(
                    flex: 2,
                    child: CustomTextFromField(
                      controller: controllerSlabName,
                      hint: '',
                      themeColor: localColor,
                      focusNode: focus1,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus2);
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) return 'Slab name be blank';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    'Tax rate',
                    style: TextStyle(
                      color: ColorStyle.text400,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SpacingStyle.defaultHorizontalSpacing,
                  SpacingStyle.defaultHorizontalSpacing,
                  Flexible(
                    child: CustomTextFromField(
                      controller: controllerTaxRate,
                      hint: '',
                      themeColor: localColor,
                      focusNode: focus2,
                      suffixWidget: Icon(
                        Icons.percent,
                        color: ColorStyle.text400,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Tax rate couldn\'t be blank';
                        }
                        return null;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type',
                    style: TextStyle(
                      color: ColorStyle.text400,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ToggleSwitch(
                    color: localColor,
                    options: [for (var each in TaxType.values) each.name!],
                    index: _taxType.index,
                    onChange: (int? index) {
                      _taxType = TaxType.values
                          .singleWhere((element) => element.id == index);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            color: localColor,
            onPressed: _submit,
            child: const Text('Update'),
          ),
        ),
      ),
    );
  }
}
