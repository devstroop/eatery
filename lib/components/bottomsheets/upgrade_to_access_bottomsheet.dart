import 'package:eatery/references.dart';
import 'package:go_router/go_router.dart';

class UpgradeToAccessBottomSheet extends StatefulWidget {
  final BuildContext context;
  final Color themeColor;
  final Company? company;
  final Function(Company? company) callback;
  const UpgradeToAccessBottomSheet(
    this.context, {
    Key? key,
    required this.themeColor,
    required this.callback,
    this.company,
  }) : super(key: key);

  @override
  State<UpgradeToAccessBottomSheet> createState() =>
      _UpgradeToAccessBottomSheetState();
}

class _UpgradeToAccessBottomSheetState
    extends State<UpgradeToAccessBottomSheet> {
  void _upgrade() {
    GoRouter.of(
      widget.context,
    ).pushNamed('upgrade', extra: widget.company).then((_) async {
      setState(() {
        // DO CHANGE HERE
      });
      Navigator.pop(this.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(child: BottomViewGrip()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/upgrade.png', width: 96.0),
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
              AppButton.primary(
                height: 50,
                onPressed: _upgrade,
                label: 'Upgrade',
              ),
              SpacingStyle.defaultVerticalSpacing,
            ],
          ),
        );
      },
    );
  }
}
