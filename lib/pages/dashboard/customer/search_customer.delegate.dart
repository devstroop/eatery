import 'package:eatery/references.dart';

class SearchCustomerDelegate extends SearchDelegate<Customer?> {
  final List<Customer> customers;
  final Function(Customer customer) callback;

  SearchCustomerDelegate(this.customers, this.callback);

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
            MaterialPageRoute(builder: (context) => const AddCustomerPage()),
          ).then((customer) {
            if (customer != null) {
              close(context, customer as Customer);
            }
          });
        },
        icon: const Icon(Icons.person_add),
      )
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
    return _buildSearchResults(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Show recent customers
      return _buildRecentCustomers(context);
    } else {
      // Show search results
      return _buildSearchResults(context, query);
    }
  }

  Widget _buildRecentCustomers(BuildContext context) {
    List<Customer> recentCustomers = customers.reversed.toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Recent Customers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentCustomers.length,
            itemBuilder: (context, index) {
              Customer customer = recentCustomers[index];
              return _buildCustomerListItem(context, customer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    List<Customer> searchResults = customers
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()) ||
            (element.phone ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (searchResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Search results',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: KColors.black500,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              Customer customer = searchResults[index];
              return _buildCustomerListItem(context, customer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerListItem(BuildContext context, Customer customer) {
    return ListTile(
      onTap: () {
        callback(customer);
        close(context, customer);
      },
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            customer.name[0],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),

      ),
      title: Text(
        customer.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: KColors.black600,
        ),
      ),
      subtitle: Text(
        customer.phone ?? '',
        style: TextStyle(color: KColors.black500),
      ),
      trailing: Text(
        (customer.lastOrderAt ?? DateTime.now()).toIso8601String(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: KColors.black600,
        ),
      ),
    );
  }
}
