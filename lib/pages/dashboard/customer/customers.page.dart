import 'package:eatery/pages/dashboard/customer/view.customer.page.dart';
import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.primary;

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
                    title: Text(
                      customer.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(customer.phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: _pageColor),
                          onPressed: () {
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
                        IconButton(
                          icon: Icon(Icons.delete, color: _pageColor),
                          onPressed: () {
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
                                        // (customer).delete();
                                        setState(() {});
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
