import 'package:eatery/references.dart';

class Body3 extends StatelessWidget {
  final Function(TaxEditionType edition) callback;
  final Color themeColor;
  final TaxEditionType edition;
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
            title: TaxEditionType.gst.name,
            footer: 'TaxEditionType.gst.description',
            selected: edition == TaxEditionType.gst,
            onTap: () {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              callback(TaxEditionType.gst);
            },
          ),
          SpacingStyle.defaultVerticalSpacing,
          SelectableCard(
            header: "Edition",
            title: TaxEditionType.vat.name,
            footer: 'TaxEditionType.vat.description',
            selected: edition == TaxEditionType.vat,
            onTap: () {
              if (callbackFormKey != null) callbackFormKey!(formKey);
              callback(TaxEditionType.vat);
            },
          ),
        ],
      ),
    );
  }
}
