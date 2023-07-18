import 'package:eatery/references.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateCompanyPage extends StatefulWidget {
  const CreateCompanyPage({Key? key}) : super(key: key);

  @override
  State<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends State<CreateCompanyPage> {
  int viewIndex = 0;
  LibraryImage? logo;
  TaxEditionType edition = TaxEditionType.gst;
  SubscriptionType subscriptionType = SubscriptionType.basic;
  String? deviceSerial;

  final TextEditingController _ctrName = TextEditingController(); // used
  final TextEditingController _ctrEmail = TextEditingController();
  final TextEditingController _ctrPhone = TextEditingController();
  final TextEditingController _ctrAddress = TextEditingController();
  final TextEditingController _ctrSalesTaxNo = TextEditingController();
  final TextEditingController _ctrFoodLicNo = TextEditingController();

  Currency? currency;
  String? purchaseCode;
  DateTime? validFrom;
  DateTime? validTill;

  Color themeColor = ColorStyle.brandColor;

  List<Widget> bodies() => [
        Body1(
          formKey: formKeys[0],
          selectedLibraryImage: logo,
          themeColor: themeColor,
          restaurantNameController: _ctrName,
          emailController: _ctrEmail,
          phoneController: _ctrPhone,
          addressController: _ctrAddress,
          onChanged: (logoPath) async {
            setState(() {
              logo = logoPath;
            });
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[0] = formKey;
          }),
        ),
        Body2(
          formKey: formKeys[1],
          edition: edition,
          themeColor: themeColor,
          callback: (TaxEditionType edition) {
            setState(() {
              this.edition = edition;
            });
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[1] = formKey;
          }),
        ),
        Body3(
          formKey: formKeys[2],
          themeColor: themeColor,
          edition: edition,
          taxNoController: _ctrSalesTaxNo,
          foodLicNoController: _ctrFoodLicNo,
          callbackFormKey: (formKey) => setState(() {
            formKeys[2] = formKey;
          }),
        ),
        Body4(
          formKey: formKeys[3],
          themeColor: themeColor,
          currency: currency,
          callback: (currency) {
            this.currency = currency;
          },
          callbackFormKey: (formKey) => setState(() {
            formKeys[3] = formKey;
          }),
        ),
        Body5(
          formKey: formKeys[4],
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
            formKeys[4] = formKey;
          }),
        )
      ];

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    // GlobalKey<FormState>()
  ];

  void _submit(
      {required GlobalKey<FormState> formKey,
      required int index,
      Function(int? index)? callback}) {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    if (callback != null) {
      callback(index);
    }
  }

  List<Widget> bottomAppBars() => [
        BottomAppBar(
          color: ColorStyle.backgroundColorAlter,
          child: PrimaryButton(
              color: themeColor,
              onPressed: () => _submit(
                  formKey: formKeys[0],
                  index: 1,
                  callback: (index) {
                    setState(() {
                      viewIndex++;
                    });
                  }),
              child: const Text('Next')),
        ),
        BottomAppBar(
          color: ColorStyle.backgroundColorAlter,
          child: PrimaryButton(
              color: themeColor,
              onPressed: () => _submit(
                  formKey: formKeys[1],
                  index: 2,
                  callback: (index) {
                    setState(() {
                      viewIndex++;
                    });
                  }),
              child: const Text('Next')),
        ),
        BottomAppBar(
          color: ColorStyle.backgroundColorAlter,
          child: PrimaryButton(
              color: themeColor,
              onPressed: () => _submit(
                  formKey: formKeys[2],
                  index: 3,
                  callback: (index) {
                    setState(() {
                      viewIndex++;
                    });
                  }),
              child: const Text('Next')),
        ),
        BottomAppBar(
          color: ColorStyle.backgroundColorAlter,
          child: PrimaryButton(
              color: themeColor,
              onPressed: () => _submit(
                  formKey: formKeys[3],
                  index: 4,
                  callback: (index) {
                    setState(() {
                      viewIndex++;
                    });
                  }),
              child: const Text('Next')),
        ),
        BottomAppBar(
          color: ColorStyle.backgroundColorAlter,
          child: PrimaryButton(
            color: themeColor,
            child: const Text('Finish'),
            onPressed: () => _submit(
                formKey: formKeys[4],
                index: 5,
                callback: (index) async {
                  try {
                    // Subscription
                    Subscription subscription = Subscription(
                      serialNo: deviceSerial ?? '',
                      activationKey: '',
                    );
                    await EateryDB.instance.subscriptionBox.add(subscription);

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
                          symbolOnLeft: currency!.symbolOnLeft);

                      await EateryDB.instance.currencyBox!.add(kCurrency); // TODO: Throwing error null check operator used on a null value (currencyBox) // TODO: Important!!!
                    }
                    // COMPANY
                    Company company = Company(
                      name: _ctrName.text,
                      logo: logo?.filename,
                      email: _ctrEmail.text,
                      phone: _ctrPhone.text,
                      address: _ctrAddress.text,
                      taxEdition: edition,
                      foodLicenseNo: _ctrFoodLicNo.text,
                      salesTaxNumber: _ctrSalesTaxNo.text,
                      activeSubscriptionKey: subscription.key,
                      defaultCurrencyKey: kCurrency?.key,
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
                }),
          ),
        ),
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

// Bodies

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
            themeColor: themeColor,
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

class Body2 extends StatelessWidget {
  final Function(TaxEditionType edition) callback;
  final Color themeColor;
  final TaxEditionType edition;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;

  const Body2(
      {Key? key,
      required this.themeColor,
      required this.callback,
      required this.edition,
      required this.formKey,
      this.callbackFormKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const PageTitle(
            title: "Edition",
            subtitle: "Choose a suitable edition",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          SelectableCard(
            header: "Edition",
            title: TaxEditionType.gst.label,
            footer: TaxEditionType.gst.description,
            selected: edition == TaxEditionType.gst,
            onTap: () {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              callback(TaxEditionType.gst);
            },
          ),
          SpacingStyle.defaultVerticalSpacing,
          SelectableCard(
            header: "Edition",
            title: TaxEditionType.vat.label,
            footer: TaxEditionType.vat.description,
            selected: edition == TaxEditionType.vat,
            onTap: () {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              callback(TaxEditionType.vat);
            },
          ),
        ],
      ),
    );
  }
}

