import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/core/theme/app_typography.dart';
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

class _ShowCurrencyRegionPageState
    extends ConsumerState<ShowCurrencyRegionPage> {
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
            ? ref
                  .read(appDatabaseProvider)
                  .currencyBox
                  .values
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
    return AppPageShell(
      title: 'Region and Currency',
      color: themeColor,
      child: Padding(
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
                        MediaQuery.of(context).size.height * 4 / 5,
                  ),
                  onSelect: _onCurrencySelected,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: themeColor, width: 2),
                  ),
                  child: ListTile(
                    leading: selectedCurrency != null
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                CurrencyUtils.currencyToEmoji(
                                  selectedCurrency!,
                                ),
                                style: AppTypography.headlineLarge.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        : null,
                    trailing: selectedCurrency != null
                        ? Text(
                            selectedCurrency!.symbol,
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w400,
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
        child: AppButton.primary(
          label: 'Save',
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              ref.read(eateryStoreProvider).execute('DELETE FROM currency');
              KCurrency? currency = selectedCurrency != null
                  ? KCurrency.fromMap(selectedCurrency!.toJson())
                  : null;
              if (currency != null) {
                ref.read(appDatabaseProvider).currencyBox.add(currency);
              }
              final company = ref
                  .read(companyRepositoryProvider)
                  .getCurrentCompany();
              if (company != null) {
                company.currencyCode = currency?.code;
                ref.read(companyRepositoryProvider).saveCompany(company).then((
                  _,
                ) {
                  setState(() {
                    ref.read(companyProvider.notifier).setCompany(company);
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
