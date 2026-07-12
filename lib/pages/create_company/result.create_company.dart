import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        backgroundColor: AppColors.grey200,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Image.asset(
            'assets/logo.png',
            height: 48,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Lottie.asset(
                    'assets/lottie/animation_llie4lzc.json'),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Congrats!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary2),
                  ),
                  Text(
                    'Your company has been created successfully.\nLogin to get started!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.black500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: AppButton.primary(
                  onPressed: () {
                    GoRouter.of(context).goNamed('login');
                  },
                  label: 'Continue to Login',
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: AppColors.white,
      //   child: PrimaryButton(
      //     color: AppColors.secondary2,
      //     onPressed: () {
      //       Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => const LoginPage()),
      //         (Route<dynamic> route) => false,
      //       );
      //     },
      //     child: const Text('Continue to Login'),
      //   ),
      // ),
    );
  }
}
