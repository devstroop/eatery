import 'package:eatery/constants/style/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Onboarding1Body extends StatelessWidget {
  const Onboarding1Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/onboarding/onboarding1.svg',
        ),
        SpacingStyle.defaultVerticalSpacing,
        Text(
          'Fast & easy to access',
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
