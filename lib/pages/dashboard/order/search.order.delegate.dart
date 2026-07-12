import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/references.dart';

class SearchOrderDelegate extends SearchDelegate<Order?> {
  final List<Order> orders;
  final Function(Order order) callback;
  final String currencySymbol;

  SearchOrderDelegate({
    required this.orders,
    required this.callback,
    required this.currencySymbol,
  });

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
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.white, fontSize: 18),
      ),
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
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'Recent orders',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
        ),
        for (final order in orders)
          ListTile(
            title: Text('$currencySymbol${order.id} - ${order.grandTotal}'),
            onTap: () {
              callback(order);
              close(context, order);
            },
          ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    final List<Order> searchResults = orders
        .where((order) => order.id.toString().contains(query.trim()))
        .toList();

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'Search results',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
        ),
        for (final order in searchResults)
          ListTile(
            title: Text('$currencySymbol${order.id} - ${order.grandTotal}'),
            onTap: () {
              callback(order);
              close(context, order);
            },
          ),
      ],
    );
  }
}
