import 'package:eatery/references.dart';

class OnBoarding1Body extends StatelessWidget {
  const OnBoarding1Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200, // Adjust the width and height as needed
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, // Create a circular container
                color: Colors.blue, // Set a background color if desired
              ),
              child: Lottie.asset('assets/lottie/animation_lk9p1ks4.json'),
            ),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Let\'s Start the Journey',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Join us on an adventure into the future of dining. Embrace revolutionary technology that redefines your dining experience.',
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 15,
              ),
            ),
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            IconButton(
              onPressed: () {},
              icon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(UIcons.regularStraight.arrow_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
