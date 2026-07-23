import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/extensions/string_ext.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/auth_session.dart';
import 'package:eatery_core/providers/role_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/providers/database_provider.dart';

import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _controllerLoginId = TextEditingController();
  final TextEditingController _controllerPin = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color themeColor = AppColors.secondary2;
  Company? company;
  bool _loaded = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      setState(() {
        company = ref.read(companyRepositoryProvider).getCurrentCompany();
        _loaded = true;
      });
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final store = ref.read(eateryStoreProvider);
    final employee = authenticateEmployee(
      store,
      _controllerLoginId.text.trim(),
      _controllerPin.text.trim(),
    );

    if (employee != null) {
      ref.read(authSessionProvider.notifier).state = employee;
      // Sync device role to match the logged-in employee type so RBAC
      // permissions align with what the user is allowed to do.
      final roleNotifier = ref.read(roleProvider.notifier);
      switch (employee.type) {
        case EmployeeRole.admin:
          roleNotifier.setRole('admin');
        case EmployeeRole.waiter:
          roleNotifier.setRole('waiter');
        case EmployeeRole.chef:
          roleNotifier.setRole('kds');
        default:
          roleNotifier.setRole('admin');
      }
      // Navigate to the role-appropriate home.
      switch (employee.type) {
        case EmployeeRole.admin:
          GoRouter.of(context).goNamed('dashboard');
        case EmployeeRole.waiter:
          GoRouter.of(context).goNamed('tables');
        case EmployeeRole.chef:
          GoRouter.of(context).goNamed('kds');
        default:
          GoRouter.of(context).goNamed('dashboard');
      }
    } else {
      AppDialog.showMessage(
        context,
        message: 'Invalid credentials',
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: '',
      titleWidget: Image.asset('assets/logo.png', height: 30),
      color: AppColors.grey200,
      showBack: false,
      contentMaxWidth: 480,
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: AppColors.grey700),
          onPressed: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 100, 0, 0),
              items: [
                PopupMenuItem(
                  value: 'reset',
                  child: Row(
                    children: [
                      Icon(Icons.lock_reset, color: AppColors.grey700),
                      AppSpacing.gapSm,
                      Text(
                        'Reset PIN',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppColors.error),
                      AppSpacing.gapSm,
                      Text(
                        'Delete Company',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).then((value) {
              if (value == 'reset') {
                GoRouter.of(context).pushNamed('resetPin');
              } else if (value == 'delete') {
                AppDialog.show(
                  context,
                  title: 'Delete ${company?.name}',
                  content:
                      'Are you sure you want to delete ${company?.name} and its data?',
                  confirmLabel: 'Delete',
                  cancelLabel: 'Cancel',
                  destructive: true,
                  onConfirm: () async {
                    if (_deleting) return;
                    _deleting = true;
                    try {
                      await ref.read(appDatabaseProvider).deleteAll();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Company data deleted')),
                        );
                        GoRouter.of(context).goNamed('mainScreen');
                      }
                    } catch (_) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete company data'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    } finally {
                      _deleting = false;
                    }
                  },
                );
              }
            });
          },
        ),
      ],
      bottomAction: company != null
          ? AppButton.primary(label: 'Login', onPressed: _submit, height: 50)
          : null,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: _buildBody(),
      ),
    );
  }

  List<Widget> _buildBody() {
    // Still loading — show skeleton.
    if (!_loaded) {
      return [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppSpacing.gapMd,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSkeleton(width: 120, height: 120, borderRadius: 24),
                  AppSpacing.gapSm,
                  AppSkeleton.line(width: 180, height: 22),
                  AppSpacing.gapXs,
                  AppSkeleton.line(width: 240, height: 16),
                ],
              ),
              AppSpacing.gapMd,
              AppSkeleton(width: double.infinity, height: 56, borderRadius: 8),
              AppSpacing.gapSm,
              AppSkeleton(width: double.infinity, height: 56, borderRadius: 8),
            ],
          ),
        ),
      ];
    }

    // No company — show onboarding prompt.
    if (company == null) {
      return [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppSpacing.gapXxl,
              Text('Eatery', style: AppTypography.headlineLarge),
              AppSpacing.gapSm,
              Text(
                'Not set up yet.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapLg,
              AppButton.primary(
                label: 'Set up',
                onPressed: () {
                  if (mounted) GoRouter.of(context).goNamed('setup');
                },
                height: 50,
              ),
              AppSpacing.gapMd,
              TextButton(
                onPressed: () {
                  if (mounted) GoRouter.of(context).goNamed('mainScreen');
                },
                child: const Text('Try Demo'),
              ),
            ],
          ),
        ),
      ];
    }

    // Company loaded — show login form.
    return [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Subtle brand animation
            SizedBox(
              height: 80,
              width: 80,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Lottie.asset('assets/lottie/brand.json'),
              ),
            ),
            AppSpacing.gapMd,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: LibraryImage(company?.logo ?? '').image,
                    ),
                  ),
                ),
                AppSpacing.gapSm,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(company!.name, style: AppTypography.headlineSmall),
                    Text(
                      company!.address,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AppSpacing.gapMd,
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFromField(
                    themeColor: themeColor,
                    controller: _controllerLoginId,
                    label: 'Employee ID or Phone',
                    hint: 'Enter phone or name...',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapSm,
                  CustomTextFromField(
                    themeColor: themeColor,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    controller: _controllerPin,
                    obscureText: true,
                    isPassword: true,
                    label: 'PIN',
                    hint: 'Enter your PIN...',
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).unfocus();
                      _submit();
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'PIN cannot be blank';
                      }
                      if (!value.trim().isNumericOnly) {
                        return 'Invalid character';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