class Body3 extends StatelessWidget {
  final Color themeColor;
  final TaxEditionType edition;
  final TextEditingController taxNoController;
  final TextEditingController foodLicNoController;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;

  Body3(
      {Key? key,
      required this.themeColor,
      required this.edition,
      required this.taxNoController,
      required this.foodLicNoController,
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
            title: "Registration / License info (optional)",
            subtitle: "Help us to know more about your business",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
            themeColor: themeColor,
            keyboardType: TextInputType.text,
            controller: taxNoController,
            title: '${edition.label} Registration No',
            hint: 'Enter ${edition.label.toLowerCase()} registration number',
            focusNode: focus1,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              FocusScope.of(context).requestFocus(focus2);
            },
            validator: (value) {
              if (value!.trim().isNotEmpty && !value.trim().isValidGSTIN()) {
                return '${edition.name} license number is not valid';
              }
              return null;
            },
          ),
          SpacingStyle.defaultVerticalSpacing,
          CustomTextFromField(
            themeColor: themeColor,
            keyboardType: TextInputType.number,
            controller: foodLicNoController,
            title:
                '${edition == TaxEditionType.gst ? 'FSSAI' : 'Food'} Registration Number',
            hint:
                'Enter ${edition == TaxEditionType.gst ? 'fssai' : 'food'} license number',
            focusNode: focus2,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              FocusScope.of(context).requestFocus(focus3);
            },
            validator: (value) {
              if (value!.trim().isNotEmpty &&
                  (value.trim().length < 10 || !value.trim().isNumericOnly)) {
                return '${edition == TaxEditionType.gst ? 'FSSAI' : 'Food'} license number is not valid';
              }
              // if (edition == Edition.gst && !value!.trim().isValidGSTIN()) return '${edition.name} license number is not valid';
              return null;
            },
          ),
          SpacingStyle.defaultVerticalSpacing
        ],
      ),
    );
  }
}

