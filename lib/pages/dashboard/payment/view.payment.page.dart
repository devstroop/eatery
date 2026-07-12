import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit.payment.page.dart';

class ViewPaymentPage extends ConsumerStatefulWidget {
  ViewPaymentPage({super.key, required this.payment});
  late Payment payment;

  @override
  ConsumerState<ViewPaymentPage> createState() => _ViewPaymentPageState();
}

class _ViewPaymentPageState extends ConsumerState<ViewPaymentPage> {
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
                items: [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                ],
              ).then((value) {
                switch (value) {
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPaymentPage(payment: widget.payment),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          widget.payment = value;
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
              subtitle: Text(widget.payment.id.toString()),
            ),
            ListTile(
              title: const Text('Amount'),
              subtitle: Text(widget.payment.amount.toString()),
            ),
            ListTile(
              title: const Text('Payment Mode'),
              subtitle: Text(widget.payment.mode.name ?? 'NA'),
            ),
            ListTile(
              title: const Text('Payment Date'),
              subtitle: Text(widget.payment.date.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
