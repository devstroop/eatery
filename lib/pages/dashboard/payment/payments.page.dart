import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/presentation/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = KColors.alternate2;

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        title: const Text('Payments'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPaymentDelegate(
                  payments,
                  (payment) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPaymentPage(payment: payment),
                    ),
                  ),
                  currencySymbol: currencySymbol,
                ),
              );
            },
          ),
        ],
      ),
      body: payments.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ...payments.map((payment) {
                  return ListTile(
                    title: Text('${payment.id ?? 'NA'}'),
                    subtitle: Text(payment.date.toString()),
                    trailing: Text(
                      '$currencySymbol${payment.amount}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  );
                }),
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 100, color: Colors.grey),
                  Text(
                    'No payments received yet',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPaymentPage()),
          ).then((_) => setState(() {}));
        },
        backgroundColor: _pageColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Payment'),
      ),
    );
  }
}