class Body4 extends StatefulWidget {
  final Color themeColor;
  final Currency? currency;
  final Function(Currency? currency) callback;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;

  const Body4({
    Key? key,
    required this.themeColor,
    required this.callback,
    this.currency,
    required this.formKey,
    this.callbackFormKey,
  }) : super(key: key);

  @override
  State<Body4> createState() => _Body4State();
}
class _Body4State extends State<Body4> {
  Currency? selectedCurrency;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedCurrency = widget.currency;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const PageTitle(
            title: "Region and Currency",
            subtitle: "Select the default currency as per region",
          ),
          SpacingStyle.defaultVerticalSpacing,
          InkWell(
            onTap: () => showCurrencyPicker(
              context: context,
              showSearchField: false,
              showFlag: true,
              showCurrencyName: true,
              showCurrencyCode: true,
              currencyFilter: const ['INR', 'AED'],
              theme: CurrencyPickerThemeData(
                bottomSheetHeight: MediaQuery.of(context).size.height * 4/5
              ),
              onSelect: (Currency currency) {
                setState(() {
                  selectedCurrency = currency;
                });
                if (widget.callbackFormKey != null) {
                  widget.callbackFormKey!(widget.formKey);
                }
                widget.callback(currency);
              },
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: ColorStyle.brandColor,
                  width: 2,
                ),
              ),
              child: ListTile(
                leading: selectedCurrency != null
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CurrencyUtils.currencyToEmoji(selectedCurrency!),
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ],
                      )
                    : null,
                trailing: selectedCurrency != null
                    ? Text(
                        selectedCurrency!.symbol,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      )
                    : null,
                title: Text(
                  selectedCurrency != null
                      ? selectedCurrency!.code
                      : 'Not Selected',
                ),
                subtitle: selectedCurrency != null
                    ? Text(selectedCurrency!.name)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Body5 extends StatefulWidget {
  final Color themeColor;
  final Function(SubscriptionType subscriptionType, String? purchaseCde,
      DateTime? validFrom, DateTime? validTill) callback;
  SubscriptionType? subscriptionType;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;

  Body5(
      {Key? key,
      required this.themeColor,
      required this.callback,
      required this.subscriptionType,
      required this.formKey,
      this.callbackFormKey})
      : super(key: key);

  @override
  State<Body5> createState() => _Body5State();
}
class _Body5State extends State<Body5> {
  final TextEditingController _controllerPurchaseCode = TextEditingController();
  DateTime? validFrom;
  DateTime? validTill;
  String? deviceSerial;

