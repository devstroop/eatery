import 'package:eatery/references.dart';

class OnBoarding3Body extends StatelessWidget {
  const OnBoarding3Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/animation_lk9p1ks4.json', width: 300),
            SpacingStyle.defaultVerticalSpacing,
            Center( // Wrap the Text widget with Center to make the title centered
              child: Text(
                'Empower Your Dining Experience',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Take control with our multi-order feature. Customize meals exactly the way you desire, whether dine-in, delivery, or takeaway.',
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
