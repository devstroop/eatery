import 'package:eatery/references.dart';

class CreateCompanyPage extends StatefulWidget {
  const CreateCompanyPage({Key? key}) : super(key: key);

  @override
  State<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends State<CreateCompanyPage> {
  int viewIndex = 0;
  LibraryImage? libraryImageLogo; // used
  Edition edition = Edition.gst;
  SubscriptionType subscriptionType = SubscriptionType.free;
  String? deviceSerial;
  final TextEditingController _controllerRestaurantName =
      TextEditingController(); // used
  final TextEditingController _controllerEmailAddress = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerRetypePassword =
      TextEditingController();
  final TextEditingController _controllerTaxLicNo = TextEditingController();
  final TextEditingController _controllerFoodLicNo = TextEditingController();
  final TextEditingController _controllerDefaultTaxPercent =
      TextEditingController();

  String? purchaseCode;
  DateTime? validFrom;
  DateTime? validTill;
  Currency? currency;
  TaxType _taxType = TaxType.inclusive;

  Color themeColor = ColorStyle.brandColor;

  List<Widget> bodies() => [
        Body1(
          formKey: formKeys[0],
          selectedLibraryImage: libraryImageLogo,
          themeColor: themeColor,
          restaurantNameController: _controllerRestaurantName,
          emailController: _controllerEmailAddress,
          phoneController: _controllerPhoneNumber,
          addressController: _controllerAddress,
          onChanged: (logoPath) async {
            setState(() {
              libraryImageLogo = logoPath;
            });
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[0] = formKey;
          }),
        ),
        Body2(
          formKey: formKeys[1],
          themeColor: themeColor,
          passwordController: _controllerPassword,
          confirmPasswordController: _controllerRetypePassword,
          callbackFormKey: (formKey) => setState(() {
            formKeys[1] = formKey;
          }),
        ),
        Body3(
          formKey: formKeys[2],
          edition: edition,
          themeColor: themeColor,
          callback: (Edition edition) {
            setState(() {
              this.edition = edition;
            });
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[2] = formKey;
          }),
        ),
        Body4(
          formKey: formKeys[3],
          themeColor: themeColor,
          edition: edition,
          taxNoController: _controllerTaxLicNo,
          foodLicNoController: _controllerFoodLicNo,
          defaultTaxController: _controllerDefaultTaxPercent,
          taxType: _taxType,
          onTaxTypeChanged: (int? index) {
            _taxType =
                TaxType.values.singleWhere((element) => element.id == index);
            setState(() {});
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[3] = formKey;
          }),
        ),
        Body5(
          formKey: formKeys[4],
          themeColor: themeColor,
          currency: currency,
          callback: (currency) {
            this.currency = currency;
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[4] = formKey;
          }),
        ),
        Body6(
          formKey: formKeys[5],
          themeColor: themeColor,
          subscriptionType: subscriptionType,
          callback: (subscriptionType, purchaseCode, validFrom, validTill) {
            setState(() {
              this.subscriptionType = subscriptionType;
              this.purchaseCode = purchaseCode;
              this.validFrom = validFrom;
              this.validTill = validTill;
            });
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[5] = formKey;
          }),
        )
      ];

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  List<Widget> bottomAppBars() => [
        CreateCompanyBottomAppBar(
            formKey: formKeys[0],
            index: 1,
            themeColor: themeColor,
            title: 'Next',
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        CreateCompanyBottomAppBar(
            formKey: formKeys[1],
            index: 2,
            themeColor: themeColor,
            title: 'Next',
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        CreateCompanyBottomAppBar(
            formKey: formKeys[2],
            index: 3,
            themeColor: themeColor,
            title: 'Next',
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        CreateCompanyBottomAppBar(
          formKey: formKeys[3],
          index: 4,
          themeColor: themeColor,
          callback: (index) {
            setState(() {
              viewIndex++;
            });
          },
          title: 'Next',
        ),
        CreateCompanyBottomAppBar(
          formKey: formKeys[4],
          index: 5,
          themeColor: themeColor,
          callback: (index) {
            setState(() {
              viewIndex++;
            });
          },
          title: 'Next',
        ),
        CreateCompanyBottomAppBar(
            title: 'Finish',
            formKey: formKeys[5],
            index: 6,
            themeColor: themeColor,
            callback: (index) async {
              try {
                TaxSlab? taxSlab = _controllerDefaultTaxPercent.text.isNotEmpty
                    ? TaxSlab(
                        id: EateryDB.instance.taxSlabBox.nextId(),
                        name: 'default',
                        rate: double.parse(_controllerDefaultTaxPercent.text),
                        type: _taxType)
                    : null;
                List<TaxSlab> isMatch = EateryDB.instance.taxSlabBox.values
                    .where((element) => element.name == 'default')
                    .toList();
                if (taxSlab != null) {
                  if (isMatch.isNotEmpty) {
                    for (var each in isMatch) {
                      await each.delete();
                    }
                  }
                  await EateryDB.instance.taxSlabBox.add(taxSlab);
                }

                // Subscription
                Subscription subscription = Subscription(
                    id: EateryDB.instance.subscriptionBox.nextId(),
                    purchaseCode: purchaseCode,
                    validFrom: validFrom,
                    validTill: validTill,
                    subscriptionType: subscriptionType);
                await EateryDB.instance.subscriptionBox.add(subscription);

                kCurrency? _kCurrency;
                if (currency != null) {
                  _kCurrency = kCurrency(
                      id: 1,
                      name: currency!.name,
                      code: currency!.code,
                      symbol: currency!.symbol,
                      flag: currency!.flag,
                      decimalDigits: currency!.decimalDigits,
                      number: currency!.number,
                      namePlural: currency!.namePlural,
                      thousandsSeparator: currency!.thousandsSeparator,
                      spaceBetweenAmountAndSymbol:
                          currency!.spaceBetweenAmountAndSymbol,
                      decimalSeparator: currency!.decimalSeparator,
                      symbolOnLeft: currency!.symbolOnLeft);
                  await EateryDB.instance.currencyBox.add(_kCurrency);
                }
                // COMPANY
                Company company = Company(
                  id: 1,
                  name: _controllerRestaurantName.text,
                  logo: libraryImageLogo?.filename,
                  email: _controllerEmailAddress.text,
                  phone: _controllerPhoneNumber.text,
                  address: _controllerAddress.text,
                  password: _controllerPassword.text,
                  edition: edition,
                  foodLicenseNo: _controllerFoodLicNo.text,
                  salesTaxNumber: _controllerTaxLicNo.text,
                  defaultTaxSlabId: taxSlab?.id,
                  subscriptionId: subscription.id,
                  currencyId: _kCurrency?.id,
                );
                int result = await EateryDB.instance.companyBox
                    .add(company)
                    .whenComplete(() => Navigator.of(this.context)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const CreateCompanyResultPage()),
                            (route) => false));
                debugPrint('Company Added: $result');
              } catch (e) {
                showSnackBar(this.context, e.toString());
              }
            })
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColorAlter,
      appBar: AppBar(
        backgroundColor: ColorStyle.backgroundColorAlter,
        title: Image.asset(
          'assets/logo.png',
          height: 36,
        ),
        leading: viewIndex != 0
            ? IconButton(
                icon: Icon(
                  UIcons.regularStraight.arrow_small_left,
                  color: themeColor,
                ),
                onPressed: () {
                  if (viewIndex == 0) {
                  } else {
                    setState(() {
                      viewIndex--;
                    });
                  }
                },
              )
            : null,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: Center(
                child: Text(
              'Step ${viewIndex + 1}/${bodies().length}',
              style: TextStyle(
                  color: ColorStyle.text200, fontWeight: FontWeight.w500),
            )),
          )
        ],
      ),
      body: Padding(
        padding: SpacingStyle.defaultPadding,
        child: bodies()[viewIndex],
      ),
      bottomNavigationBar: bottomAppBars()[viewIndex],
    );
  }
}
