import 'dart:io';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:eatery/components/notification_widget.dart';
import 'package:flutter/material.dart';

class LowBatteryWarningNotification extends StatelessWidget {
  const LowBatteryWarningNotification({Key? key, this.onSlideRight}) : super(key: key);
  final VoidCallback? onSlideRight;

  getBatteryLevel() async {
    if (Platform.isIOS) {
      return (await BatteryInfoPlugin().iosBatteryInfo)!.batteryLevel;
    } else if (Platform.isAndroid) {
      return (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel;
    } else {
      return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBatteryLevel(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data <= 20) {
          return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: NotificationWidget(
                leading: const Icon(Icons.battery_1_bar, color: Colors.white,),
                message:
                    'Battery level is ${snapshot.data}% in need of charging.',
                timestamp: true,
              ));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
