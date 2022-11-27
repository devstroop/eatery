import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery_components/titles/page.title.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:eatery_components/buttons/primary.button.dart';

class Body5 extends StatefulWidget {
  final Color themeColor;
  Currency? currency;
  final Function(Currency? currency) callback;

  Body5({Key? key, required this.themeColor, this.currency, required this.callback}) : super(key: key);

  @override
  State<Body5> createState() => _Body5State();
}

class _Body5State extends State<Body5> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const PageTitle(
            title: "Region and Currency",
            subtitle: "Select the default currency as per region",
          ),
          SpacingStyle.defaultVerticalSpacing,
          SpacingStyle.defaultVerticalSpacing,
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: ColorStyle.brandColor,
                  width: 2,
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: widget.currency != null
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                CurrencyUtils.currencyToEmoji(widget.currency!),
                                style: const TextStyle(
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          )
                        : null,
                    trailing: widget.currency != null
                        ? Text(widget.currency!.symbol,
                            style: const TextStyle(
                              fontSize: 18,
                            ))
                        : null,
                    title: Text(widget.currency != null ? widget.currency!.code : 'Not Selected'),
                    subtitle: widget.currency != null ? Text(widget.currency!.name) : null,
                  )
                ],
              ),
            ),
            onTap: () => showCurrencyPicker(
              context: context,
              showSearchField: false,
              showFlag: true,
              showCurrencyName: true,
              showCurrencyCode: true,
              currencyFilter: <String>['INR', 'AED'],
              onSelect: (Currency currency) {
                setState(() {
                  widget.currency = currency;
                });
                widget.callback(currency);
              },
            ),
          ),
        ],
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();

class BAP5 extends StatelessWidget {
  final Color themeColor;
  final Function(int? index)? callback;
  final int? index;

  const BAP5({Key? key, required this.themeColor, this.callback, this.index}) : super(key: key);

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
            child: const Text('Next'),
            color: themeColor,
            onPressed: _submit),
      ),
    );
  }
}
