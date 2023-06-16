import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery/constants/validators/gstin_validator.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_components/switches/toggle.switch.dart';
import 'package:eatery_components/titles/page.title.dart';
import 'package:eatery_db/models/company/edition.dart';
import 'package:eatery_db/models/tax/tax_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Body4 extends StatelessWidget {
  final Color themeColor;
  final Edition edition;
  final TextEditingController taxNoController;
  final TextEditingController foodLicNoController;
  final TextEditingController defaultTaxController;
  final TaxType taxType;
  final Function(int? index) onTaxTypeChanged;
  Body4(
      {Key? key,
      required this.themeColor,
      required this.edition,
      required this.taxNoController,
      required this.foodLicNoController,
      required this.defaultTaxController,
      required this.onTaxTypeChanged,
      required this.taxType})
      : super(key: key);

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const PageTitle(
            title: "Registration info (optional)",
            subtitle: "Help us to know more about your business",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
            themeColor: themeColor,
            keyboardType: TextInputType.text,
            controller: taxNoController,
            title: '${edition.name} License No',
            hint: 'Enter ${edition.name} license number...',
            focusNode: focus1,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focus2);
            },
            validator: (value) {
              if (value!.trim().isNotEmpty && !value.trim().isValidGSTIN()) {
                return '${edition.name} license number is not valid';
              }
              return null;
            },
          ),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
            themeColor: themeColor,
            keyboardType: TextInputType.number,
            controller: foodLicNoController,
            title: '${edition == Edition.gst ? 'FSSAI' : 'Food'} License No',
            hint:
                'Enter ${edition == Edition.gst ? 'FSSAI' : 'Food'} license number...',
            focusNode: focus2,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focus3);
            },
            validator: (value) {
              if (value!.trim().isNotEmpty &&
                  (value.trim().length < 10 || !value.trim().isNumericOnly)) {
                return '${edition == Edition.gst ? 'FSSAI' : 'Food'} license number is not valid';
              }
              // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
              return null;
            },
          ),
          SpacingStyle.defaultVerticalSpacing,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: CustomTextFromField(
                  themeColor: themeColor,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: defaultTaxController,
                  title: 'Default ${edition.name} Rate',
                  hint: 'Enter default ${edition.name} rate...',
                  suffixWidget: Icon(
                    Icons.percent,
                    color: ColorStyle.text400,
                  ),
                  focusNode: focus3,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.trim().isNotEmpty && !value.trim().isNum)
                      return 'Default ${edition.name} license number is not valid';
                    // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
                    return null;
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              SpacingStyle.defaultHorizontalSpacing,
              ToggleSwitch(
                color: themeColor,
                options: [for (var each in TaxType.values) each.name!],
                index: taxType.index,
                onChange: onTaxTypeChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();

class BAP4 extends StatelessWidget {
  final Color themeColor;
  final Function(int? index)? callback;
  final int? index;
  const BAP4({Key? key, required this.themeColor, this.callback, this.index})
      : super(key: key);

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (callback != null) {
      callback!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ColorStyle.backgroundColorAlter,
      child: Padding(
        padding: SpacingStyle.defaultPadding,
        child: PrimaryButton(
            child: const Text('Next'), color: themeColor, onPressed: _submit),
      ),
    );
  }
}
