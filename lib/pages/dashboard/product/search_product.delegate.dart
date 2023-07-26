import 'package:eatery/references.dart';

class SearchProductDelegate extends SearchDelegate<Product?> {
  final List<Product> products;
  SearchProductDelegate(this.products, Function(Product product) callback);

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
    if (query.isNotEmpty) {
      List<Product> products = this.products
              .where((element) => element.name.toLowerCase().contains(query))
              .toList();
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          return ListTile(
            onTap: () {
              close(context, product);
            },
            title: Text(product.name),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      List<Product> products = this.products
              .where((element) => element.name.toLowerCase().contains(query))
              .toList() ??
          [];
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          return ListTile(
            onTap: () {
              close(context, product);
            },
            title: Text(product.name),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }

  // final Function(Product? product)? onSelect;
  // final Function? onCancel;
  //
  // @override
  // List<Widget> buildActions(BuildContext context) {
  //   return [
  //     IconButton(
  //       onPressed: () {
  //         query = '';
  //         showSuggestions(context);
  //       },
  //       icon: const Icon(Icons.clear),
  //     ),
  //   ];
  // }
  //
  // @override
  // Widget buildLeading(BuildContext context) {
  //   return IconButton(
  //     onPressed: () {
  //       onCancel?.call();
  //       close(context, null);
  //     },
  //     icon: const Icon(Icons.arrow_back),
  //   );
  // }
  //
  // @override
  // Widget buildResults(BuildContext context) {
  //   if (query.isNotEmpty) {
  //     List<Product> products = EateryDB.instance.productBox?.values
  //             .where((element) => element.name.toLowerCase().contains(query))
  //             .toList() ??
  //         [];
  //     return ListView.builder(
  //       itemCount: products.length,
  //       itemBuilder: (context, index) {
  //         Product product = products[index];
  //         return ListTile(
  //           onTap: () {
  //             onSelect?.call(product);
  //             close(context, product);
  //           },
  //           title: Text(product.name),
  //         );
  //       },
  //     );
  //   } else {
  //     return const SizedBox();
  //   }
  // }
  //
  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   if (query.isNotEmpty) {
  //     List<Product> products = EateryDB.instance.productBox?.values
  //             .where((element) => element.name.toLowerCase().contains(query))
  //             .toList() ??
  //         [];
  //     return ListView.builder(
  //       itemCount: products.length,
  //       itemBuilder: (context, index) {
  //         Product product = products[index];
  //         return ListTile(
  //           onTap: () {
  //             onSelect?.call(product);
  //             close(context, product);
  //           },
  //           title: Text(product.name),
  //         );
  //       },
  //     );
  //   } else {
  //     return const SizedBox();
  //   }
  // }
}