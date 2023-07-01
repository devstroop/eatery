import 'package:intl/intl.dart';
import 'package:eatery/references.dart';

class Body6 extends StatefulWidget {
  final Color themeColor;
  final Function(SubscriptionType subscriptionType, String? purchaseCde,
      DateTime? validFrom, DateTime? validTill) callback;
  SubscriptionType? subscriptionType;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  Body6(
      {Key? key,
      required this.themeColor,
      required this.callback,
      required this.subscriptionType,
      required this.formKey,
      this.callbackFormKey})
      : super(key: key);

  @override
  State<Body6> createState() => _Body6State();
}

class _Body6State extends State<Body6> {
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
    Future.delayed(Duration.zero, (){
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
                    if (widget.subscriptionType == SubscriptionType.professional) {
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
