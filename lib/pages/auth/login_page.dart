import 'dart:io';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery/pages/backup_restore/backup_restore_page.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:eatery_services/eatery_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/pages/dashboard/dashboard_page.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/components/bottomsheets/forgot_password_bottomsheet.dart';
import 'package:eatery/components/bottomsheets/upgrade_to_access_bottomsheet.dart';
import 'package:eatery/components/loaders/loading_screen.dart';
import 'package:uicons/uicons.dart';

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
    company = EateryDB().companyBox().values.single;
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (_controllerPassword.text == company!.password) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            company: company!,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showSnackBar(context, "Invalid credentials");
    }
  }

  Color themeColor = ColorStyle.brandColor;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColorAlter,
      appBar: AppBar(
        backgroundColor: ColorStyle.backgroundColorAlter,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/logo.png',
          height: 36,
        ),
        actions: [
          IconButton(
            icon: Icon(
              UIcons.regularStraight.time_past,
              color: ColorStyle.text200,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupRestorePage(),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView here
        child: Column(
          // Added Column here
          children: [
            company != null
                ? InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Padding(
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
                              FutureBuilder<String>(
                                  future: FileServices.absImage(
                                      company!.logo ?? ''),
                                  builder: (context, snapshot) {
                                    return Container(
                                      height: 96,
                                      width: 96,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(48),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: snapshot.hasData &&
                                                  company!.logo != null &&
                                                  File(snapshot.data!)
                                                      .existsSync()
                                              ? Image.file(
                                                  File(snapshot.data!),
                                                ).image
                                              : Image.asset(
                                                      'assets/images/default.jpg')
                                                  .image,
                                        ),
                                      ),
                                    );
                                  }),
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
                                      fontSize: 20,
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: false, signed: false),
                                  controller: _controllerPassword,
                                  obscureText: true,
                                  isPassword: true,
                                  title: 'Secure PIN',
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
                          SpacingStyle.defaultVerticalSpacing,
                          TextButton(
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(color: ColorStyle.text200),
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
                              builder: (context) => EateryDB()
                                          .subscriptionBox()
                                          .values
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
                          )
                        ],
                      ),
                    ),
                  )
                : LoadingScreen(),
            const SizedBox(
                height: 80), // Placeholder to add space for the bottom app bar
          ],
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Enable auto resize to avoid the keyboard
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
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
