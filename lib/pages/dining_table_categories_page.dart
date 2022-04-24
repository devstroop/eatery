import 'package:flutter/material.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/style/color_style.dart';

class DiningTableCategoriesPage extends StatefulWidget {
  const DiningTableCategoriesPage({Key? key}) : super(key: key);

  @override
  State<DiningTableCategoriesPage> createState() => _DiningTableCategoriesPageState();
}

class _DiningTableCategoriesPageState extends State<DiningTableCategoriesPage> {

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Product Categories'),
    );
    final categoriesPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            FutureBuilder(
                future: DiningTableCategory.getAll(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                  return Container();
                }
            )
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 60.0,
              left: 0.0,
              right: 0.0,
              bottom: 72,
              child: categoriesPanel
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
        onPressed: () {  },
      ),
    );
  }
}
