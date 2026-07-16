import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/dev/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _loading = false;

  Future<void> _loadDemo() async {
    setState(() => _loading = true);
    try {
      final store = ref.read(eateryStoreProvider);
      await SeedData.load(store);
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Demo loaded! Log in with PIN 1234')),
        );
        GoRouter.of(this.context).goNamed('login');
      }
    } catch (e) {
      if (mounted) {
        AppDialog.showMessage(
          this.context,
          message: 'Failed to load demo: $e',
          type: MessageType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(top: 12),
          child: Image.asset('assets/logo.png', height: 48),
        ),
      ),
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: isDesktop
              ? _buildDesktop(screenWidth)
              : _buildMobile(screenWidth),
        ),
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomBar(),
    );
  }

  Widget _buildDesktop(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome to', style: AppTypography.headlineLarge),
                Text(
                  'Eatery',
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapMd,
                Text(
                  'Free & open restaurant POS system.\n'
                  'Works offline, syncs locally.\n'
                  'No monthly fees, no cloud dependency.',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
                AppSpacing.gapLg,
                Row(
                  children: [
                    AppButton.primary(
                      label: 'Set up my restaurant',
                      height: 52,
                      width: 200,
                      onPressed: () =>
                          GoRouter.of(this.context).pushNamed('setup'),
                    ),
                    AppSpacing.gapMd,
                    AppButton.destructive(
                      label: _loading ? 'Loading...' : 'Try Demo',
                      height: 52,
                      width: 160,
                      onPressed: _loading ? null : _loadDemo,
                    ),
                  ],
                ),
                AppSpacing.gapMd,
                TextButton.icon(
                  icon: const Icon(Icons.restore, size: 18),
                  label: const Text('Restore from backup'),
                  onPressed: () =>
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Restore coming soon')),
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Lottie.asset('assets/lottie/brand.json'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to', style: AppTypography.headlineMedium),
          Text(
            'Eatery',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapMd,
          Text(
            'Free & open restaurant POS.\nOffline-first, locally synced.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
          ),
          AppSpacing.gapLg,
          SizedBox(
            height: 180,
            width: 180,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Lottie.asset('assets/lottie/brand.json'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: AppColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: AppButton.primary(
                  label: 'Set up',
                  height: 50,
                  onPressed: () => GoRouter.of(this.context).pushNamed('setup'),
                ),
              ),
              AppSpacing.gapMd,
              Expanded(
                child: AppButton.destructive(
                  label: _loading ? '...' : 'Demo',
                  height: 50,
                  onPressed: _loading ? null : _loadDemo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
