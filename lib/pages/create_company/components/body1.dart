import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery/constants/utils/email_validator.dart';
import 'package:eatery/constants/validators/phone_validator.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_components/buttons/upload.button.dart';
import 'package:eatery_components/titles/page.title.dart';
import 'package:flutter/material.dart';

class Body1 extends StatelessWidget {
  final Function(String? logoPath) onChanged;
  final Color themeColor;
  final TextEditingController restaurantNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final String? selectedLogoPath;
  Body1(
      {Key? key,
      required this.onChanged,
      required this.themeColor,
      required this.restaurantNameController,
      required this.emailController,
      required this.phoneController,
      required this.addressController,
      this.selectedLogoPath})
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
            title: "Create new company",
            subtitle: "Let's create an account with us",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          UploadButton(
            label: 'Restaurant Logo',
            primaryColor: themeColor,
            secondaryColor: ColorStyle.text200,
            uploadType: UploadType.image,
            filePath: selectedLogoPath,
            onChanged: onChanged,
          ),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
              themeColor: themeColor,
              keyboardType: TextInputType.name,
              controller: restaurantNameController,
              title: 'Company name',
              hint: 'Enter company name...',
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(focus1);
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Restaurant name cannot be blank';
                }
                return null;
              }),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
              themeColor: themeColor,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              title: 'Email address',
              hint: 'Enter email address...',
              focusNode: focus1,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(focus2);
              },
              validator: (value) {
                if (value!.trim().isEmpty) return 'Email cannot be blank';
                if (!value.trim().isValidEmail()) {
                  return 'Email address is not valid';
                }
                return null;
              }),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
              themeColor: themeColor,
              keyboardType: TextInputType.phone,
              controller: phoneController,
              title: 'Phone no',
              hint: 'Enter phone no...',
              focusNode: focus2,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(focus3);
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Phone number cannot be blank';
                }
                if (!value.trim().isValidPhone()) {
                  return 'Phone number is not valid';
                }
                return null;
              }),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
            themeColor: themeColor,
            controller: addressController,
            title: 'Address',
            hint: 'Enter address...',
            focusNode: focus3,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value!.trim().isEmpty) return 'Address cannot be blank';
              return null;
            },
            onFieldSubmitted: (v) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();

class BAP1 extends StatelessWidget {
  final Color themeColor;
  final Function(int? index)? callback;
  final int? index;

  const BAP1({Key? key, required this.themeColor, this.callback, this.index})
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
            color: themeColor, onPressed: _submit, child: const Text('Next')),
      ),
    );
  }
}
