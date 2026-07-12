import 'package:eatery/core/utils/responsive.dart';
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
    final isDesktop = Responsive.isDesktop(context);
    final headlineSize = Responsive.headlineSize(context);
    final bodySize = Responsive.bodySize(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(top: 12),
          child: Image.asset('assets/logo.png', height: 48),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 800 : double.infinity,
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context),
                    vertical: isDesktop ? 48 : 24,
                  ),
                  children: [
                    // Lottie animation — height scales with screen
                    Lottie.asset(
                      'assets/lottie/1699652006712.json',
                      height: isDesktop ? 360 : constraints.maxWidth * 0.6,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: isDesktop ? 40 : 24),
                    // Title
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 64 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All-in-one',
                            style: TextStyle(
                              fontSize: headlineSize + 8,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'restaurant POS System',
                            style: TextStyle(
                              fontSize: headlineSize + 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            children: [
                              Text(
                                'Manage your restaurant with ease',
                                style: TextStyle(
                                  fontSize: bodySize,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'with Eatery',
                                style: TextStyle(
                                  fontSize: bodySize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        height: 50,
                        color: KColors.tertiary3,
                        onPressed: () => _restoreExisting(context),
                        child: const Text('Restore Existing'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        height: 50,
                        color: themeColor,
                        onPressed: () => _createNew(context),
                        child: const Text('Create Company'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _restoreExisting(BuildContext context) {}

  _createNew(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCompanyPage()),
    );
  }
}
