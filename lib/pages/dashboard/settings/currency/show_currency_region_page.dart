import 'package:currency_picker/currency_picker.dart';
import 'package:eatery/components/loaders/loading_screen.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:flutter/material.dart';

class ShowCurrencyRegionPage extends StatefulWidget {
  const ShowCurrencyRegionPage({Key? key})
      : super(key: key);

  @override
  State<ShowCurrencyRegionPage> createState() => _ShowCurrencyRegionPageState();
}

class _ShowCurrencyRegionPageState extends State<ShowCurrencyRegionPage> {
  final themeColor = ColorStyle.brandColor;
  Currency? currency;

  @override
  void initState() {
    super.initState();
    postInit();
  }

  void postInit() async {
    /*Stream<CurrencyInfo?> _stream = widget.database.currencyInfoDao.findCurrencyInfo(1);
    if(!(await _stream.isEmpty)){
      CurrencyInfo? currencyInfo = await _stream.first;
      currency = Currency(
          code: currencyInfo!.code,
          name: currencyInfo.name,
          symbol: currencyInfo.symbol,
          flag: currencyInfo.flag,
          number: currencyInfo.number,
          decimalDigits: currencyInfo.decimalDigits,
          namePlural: currencyInfo.namePlural,
          symbolOnLeft: currencyInfo.symbolOnLeft,
          decimalSeparator: currencyInfo.decimalSeparator,
          thousandsSeparator: currencyInfo.thousandsSeparator,
          spaceBetweenAmountAndSymbol: currencyInfo.spaceBetweenAmountAndSymbol);
      setState(() {});
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return currency != null ? Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Currency and Region'),
      ),
      body: Padding(
        padding: SpacingStyle.defaultPadding,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: ColorStyle.brandColor,
                    width: 1,
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: currency != null
                          ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CurrencyUtils.currencyToEmoji(currency!),
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ],
                      )
                          : null,
                      trailing: currency != null
                          ? Text(currency!.symbol,
                          style: const TextStyle(
                            fontSize: 18,
                          ))
                          : null,
                      title: Text(currency != null ? currency!.code : 'Not Selected'),
                      subtitle: currency != null ? Text(currency!.name) : null,
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
                    currency = currency;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ) : LoadingScreen();
  }
}
