import 'package:eatery/references.dart';

class Body3 extends StatelessWidget {
  final Function(Edition edition) callback;
  final Color themeColor;
  final Edition edition;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  const Body3(
      {Key? key,
      required this.themeColor,
      required this.callback,
      required this.edition,
      required this.formKey,
      this.callbackFormKey})
      : super(key: key);

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
              title: "Edition",
              subtitle: "Choose a suitable edition",
            ),
            SpacingStyle.defaultVerticalSpacing,
            SpacingStyle.defaultVerticalSpacing,
            SelectableCard(
              header: "Edition",
              title: Edition.gst.name,
              footer: Edition.gst.description,
              selected: edition == Edition.gst,
              onTap: () {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(Edition.gst);
              },
            ),
            SpacingStyle.defaultVerticalSpacing,
            SelectableCard(
              header: "Edition",
              title: Edition.vat.name,
              footer: Edition.vat.description,
              selected: edition == Edition.vat,
              onTap: () {
                if (callbackFormKey != null) callbackFormKey!(formKey);
                callback(Edition.vat);
              },
            ),
          ],
        ),
      ),
    );
  }
}
