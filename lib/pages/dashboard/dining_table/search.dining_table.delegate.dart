import 'package:eatery/references.dart';

class SearchDiningTableDelegate extends SearchDelegate<DiningTable?>{
  final List<DiningTable> diningTables;
  final Function(DiningTable diningTable) callback;

  SearchDiningTableDelegate(this.diningTables, this.callback);

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
            MaterialPageRoute(builder: (context) => const AddDiningTablePage()),
          ).then((diningTable) {
            if (diningTable != null) {
              callback(diningTable);
              close(context, diningTable);
            }
          });
        },
        icon: const Icon(Icons.add),
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
              color: Colors.grey[600],
            ),
          ),
        ),
        ...diningTables.map((e) => ListTile(
          onTap: () {
            callback(e);
            close(context, e);
          },
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.name.split(' ').last.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

          ),
          title: Text(e.name),
        )).toList()
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
              color: Colors.grey[600],
            ),
          ),
        ),
        ...diningTables.map((e) => ListTile(
          onTap: () {
            callback(e);
            close(context, e);
          },
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
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
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

          ),
          title: Text(e.name),
        )).toList()
      ],
    );
  }
}