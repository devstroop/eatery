import 'package:eatery/references.dart';

class OnBoarding4Body extends StatelessWidget {
  const OnBoarding4Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/onboarding/onboarding4.svg',
        ),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'Aesthetically pleasing UI',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'A well thought POS system keeping user\nexperience and accessibility as priority',
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
