import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/extensions/string_ext.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final store = ref.read(eateryStoreProvider);

      // Create admin employee
      final hashedPin = hashPin(_pinCtrl.text.trim());
      store.execute(
        'INSERT INTO employee (name, pin, type, isActive) VALUES (?,?,?,?)',
        [_nameCtrl.text.trim(), hashedPin, 4, 1],
      );
      final employeeId = store.queryScalar('SELECT last_insert_rowid()') as int;

      // Create company with default values
      store.execute(
        'INSERT INTO company (name, taxation, adminEmployeeId) VALUES (?,?,?)',
        ['My Restaurant', -1, employeeId],
      );

      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(
            content: Text('Restaurant set up! Log in with your PIN'),
          ),
        );
        GoRouter.of(this.context).goNamed('login');
      }
    } catch (e) {
      if (mounted) {
        AppDialog.showMessage(
          this.context,
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
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        title: const Text('Set up your restaurant'),
        backgroundColor: AppColors.grey200,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Just the essentials',
                    style: AppTypography.headlineSmall,
                  ),
                  AppSpacing.gapSm,
                  Text(
                    'You can configure everything else later from the dashboard.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  AppSpacing.gapXxl,
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
                    label: _loading ? 'Setting up...' : 'Complete Setup',
                    height: 50,
                    onPressed: _loading ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
