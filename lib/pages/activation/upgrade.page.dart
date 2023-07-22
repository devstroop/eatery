import 'package:eatery/references.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key, required this.company}) : super(key: key);
  final Company? company;

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  int selectedIndex = 1;
  var controllerPurchaseCode = TextEditingController();
  late String? deviceSerial = 'Fetching';

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration.zero, (){
      fetchDeviceInfo();
    });
  }

  fetchDeviceInfo() async {
    String? deviceSerial = await PlatformDeviceId.getDeviceId;
    setState(() {
      this.deviceSerial = deviceSerial;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color getThemeColor() {
      return ColorStyle.brandColor;
    }

    final appBar = AppBar(
      foregroundColor: Colors.white,
      backgroundColor: getThemeColor(),
      title: const Text('Upgrade'),
    );
    Widget buildContactSalesBottomSheet() =>
        StatefulBuilder(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Center(
                  child: BottomViewGrip(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Sales',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Contact us to get subscription',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          const url = "https://eatery.devstroop.com";
                          canLaunchUrl(Uri.parse(url)).then(
                              (value) => value
                                  ? launchUrl(Uri.parse(url))
                                  : throw "Could not launch $url");
                        },
                        icon: Icon(Icons.link,
                            color: ColorStyle.brandColor))
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.call,
                      size: 24,
                      color: ColorStyle.brandColor,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      '+91 950 100 5734',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 24,
                      color: ColorStyle.brandColor,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'help@devstroop.com',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        });
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColorAlter,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 12.0,
              ),
              InkWell(
                child: SelectableCard(
                  header: 'PREMIUM',
                  title: 'UPGRADE TO PREMIUM',
                  highlights: const ['Everything Unlimited'],
                  footer: 'Get unlocked to all premium features',
                  selected: selectedIndex == 1,
                  highlightColor: ColorStyle.warning,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device Id: $deviceSerial',
                        style: TextStyle(
                          color: ColorStyle.text200,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      CustomTextFromField(
                        controller: controllerPurchaseCode,
                        hint: 'Purchase Code',
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: SecondaryButton(
                color: ColorStyle.text300,
                borderColor: ColorStyle.text400,
                text: 'Contact Sales',
                height: 50.0,
                onTap: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    context: context,
                    builder: (context) => buildContactSalesBottomSheet()),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: PrimaryButton(
                height: 50.0,
                color: getThemeColor(),
                onPressed: () async {
                  if (selectedIndex == 1 && controllerPurchaseCode.text != '') {
                    /*LicenseData licData = License.validate(controllerPurchaseCode.text);
                    if (licData.status) {
                      */ /*Map<String, dynamic> account = widget.account;
                      account['purchaseCode'] = licData.purchaseCode;
                      var status = await Account.update(account);
                      if (status) {
                        showSnackBar(context, "Activated successfully");
                        Navigator.pop(context);
                      } else {
                        showSnackBar(context, "Activation failed");
                      }*/ /*
                    } else {
                      showSnackBar(context, licData.message);
                    }*/
                  }
                },
                child: const Text('Activate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
