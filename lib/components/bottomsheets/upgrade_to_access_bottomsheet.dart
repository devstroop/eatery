import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:go_router/go_router.dart';

class UpgradeToAccessBottomSheet extends StatefulWidget {
  final Color themeColor;
  final Company? company;
  final Function(Company? company) callback;
  const UpgradeToAccessBottomSheet({
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
    GoRouter.of(this.context).pushNamed('upgrade', extra: widget.company).then((
      _,
    ) async {
      setState(() {
        // DO CHANGE HERE
      });
      if (mounted) Navigator.pop(this.context);
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
              const Center(child: AppBottomSheetGrip()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/upgrade.png', width: 96.0),
                  AppSpacing.gapMd,
                  const Text(
                    'Upgrade to access',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  AppSpacing.gapMd,
                  const Text(
                    "Feature isn't available for evaluation user",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              AppSpacing.gapMd,
              AppSpacing.gapMd,
              AppSpacing.gapMd,
              AppButton.primary(
                height: 50,
                onPressed: _upgrade,
                label: 'Upgrade',
              ),
              AppSpacing.gapMd,
            ],
          ),
        );
      },
    );
  }
}
