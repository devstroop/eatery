import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body5 extends ConsumerStatefulWidget {
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
  ConsumerState<Body5> createState() => _Body5State();
}

class _Body5State extends ConsumerState<Body5> {
  Currency? selectedCurrency;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedCurrency = widget.currency;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                showSearchField: true,
                showFlag: true,
                showCurrencyName: true,
                showCurrencyCode: true,
                favorite: const ['INR'],
                physics: const BouncingScrollPhysics(),
                searchHint: 'Search by country name or currency code',
                useRootNavigator: true,
                // currencyFilter: const ['INR', 'AED'],
                theme: CurrencyPickerThemeData(
                  bottomSheetHeight: MediaQuery.of(context).size.height * 4 / 5,
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
                  border: Border.all(color: AppColors.secondary2, width: 2),
                ),
                child: ListTile(
                  leading: selectedCurrency != null
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CurrencyUtils.currencyToEmoji(selectedCurrency!),
                              style: const TextStyle(fontSize: 32),
                            ),
                          ],
                        )
                      : null,
                  trailing: selectedCurrency != null
                      ? Text(
                          selectedCurrency!.symbol,
                          style: const TextStyle(fontSize: 18),
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
      ),
    );
  }
}
