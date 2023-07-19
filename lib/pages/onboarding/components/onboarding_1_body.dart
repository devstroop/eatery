import 'package:eatery/references.dart';

class OnBoarding1Body extends StatelessWidget {
  const OnBoarding1Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset('assets/lottie/animation_lk9syi35.json', width: 300),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'Let\'s Start the Journey to the Futuristic Restaurant Management Odyssey',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600
          ),
        ),
        SpacingStyle.defaultVerticalSpacing,
        // Text(
        //   'Step into the future, bid adieu to pen and paper. Embrace state-of-the-art technology for a fully managed restaurant system.',
        //   overflow: TextOverflow.clip,
        //   textAlign: TextAlign.center,
        //   style: Theme.of(context).textTheme.bodyText2,
        // ),
        SpacingStyle.defaultVerticalSpacing,
        SpacingStyle.defaultVerticalSpacing,
        SpacingStyle.defaultVerticalSpacing,
        IconButton(
          onPressed: () {},
          icon: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(UIcons.regularStraight.arrow_right),
          ),
        )
      ],
    );
  }
}
