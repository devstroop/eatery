import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/database/waiter.dart';
import 'package:restaurant_pos/style/color_style.dart';

class WaitersPage extends StatefulWidget {
  const WaitersPage({Key? key}) : super(key: key);

  @override
  State<WaitersPage> createState() => _WaitersPageState();
}

class _WaitersPageState extends State<WaitersPage> {

  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Waiters'),
    );


    final productsPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            FutureBuilder(
                future: Waiter.getAll(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                  if (snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasData){
                      for (var product in snapshot.data){
                        ProductCard(
                          id: product['id'],
                          name: product['name'],
                          description: product['description'],
                          mrp: product['mrp'],
                          salePrice: product['salePrice'],
                          quantity: product['quantity'],
                          warningQuantity: product['warningQuantity'],
                          image: product['image'],
                          foodType: product['foodType'],
                          themeColor: getThemeColor(),
                        );
                      }
                    }
                    return Container();
                  }
                  else{
                    return const Center(child: CircularProgressIndicator(),);
                  }
                }
            ),

          ],
        ),
      ),
    );

    final detailedProduct = Container();


    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 60.0,
              left: 0.0,
              right: 0.0,
              bottom: 72,
              child: productsPanel
          ),
          Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: detailedProduct
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
