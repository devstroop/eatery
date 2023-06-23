import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/labeled_custom_text_from_field.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery/constants/utils/email_validator.dart';
import 'package:eatery/constants/validators/phone_validator.dart';
import 'package:eatery/services/utility/library_image.dart';

import 'package:eatery_components/titles/page.title.dart';
import 'package:flutter/material.dart';

import '../../../widgets/buttons/upload.button.dart';

class Body1 extends StatelessWidget {
  final Function(LibraryImage? logoPath) onChanged;
  final Color themeColor;
  final GlobalKey<FormState> formKey;
  final TextEditingController restaurantNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final LibraryImage? selectedLibraryImage;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  Body1(
      {Key? key,
      required this.onChanged,
      required this.themeColor,
      required this.restaurantNameController,
      required this.emailController,
      required this.phoneController,
      required this.addressController,
      this.selectedLibraryImage,
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
            title: "Create new company",
            subtitle: "Let's create an account with us",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          UploadButton(
            label: 'Restaurant Logo',
            primaryColor: themeColor,
            secondaryColor: ColorStyle.text200,
            image: selectedLibraryImage?.image,
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
                if (callbackFormKey != null) callbackFormKey!(formKey);
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
                if (callbackFormKey != null) callbackFormKey!(formKey);
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
                if (callbackFormKey != null) callbackFormKey!(formKey);
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
          LabeledCustomTextFromField(
            backgroundColor: themeColor,
            foregroundColor: ColorStyle.text200,
            controller: addressController,
            label: 'Address',
            hint: 'Enter address...',
            focusNode: focus3,
            textInputAction: TextInputAction.done,
            multiline: true,
            validator: (value) {
              if (value!.trim().isEmpty) return 'Address cannot be blank';
              return null;
            },
            onFieldSubmitted: (v) {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
