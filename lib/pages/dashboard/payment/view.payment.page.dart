import 'package:eatery/references.dart';

import 'edit.payment.page.dart';

class ViewPaymentPage extends StatelessWidget {
  ViewPaymentPage({super.key, required this.payment});
  late Payment payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        actions: [
          // More Vert
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 100),
                items: [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                ],
              ).then((value) {
                switch (value) {
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditPaymentPage(payment: payment)),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          payment = value;
                        });
                      }
                    });
                    break;
                  case 'activate':
                    EateryDB.instance.paymentBox!.values
                        .where((element) => element.id == payment.id)
                        .first
                        .isActive = true;
                    EateryDB.instance.paymentBox!.put(
                        payment.id, EateryDB.instance.paymentBox!.get(payment.id));
                    setState(() {
                      payment = EateryDB.instance.paymentBox!.get(payment.id)!;
                    });
                    break;
                  case 'suspend':
                    EateryDB.instance.paymentBox!.values
                        .where((element) => element.id == payment.id)
                        .first
                        .isActive = false;
                    EateryDB.instance.paymentBox!.put(
                        payment.id, EateryDB.instance.paymentBox!.get(payment.id));
                    setState(() {
                      payment = EateryDB.instance.paymentBox!.get(payment.id)!;
                    });
                    break;
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Transaction ID'),
              subtitle: Text(payment.id.toString()),
            ),
            ListTile(
              title: const Text('Amount'),
              subtitle: Text(payment.amount.toString()),
            ),
            ListTile(
              title: const Text('Payment Mode'),
              subtitle: Text(payment.paymentMode.name),
            ),
            ListTile(
              title: const Text('Payment Date'),
              subtitle: Text(payment.date.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
