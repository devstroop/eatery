import '../../references.dart';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  int index = 0;
  List<Widget> bodies = [
    const OnBoarding1Body(),
    const OnBoarding2Body(),
    const OnBoarding3Body(),
    const OnBoarding4Body(),
  ];

  Widget build(BuildContext context) {
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