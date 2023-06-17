import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery_components/titles/page.title.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

class Body5 extends StatefulWidget {
  final Color themeColor;
  final Currency? currency;
  final Function(Currency? currency) callback;
  final GlobalKey<FormState> formKey;

  const Body5({
    Key? key,
    required this.themeColor,
    required this.callback,
    this.currency,
    required this.formKey,
  }) : super(key: key);

  @override
  State<Body5> createState() => _Body5State();
}

class _Body5State extends State<Body5> {
  Currency? selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.currency;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const PageTitle(
            title: "Region and Currency",
            subtitle: "Select the default currency as per region",
          ),
          SpacingStyle.defaultVerticalSpacing,
          InkWell(
            onTap: () => showCurrencyPicker(
              context: context,
              showSearchField: false,
              showFlag: true,
              showCurrencyName: true,
              showCurrencyCode: true,
              currencyFilter: const ['INR', 'AED'],
              onSelect: (Currency currency) {
                setState(() {
                  selectedCurrency = currency;
                });
                widget.callback(currency);
              },
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: ColorStyle.brandColor,
                  width: 2,
                ),
              ),
              child: ListTile(
                leading: selectedCurrency != null
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CurrencyUtils.currencyToEmoji(selectedCurrency!),
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ],
                      )
                    : null,
                trailing: selectedCurrency != null
                    ? Text(
                        selectedCurrency!.symbol,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      )
                    : null,
                title: Text(
                  selectedCurrency != null
                      ? selectedCurrency!.code
                      : 'Not Selected',
                ),
                subtitle: selectedCurrency != null
                    ? Text(selectedCurrency!.name)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
