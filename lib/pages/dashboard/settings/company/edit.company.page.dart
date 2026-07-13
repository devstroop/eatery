import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/core/extensions/string_ext.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:eatery/core/widgets/app_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/company_provider.dart';

final _pageColor = AppColors.primary;

class EditCompanyPage extends ConsumerStatefulWidget {
  const EditCompanyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends ConsumerState<EditCompanyPage> {
  Company? company;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {});
    postInit();
  }

  Future postInit() async {
    company = ref.read(companyRepositoryProvider).getCurrentCompany();
    // company = await CompanyLoader(widget.database).load(context);
    setState(() {
      selectedLogo = LibraryImage(company!.logo);
      _controllerCompanyName.text = company!.name;
      _controllerEmail.text = company!.email;
      _controllerPhone.text = company!.phone;
      _controllerPhone.text = company!.phone;
      _controllerAddress.text = company!.address;
      _controllerSalesTaxNo.text = company!.salesTaxNumber ?? '';
      _controllerFoodLicNo.text = company!.foodLicenseNo ?? '';
    });
  }

  LibraryImage? selectedLogo;

  final TextEditingController _controllerCompanyName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerSalesTaxNo = TextEditingController();
  final TextEditingController _controllerFoodLicNo = TextEditingController();

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  final focus7 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return company != null
        ? AppPageShell(
            title: 'Company Details',
            color: _pageColor,
            child: Padding(
              padding: SpacingStyle.defaultPadding,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  UploadButton(
                    label: 'Restaurant Logo',
                    primaryColor: _pageColor,
                    secondaryColor: AppColors.black600,
                    libraryImage: selectedLogo,
                    onChanged: (image) {
                      setState(() {
                        selectedLogo = image;
                      });
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFormField(
                    themeColor: _pageColor,
                    foregroundColor: AppColors.black600,
                    keyboardType: TextInputType.name,
                    controller: _controllerCompanyName,
                    focusNode: focus1,
                    label: 'Company name',
                    hint: 'Enter company name...',
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus2);
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Company name cannot be blank';
                      }
                      return null;
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFormField(
                    themeColor: _pageColor,
                    foregroundColor: AppColors.black600,
                    keyboardType: TextInputType.emailAddress,
                    controller: _controllerEmail,
                    label: 'Email address',
                    hint: 'Enter email address...',
                    focusNode: focus2,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus3);
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Email cannot be blank';
                      }
                      if (!value.trim().isValidEmail()) {
                        return 'Email address is not valid';
                      }
                      return null;
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFormField(
                    themeColor: _pageColor,
                    foregroundColor: AppColors.black600,
                    keyboardType: TextInputType.phone,
                    controller: _controllerPhone,
                    label: 'Phone no',
                    hint: 'Enter phone no...',
                    focusNode: focus3,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus4);
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Phone number cannot be blank';
                      }
                      if (!value.trim().isValidPhone()) {
                        return 'Phone number is not valid';
                      }
                      return null;
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFormField(
                    themeColor: _pageColor,
                    foregroundColor: AppColors.black600,
                    controller: _controllerAddress,
                    label: 'Address',
                    hint: 'Enter address...',
                    focusNode: focus4,
                    textInputAction: TextInputAction.next,
                    multiline: true,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Address cannot be blank';
                      }
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus5);
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFormField(
                    themeColor: _pageColor,
                    foregroundColor: AppColors.black600,
                    keyboardType: TextInputType.text,
                    controller: _controllerSalesTaxNo,
                    label:
                        '${Taxation.values.singleWhere((element) => element.id == company?.taxation.id).name} License No',
                    hint:
                        'Enter ${Taxation.values.singleWhere((element) => element.id == company?.taxation.id).name} license number...',
                    focusNode: focus5,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus6);
                    },
                    validator: (value) {
                      if (value!.trim().isNotEmpty &&
                          value.trim().length < 10) {
                        return '${Taxation.values.singleWhere((element) => element.id == company?.taxation.id).name} license number is not valid';
                      }
                      return null;
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFormField(
                    themeColor: _pageColor,
                    foregroundColor: AppColors.black600,
                    keyboardType: TextInputType.text,
                    controller: _controllerFoodLicNo,
                    label:
                        '${Taxation.values.singleWhere((element) => element.id == company?.taxation.id) == Taxation.gst ? 'FSSAI' : 'Food'} License No',
                    hint:
                        'Enter ${Taxation.values.singleWhere((element) => element.id == company?.taxation.id) == Taxation.gst ? 'FSSAI' : 'Food'} license number...',
                    focusNode: focus6,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus7);
                    },
                    validator: (value) {
                      if (value!.trim().isNotEmpty &&
                          (value.trim().length <
                              10 /* ||
                              !value.trim().isNumericOnly*/ )) {
                        return '${Taxation.values.singleWhere((element) => element.id == company?.taxation.id) == Taxation.gst ? 'FSSAI' : 'Food'} license number is not valid';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: AppColors.white,
              child: AppButton.primary(
                label: 'Save',
                onPressed: () async {
                  company!.name = _controllerCompanyName.text;
                  company!.email = _controllerEmail.text;
                  company!.phone = _controllerPhone.text;
                  company!.address = _controllerAddress.text;
                  company!.foodLicenseNo = _controllerFoodLicNo.text;
                  company!.salesTaxNumber = _controllerSalesTaxNo.text;

                  // Update the company in the database
                  final repo = ref.read(companyRepositoryProvider);
                  repo.saveCompany(company!).then((value) {
                    AppDialog.showMessage(
                      context,
                      message: 'Company details successfully updated',
                      type: MessageType.success,
                      onConfirm: () {
                        Navigator.pop(context);
                      },
                    );
                  });
                },
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
