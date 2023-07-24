import 'package:get/get.dart';
import 'package:eatery/references.dart';

class EditCompanyPage extends StatefulWidget {
  const EditCompanyPage({Key? key}) : super(key: key);

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  Company? company;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      
    });
    postInit();
  }

  Future postInit() async {
    company = EateryDB.instance.companyBox!.values.first;
    // company = await CompanyLoader(widget.database).load(context);
    setState(() {
      _controllerCompanyName.text = company!.name;
      _controllerEmail.text = company!.email;
      _controllerPhone.text = company!.phone;
      _controllerPhone.text = company!.phone;
      _controllerAddress.text = company!.address;
      _controllerSalesTaxNo.text = company!.salesTaxNumber ?? '';
      _controllerFoodLicNo.text = company!.foodLicenseNo ?? '';
    });
  }
  final themeColor = ColorStyle.brandColor;

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
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              title: const Text('Company Details'),
            ),
            body: Padding(
              padding: SpacingStyle.defaultPadding,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  SpacingStyle.defaultVerticalSpacing,
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFromField(
                      themeColor: themeColor,
                      foregroundColor: ColorStyle.text200,
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
                      }),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFromField(
                      themeColor: themeColor,
                      foregroundColor: ColorStyle.text200,
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
                      }),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFromField(
                      themeColor: themeColor,
                      foregroundColor: ColorStyle.text200,
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
                      }),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFromField(
                    themeColor: themeColor,
                    foregroundColor: ColorStyle.text200,
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
                  LabeledCustomTextFromField(
                    themeColor: themeColor,
                    foregroundColor: ColorStyle.text200,
                    keyboardType: TextInputType.text,
                    controller: _controllerSalesTaxNo,
                    label:
                        '${Edition.values.singleWhere((element) => element.id == company?.edition.id).name} License No',
                    hint:
                        'Enter ${Edition.values.singleWhere((element) => element.id == company?.edition.id).name} license number...',
                    focusNode: focus5,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus6);
                    },
                    validator: (value) {
                      if (value!.trim().isNotEmpty &&
                          !value.trim().isValidGSTIN()) {
                        return '${Edition.values.singleWhere((element) => element.id == company?.edition.id).name} license number is not valid';
                      }
                      return null;
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                  LabeledCustomTextFromField(
                    themeColor: themeColor,
                    foregroundColor: ColorStyle.text200,
                    keyboardType: TextInputType.text,
                    controller: _controllerFoodLicNo,
                    label:
                        '${Edition.values.singleWhere((element) => element.id == company?.edition.id) == Edition.gst ? 'FSSAI' : 'Food'} License No',
                    hint:
                        'Enter ${Edition.values.singleWhere((element) => element.id == company?.edition.id) == Edition.gst ? 'FSSAI' : 'Food'} license number...',
                    focusNode: focus6,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus7);
                    },
                    validator: (value) {
                      if (value!.trim().isNotEmpty &&
                          (value.trim().length < 10 ||
                              !value.trim().isNumericOnly)) {
                        return '${Edition.values.singleWhere((element) => element.id == company?.edition.id) == Edition.gst ? 'FSSAI' : 'Food'} license number is not valid';
                      }
                      // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: ColorStyle.backgroundColorAlter,
              child: PrimaryButton(
                color: themeColor,
                child: const Text('Save'),
                onPressed: () async {
                  company!.name = _controllerCompanyName.text;
                  company!.email = _controllerEmail.text;
                  company!.phone = _controllerPhone.text;
                  company!.address = _controllerAddress.text;
                  company!.foodLicenseNo = _controllerFoodLicNo.text;
                  company!.salesTaxNumber = _controllerSalesTaxNo.text;

                  // Update the company in the Hive database
                  company!.save().then((value) {
                    // Update the company in the database
                    // Display a success message and navigate back
                    showSnackBar(context, 'Company details successfully updated');
                    Navigator.pop(context);
                  });

                },

              ),
            ),
          )
        : LoadingScreen();
  }
}
