import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery/references.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewPaymentPage extends ConsumerStatefulWidget {
  const ViewPaymentPage({super.key, required this.payment});
  final Payment payment;

  @override
  ConsumerState<ViewPaymentPage> createState() => _ViewPaymentPageState();
}

class _ViewPaymentPageState extends ConsumerState<ViewPaymentPage> {
  late Payment _payment;

  @override
  void initState() {
    super.initState();
    _payment = widget.payment;
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Payment Details',
      actions: [
        // More Vert
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 100, 0, 100),
              items: [const PopupMenuItem(value: 'edit', child: Text('Edit'))],
            ).then((value) {
              switch (value) {
                case 'edit':
                  GoRouter.of(
                    context,
                  ).pushNamed('editPayment', extra: _payment).then((value) {
                    if (value != null) {
                      setState(() {
                        _payment = value as Payment;
                      });
                    }
                  });
                  break;
              }
            });
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Transaction ID'),
              subtitle: Text(_payment.id.toString()),
            ),
            ListTile(
              title: const Text('Amount'),
              subtitle: Text(_payment.amount.toString()),
            ),
            ListTile(
              title: const Text('Payment Mode'),
              subtitle: Text(_payment.mode.name),
            ),
            ListTile(
              title: const Text('Payment Date'),
              subtitle: Text(_payment.date.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
