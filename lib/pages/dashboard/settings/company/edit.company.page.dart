import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery/references.dart';
import 'package:eatery/constants/validators/email_validator.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/company_provider.dart';

final _pageColor = AppColors.primary;

class EditCompanyPage extends ConsumerStatefulWidget {
  const EditCompanyPage({super.key});

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
            bottomNavigationBar: BottomAppBar(
              color: AppColors.white,
              child: AppButton.primary(
                label: 'Save',
                onPressed: () async {
                  final updated = company!.copyWith(
                    name: _controllerCompanyName.text,
                    email: _controllerEmail.text,
                    phone: _controllerPhone.text,
                    address: _controllerAddress.text,
                    foodLicenseNo: _controllerFoodLicNo.text,
                    salesTaxNumber: _controllerSalesTaxNo.text,
                  );

                  // Update the company in the database
                  final repo = ref.read(companyRepositoryProvider);
                  repo.saveCompany(updated).then((value) {
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
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
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
                  AppSpacing.gapMd,
                  AppSpacing.gapMd,
                  AppFormField(
                    keyboardType: TextInputType.name,
                    controller: _controllerCompanyName,
                    focusNode: focus1,
                    label: 'Company name',
                    hint: 'Enter company name...',
                    focusNext: focus2,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Company name cannot be blank';
                      }
                      return null;
                    },
                  ),
                  AppFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _controllerEmail,
                    label: 'Email address',
                    hint: 'Enter email address...',
                    focusNode: focus2,
                    focusNext: focus3,
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
                  AppFormField(
                    keyboardType: TextInputType.phone,
                    controller: _controllerPhone,
                    label: 'Phone no',
                    hint: 'Enter phone no...',
                    focusNode: focus3,
                    focusNext: focus4,
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
                  AppFormField(
                    controller: _controllerAddress,
                    label: 'Address',
                    hint: 'Enter address...',
                    focusNode: focus4,
                    focusNext: focus5,
                    multiline: true,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Address cannot be blank';
                      }
                      return null;
                    },
                  ),
                  AppFormField(
                    keyboardType: TextInputType.text,
                    controller: _controllerSalesTaxNo,
                    label:
                        '${Taxation.values.singleWhere((element) => element.id == company?.taxation.id).name} License No',
                    hint:
                        'Enter ${Taxation.values.singleWhere((element) => element.id == company?.taxation.id).name} license number...',
                    focusNode: focus5,
                    focusNext: focus6,
                    validator: (value) {
                      if (value!.trim().isNotEmpty &&
                          value.trim().length < 10) {
                        return '${Taxation.values.singleWhere((element) => element.id == company?.taxation.id).name} license number is not valid';
                      }
                      return null;
                    },
                  ),
                  AppFormField(
                    keyboardType: TextInputType.text,
                    controller: _controllerFoodLicNo,
                    label:
                        '${Taxation.values.singleWhere((element) => element.id == company?.taxation.id) == Taxation.gst ? 'FSSAI' : 'Food'} License No',
                    hint:
                        'Enter ${Taxation.values.singleWhere((element) => element.id == company?.taxation.id) == Taxation.gst ? 'FSSAI' : 'Food'} license number...',
                    focusNode: focus6,
                    focusNext: focus7,
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
          )
        : Center(child: CircularProgressIndicator());
  }
}
