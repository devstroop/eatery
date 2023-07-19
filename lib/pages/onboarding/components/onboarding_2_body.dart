import 'package:eatery/references.dart';

class OnBoarding2Body extends StatelessWidget {
  const OnBoarding2Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/onboarding_2.json', width: 300),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Hang Up the Traditional Approach',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Explore new culinary frontiers as our innovative POS portal enchants your dining experiences.',
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
