import 'package:eatery_core/extensions/string_ext.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';

class ForgotPasswordBottomSheet extends ConsumerStatefulWidget {
  final Color themeColor;
  final Function(Company? company) callback;
  const ForgotPasswordBottomSheet({
    super.key,
    required this.themeColor,
    required this.callback,
  });

  @override
  ConsumerState<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState
    extends ConsumerState<ForgotPasswordBottomSheet> {
  Company? company;
  bool verified = false;
  final TextEditingController _controllerPurchaseCode = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (company != null) {
      /*company!.password = _controllerPassword.text;
      await widget.database.companyDao.updateEntity(company!);
      showSnackBar(context, "Password changed successfully");
      widget.callback(company);
      Navigator.pop(context);*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Center(child: AppBottomSheetGrip()),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot password?',
                          style: AppTypography.headlineSmall,
                        ),
                        Text(
                          'Reset and get the access back',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpacing.gapLg,
                if (!verified)
                  CustomTextFromField(
                    themeColor: widget.themeColor,
                    controller: _controllerPurchaseCode,
                    label: 'Purchase code',
                    hint: 'Enter purchase code...',
                    autoFocus: true,
                    textInputAction: TextInputAction.done,
                    suffix: IconButton(
                      onPressed: () async {
                        String val = await FlutterClipboard.paste();
                        setState(() {
                          _controllerPurchaseCode.text = val;
                        });
                      },
                      icon: const Icon(Icons.paste),
                      color: AppColors.white600,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Purchase code cannot be blank';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final sub = ref
                          .read(subscriptionRepositoryProvider)
                          .getFirst();
                      if (sub != null && value == sub.purchaseCode) {
                        setState(() {
                          verified = true;
                        });
                      } else {
                        setState(() {
                          verified = false;
                        });
                      }
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                if (verified)
                  CustomTextFromField(
                    themeColor: widget.themeColor,
                    keyboardType: TextInputType.number,
                    controller: _controllerPassword,
                    obscureText: true,
                    isPassword: true,
                    label: 'Secure PIN',
                    hint: 'Enter secure pin...',
                    focusNode: focus1,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus2);
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) return 'Pin cannot be blank';
                      if (!value.trim().isNumericOnly) {
                        return 'Invalid character';
                      }
                      if (value.trim().length < 4) return 'Less secured pin';
                      return null;
                    },
                  ),
                if (verified) AppSpacing.gapMd,
                if (verified)
                  CustomTextFromField(
                    themeColor: widget.themeColor,
                    keyboardType: TextInputType.number,
                    controller: _controllerConfirmPassword,
                    obscureText: true,
                    isPassword: true,
                    label: 'Confirm Secure PIN',
                    hint: 'Confirm secure pin...',
                    focusNode: focus2,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (!value!.trim().isNumericOnly) {
                        return 'Invalid character';
                      }
                      if (value.trim().isEmpty ||
                          _controllerPassword.text != value) {
                        return "Confirm pin didn't match";
                      }
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                if (verified) AppSpacing.gapMd,
                if (verified)
                  Row(
                    children: [
                      AppButton.primary(onPressed: _submit, label: 'Reset'),
                    ],
                  ),
                AppSpacing.gapXl,
              ],
            ),
          ),
        );
      },
    );
  }
}
