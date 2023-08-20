import 'package:eatery/references.dart';

class ViewCustomer extends StatefulWidget {
  ViewCustomer({super.key, required this.customer});

  Customer customer;

  @override
  State<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Customer Details'),
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
                  if (!widget.customer.isActive)
                    const PopupMenuItem(
                      value: 'activate',
                      child: Text('Activate'),
                    ),
                  if (widget.customer.isActive)
                    const PopupMenuItem(
                      value: 'suspend',
                      child: Text('Suspend'),
                    ),
                ],
              ).then((value) {
                switch (value) {
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditCustomerPage(customer: widget.customer)),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          widget.customer = value;
                        });
                      }
                    });
                    break;
                  case 'activate':
                    EateryDB.instance.customerBox!.values
                        .where((element) => element.id == widget.customer.id)
                        .first
                      ..isActive = true
                      ..save()
                          .then((value) => showMessageDialog(
                              context,
                              'Successfully activated',
                              MessageType.success,
                              () => setState(() {})))
                          .onError((error, stackTrace) => showMessageDialog(
                              context,
                              error.toString(),
                              MessageType.error,
                              () => setState(() {})));
                    setState(() {
                      widget.customer.isActive = true;
                    });
                    break;
                  case 'suspend':
                    EateryDB.instance.customerBox!.values
                        .where((element) => element.id == widget.customer.id)
                        .first
                      ..isActive = false
                      ..save()
                          .then((value) => showMessageDialog(
                              context,
                              'Successfully suspended',
                              MessageType.success,
                              () => setState(() {})))
                          .onError((error, stackTrace) => showMessageDialog(
                              context,
                              error.toString(),
                              MessageType.error,
                              () => setState(() {})));
                    setState(() {
                      widget.customer.isActive = false;
                    });
                    break;
                }
              });
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Outstanding amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Outstanding\nAmount'),
                    Text(
                        '${Common.currency?.symbol ?? ''}${widget.customer.outstandingAmount}',
                        style:
                        const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Name'),
                    Text(widget.customer.name ?? '',
                        style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Phone'),
                    Text(widget.customer.phone,
                        style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Address'),
                    Text((widget.customer.address ?? '').isNotEmpty ? widget.customer.address! : 'NA',
                        style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 5),
                // Landmark
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Landmark'),
                    Text((widget.customer.landmark ?? '').isNotEmpty ? widget.customer.landmark! : 'NA',
                        style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 5),
                // Last order date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Last Order At'),
                    Text(widget.customer.lastOrderAt != null
                        ? widget.customer.lastOrderAt!.toIso8601String()
                        : 'NA',
                        style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(height: 5),
                // Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status'),
                    if(widget.customer.isActive)
                      const Icon(Icons.check_circle, color: Colors.green),
                    if(!widget.customer.isActive)
                      const Icon(Icons.cancel, color: Colors.red),
                  ],
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Colors.grey[200],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Orders',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700]),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ...EateryDB.instance.orderBox!.values.map((e) => ListTile(
                        title: Text('${e.id ?? 'NA'}'),
                        subtitle: Text(e.timestamp.toIso8601String()),
                        trailing: Text(
                            '${Common.currency?.symbol ?? ''}${e.finalTotal}'),
                      )),
                      if (EateryDB.instance.orderBox!.values.isEmpty)
                        ListTile(
                          title: Text('No previous orders', style: TextStyle(color: Colors.grey[400]),),
                        )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
