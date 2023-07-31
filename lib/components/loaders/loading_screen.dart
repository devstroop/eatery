import 'package:eatery/references.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key}) : super(key: key);

  final Color themeColor = KColors.secondary2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset('assets/lottie/105511-fireworks.json')),
    );
  }
}
