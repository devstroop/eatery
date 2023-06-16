import 'package:currency_picker/currency_picker.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery/constants/utils/utils.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:eatery_db/models/company/edition.dart';
import 'package:eatery_db/models/company/k_currency.dart';
import 'package:eatery_db/models/subscription/subscription.dart';
import 'package:eatery_db/models/subscription/subscription_type.dart';
import 'package:eatery_db/models/tax/tax_slab.dart';
import 'package:eatery_db/models/tax/tax_type.dart';
import 'package:flutter/material.dart';
import 'components/body1.dart';
import 'components/body2.dart';
import 'components/body3.dart';
import 'components/body4.dart';
import 'components/body5.dart';
import 'components/body6.dart';
import 'create_account_result_page.dart';

class CreateCompanyPage extends StatefulWidget {
  const CreateCompanyPage({Key? key}) : super(key: key);

  @override
  State<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends State<CreateCompanyPage> {
  int viewIndex = 0;
  String? logoPath; // used
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
          selectedLogoPath: logoPath,
          themeColor: themeColor,
          restaurantNameController: _controllerRestaurantName,
          emailController: _controllerEmailAddress,
          phoneController: _controllerPhoneNumber,
          addressController: _controllerAddress,
          onChanged: (logoPath) async {
            setState(() {
              this.logoPath = logoPath;
            });
          },
        ),
        Body2(
          themeColor: themeColor,
          passwordController: _controllerPassword,
          confirmPasswordController: _controllerRetypePassword,
        ),
        Body3(
          edition: edition,
          themeColor: themeColor,
          callback: (Edition edition) {
            setState(() {
              this.edition = edition;
            });
          },
        ),
        Body4(
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
        ),
        Body5(
          themeColor: themeColor,
          currency: currency,
          callback: (currency) {
            this.currency = currency;
          },
        ),
        Body6(
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
        )
      ];

  List<Widget> bottomAppBars() => [
        BAP1(
            index: 1,
            themeColor: themeColor,
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        BAP2(
            index: 2,
            themeColor: themeColor,
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        BAP3(
            index: 3,
            themeColor: themeColor,
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        BAP4(
            index: 4,
            themeColor: themeColor,
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        BAP5(
            index: 5,
            themeColor: themeColor,
            callback: (index) {
              setState(() {
                viewIndex++;
              });
            }),
        BAP6(
            index: 6,
            themeColor: themeColor,
            callback: (index) async {
              try {
                TaxSlab? taxSlab = _controllerDefaultTaxPercent.text.isNotEmpty
                    ? TaxSlab(
                        id: EateryDB()
                            .getNewIdentity(EateryDB().taxSlabBox().values),
                        name: 'default',
                        rate: double.parse(_controllerDefaultTaxPercent.text),
                        type: _taxType)
                    : null;
                List<TaxSlab> isMatch = EateryDB()
                    .taxSlabBox()
                    .values
                    .where((element) => element.name == 'default')
                    .toList();
                if (taxSlab != null) {
                  if (isMatch.isNotEmpty) {
                    for (var each in isMatch) {
                      await each.delete();
                    }
                  }
                  await EateryDB().taxSlabBox().add(taxSlab);
                }

                // Subscription
                Subscription subscription = Subscription(
                    id: EateryDB()
                        .getNewIdentity(EateryDB().subscriptionBox().values),
                    purchaseCode: purchaseCode,
                    validFrom: validFrom,
                    validTill: validTill,
                    subscriptionType: subscriptionType);
                await EateryDB().subscriptionBox().add(subscription);

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
                  await EateryDB().currencyBox().add(_kCurrency);
                }
                // COMPANY
                Company company = Company(
                  id: 1,
                  name: _controllerRestaurantName.text,
                  logo: logoPath,
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
                int result = await EateryDB().companyBox().add(company);
                debugPrint('Company Added: $result');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const CreateAccountResultPage()),
                    (route) => false);
              } catch (e) {
                showSnackBar(context, e.toString());
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
                  Icons.arrow_back,
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
