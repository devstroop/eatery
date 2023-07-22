import 'package:eatery/references.dart';

class CreateCompanyResultPage extends StatefulWidget {
  const CreateCompanyResultPage({Key? key}) : super(key: key);

  @override
  State<CreateCompanyResultPage> createState() =>
      _CreateCompanyResultPageState();
}

class _CreateCompanyResultPageState extends State<CreateCompanyResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Image.asset(
            'assets/logo.png',
            height: 48,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: ColorStyle.backgroundColorAlter,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Lottie.asset(
                  'assets/lottie/hurray.json'),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hurray!',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ColorStyle.brandColor),
                  ),
                  const Text(
                    'You\'ve successfully created a company.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: ColorStyle.brandColor,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          },
          child: const Text('Continue to Login'),
        ),
      ),
    );
  }
}
