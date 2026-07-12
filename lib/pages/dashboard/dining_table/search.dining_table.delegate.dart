import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/core/extensions/double_ext.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';

class SearchDiningTableDelegate extends SearchDelegate<DiningTable?> {
  final List<DiningTable> diningTables;
  final Function(DiningTable diningTable) callback;
  final String currencySymbol;
  final List<Order> orders;

  SearchDiningTableDelegate(
    this.diningTables,
    this.callback, {
    this.currencySymbol = '',
    this.orders = const [],
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
      /*IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiningTablePage()),
          ).then((diningTable) {
            if (diningTable != null) {
              callback(diningTable);
              close(context, diningTable);
            }
          });
        },
        icon: const Icon(Icons.add),
      )*/
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
      // Show recent diningTables
      return _buildRecentDiningTables(context);
    } else {
      // Show search results
      return _buildSearchResults(context, query);
    }
  }

  Widget _buildRecentDiningTables(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'Recent dining tables',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.grey600,
            ),
          ),
        ),
        ...diningTables
            .map(
              (e) => ListTile(
                onTap: () {
                  callback(e);
                  close(context, e);
                },
                leading: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e.name.split(' ').last[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  e.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (e.description != null &&
                        e.description!.trim().isNotEmpty)
                      Text(e.description!.trim()),
                    Text(
                      '${e.capacity} seats',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: e.status == DiningTableStatus.available
                            ? Colors.green
                            : e.status == DiningTableStatus.occupied
                            ? AppColors.error
                            : Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        e.status.name,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    if (e.orderId != null)
                      Text(
                        'Order #${e.orderId}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black800,
                        ),
                      ),
                    if (e.orderId != null)
                      Text(
                        'Due $currencySymbol${orders.where((element) => element.id == e.orderId).firstOrNull?.grandTotal.toPrecision(2)}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    List<DiningTable> diningTables = this.diningTables
        .where((element) => element.name.toLowerCase().contains(query))
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
              color: AppColors.grey600,
            ),
          ),
        ),
        ...diningTables
            .map(
              (e) => ListTile(
                onTap: () {
                  callback(e);
                  close(context, e);
                },
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e.name.split(' ').last.toUpperCase()[0],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(e.name),
              ),
            )
            .toList(),
      ],
    );
  }
}
