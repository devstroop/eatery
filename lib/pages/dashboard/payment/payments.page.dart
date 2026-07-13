import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/widgets/responsive/responsive_list_view.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Color _pageColor = AppColors.menuPayments;

class PaymentsPage extends ConsumerStatefulWidget {
  const PaymentsPage({super.key});

  @override
  ConsumerState<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends ConsumerState<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    List<Payment> payments = ref
        .read(paymentRepositoryProvider)
        .getAllPayments();
    payments.sort((a, b) => b.date.compareTo(a.date));
    final currencySymbol =
        ref.read(companyProvider.notifier).currency?.symbol ?? '';
    return AppPageShell(
      title: 'Payments',
      color: _pageColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchPaymentDelegate(
                payments,
                (payment) => GoRouter.of(context).pushNamed('viewPayment', extra: payment),
                currencySymbol: currencySymbol,
              ),
            );
          },
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: AppColors.white,
        onPressed: () {
          GoRouter.of(context).pushNamed('addPayment').then((_) => setState(() {}));
        },
        backgroundColor: _pageColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Payment'),
      ),
      child: payments.isNotEmpty
          ? ResponsiveListView(
              itemCount: payments.length,
              childAspectRatio: 4.0,
              separator: (_, __) => const SizedBox.shrink(),
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: ListTile(
                    title: Text('${payment.id ?? 'NA'}'),
                    subtitle: Text(payment.date.toString()),
                    trailing: Text(
                      '$currencySymbol${payment.amount}',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                );
              },
            )
           : Center(
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 100, color: Colors.grey),
                  Text(
                    'No payments received yet',
                    style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
