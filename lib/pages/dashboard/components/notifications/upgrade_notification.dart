import 'package:eatery/components/notification_widget.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:flutter/material.dart';
import '../../../activation/upgrade_page.dart';

class UpgradeNotification extends StatefulWidget {
  late Company? company;

  UpgradeNotification({Key? key, this.company}) : super(key: key);

  @override
  State<UpgradeNotification> createState() => _UpgradeNotificationState();
}

class _UpgradeNotificationState extends State<UpgradeNotification> {
  @override
  Widget build(BuildContext context) {
    return EateryDB().subscriptionBox().values.singleWhere((element) => element.id == widget.company!.subscriptionId!).purchaseCode == null
        ? Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: NotificationWidget(
              message: 'Activate License',
              header: "Upgrade",
              leading: const Icon(Icons.workspace_premium, color: Colors.white,)/*Image.asset(
                'assets/images/upgrade.png',
                width: 36.0,
              )*/,
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
        : Container();
  }
}
