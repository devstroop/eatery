import 'package:eatery/references.dart';

class SearchCustomerDelegate extends SearchDelegate<Customer?> {
  final List<Customer> customers;

  SearchCustomerDelegate(this.customers, Function(Customer customer) callback);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
      IconButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCustomerPage()))
                .then((customer) {
              if (customer != null) {
                close(context, customer as Customer);
              }
            });
          },
          icon: const Icon(Icons.add))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      List<Customer> customers = this
          .customers
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()) ||
              (element.phone ?? '').toLowerCase().contains(query))
          .toList();
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Search Results',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorStyle.text300,
                  fontStyle: FontStyle.normal),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                Customer customer = customers[index];
                return ListTile(
                  onTap: () {
                    close(context, customer);
                  },
                  title: Text(
                    customer.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ColorStyle.text200),
                  ),
                  subtitle: Text(
                    customer.phone ?? '',
                    style: TextStyle(color: ColorStyle.text300),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // show menu, view, orders
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: [
                          const PopupMenuItem(
                            value: 'view',
                            child: Text('View Customer'),
                          ),
                          const PopupMenuItem(
                            value: 'orders',
                            child: Text('Orders'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      List<Customer> customers = this
          .customers
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()) ||
              (element.phone ?? '').toLowerCase().contains(query))
          .toList();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Search Results',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorStyle.text300,
                  fontStyle: FontStyle.normal),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                Customer customer = customers[index];
                return ListTile(
                  onTap: () {
                    close(context, customer);
                  },
                  title: Text(
                    customer.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ColorStyle.text200),
                  ),
                  subtitle: Text(
                    customer.phone ?? '',
                    style: TextStyle(color: ColorStyle.text300),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // show menu, view, orders
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: [
                          const PopupMenuItem(
                            value: 'view',
                            child: Text('View Customer'),
                          ),
                          const PopupMenuItem(
                            value: 'orders',
                            child: Text('Orders'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      // Return last 5 customers
      List<Customer> customers = this.customers.reversed.toList();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Recent Customers',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorStyle.text300,
                  fontStyle: FontStyle.normal),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                Customer customer = customers[index];
                return ListTile(
                  onTap: () {
                    close(context, customer);
                  },
                  title: Text(
                    customer.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ColorStyle.text200),
                  ),
                  subtitle: Text(
                    customer.phone ?? '',
                    style: TextStyle(color: ColorStyle.text300),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // show menu, view, orders
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: [
                          const PopupMenuItem(
                            value: 'view',
                            child: Text('View Customer'),
                          ),
                          const PopupMenuItem(
                            value: 'orders',
                            child: Text('Orders'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
