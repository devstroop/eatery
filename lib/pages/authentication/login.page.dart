import 'package:eatery/pages/authentication/reset-pin.dart';
import 'package:get/get.dart';
import 'package:eatery/references.dart';

import '../main.screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerPassword = TextEditingController();
  Company? company;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        company = EateryDB.instance.companyBox!.values.firstOrNull;
      });
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (_controllerPassword.text == company!.password) {
      setState(() {
        Common.company = company;
        Common.currency = EateryDB.instance.currencyBox!.values
            .where((element) => element.code == Common.company?.currencyCode)
            .firstOrNull;
        Common.activeOrderType = null;
        Common.activeDiningTable = null;
        Common.activeCustomer = null;
      });
      Navigator.pushAndRemoveUntil(
        this.context,
        MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showMessageDialog(this.context, 'Invalid secure pin', MessageType.error);
    }
  }

  Color themeColor = KColors.secondary2;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/logo.png',
          height: 36,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: KColors.black600,
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'reset',
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_reset,
                          color: KColors.black600,
                        ),
                        const SizedBox(width: 8,),
                        Text(
                          'Reset PIN',
                          style: TextStyle(
                            color: KColors.black600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: KColors.red,
                        ),
                        const SizedBox(width: 8,),
                        Text(
                          'Delete Company',
                          style: TextStyle(
                            color: KColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).then((value) {
                if (value == 'reset') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPinScreen(),
                    ),
                  );
                } else if (value == 'delete') {

                  // ask for confirmation
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete ${company?.name}'),
                      content: Text('Are you sure you want to delete ${company?.name} and its data?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            EateryDB.instance.flush();
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                }

                /*if (value == 'settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                } else if (value == 'backup_restore') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BackupRestorePage(),
                    ),
                  );
                }*/
              });
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupRestorePage(),
                ),
              );*/
            },
          )
        ],
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            if (company == null)
              LinearProgressIndicator(
                backgroundColor: KColors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  KColors.secondary2,
                ),
              ),
            if (company != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SpacingStyle.defaultVerticalSpacing,
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
                        const SizedBox(
                          height: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              company!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              company!.address,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SpacingStyle.defaultVerticalSpacing,
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFromField(
                            themeColor: themeColor,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            controller: _controllerPassword,
                            obscureText: true,
                            isPassword: true,
                            label: 'Secure PIN',
                            hint: 'Enter secure pin...',
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).unfocus();
                              _submit();
                            },
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Pin cannot be blank';
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
                    /*SpacingStyle.defaultVerticalSpacing,
                    TextButton(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: KColors.black600),
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        builder: (context) =>
                            EateryDB.instance.subscriptionBox!.values
                                        .singleWhere(
                                          (element) =>
                                              element.id ==
                                              company!.subscriptionId!,
                                        )
                                        .purchaseCode !=
                                    null
                                ? ForgotPasswordBottomSheet(
                                    context,
                                    themeColor: themeColor,
                                    callback: (Company? company) {
                                      setState(() {
                                        this.company = company;
                                      });
                                    },
                                  )
                                : UpgradeToAccessBottomSheet(
                                    context,
                                    themeColor: themeColor,
                                    callback: (Company? company) {
                                      setState(() {
                                        this.company = company;
                                      });
                                    },
                                  ),
                      ),
                    )*/
                  ],
                ),
              ), // Placeholder to add space for the bottom app bar
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      // Enable auto resize to avoid the keyboard
      bottomNavigationBar: BottomAppBar(
        color: KColors.white,
        child: PrimaryButton(
          height: 50,
          color: themeColor,
          onPressed: _submit,
          child: const Text('Login'),
        ),
      ),
    );
  }
}
