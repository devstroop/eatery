import 'package:eatery/references.dart';
import 'package:get/get.dart';

class SearchOrderDelegate extends SearchDelegate<Order?>{
  final List<Order> orders;
  final Function(Order order) callback;

  SearchOrderDelegate(this.orders, this.callback);

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
      // Show recent orders
      return _buildRecentOrders(context);
    } else {
      // Show search results
      return _buildSearchResults(context, query);
    }
  }

  Widget _buildRecentOrders(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Order 1'),
          onTap: () {
            close(context, orders[0]);
          },
        ),
        ListTile(
          title: const Text('Order 2'),
          onTap: () {
            close(context, orders[1]);
          },
        ),
        ListTile(
          title: const Text('Order 3'),
          onTap: () {
            close(context, orders[2]);
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    final List<Order> searchResults = orders.where((order) => order.id.toString().contains(query.trim())).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${searchResults[index].id} - ${Common.currency?.symbol ?? ''}${searchResults[index].finalTotal}'),
          onTap: () {
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

}