import 'package:eatery_core/widgets/widgets.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery/pages/authentication/reset-pin.dart';
import 'package:eatery_core/extensions/string_ext.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/providers/database_provider.dart';

import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:go_router/go_router.dart';
import '../main.screen.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _controllerPassword = TextEditingController();
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
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (company!.password == null || _controllerPassword.text == company!.password) {
      ref.read(companyProvider.notifier).setCompany(company);
      GoRouter.of(context as BuildContext).goNamed('dashboard');
    } else {
      AppDialog.showMessage(this.context, message: 'Invalid secure pin', type: MessageType.error);
    }
  }

  Color themeColor = AppColors.secondary2;
  final _formKey = GlobalKey<FormState>();

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
                        const SizedBox(width: 8),
                        Text(
                          'Reset PIN',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppColors.error),
                        const SizedBox(width: 8),
                        Text(
                          'Delete Company',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
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
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupRestorePage(),
                ),
              );*/
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
              const SizedBox(height: 12),
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
                  const SizedBox(height: 8),
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
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFromField(
                      themeColor: themeColor,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      controller: _controllerPassword,
                      obscureText: true,
                      isPassword: true,
                      label: 'Secure PIN',
                      hint: 'Enter secure pin...',
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (v) {
                        FocusScope.of(this.context).unfocus();
                        _submit();
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) return 'Pin cannot be blank';
                        if (!value.trim().isNumericOnly)
                          return 'Invalid character';
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
