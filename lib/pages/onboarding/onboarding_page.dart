import '../../references.dart';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  int index = 0;


  Widget build(BuildContext context) {
    List<Widget> bodies = [
      const OnBoarding1Body(),
      SvgPicture.asset('assets/vectors/FrameVector.svg', width: 72,),
      const OnBoarding2Body(),
      SvgPicture.asset('assets/vectors/vector_arrow_rounded.svg', width: 72,),
      const OnBoarding3Body(),
      SvgPicture.asset('assets/vectors/vector_arrow_rounded.svg', width: 72,),
      const OnBoarding4Body(),
    ];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...bodies.map((e) => SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: e,
            )).toList(),
          ],

        ),
      ),
    );
  }
}