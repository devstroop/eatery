import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/extensions/string_ext.dart';
import 'package:eatery_core/data/repositories/company_repository_sqlite.dart';
import 'package:eatery_core/data/repositories/employee_repository_sqlite.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _restaurantNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    _confirmCtrl.dispose();
    _restaurantNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final store = ref.read(eateryStoreProvider);

      // Hash the PIN
      final hashedPin = hashPin(_pinCtrl.text.trim());

      // Create admin employee via repository
      final employeeRepo = SqliteEmployeeRepository(store: store);
      final employee = Employee(
        name: _nameCtrl.text.trim(),
        type: EmployeeRole.admin,
        pin: hashedPin,
        isActive: true,
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      );
      final employeeId = await employeeRepo.saveEmployee(employee);

      // Create company via repository
      final companyRepo = SqliteCompanyRepository(store: store);
      final company = Company(
        name: _restaurantNameCtrl.text.trim().isEmpty
            ? 'My Restaurant'
            : _restaurantNameCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? '' : _emailCtrl.text.trim(),
        phone: '',
        address: '',
        taxation: Taxation.none,
        createdAt: DateTime.now(),
        adminEmployeeId: employeeId,
      );
      await companyRepo.saveCompany(company);

      // Show success animation before navigating
      if (mounted) {
        setState(() => _showSuccess = true);
        await Future.delayed(const Duration(seconds: 2));
      }
      if (mounted) {
        GoRouter.of(context).goNamed('login');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _showSuccess = false);
        AppDialog.showMessage(
          context,
          message: 'Setup failed: $e',
          type: MessageType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Success animation overlay
    if (_showSuccess) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Lottie.asset(
                    'assets/lottie/hurray.json',
                    repeat: false,
                  ),
                ),
              ),
              AppSpacing.gapLg,
              Text(
                'All set!',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.grey900,
                ),
              ),
              AppSpacing.gapSm,
              Text(
                'Redirecting to login...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppPageShell(
      title: 'Set up your restaurant',
      backgroundColor: AppColors.grey200,
      showBack: false,
      contentMaxWidth: 480,
      actions: [
        TextButton(
          onPressed: () => GoRouter.of(context).goNamed('rolePicker'),
          child: const Text('Change role'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('Just the essentials', style: AppTypography.headlineSmall),
              AppSpacing.gapSm,
              Text(
                'You can configure everything else later from the dashboard.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              AppSpacing.gapXxl,
              CustomTextFromField(
                controller: _restaurantNameCtrl,
                label: 'Restaurant name',
                hint: 'e.g. My Restaurant',
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              AppSpacing.gapLg,
              CustomTextFromField(
                controller: _nameCtrl,
                label: 'Your name',
                hint: 'e.g. Rajesh',
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              AppSpacing.gapLg,
              CustomTextFromField(
                controller: _emailCtrl,
                label: 'Email (optional)',
                hint: 'e.g. hello@myrestaurant.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              AppSpacing.gapLg,
              CustomTextFromField(
                controller: _pinCtrl,
                label: 'Create a PIN (4 digits)',
                hint: 'Enter PIN...',
                obscureText: true,
                isPassword: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!v.trim().isNumericOnly) return 'Numbers only';
                  if (v.trim().length < 4) return 'Minimum 4 digits';
                  return null;
                },
              ),
              AppSpacing.gapLg,
              CustomTextFromField(
                controller: _confirmCtrl,
                label: 'Confirm PIN',
                hint: 'Re-enter PIN...',
                obscureText: true,
                isPassword: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    v != _pinCtrl.text ? 'PINs do not match' : null,
              ),
              AppSpacing.gapXl,
              AppButton.primary(
                label: _loading ? 'Setting up...' : 'Set up My Restaurant',
                height: 50,
                onPressed: _loading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
