import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/references.dart';

class UpgradeToAccessBottomSheet extends StatefulWidget {
  final BuildContext context;
  final Color themeColor;
  final Company? company;
  final Function(Company? company) callback;
  const UpgradeToAccessBottomSheet(this.context,
      {Key? key,
      required this.themeColor,
      required this.callback,
      this.company})
      : super(key: key);

  @override
  State<UpgradeToAccessBottomSheet> createState() =>
      _UpgradeToAccessBottomSheetState();
}

class _UpgradeToAccessBottomSheetState
    extends State<UpgradeToAccessBottomSheet> {
  void _upgrade() {
    Navigator.push(
      widget.context,
      MaterialPageRoute(
          builder: (context) => UpgradePage(
                company: widget.company,
              )),
    ).then((_) async {
      setState(() {
        // DO CHANGE HERE
      });
      Navigator.pop(this.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: BottomViewGrip(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/upgrade.png',
                  width: 96.0,
                ),
                SpacingStyle.defaultVerticalSpacing,
                const Text(
                  'Upgrade to access',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                SpacingStyle.defaultVerticalSpacing,
                const Text(
                  "Feature isn't available for evaluation user",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            PrimaryButton(
              height: 50,
              color: widget.themeColor,
              onPressed: _upgrade,
              child: const Text('Upgrade'),
            ),
            SpacingStyle.defaultVerticalSpacing,
          ],
        ),
      );
    });
  }
}
