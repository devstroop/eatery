import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/dining_table_category_card.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/pages/add_dining_table_category_page.dart';
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
      title: const Text('Dining Table Categories'),
    );
    final categoriesPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
              future: DiningTableCategory.getAll(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasData && snapshot.data.isNotEmpty){
                    return Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (var category in snapshot.data)
                          DiningTableCategoryCard(
                            id: category['id'],
                            name: category['name'],
                            image: category['image'],
                          )
                      ],
                    );
                  }
                  return SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: 0.0) * 0.5,),
                      child: Center(
                          child: Image.asset('assets/images/2748558.png', width: (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width: MediaQuery.of(context).size.height) * 0.5,)
                      ),
                    ),
                  );
                }
                else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              }
          )
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 12.0,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiningTableCategoryPage()),
          );
        },
      ),
    );
  }
}
