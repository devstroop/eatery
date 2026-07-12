import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

class UpgradeNotification extends ConsumerStatefulWidget {
  final Company? company;
  final double? width;
  final EdgeInsets? margin;
  const UpgradeNotification({Key? key, this.company, this.width, this.margin})
    : super(key: key);

  @override
  ConsumerState<UpgradeNotification> createState() =>
      _UpgradeNotificationState();
}

class _UpgradeNotificationState extends ConsumerState<UpgradeNotification> {
  @override
  Widget build(BuildContext context) {
    return ref
                .read(appDatabaseProvider)
                .subscriptionBox
                .values
                .singleWhere(
                  (element) => element.id == widget.company!.subscriptionId!,
                )
                .purchaseCode ==
            null
        ? Container(
            margin: widget.margin,
            width: widget.width,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: NotificationWidget(
              message: 'Activate License',
              header: "Upgrade",
              leading: const Icon(Icons.workspace_premium, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpgradePage(company: widget.company),
                  ),
                ).then((_) async {
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
