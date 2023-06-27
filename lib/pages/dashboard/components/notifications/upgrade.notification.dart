import 'package:eatery/references.dart';

class UpgradeNotification extends StatefulWidget {
  final Company? company;
  final double? width;
  final EdgeInsets? margin;
  const UpgradeNotification({Key? key, this.company, this.width, this.margin})
      : super(key: key);

  @override
  State<UpgradeNotification> createState() => _UpgradeNotificationState();
}

class _UpgradeNotificationState extends State<UpgradeNotification> {
  @override
  Widget build(BuildContext context) {
    return EateryDB.instance.subscriptionBox.values
                .singleWhere(
                    (element) => element.id == widget.company!.subscriptionId!)
                .purchaseCode ==
            null
        ? Container(
      margin: widget.margin,
            width: widget.width,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: NotificationWidget(
              message: 'Activate License',
              header: "Upgrade",
              leading: Icon(
                UIcons.regularStraight.badge,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpgradePage(
                            company: widget.company,
                          )),
                ).then((_) async {
                  setState(() {
                    // DO CHANGE HERE
                  });
                });
              },
            ))
        : const SizedBox.shrink();
  }
}
