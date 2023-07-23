import 'package:eatery/references.dart';

class ShowCurrencyRegionPage extends StatefulWidget {
  const ShowCurrencyRegionPage({Key? key}) : super(key: key);

  @override
  State<ShowCurrencyRegionPage> createState() => _ShowCurrencyRegionPageState();
}

class _ShowCurrencyRegionPageState extends State<ShowCurrencyRegionPage> {
  final themeColor = ColorStyle.primary;
  Currency? selectedCurrency;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        int? currencyId = GlobalVariables.company?.currencyId;
        KCurrency? currencyObj = currencyId != null ? EateryDB.instance.currencyBox!.values
            .singleWhere((element) => element.id == currencyId) : null;
        var map = currencyObj?.toMap();
        selectedCurrency = map != null ? Currency.from(json: map) : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: ColorStyle.textColorLight,
        title: const Text('Region and Currency'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
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
                      bottomSheetHeight:
                          MediaQuery.of(context).size.height * 4 / 5),
                  onSelect: _onCurrencySelected,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: themeColor,
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
                                CurrencyUtils.currencyToEmoji(
                                    selectedCurrency!),
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
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: PrimaryButton(
          color: themeColor,
          child: const Text('Save'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Company company = EateryDB.instance.companyBox!.values.first;
              company.currencyId = 0; //selectedCurrency?.id;
              company.save();

              // Display dialog successfully saved
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Success'),
                  content: const Text('Successfully saved'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ).then((value) => Navigator.pop(context));
            }
          },
        ),
      ),
    );
  }

  void _onCurrencySelected(Currency value) {
    setState(() {
      selectedCurrency = value;
    });
  }
}
