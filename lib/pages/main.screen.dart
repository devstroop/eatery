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
    final isTablet = Responsive.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Sizing: scale everything properly for desktop
    final lottieHeight = isDesktop ? 360.0 : isTablet ? 280.0 : screenHeight * 0.30;
    final lottieWidth  = isDesktop ? 400.0 : isTablet ? 340.0 : screenWidth * 0.65;
    final titleFontSize = isDesktop ? 56.0 : isTablet ? 42.0 : 28.0;
    final subtitleFontSize = isDesktop ? 20.0 : isTablet ? 17.0 : 14.0;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation
              SizedBox(
                height: lottieHeight,
                width: lottieWidth,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Lottie.asset('assets/lottie/1699652006712.json'),
                ),
              ),
              SizedBox(height: isDesktop ? 40 : 24),
              // Title — centered, big, always visible
              Text(
                'All-in-one',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'restaurant POS System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Manage your restaurant with ease with Eatery',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? 600 : 480),
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
