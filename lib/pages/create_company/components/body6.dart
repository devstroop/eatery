import 'package:eatery_core/utils/device_id.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body6 extends ConsumerStatefulWidget {
  final Color themeColor;
  final Function(
    SubscriptionType subscriptionType,
    String? purchaseCde,
    DateTime? validFrom,
    DateTime? validTill,
  )
  callback;
  final SubscriptionType? subscriptionType;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  const Body6({
    super.key,
    required this.themeColor,
    required this.callback,
    required this.subscriptionType,
    required this.formKey,
    this.callbackFormKey,
  });

  @override
  ConsumerState<Body6> createState() => _Body6State();
}

class _Body6State extends ConsumerState<Body6> {
  final TextEditingController _controllerPurchaseCode = TextEditingController();
  DateTime? validFrom;
  DateTime? validTill;
  String? deviceSerial;

  Future fetchDeviceInfo() async {
    String? deviceId;
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        deviceId = await getDeviceId();
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
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const PageTitle(
              title: "Choose your subscription",
              subtitle: "Select the subscription type that suits you best",
            ),
            AppSpacing.gapMd,
            AppSpacing.gapMd,
            ...SubscriptionType.values.map((e) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSelectCard(
                    header: e.label,
                    title: e.name,
                    highlights: e.highlights,
                    footer: e.description,
                    value: e,
                    groupValue: widget.subscriptionType,
                    onChanged: (v) {
                      widget.callback(
                        v,
                        _controllerPurchaseCode.text,
                        validFrom,
                        validTill,
                      );
                    },
                  ),
                  AppSpacing.gapMd,
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  void copyDeviceIdToClipboard() {
    // Implement copy to clipboard 'deviceSerial'
    String? deviceSerial = this.deviceSerial;
    deviceSerial ??= 'Undefined';
    Clipboard.setData(ClipboardData(text: deviceSerial)).whenComplete(() {
      AppDialog.showMessage(
        context,
        message: 'Device ID copied to clipboard',
        type: MessageType.success,
      );
    });
  }
}
