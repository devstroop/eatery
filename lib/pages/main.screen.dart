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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(top: 12),
          child: Image.asset('assets/logo.png', height: 48),
        ),
      ),
      backgroundColor: Colors.white,
      body: isDesktop
          ? _buildDesktopLayout(screenWidth, screenHeight)
          : _buildMobileLayout(screenWidth, screenHeight),
      bottomNavigationBar: isDesktop ? null : _buildBottomBar(),
    );
  }

  // ── Desktop: 6/6 side-by-side hero layout ──────────────────────
  Widget _buildDesktopLayout(double screenWidth, double screenHeight) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          child: Row(
            children: [
              // Left 6 — Lottie animation
              Expanded(
                flex: 6,
                child: Center(
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Lottie.asset('assets/lottie/1699652006712.json'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
              // Right 6 — Text + buttons
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All-in-one',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'restaurant POS System',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Manage your restaurant with ease with Eatery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Buttons — inline, not bottom bar
                    Row(
                      children: [
                        PrimaryButton(
                          height: 52,
                          width: 200,
                          color: KColors.tertiary3,
                          onPressed: () => _restoreExisting(this.context),
                          child: const Text('Restore Existing'),
                        ),
                        const SizedBox(width: 16),
                        PrimaryButton(
                          height: 52,
                          width: 200,
                          color: themeColor,
                          onPressed: () => _createNew(this.context),
                          child: const Text('Create Company'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Mobile: centered vertical layout with BottomAppBar ─────────
  Widget _buildMobileLayout(double screenWidth, double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.30,
            width: screenWidth * 0.65,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Lottie.asset('assets/lottie/1699652006712.json'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'All-in-one',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
          ),
          Text(
            'restaurant POS System',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            'Manage your restaurant with ease with Eatery',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile: BottomAppBar with buttons ──────────────────────────
  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      height: 50,
                      color: KColors.tertiary3,
                      onPressed: () => _restoreExisting(this.context),
                      child: const Text('Restore Existing'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      height: 50,
                      color: themeColor,
                      onPressed: () => _createNew(this.context),
                      child: const Text('Create Company'),
                    ),
                  ),
                ],
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
