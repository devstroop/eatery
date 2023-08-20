import 'package:eatery/references.dart';

// ignore: must_be_immutable
class Body1 extends StatelessWidget {
  final Function(LibraryImage? logoPath) onChanged;
  final Color pageColor;
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
      required this.pageColor,
      required this.restaurantNameController,
      required this.emailController,
      required this.phoneController,
      required this.addressController,
      this.selectedLibraryImage,
      required this.formKey,
      this.callbackFormKey})
      : super(key: key);

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

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
            primaryColor: pageColor,
            secondaryColor: KColors.black600,
            libraryImage: selectedLibraryImage,
            onChanged: onChanged,
          ),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
              themeColor: pageColor,
              keyboardType: TextInputType.name,
              controller: restaurantNameController,
              label: 'Company name',
              hint: 'Enter company name...',
              textInputAction: TextInputAction.next,
              focusNode: focusNodes[0],
              onFieldSubmitted: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                FocusScope.of(context).requestFocus(focusNodes[1]);
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Restaurant name cannot be blank';
                }
                return null;
              }),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
              themeColor: pageColor,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              label: 'Email address',
              hint: 'Enter email address...',
              focusNode: focusNodes[1],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                FocusScope.of(context).requestFocus(focusNodes[2]);
              },
              validator: (value) {
                if (value!.trim().isEmpty) return 'Email cannot be blank';
                if (!value.trim().isValidEmailAddress()) {
                  return 'Email address is not valid';
                }
                return null;
              }),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
              themeColor: pageColor,
              keyboardType: TextInputType.phone,
              controller: phoneController,
              label: 'Phone no',
              hint: 'Enter phone no...',
              focusNode: focusNodes[2],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                FocusScope.of(context).requestFocus(focusNodes[3]);
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
          LabeledCustomTextFormField(
            themeColor: pageColor,
            foregroundColor: KColors.black600,
            controller: addressController,
            label: 'Address',
            hint: 'Enter address...',
            focusNode: focusNodes[3],
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
