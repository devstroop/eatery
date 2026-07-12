import 'package:eatery/core/utils/responsive.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

class CreateCompanyPage extends ConsumerStatefulWidget {
  const CreateCompanyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends ConsumerState<CreateCompanyPage> {
  int viewIndex = 0;
  LibraryImage? libraryImageLogo; // used
  Taxation taxation = Taxation.none;
  SubscriptionType subscriptionType = SubscriptionType.individual;
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

  Color themeColor = KColors.secondary2;

  List<Widget> bodies() => [
    Body1(
      formKey: formKeys[0],
      selectedLibraryImage: libraryImageLogo,
      pageColor: themeColor,
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
      taxation: taxation,
      themeColor: themeColor,
      callback: (Taxation taxation) {
        setState(() {
          this.taxation = taxation;
        });
      },
      callbackFormKey: (formKey) => setState(() {
        formKeys[2] = formKey;
      }),
    ),
    // Skip tax registration step when "No Tax" is selected
    if (taxation != Taxation.none)
      Body4(
        formKey: formKeys[3],
        themeColor: themeColor,
        taxation: taxation,
        taxNoController: _controllerTaxLicNo,
        foodLicNoController: _controllerFoodLicNo,
        defaultTaxController: _controllerDefaultTaxPercent,
        taxType: _taxType,
        onTaxTypeChanged: (int? index) {
          _taxType = TaxType.values.singleWhere(
            (element) => element.index == index,
          );
          setState(() {});
        },
        callbackFormKey: (formKey) => setState(() {
          formKeys[3] = formKey;
        }),
      ),
    Body5(
      formKey: taxation != Taxation.none ? formKeys[4] : formKeys[3],
      themeColor: themeColor,
      currency: currency,
      callback: (currency) {
        this.currency = currency;
      },
      callbackFormKey: (formKey) => setState(() {
        if (taxation != Taxation.none) {
          formKeys[4] = formKey;
        } else {
          formKeys[3] = formKey;
        }
      }),
    ),
    Body6(
      formKey: taxation != Taxation.none ? formKeys[5] : formKeys[4],
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
        if (taxation != Taxation.none) {
          formKeys[5] = formKey;
        } else {
          formKeys[4] = formKey;
        }
      }),
    ),
  ];

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
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
      },
    ),
    CreateCompanyBottomAppBar(
      formKey: formKeys[1],
      index: 2,
      themeColor: themeColor,
      title: 'Next',
      callback: (index) {
        setState(() {
          viewIndex++;
        });
      },
    ),
    CreateCompanyBottomAppBar(
      formKey: formKeys[2],
      index: 3,
      themeColor: themeColor,
      title: 'Next',
      callback: (index) {
        setState(() {
          viewIndex++;
        });
      },
    ),
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
      title: 'Continue',
      formKey: formKeys[5],
      index: 6,
      themeColor: themeColor,
      callback: (index) async {
        try {
          // Subscription
          Subscription subscription = Subscription(
            purchaseCode: purchaseCode,
            validFrom: validFrom,
            validTill: validTill,
            subscriptionType: subscriptionType,
          );
          await ref.read(appDatabaseProvider).subscriptionBox.add(subscription);

          KCurrency? kCurrency;
          if (currency != null) {
            kCurrency = KCurrency(
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
              symbolOnLeft: currency!.symbolOnLeft,
            );
            await ref.read(appDatabaseProvider).currencyBox.add(kCurrency);
          }
          // COMPANY
          Company company = Company(
            name: _controllerRestaurantName.text,
            logo: libraryImageLogo?.filename,
            email: _controllerEmailAddress.text,
            phone: _controllerPhoneNumber.text,
            address: _controllerAddress.text,
            password: _controllerPassword.text,
            taxation: taxation,
            foodLicenseNo: _controllerFoodLicNo.text,
            salesTaxNumber: _controllerTaxLicNo.text,
            subscriptionId: subscription.id,
            currencyCode: kCurrency?.code,
          );
          int? result = await ref
              .read(appDatabaseProvider)
              .companyBox
              .add(company)
              .whenComplete(
                () => Navigator.of(this.context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const CreateCompanyResultPage(),
                  ),
                  (route) => false,
                ),
              );
          debugPrint('Company Added: $result');
        } catch (e) {
          showMessageDialog(this.context, e.toString(), MessageType.error);
        }
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Image.asset('assets/logo.png', height: 36),
        leading: viewIndex != 0
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: themeColor),
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
                  color: KColors.black600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: SpacingStyle.defaultPadding,
                  child: bodies()[viewIndex],
                ),
              ),
            )
          : Padding(
              padding: SpacingStyle.defaultPadding,
              child: bodies()[viewIndex],
            ),
      bottomNavigationBar: isDesktop
          ? SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: bottomAppBars()[viewIndex],
                ),
              ),
            )
          : bottomAppBars()[viewIndex],
    );
  }
}
