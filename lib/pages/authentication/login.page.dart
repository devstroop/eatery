import 'package:eatery_core/widgets/widgets.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery_core/extensions/string_ext.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/auth_session.dart';
import 'package:eatery_core/providers/role_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/providers/database_provider.dart';

import 'package:eatery_core/widgets/app_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        company = ref.read(companyRepositoryProvider).getCurrentCompany();
      });
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final store = ref.read(eateryStoreProvider);
    final staff = authenticateStaff(
      store,
      _controllerLoginId.text.trim(),
      _controllerPin.text.trim(),
    );

    if (staff != null) {
      ref.read(authSessionProvider.notifier).state = staff;
      // Sync device role to match the logged-in staff type so RBAC
      // permissions align with what the user is allowed to do.
      final roleNotifier = ref.read(roleProvider.notifier);
      switch (staff.type) {
        case StaffType.admin:
          roleNotifier.setRole('admin');
        case StaffType.waiter:
          roleNotifier.setRole('waiter');
        case StaffType.chef:
          roleNotifier.setRole('kds');
        default:
          roleNotifier.setRole('admin');
      }
      // Navigate to the role-appropriate home.
      final ctx = context as BuildContext;
      switch (staff.type) {
        case StaffType.admin:
          GoRouter.of(ctx).goNamed('dashboard');
        case StaffType.waiter:
          GoRouter.of(ctx).goNamed('tables');
        case StaffType.chef:
          GoRouter.of(ctx).goNamed('kds');
        default:
          GoRouter.of(ctx).goNamed('dashboard');
      }
    } else {
      AppDialog.showMessage(
        this.context,
        message: 'Invalid credentials',
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        backgroundColor: AppColors.grey200,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/logo.png', height: 36),
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
                    onConfirm: () {
                      ref.read(appDatabaseProvider).deleteAll();
                      GoRouter.of(context).goNamed('mainScreen');
                    },
                  );
                }
              });
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = Responsive.isDesktop(context);
          return InkWell(
            onTap: () => FocusScope.of(context).unfocus(),
            child: isDesktop
                ? Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(12),
                        children: _buildBody(),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: _buildBody(),
                  ),
          );
        },
      ),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: AppButton.primary(
          label: 'Login',
          onPressed: _submit,
          height: 50,
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    return [
      if (company == null)
        const LinearProgressIndicator(
          backgroundColor: AppColors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF74B952)),
        ),
      if (company != null)
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
                      label: 'Staff ID or Phone',
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
                        FocusScope.of(this.context).unfocus();
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
