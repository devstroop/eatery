import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:go_router/go_router.dart';

class UpgradeNotification extends ConsumerStatefulWidget {
  final Company? company;
  final double? width;
  final EdgeInsets? margin;
  const UpgradeNotification({super.key, this.company, this.width, this.margin});

  @override
  ConsumerState<UpgradeNotification> createState() =>
      _UpgradeNotificationState();
}

class _UpgradeNotificationState extends ConsumerState<UpgradeNotification> {
  @override
  Widget build(BuildContext context) {
    return ref.read(subscriptionRepositoryProvider).getFirst()?.purchaseCode ==
            null
        ? Container(
            margin: widget.margin,
            width: widget.width,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: AppNotification(
              message: 'Activate License',
              header: "Upgrade",
              leading: const Icon(
                Icons.workspace_premium,
                color: AppColors.white,
              ),
              onTap: () {
                GoRouter.of(
                  context,
                ).pushNamed('upgrade', extra: widget.company).then((_) async {
                  setState(() {
                    // DO CHANGE HERE
                  });
                });
              },
            ),
          )
        : const SizedBox.shrink();
  }
}
