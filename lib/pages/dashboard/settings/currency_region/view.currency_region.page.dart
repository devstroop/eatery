import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/database_provider.dart';
import 'package:eatery/presentation/providers/company_provider.dart';

class ShowCurrencyRegionPage extends ConsumerStatefulWidget {
  const ShowCurrencyRegionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShowCurrencyRegionPage> createState() =>
      _ShowCurrencyRegionPageState();
}

class _ShowCurrencyRegionPageState extends ConsumerState<ShowCurrencyRegionPage> {
  final themeColor = AppColors.primary;
  Currency? selectedCurrency;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        String? currencyCode = ref.read(companyProvider)?.currencyCode;
        KCurrency? curr = currencyCode != null
            ? ref.read(appDatabaseProvider).currencyBox.values
                .singleWhere((element) => element.code == currencyCode)
            : null;
        selectedCurrency = curr != null
            ? Currency.from(json: curr.toMap())
            : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: AppColors.white900,
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
                  // currencyFilter: const ['INR', 'AED'],
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
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              for (var element in ref.read(appDatabaseProvider).currencyBox.values) {
                await element.delete();
              }
              KCurrency? currency = selectedCurrency != null ? KCurrency.fromMap(selectedCurrency!.toJson()) : null;
              if (currency != null) {
                await ref.read(appDatabaseProvider).currencyBox.add(currency);
                currency = ref.read(appDatabaseProvider).currencyBox.values.first;
              }
              ref.read(appDatabaseProvider).companyBox.values.first
                  ..currencyCode = currency?.code
                ..save().then((value) {
                  setState(() {
                    ref.read(companyProvider.notifier).setCompany(
                      ref.read(appDatabaseProvider).companyBox.values.first,
                    );
                  });
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
              });
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
