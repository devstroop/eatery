import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery_components/titles/page.title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Body2 extends StatelessWidget {
  final Color themeColor;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;

  Body2(
      {Key? key,
      required this.themeColor,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.formKey,
      this.callbackFormKey})
      : super(key: key);

  final focus1 = FocusNode();
  final focus2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const PageTitle(
            title: "Setup PIN",
            subtitle: "Secure account with login PIN",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
            themeColor: themeColor,
            keyboardType: TextInputType.number,
            controller: passwordController,
            obscureText: true,
            isPassword: true,
            title: 'Secure PIN',
            hint: 'Enter secure pin...',
            focusNode: focus1,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              FocusScope.of(context).requestFocus(focus2);
            },
            validator: (value) {
              if (value!.trim().isEmpty) return 'Pin cannot be blank';
              if (!value.trim().isNumericOnly) return 'Invalid character';
              if (value.trim().length < 4) return 'Less secured pin';
              return null;
            },
          ),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
            themeColor: themeColor,
            keyboardType: TextInputType.number,
            controller: confirmPasswordController,
            obscureText: true,
            isPassword: true,
            title: 'Confirm Secure PIN',
            hint: 'Confirm secure pin...',
            focusNode: focus2,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (!value!.trim().isNumericOnly) return 'Invalid character';
              if (value.trim().isEmpty || passwordController.text != value) {
                return "Confirm pin didn't match";
              }
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
