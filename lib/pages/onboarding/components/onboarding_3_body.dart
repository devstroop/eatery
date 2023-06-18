import 'package:eatery/constants/style/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Onboarding3Body extends StatelessWidget {
  const Onboarding3Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/onboarding/onboarding3.svg',
        ),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'Easy & safe management ',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'A smooth transpire of data backup automatically\nso that you don’t have to worry about data',
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
