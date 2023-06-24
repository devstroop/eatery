import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery/constants/validators/gstin_validator.dart';
import 'package:eatery_components/switches/toggle.switch.dart';
import 'package:eatery_components/titles/page.title.dart';
import 'package:eatery_db/eatery_db.dart';
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
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  Body4(
      {Key? key,
      required this.themeColor,
      required this.edition,
      required this.taxNoController,
      required this.foodLicNoController,
      required this.defaultTaxController,
      required this.onTaxTypeChanged,
      required this.taxType,
      required this.formKey,
      this.callbackFormKey})
      : super(key: key);

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            title: '${edition.name} Registration No',
            hint: 'Enter ${edition.name} registration number',
            focusNode: focus1,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              if (callbackFormKey != null) callbackFormKey!(formKey);
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
            title:
                '${edition == Edition.gst ? 'FSSAI' : 'Food'} Registration Number',
            hint:
                'Enter ${edition == Edition.gst ? 'FSSAI' : 'Food'} registration number',
            focusNode: focus2,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              if (callbackFormKey != null) callbackFormKey!(formKey);
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
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: defaultTaxController,
                  title: 'Default ${edition.name} Rate',
                  hint: '${edition.name} Rate',
                  suffix: Icon(
                    UIcons.regularStraight.percentage,
                    color: ColorStyle.text400,
                    size: 18,
                  ),
                  focusNode: focus3,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.trim().isNotEmpty && !value.trim().isNum) {
                      return 'Default ${edition.name} registration number is not valid';
                    }
                    // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
                    return null;
                  },
                  onFieldSubmitted: (v) {
                    if (callbackFormKey != null) callbackFormKey!(formKey);
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
