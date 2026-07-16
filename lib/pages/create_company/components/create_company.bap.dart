import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

class CreateCompanyBottomAppBar extends StatelessWidget {
  final Color themeColor;
  final Function(int? index)? callback;
  final int? index;
  final String title;
  final GlobalKey<FormState> formKey;

  const CreateCompanyBottomAppBar({
    super.key,
    required this.themeColor,
    this.callback,
    this.index,
    required this.title,
    required this.formKey,
  });

  void _submit() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    formKey.currentState!.save();
    callback?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Responsive.isDesktop(context)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: AppButton.primary(
                      label: title,
                      onPressed: _submit,
                      height: 50,
                    ),
                  ),
                ],
              )
            : AppButton.primary(label: title, onPressed: _submit, height: 50),
      ),
    );
  }
}
