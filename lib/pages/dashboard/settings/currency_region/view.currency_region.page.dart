import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';

class ShowCurrencyRegionPage extends ConsumerStatefulWidget {
  const ShowCurrencyRegionPage({super.key});

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
                  .read(companyRepositoryProvider)
                  .getCurrencyByCode(currencyCode)
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
                ref.read(eateryStoreProvider).execute(
                  'INSERT INTO currency (code, name, symbol, flag, number, decimal_digits, name_plural, symbol_on_left, decimal_separator, thousands_separator, space_between_amount_and_symbol) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
                  [
                    currency.code,
                    currency.name,
                    currency.symbol,
                    currency.flag,
                    currency.number,
                    currency.decimalDigits,
                    currency.namePlural,
                    currency.symbolOnLeft ? 1 : 0,
                    currency.decimalSeparator,
                    currency.thousandsSeparator,
                    currency.spaceBetweenAmountAndSymbol ? 1 : 0,
                  ],
                );
                notifyMutation('currency', 0, 'save', currency.toMap());
              }
              final company = ref
                  .read(companyRepositoryProvider)
                  .getCurrentCompany();
              if (company != null) {
                final updated = company.copyWith(currencyCode: currency?.code);
                ref.read(companyRepositoryProvider).saveCompany(updated).then((
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
              AppSpacing.gapMd,
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
    );
  }

  void _onCurrencySelected(Currency value) {
    setState(() {
      selectedCurrency = value;
    });
  }
}
