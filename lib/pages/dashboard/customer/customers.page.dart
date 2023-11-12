import 'package:eatery/pages/dashboard/customer/view.customer.page.dart';
import 'package:eatery/references.dart';

Color _pageColor = KColors.primary;

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        title: const Text('Customers'),
        foregroundColor: Colors.white,
      ),
      body: EateryDB.instance.customerBox!.values.isNotEmpty
          ? ListView(
              children: [
                ...EateryDB.instance.customerBox!.values.map((customer) {
                  return ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCustomer(customer: customer)));
                    },
                      leading: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _pageColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          customer.name![0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    title: Text(
                      customer.name ?? 'NA',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(customer.address != null && customer.address!.isNotEmpty)
                          Text(customer.address!),
                        Text(customer.phone),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (customer.id != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditCustomerPage(customer: customer)),
                                      ).then((_) => setState(() {}));
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Delete Customer'),
                                          content: const Text(
                                              'Are you sure you want to delete this customer?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                customer.delete().then((value) {
                                                  showMessageDialog(context, 'Customer deleted successfully', MessageType.success);
                                                  Navigator.pop(context);
                                                }).onError((error, stackTrace) {
                                                  showMessageDialog(context, error.toString(), MessageType.error);
                                                }).whenComplete(() => setState(() {}));
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ));
                }),
              ],
            )
          : const Center(
              child: Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Customers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Add a customer to get started',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        label: const Text('Add Customer'),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
