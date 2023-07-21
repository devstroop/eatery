import 'package:eatery/references.dart';

class HelpBottomSheet extends StatelessWidget {
  const HelpBottomSheet({Key? key}) : super(key: key);

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
                      'Help',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Get support',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      const url = "https://devstroop.com";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw "Could not launch $url";
                      }
                    },
                    icon: Icon(UIcons.regularStraight.link,
                        color: ColorStyle.brandColor))
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
                  UIcons.regularStraight.comment_user,
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
