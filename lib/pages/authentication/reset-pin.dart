import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/extensions/string_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResetPinScreen extends ConsumerStatefulWidget {
  const ResetPinScreen({super.key});

  @override
  ConsumerState<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends ConsumerState<ResetPinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _showPinForm = false;

  @override
  void dispose() {
    _loginIdController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _lookupEmployee() {
    final loginId = _loginIdController.text.trim();
    if (loginId.isEmpty) return;

    final store = ref.read(eateryStoreProvider);
    var employee = _findByPhone(store, loginId);
    employee ??= _findByName(store, loginId);

    if (employee == null) {
      AppDialog.showMessage(
        this.context,
        message: 'No employee found with that ID or phone',
        type: MessageType.error,
      );
      return;
    }

    setState(() => _showPinForm = true);
  }

  void _savePin() {
    if (!_formKey.currentState!.validate()) return;

    final loginId = _loginIdController.text.trim();
    final newPin = _newPinController.text.trim();
    final store = ref.read(eateryStoreProvider);

    store.execute(
      'UPDATE employee SET pin = ? WHERE phone = ? OR lower(trim(name)) = ?',
      [newPin, loginId, loginId.toLowerCase().trim()],
    );

    AppDialog.showMessage(
      this.context,
      message: 'PIN updated successfully',
      type: MessageType.success,
    );
    GoRouter.of(this.context).goNamed('login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        title: const Text('Reset PIN'),
        backgroundColor: AppColors.grey200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_showPinForm) ...[
                Text(
                  'Identify your account',
                  style: AppTypography.headlineSmall,
                ),
                AppSpacing.gapSm,
                Text(
                  'Enter your employee ID or phone number.',
                  style: AppTypography.bodyMedium,
                ),
                AppSpacing.gapXl,
                CustomTextFromField(
                  controller: _loginIdController,
                  label: 'Employee ID or Phone',
                  hint: 'Enter phone or name...',
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                AppSpacing.gapXl,
                AppButton.primary(
                  label: 'Continue',
                  onPressed: _lookupEmployee,
                ),
              ],
              if (_showPinForm) ...[
                Text('Set new PIN', style: AppTypography.headlineSmall),
                AppSpacing.gapSm,
                Text(
                  'Choose a new 4-digit PIN.',
                  style: AppTypography.bodyMedium,
                ),
                AppSpacing.gapXl,
                CustomTextFromField(
                  controller: _newPinController,
                  label: 'New PIN',
                  hint: 'Enter new PIN...',
                  obscureText: true,
                  isPassword: true,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!v.trim().isNumericOnly) return 'Numbers only';
                    if (v.trim().length < 4) return 'Minimum 4 digits';
                    return null;
                  },
                ),
                AppSpacing.gapMd,
                CustomTextFromField(
                  controller: _confirmPinController,
                  label: 'Confirm PIN',
                  hint: 'Re-enter new PIN...',
                  obscureText: true,
                  isPassword: true,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v != _newPinController.text) return 'PINs do not match';
                    return null;
                  },
                ),
                AppSpacing.gapXl,
                AppButton.primary(label: 'Reset PIN', onPressed: _savePin),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Employee? _findByPhone(EateryStore store, String phone) {
    final rows = store.query('SELECT * FROM employee WHERE phone = ? LIMIT 1', [
      phone,
    ]);
    return rows.isEmpty ? null : Employee.fromMap(rows.first);
  }

  Employee? _findByName(EateryStore store, String name) {
    final rows = store.query(
      'SELECT * FROM employee WHERE lower(trim(name)) = ? LIMIT 1',
      [name.toLowerCase().trim()],
    );
    return rows.isEmpty ? null : Employee.fromMap(rows.first);
  }
}
