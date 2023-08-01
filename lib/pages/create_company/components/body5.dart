import 'package:eatery/references.dart';

class Body5 extends StatefulWidget {
  final Color themeColor;
  final Currency? currency;
  final Function(Currency? currency) callback;
  final GlobalKey<FormState> formKey;
  final Function(GlobalKey<FormState> formKey)? callbackFormKey;
  const Body5({
    Key? key,
    required this.themeColor,
    required this.callback,
    this.currency,
    required this.formKey,
    this.callbackFormKey,
  }) : super(key: key);

  @override
  State<Body5> createState() => _Body5State();
}

class _Body5State extends State<Body5> {
  Currency? selectedCurrency;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState((){
        selectedCurrency = widget.currency;
      });
    });
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
              theme: CurrencyPickerThemeData(
                  bottomSheetHeight: MediaQuery.of(context).size.height * 4/5
              ),
              onSelect: (Currency currency) {
                setState(() {
                  selectedCurrency = currency;
                });
                if (widget.callbackFormKey != null) {
                  widget.callbackFormKey!(widget.formKey);
                }
                widget.callback(currency);
              },
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: KColors.secondary2,
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
