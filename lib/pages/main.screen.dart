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
    final spacing = Responsive.spacing(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Lottie sizing: fill ~35% of available height, but cap it
    final lottieMaxHeight = isDesktop ? 280.0 : screenHeight * 0.32;
    final lottieMaxWidth = isDesktop ? 320.0 : screenWidth * 0.6;
    final titleFontSize = isDesktop ? 36.0 : isTablet ? 32.0 : 28.0;

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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie animation — bounded, never scrolls away
                SizedBox(
                  height: lottieMaxHeight,
                  width: lottieMaxWidth,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Lottie.asset(
                      'assets/lottie/1699652006712.json',
                    ),
                  ),
                ),
                SizedBox(height: isDesktop ? 32 : 20),
                // Title — always visible, centered
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All-in-one',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'restaurant POS System',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your restaurant with ease with Eatery',
                        style: TextStyle(
                          fontSize: Responsive.bodySize(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
