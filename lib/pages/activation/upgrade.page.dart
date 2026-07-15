import 'package:eatery_core/utils/device_id.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _pageColor = AppColors.secondary2;

class UpgradePage extends ConsumerStatefulWidget {
  const UpgradePage({Key? key, required this.company}) : super(key: key);
  final Company? company;

  @override
  ConsumerState<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends ConsumerState<UpgradePage> {
  SubscriptionType? selectedSubscriptionType;
  var controllerPurchaseCode = TextEditingController();
  late String? deviceSerial = 'Fetching';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchDeviceInfo();
    });
  }

  fetchDeviceInfo() async {
    String? deviceSerial = await getDeviceId();
    setState(() {
      this.deviceSerial = deviceSerial;
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      foregroundColor: AppColors.white,
      backgroundColor: _pageColor,
      title: const Text('Subscription'),
    );
    /*Widget buildContactSalesBottomSheet() =>
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
                            color: AppColors.secondary2))
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
                      color: AppColors.secondary2,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      '+91 950 100 5734',
                      style:
                          AppTypography.titleMedium,
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
                      color: AppColors.secondary2,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'help@devstroop.com',
                      style:
                          AppTypography.titleMedium,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        });*/
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: appBar,
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          scrollDirection: Axis.vertical,
          children: [
            const PageTitle(
              title: "Choose your subscription",
              subtitle: "Select the subscription type that suits you best",
            ),
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            ...SubscriptionType.values.map((e) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableCard(
                    header: e.label,
                    title: e.name,
                    highlights: e.highlights,
                    footer: e.description,
                    selected: e.id == selectedSubscriptionType?.id,
                    highlightColor: e.color,
                    onTap: () {
                      setState(() {
                        selectedSubscriptionType = e;
                      });
                    },
                  ),
                  SpacingStyle.defaultVerticalSpacing,
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: AppButton.primary(
          height: 50.0,
          onPressed: () async {},
          label: 'Continue',
        ),
      ),
    );
  }
}