  Future fetchDeviceInfo() async {
    String? deviceId;
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        deviceId = await PlatformDeviceId.getDeviceId;
      } on Exception {
        deviceId = null;
      }
    } else if (Platform.isWindows) {
      List<Drive> drives = WindowsHDSN().getDrives();
      for (Drive drive in drives) {
        debugPrint(drive.model);
        debugPrint(drive.serial);
      }
    } else {
      deviceId = null;
    }

    if (widget.callbackFormKey != null) {
      widget.callbackFormKey!(widget.formKey);
    }
    setState(() {
      deviceSerial = deviceId;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchDeviceInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const PageTitle(
            title: "Choose your plan",
            subtitle: "Get access to whole product in one go",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          SelectableCard(
            header: 'EVALUATION',
            title: 'Try It Free',
            highlights: const ['100 invoices a month', '10 products'],
            footer: 'Enjoy with limited access',
            selected: widget.subscriptionType == SubscriptionType.basic,
            highlightColor: ColorStyle.warning,
            onTap: () {
              widget.callback(SubscriptionType.basic, null, null, null);

              if (widget.callbackFormKey != null) {
                widget.callbackFormKey!(widget.formKey);
              }
            },
          ),
          SpacingStyle.defaultVerticalSpacing,
          SelectableCard(
            header: 'PREMIUM',
            title: 'Activate License',
            highlights: const ['Everything Unlimited'],
            footer: 'Get unlocked to all premium features',
            selected: widget.subscriptionType == SubscriptionType.professional,
            highlightColor: ColorStyle.success,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacingStyle.defaultVerticalSpacing,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Device ID'),
                        IconButton(
                          onPressed: fetchDeviceInfo,
                          iconSize: 14,
                          icon: Icon(
                            UIcons.regularStraight.refresh,
                          ),
                        ),
                        IconButton(
                          onPressed: copyDeviceIdToClipboard,
                          iconSize: 14,
                          icon: Icon(
                            UIcons.regularStraight.copy,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: copyDeviceIdToClipboard,
                      child: Text(
                        deviceSerial ?? 'Undefined',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                    const Divider()
                  ],
                ),
                SpacingStyle.defaultVerticalSpacing,
                if (validTill != null)
                  Text('Validity: ${DateFormat.yMMMd().format(validTill!)}'),
                if (validTill != null) SpacingStyle.defaultVerticalSpacing,
                CustomTextFromField(
                  themeColor: widget.themeColor,
                  controller: _controllerPurchaseCode,
                  title: 'Purchase code',
                  hint: 'Enter purchase code...',
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  suffix: IconButton(
                    onPressed: () async {
                      String val = await FlutterClipboard.paste();
                      setState(() {
                        _controllerPurchaseCode.text = val;
                      });

                      if (widget.callbackFormKey != null) {
                        widget.callbackFormKey!(widget.formKey);
                      }
                    },
                    icon: Icon(UIcons.regularStraight.clipboard_list),
                    color: ColorStyle.text400,
                  ),
                  validator: (value) {
                    if (widget.subscriptionType ==
                        SubscriptionType.professional) {
                      if (value!.isEmpty) {
                        return 'Purchase code cannot be blank';
                      }
                      if (value.contains(' ')) {
                        return 'Purchase code is not valid';
                      }
                      if (validFrom == null || validTill == null) {
                        return 'Purchase code is not valid';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // VALIDATE_LICENSE_HERE
                    License(purchaseCode: value)
                        .validate((validFrom, validTill) {
                      setState(() {
                        this.validFrom = validFrom;
                        this.validTill = validTill;
                      });
                      widget.callback(SubscriptionType.professional,
                          _controllerPurchaseCode.text, validFrom, validTill);

                      if (widget.callbackFormKey != null) {
                        widget.callbackFormKey!(widget.formKey);
                      }
                    });
                  },
                  onFieldSubmitted: (v) {
                    if (widget.callbackFormKey != null) {
                      widget.callbackFormKey!(widget.formKey);
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
            onTap: () {
              widget.callback(SubscriptionType.professional, null, null, null);

              if (widget.callbackFormKey != null) {
                widget.callbackFormKey!(widget.formKey);
              }
            },
          ),
        ],
      ),
    );
  }

  void copyDeviceIdToClipboard() {
    // Implement copy to clipboard 'deviceSerial'
    String? deviceSerial = this.deviceSerial;
    if (deviceSerial == null) {
      showSnackBar(this.context, 'Device Id can\'t be copied in clipboard');
      return;
    }
    Clipboard.setData(ClipboardData(text: deviceSerial)).whenComplete(() {
      showSnackBar(this.context, 'Copied to clipboard');
    });
  }
}