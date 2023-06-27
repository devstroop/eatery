import 'package:get/get.dart';
import 'package:eatery/references.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  final BuildContext context;
  final Color themeColor;
  final Function(Company? company) callback;
  const ForgotPasswordBottomSheet(this.context,
      {Key? key, required this.themeColor, required this.callback})
      : super(key: key);

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
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
    return StatefulBuilder(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(
                child: BottomViewGrip(),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Reset and get the access back',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              if (!verified)
                CustomTextFromField(
                  themeColor: widget.themeColor,
                  controller: _controllerPurchaseCode,
                  title: 'Purchase code',
                  hint: 'Enter purchase code...',
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  suffix: IconButton(
                    onPressed: () async {
                      String val = await FlutterClipboard.paste();
                      setState(() {
                        _controllerPurchaseCode.text = val;
                      });
                    },
                    icon: const Icon(Icons.paste),
                    color: ColorStyle.text400,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Purchase code cannot be blank';
                    return null;
                  },
                  onChanged: (value) {
                    var temp = EateryDB.instance.subscriptionBox.values
                        .singleWhere((element) =>
                            element.id == company!.subscriptionId!);
                    if (value == temp.purchaseCode) {
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
                  title: 'Secure PIN',
                  hint: 'Enter secure pin...',
                  focusNode: focus1,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus2);
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) return 'Pin cannot be blank';
                    if (!value.trim().isNumericOnly) return 'Invalid character';
                    if (value.trim().length < 4) return 'Less secured pin';
                    return null;
                  },
                ),
              if (verified) SpacingStyle.defaultVerticalSpacing,
              if (verified)
                CustomTextFromField(
                  themeColor: widget.themeColor,
                  keyboardType: TextInputType.number,
                  controller: _controllerConfirmPassword,
                  obscureText: true,
                  isPassword: true,
                  title: 'Confirm Secure PIN',
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
              if (verified) SpacingStyle.defaultVerticalSpacing,
              if (verified)
                Row(
                  children: [
                    PrimaryButton(
                      color: widget.themeColor,
                      onPressed: _submit,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      );
    });
  }
}
