import 'package:eatery_core/extensions/string_ext.dart';
import 'package:eatery/references.dart';

class Body4 extends StatelessWidget {
  final Color themeColor;
  final Taxation taxation;
  final TextEditingController taxNoController;
  final TextEditingController foodLicNoController;
  final TextEditingController defaultTaxController;
  final TaxType taxType;
  final Function(int? index) onTaxTypeChanged;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  Body4({
    Key? key,
    required this.themeColor,
    required this.taxation,
    required this.taxNoController,
    required this.foodLicNoController,
    required this.defaultTaxController,
    required this.onTaxTypeChanged,
    required this.taxType,
    required this.formKey,
    this.callbackFormKey,
  }) : super(key: key);

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
              label: '${taxation.name} Registration No',
              hint: 'Enter ${taxation.name} registration number',
              focusNode: focus1,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                FocusScope.of(context).requestFocus(focus2);
              },
              validator: (value) {
                if (value!
                        .trim()
                        .isNotEmpty /*&& !value.trim().isValidGSTIN()*/ &&
                    value.trim().length < 10) {
                  return '${taxation.name} license number is not valid';
                }
                return null;
              },
            ),
            SpacingStyle.defaultVerticalSpacing,
            CustomTextFromField(
              themeColor: themeColor,
              keyboardType: TextInputType.number,
              controller: foodLicNoController,
              label:
                  '${taxation == Taxation.gst ? 'FSSAI' : 'Food'} Registration Number',
              hint:
                  'Enter ${taxation == Taxation.gst ? 'FSSAI' : 'Food'} registration number',
              focusNode: focus2,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                FocusScope.of(context).unfocus();
              },
              validator: (value) {
                if (value!.trim().isNotEmpty &&
                    (value.trim().length <
                        10 /* || !value.trim().isNumericOnly*/ )) {
                  return '${taxation == Taxation.gst ? 'FSSAI' : 'Food'} license number is not valid';
                }
                // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
                return null;
              },
            ),
            SpacingStyle.defaultVerticalSpacing,
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     Flexible(
            //       child: CustomTextFromField(
            //         themeColor: themeColor,
            //         keyboardType: const TextInputType.numberWithOptions(decimal: true),
            //         controller: defaultTaxController,
            //         title: 'Default ${edition.name} Rate',
            //         hint: '${edition.name} Rate',
            //         suffix: Icon(
            //           Icons.percentage,
            //           color: ColorStyle.text400,
            //           size: 18,
            //         ),
            //         focusNode: focus3,
            //         textInputAction: TextInputAction.done,
            //         validator: (value) {
            //           if (value!.trim().isNotEmpty && !value.trim().isNum) {
            //             return 'Default ${edition.name} registration number is not valid';
            //           }
            //           // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
            //           return null;
            //         },
            //         onFieldSubmitted: (v) {
            //           if (callbackFormKey != null) callbackFormKey!(formKey);
            //           FocusScope.of(context).unfocus();
            //         },
            //       ),
            //     ),
            //     SpacingStyle.defaultHorizontalSpacing,
            //     // SizedBox(
            //     //   child: ToggleSwitch(
            //     //     onChange: onTaxTypeChanged,
            //     //     children: [...TaxType.values.map((e) => e.name!)],
            //     //     selectedIndex: taxType.index,
            //     //     highlightColor: themeColor,
            //     //   ),
            //     // )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
