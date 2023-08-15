import 'package:eatery/references.dart';
import 'package:http/http.dart' as http;

final _pageColor = KColors.tertiary;

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Import'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => _downloadDemoData(context),
                  title: Text(
                    'Download Demo Data',
                    style: TextStyle(
                        color: KColors.green, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Get started with demo data',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(
                    Icons.file_download_outlined,
                    color: KColors.green,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Import from Excel',
                    style: TextStyle(
                        color: KColors.alternate2, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Select the excel file to import',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(
                    Icons.attachment,
                    color: KColors.alternate2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Import from JSON',
                    style: TextStyle(
                        color: KColors.yellow, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Select the json file to import',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(
                    Icons.code,
                    color: KColors.yellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadDemoData(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show();

    const productsUrl =
        'https://raw.githubusercontent.com/devstroop/eatery_sample_data/main/products.json';
    const productCategoriesUrl =
        'https://raw.githubusercontent.com/devstroop/eatery_sample_data/main/product_categories.json';
    const ordersUrl =
        'https://raw.githubusercontent.com/devstroop/eatery_sample_data/main/orders.json';
    //
    progressDialog.update(msg: 'Downloading Products');
    final productsList = await getList(productsUrl);
    progressDialog.update(msg: 'Saving Products');
    List<Product> products = productsList?.forEach((element) {
      Product.fromMap(element as Map<String, dynamic>);
    }) as List<Product>;
    await EateryDB.instance.productBox!.addAll(products);
    //
    progressDialog.update(msg: 'Downloading Categories');
    final productCategoriesList = await getList(productCategoriesUrl);
    progressDialog.update(msg: 'Saving Categories');
    List<ProductCategory> categories = productCategoriesList?.forEach((element) {
      ProductCategory.fromMap(element as Map<String, dynamic>);
    }) as List<ProductCategory>;
    //
    progressDialog.update(msg: 'Downloading Orders');
    final ordersList = await getList(ordersUrl);
    await EateryDB.instance.productCategoryBox!.addAll(categories);
    progressDialog.update(msg: 'Saving Orders');
    List<Order> orders = ordersList?.forEach((element) {
      Order.fromMap(element as Map<String, dynamic>);
    }) as List<Order>;
    await EateryDB.instance.orderBox!.addAll(orders);
    //
    progressDialog.update(msg: 'Done');
    progressDialog.close(delay: 99);
    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Demo data downloaded successfully'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Future<List<dynamic>?> getList(String customersUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(customersUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
