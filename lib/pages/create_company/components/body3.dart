import 'package:eatery/references.dart';

class Body3 extends StatelessWidget {
  final Function(Taxation taxation) callback;
  final Color themeColor;
  final Taxation taxation;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  const Body3({
    Key? key,
    required this.themeColor,
    required this.callback,
    required this.taxation,
    required this.formKey,
    this.callbackFormKey,
  }) : super(key: key);

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
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            SelectableCard(
              header: "Taxation",
              title: Taxation.none.name,
              footer: Taxation.none.description,
              selected: taxation == Taxation.none,
              onTap: () {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(Taxation.none);
              },
            ),
            SpacingStyle.defaultVerticalSpacing,
            SelectableCard(
              header: "Taxation",
              title: Taxation.gst.name,
              footer: Taxation.gst.description,
              selected: taxation == Taxation.gst,
              onTap: () {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(Taxation.gst);
              },
            ),
            SpacingStyle.defaultVerticalSpacing,
            SelectableCard(
              header: "Taxation",
              title: Taxation.vat.name,
              footer: Taxation.vat.description,
              selected: taxation == Taxation.vat,
              onTap: () {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(Taxation.vat);
              },
            ),
          ],
        ),
      ),
    );
  }
}
