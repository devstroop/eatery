import 'package:eatery/references.dart';

class OnBoarding4Body extends StatelessWidget {
  const OnBoarding4Body({Key? key}) : super(key: key);

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
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Lottie.asset('assets/lottie/animation_lk9p1ks4.json'),
            ),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Navigate with Ease',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            SpacingStyle.defaultVerticalSpacing,
            Text(
              'Congratulations on nearing the cosmic finale! Create your account securely and let our user-friendly navigator guide you through a galaxy of options.',
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 15,
              ),
            ),
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your action for "Let's Start" button here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    // primary: Colors.blue, // Set the color to blue
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Increase button padding
                    textStyle: const TextStyle(fontSize: 18, color: Colors.white), // Increase font size
                  ),
                  child: const Text("Let's Start"),
                ),
                const SizedBox(width: 16), // Add some space between the buttons
                ElevatedButton(
                  onPressed: () {
                    // Add your action for "Login" button here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    // primary: Colors.blue, // Set the color to blue
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Increase button padding
                    textStyle: const TextStyle(fontSize: 18, color: Colors.white), // Increase font size
                  ),
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
