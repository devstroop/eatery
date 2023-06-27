import 'package:eatery/references.dart';

class OnBoarding2Body extends StatelessWidget {
  const OnBoarding2Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/onboarding/onboarding2.svg',
        ),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'Quick Communication',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'Instant KOT printing and allocation of\nresponsibility right after placing order',
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
