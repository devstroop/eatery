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
    return ListView.builder(
      itemCount: diningTables.length,
      itemBuilder: (context, index) {
        DiningTable diningTable = diningTables[index];
        return ListTile(
          onTap: () {
            callback(diningTable);
            close(context, diningTable);
          },
          title: Text(diningTable.name),
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    List<DiningTable> diningTables = this.diningTables
        .where((element) => element.name.toLowerCase().contains(query))
        .toList();
    return ListView.builder(
      itemCount: diningTables.length,
      itemBuilder: (context, index) {
        DiningTable diningTable = diningTables[index];
        return ListTile(
          onTap: () {
            callback(diningTable);
            close(context, diningTable);
          },
          title: Text(diningTable.name),
        );
      },
    );
  }
}