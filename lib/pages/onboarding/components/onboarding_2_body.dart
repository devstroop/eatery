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
            Container(
              width: 200, // Adjust the width and height as needed
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, // Create a circular container
                color: Colors.blue, // Set a background color if desired
              ),
                child: Lottie.asset('assets/lottie/onboarding_2.json'),
            ),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Hang Up the Traditional Approach',
              textAlign: TextAlign.center,
              maxLines: 1, // Set maxLines to 1 to make the title fit in one line
              overflow: TextOverflow.ellipsis, // Add ellipsis in case the title overflows
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20, // Adjust the fontSize as needed
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
