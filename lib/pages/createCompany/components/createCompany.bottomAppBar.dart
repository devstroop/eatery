import 'package:eatery/references.dart';

class CreateCompanyBottomAppBar extends StatelessWidget {
  final Color themeColor;
  final Function(int? index)? callback;
  final int? index;
  final String title;
  final GlobalKey<FormState> formKey;

  const CreateCompanyBottomAppBar(
      {Key? key,
      required this.themeColor,
      this.callback,
      this.index,
      required this.title,
      required this.formKey})
      : super(key: key);

  void _submit() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    if (callback != null) {
      callback!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: KColors.white,
      child: PrimaryButton(
          color: themeColor, onPressed: _submit, child: Text(title)),
    );
  }
}
