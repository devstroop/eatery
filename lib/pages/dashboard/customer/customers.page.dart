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
    List<Customer> customers = EateryDB.instance.customerBox.values.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        title: const Text('Customers'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: customers.isNotEmpty
          ? ListView(
              children: [
                ...customers.map((e) {
                  return ListTile(
                      title: Text(
                        e.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: e.phone != null ? Text(e.phone!) : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(UIcons.regularStraight.pencil,
                                color: _pageColor),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditCustomerPage(customer: e)),
                              ).then((_) => setState(() {}));
                            },
                          ),
                          IconButton(
                            icon: Icon(UIcons.regularStraight.trash,
                                color: _pageColor),
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
                                          // e.delete().whenComplete(() {
                                          //   Navigator.pop(context);
                                          //   setState(() {});
                                          // });
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
                })
              ],
            )
          : Center(
              child: Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    UIcons.regularStraight.user,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Customers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
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
        icon: Icon(UIcons.regularStraight.plus_small),
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
