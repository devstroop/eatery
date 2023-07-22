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
    //WidgetsBinding.instance.addPostFrameCallback((_) => loadCompany());
  }

  void postInit() async {
    company = await EateryDB.instance.companyBox.values.first;
    // company = await CompanyLoader(widget.database).load(context);
    setState(() {
      _controllerCompanyName.text = company!.name;
      _controllerEmail.text = company!.email;
      _controllerPhone.text = company!.phone;
      _controllerPhone.text = company!.phone;
      _controllerAddress.text = company!.address;
      // _controllerTaxNo.text = company!.taxLicNo ?? '';
      // _controllerFoodLicNo.text = company!.foodLicNo ?? '';
      // _controllerDefaultTax.text = company!.defaultTaxRate != null ? company!.defaultTaxRate.toString() : '';
    });
  }
  final themeColor = ColorStyle.brandColor;

  final TextEditingController _controllerCompanyName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerTaxNo = TextEditingController();
  final TextEditingController _controllerFoodLicNo = TextEditingController();
  final TextEditingController _controllerDefaultTax = TextEditingController();

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
              title: const Text('Company Details'),
              leading: IconButton(
                icon: Icon(UIcons.regularStraight.arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: SpacingStyle.defaultPadding,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  SpacingStyle.defaultVerticalSpacing,
                  SpacingStyle.defaultVerticalSpacing,
                  CustomTextFromField(
                      themeColor: themeColor,
                      keyboardType: TextInputType.name,
                      controller: _controllerCompanyName,
                      autofocus: true,
                      focusNode: focus1,
                      title: 'Company name',
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
                  CustomTextFromField(
                      themeColor: themeColor,
                      keyboardType: TextInputType.emailAddress,
                      controller: _controllerEmail,
                      title: 'Email address',
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
                  CustomTextFromField(
                      themeColor: themeColor,
                      keyboardType: TextInputType.phone,
                      controller: _controllerPhone,
                      title: 'Phone no',
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
                  CustomTextFromField(
                    themeColor: themeColor,
                    controller: _controllerAddress,
                    title: 'Address',
                    hint: 'Enter address...',
                    focusNode: focus4,
                    textInputAction: TextInputAction.next,
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
                  CustomTextFromField(
                    themeColor: themeColor,
                    keyboardType: TextInputType.text,
                    controller: _controllerTaxNo,
                    title:
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
                  CustomTextFromField(
                    themeColor: themeColor,
                    keyboardType: TextInputType.number,
                    controller: _controllerFoodLicNo,
                    title:
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
                  SpacingStyle.defaultVerticalSpacing,
                  CustomTextFromField(
                    themeColor: themeColor,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _controllerDefaultTax,
                    title:
                        'Default ${Edition.values.singleWhere((element) => element.id == company?.edition.id).name} Rate',
                    hint:
                        'Enter default ${Edition.values.singleWhere((element) => element.id == company?.edition.id).name} rate...',
                    suffix: Icon(
                      Icons.percent,
                      color: ColorStyle.text400,
                    ),
                    focusNode: focus7,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.trim().isNotEmpty && !value.trim().isNum) {
                        return 'Default ${Edition.values.singleWhere((element) => element.id == company?.edition.id).name} license number is not valid';
                      }
                      // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: ColorStyle.backgroundColorAlter,
              child: Padding(
                padding: SpacingStyle.defaultPadding,
                child: Row(
                  children: [
                    PrimaryButton(
                      color: themeColor,
                      child: const Text('Save'),
                      onPressed: () async {
                        /*company!.name = _controllerCompanyName.text;
                company!.email = _controllerEmail.text;
                company!.phone = _controllerPhone.text;
                company!.address = _controllerAddress.text;
                company!.taxLicNo = _controllerTaxNo.text;
                company!.foodLicNo = _controllerFoodLicNo.text;
                company!.defaultTaxRate = _controllerDefaultTax.text.isNotEmpty ? double.parse(_controllerDefaultTax.text) : null;

                await widget.database.companyDao.updateEntity(company!);
                Navigator.pop(context);
                showSnackBar(context, 'Successfully updated');*/
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        : LoadingScreen();
  }
}
