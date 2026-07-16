import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_spacing.dart';

class Body3 extends StatelessWidget {
  final Function(Taxation taxation) callback;
  final Color themeColor;
  final Taxation taxation;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  const Body3({
    super.key,
    required this.themeColor,
    required this.callback,
    required this.taxation,
    required this.formKey,
    this.callbackFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const PageTitle(
              title: "Taxation",
              subtitle: "Choose a taxation system",
            ),
            AppSpacing.gapMd,
            AppSpacing.gapMd,
            AppSelectCard(
              header: "Taxation",
              title: Taxation.none.name,
              footer: Taxation.none.description,
              value: Taxation.none,
              groupValue: taxation,
              onChanged: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(v);
              },
            ),
            AppSpacing.gapMd,
            AppSelectCard(
              header: "Taxation",
              title: Taxation.gst.name,
              footer: Taxation.gst.description,
              value: Taxation.gst,
              groupValue: taxation,
              onChanged: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(v);
              },
            ),
            AppSpacing.gapMd,
            AppSelectCard(
              header: "Taxation",
              title: Taxation.vat.name,
              footer: Taxation.vat.description,
              value: Taxation.vat,
              groupValue: taxation,
              onChanged: (v) {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(v);
              },
            ),
          ],
        ),
      ),
    );
  }
}
