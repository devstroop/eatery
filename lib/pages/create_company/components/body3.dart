import 'package:eatery/components/selectable_card.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_components/titles/page.title.dart';
import 'package:eatery_db/models/company/edition.dart';
import 'package:flutter/material.dart';

class Body3 extends StatelessWidget {
  final Function(Edition edition) callback;
  final Color themeColor;
  final Edition edition;
  Body3(
      {Key? key,
      required this.themeColor,
      required this.callback,
      required this.edition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
              callback(Edition.vat);
            },
          ),
        ],
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();

class BAP3 extends StatelessWidget {
  final Color themeColor;
  final Function(int? index)? callback;
  final int? index;
  const BAP3({Key? key, required this.themeColor, this.callback, this.index})
      : super(key: key);

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (callback != null) {
      callback!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ColorStyle.backgroundColorAlter,
      child: Padding(
        padding: SpacingStyle.defaultPadding,
        child: PrimaryButton(
            child: const Text('Next'), color: themeColor, onPressed: _submit),
      ),
    );
  }
}
