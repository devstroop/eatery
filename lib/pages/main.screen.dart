import 'package:eatery/references.dart';
import 'package:flutter/material.dart';

Color themeColor = KColors.secondary2;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            margin: const EdgeInsets.only(top: 12),
            child: Image.asset(
              'assets/logo.png',
              height: 48,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Lottie.asset('assets/lottie/1699652006712.json'),
            const Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All-in-one',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'restaurant POS System',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        children: [
                          Text(
                            'Manage your restaurant with ease',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'with Eatery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: PrimaryButton(
                  height: 50,
                  width: double.infinity,
                  color: KColors.tertiary3,
                  onPressed: () => _restoreExisting(context),
                  child: const Text('Restore Existing'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                child: PrimaryButton(
                  width: double.infinity,
                  height: 50,
                  color: themeColor,
                  onPressed: () => _createNew(context),
                  child: const Text('Create Company'),
                ),
              ),
            ],
          ),
        ));
  }

  _restoreExisting(BuildContext context) {
  }

  _createNew(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCompanyPage()),
    );
  }
}
