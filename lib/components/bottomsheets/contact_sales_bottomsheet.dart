import 'package:eatery/components/bottom_view_grip.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactSalesBottomSheet extends StatelessWidget {
  const ContactSalesBottomSheet({Key? key}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Sales',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Contact us to get subscription',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      const url = "https://eatery.devstroop.com";
                      if (await url_launcher.canLaunchUrl(Uri.parse(url))) {
                        await url_launcher.launchUrl(Uri.parse(url));
                      } else {
                        throw "Could not launch $url";
                      }
                    },
                    icon: Icon(UIcons.regularStraight.link))
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: [
                Icon(
                  UIcons.regularStraight.phone_call,
                  size: 24,
                  color: ColorStyle.brandColor,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  '+91 950 100 5734',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Icon(
                  UIcons.regularStraight.envelope,
                  size: 24,
                  color: ColorStyle.brandColor,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  'help@devstroop.com',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  }
}
